include("../../utils/io.jl")

scenario_dict = Dict()
max_geo_dict = Dict()

max_sofar = [16, 35, 20] # from the shameful trials earlier
# max_sofar = [50, 60]


function parse_blueprint(line::String)
    pattern = r".*(?<no>[0-9]+).*costs (?<ore>[0-9]+) ore.*costs (?<clay>[0-9]+) ore.*costs (?<obs1>[0-9]+) ore and (?<obs2>[0-9]+) clay.*costs (?<geo1>[0-9]+) ore and (?<geo2>[0-9]+).*"
    m = match(pattern, line)

    ore = [parse(Int64, m["ore"]), 0, 0, 0]
    clay = [parse(Int64, m["clay"]), 0, 0, 0]
    obs = [parse(Int64, m["obs1"]), parse(Int64, m["obs2"]), 0, 0]
    geo = [parse(Int64, m["geo1"]), 0, parse(Int64, m["geo2"]), 0]

    return [ore, clay, obs, geo]
end

function best_geode_possible(geodes::Int64, geobots::Int64, t_remain::Int64)
    return geodes + (2*geobots + t_remain - 1) * t_remain / 2
end

function generate_scenarios(
    minerals::Vector{Int64}, 
    robots::Vector{Int64},
    bp::Vector{Vector{Int64}}, 
    max_minerals::Vector{Int64},
    t_remain::Int64,
    target_geodes::Int64)

    current = minerals
    key = hash((current, t_remain))

    if haskey(scenario_dict, key)
        return scenario_dict[key]
    end

    if best_geode_possible(minerals[4], robots[4], t_remain) < target_geodes
        result = [-1]
        scenario_dict[key] = result
        return result
    end

    geo_avail = current[3] >= bp[4][3] && current[1] >= bp[4][1] 
    obs_avail = current[2] >= bp[3][2] && current[1] >= bp[3][1] && robots[3] < max_minerals[3]
    clay_avail = current[1] >= bp[2][1] && robots[2] < max_minerals[2]
    ore_avail = current[1] >= bp[1][1] && robots[1] < max_minerals[1]

    new_scenarios = Vector{Int64}()

    if geo_avail
        push!(new_scenarios, 4)
        # always good to make new geode bot
    else
        push!(new_scenarios, 0)
        if obs_avail
            push!(new_scenarios, 3)
        end
        if clay_avail
            push!(new_scenarios, 2)
        end
        if ore_avail
            push!(new_scenarios, 1)
        end
    end

    scenario_dict[key] = new_scenarios
    return new_scenarios
end


function max_geodes(
    current_robots::Vector{Int64}, 
    current_minerals::Vector{Int64}, 
    bp::Vector{Vector{Int64}}, 
    max_minerals::Vector{Int64},
    t_remain::Int64, total_t::Int64, 
    target_geodes::Int64) :: Int64

    key = hash((current_robots, current_minerals, t_remain))

    if haskey(max_geo_dict, key)
        return max_geo_dict[key]
    end

    if t_remain == 1
        result = current_minerals[4] + current_robots[4]
        max_geo_dict[key] = result
        return result
    else
        new_scenarios = generate_scenarios(
            current_minerals, current_robots, bp, max_minerals, t_remain, target_geodes)
        geodes = fill(0, length(new_scenarios))
        current_minerals += current_robots

        for (i, new_bot) in enumerate(new_scenarios)
            updated_bots = copy(current_robots)
            updated_minerals = current_minerals

            if new_bot == -1
                result = 0
                max_geo_dict[key] = result
                return result
            end

            if new_bot > 0
                updated_bots[new_bot] += 1
                updated_minerals -= bp[new_bot]
            end

            geodes[i] = max_geodes(updated_bots, updated_minerals, bp, max_minerals, t_remain-1, total_t, target_geodes)
        end

        result = maximum(geodes)
        max_geo_dict[key] = result
        return result
    end
end


 function get_max_geodes(bp, time, target_geodes) :: Int64
    robots = [1, 0, 0, 0]
    minerals = [0, 0, 0, 0]

    max_minerals = [0, 0, 0]
    for recipe in bp
        for i in 1:3
            if recipe[i] > max_minerals[i]
                max_minerals[i] = recipe[i]
            end
        end
    end

    println(max_minerals)

    geo = max_geodes(robots, minerals, bp, max_minerals, time, time, target_geodes)
    return geo
end



function solution1(path::String)
    input_strs = parse_input_lines(path, "\r\n")
    blueprints = parse_blueprint.(input_strs)
    time = 24

    quality = 0

    for (i, bp) in enumerate(blueprints[1:3])
        empty!(max_geo_dict)
        empty!(scenario_dict)

        result = get_max_geodes(bp, time, 0)
        println("Blueprint $i gives quality $result")
        quality += result * i 
    end

    println(quality)
end


function solution2(path::String)
    input_strs = parse_input_lines(path, "\r\n")
    blueprints = parse_blueprint.(input_strs)
    time = 32

    quality = 1

    for (i, bp) in enumerate(blueprints[1:3])
        empty!(max_geo_dict)
        empty!(scenario_dict)

        result = get_max_geodes(bp, time, max_sofar[i])
        println("Blueprint $i gives quality $result")
        quality *= result
    end
    println(quality)
end


# @time solution1("./input_example.txt")
# @time solution1("./input.txt")
@time solution2("./input.txt")
# @time solution2("./input_example.txt")