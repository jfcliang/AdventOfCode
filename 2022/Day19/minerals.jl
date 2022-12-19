include("../../utils/io.jl")

scenario_dict = Dict()
max_geo_dict = Dict()
cost_dict = Dict()


function parse_blueprint(line::String)
    pattern = r".*(?<no>[0-9]+).*costs (?<ore>[0-9]+) ore.*costs (?<clay>[0-9]+) ore.*costs (?<obs1>[0-9]+) ore and (?<obs2>[0-9]+) clay.*costs (?<geo1>[0-9]+) ore and (?<geo2>[0-9]+).*"
    m = match(pattern, line)

    ore = [parse(Int64, m["ore"]), 0, 0, 0]
    clay = [parse(Int64, m["clay"]), 0, 0, 0]
    obs = [parse(Int64, m["obs1"]), parse(Int64, m["obs2"]), 0, 0]
    geo = [parse(Int64, m["geo1"]), 0, parse(Int64, m["geo2"]), 0]

    return [ore, clay, obs, geo]
end


function calculate_cost(ore, clay, obs, geo, bp)
    key = (ore, clay, obs, geo)
    if haskey(cost_dict, key)
        return cost_dict[key]
    end
    cost = ore*bp[1] + clay*bp[2] + obs*bp[3] + geo*bp[4]
    cost_dict[key] = cost
    return cost
end


function generate_scenarios(
    minerals::Vector{Int64}, 
    bp::Vector{Vector{Int64}})

    current = minerals

    key = (current[1], current[2], current[3], current[4])

    if haskey(scenario_dict, key)
        return scenario_dict[key]
    end

    geo = min(div(current[3], bp[4][3]), div(current[1], bp[4][1]))
    current -= geo * bp[4]

    obs = min(div(current[2], bp[3][2]), div(current[1], bp[3][1]))
    current -= obs * bp[3]

    max_clay = div(current[1], bp[2][1])
    max_ore = div(current[1], bp[1][1])

    new_scenarios = []

    for ore in 0:max_ore
        for clay in 0:max_clay
            cost = calculate_cost(ore, clay, obs, geo, bp)
            if all(cost .<= minerals)
                push!(new_scenarios, ([ore, clay, obs, geo], cost))
            end 
        end
    end

    scenario_dict[key] = new_scenarios
    return new_scenarios
end


function max_geodes(
    current_robots::Vector{Int64}, 
    current_minerals::Vector{Int64}, 
    bp::Vector{Vector{Int64}}, t_remain::Int64) :: Int64
    key = (
        current_robots[1], current_robots[2], current_robots[3], current_robots[4], 
        current_minerals[1], current_minerals[2], current_minerals[3], current_minerals[4], 
        t_remain
    )

    if haskey(max_geo_dict, key)
        return max_geo_dict[key]
    end

    if t_remain == 1
        result = current_minerals[4] + current_robots[4]
        max_geo_dict[key] = result
        return result
    else
        new_scenarios = generate_scenarios(current_minerals, bp)
        geodes = fill(0, length(new_scenarios))
        after_mining = current_minerals += current_robots

        for (i, (new_bots, costs)) in enumerate(new_scenarios)
            updated_bots = current_robots + new_bots
            updated_minerals = after_mining - costs
            geodes[i] = max_geodes(updated_bots, updated_minerals, bp, t_remain-1)
        end

        result = maximum(geodes)
        max_geo_dict[key] = result
        return result
    end
end


function get_max_geodes(bp) :: Int64
    robots = [1, 0, 0, 0]
    minerals = [0, 0, 0, 0]
    time = 21
    
    geo = max_geodes(robots, minerals, bp, time)
    return geo
end
    

function solution1(path::String)
    input_strs = parse_input_lines(path, "\r\n")
    blueprints = parse_blueprint.(input_strs)

    quality = 0
    for (i, bp) in enumerate(blueprints)
        empty!(max_geo_dict)
        empty!(scenario_dict)
        empty!(cost_dict)
        quality += get_max_geodes(bp) * i
    end

    println(quality)
end

# solution1("./input.txt")
solution1("./input_example.txt")