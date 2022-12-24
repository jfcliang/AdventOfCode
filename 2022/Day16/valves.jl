
include("../../utils/io.jl")

speed_cache = Dict{UInt64, Int64}()
steam_cache = Dict{UInt64, Int64}()

struct Valve
    name::String
    flow_rate::Int64
    leads::Vector{String}
end

function parse_line(line::String)
    pattern = r"Valve (?<current>[A-Z]+) has flow rate=(?<flow>[0-9]+); tunnels? leads? to valves? (?<leads>[\,,\ ,A-Z]+)"
    m = match(pattern, line)
    name = m["current"]
    flow = parse(Int64, m["flow"])
    leads = String.(strip.(split(m["leads"], ", ")))

    return Valve(name, flow, leads)
end


function current_speed(valves::Dict{String, Valve}, statii::Dict{String, Bool})
    key = hash((statii))
    if haskey(speed_cache, key)
        return speed_cache[key]
    end

    speed = 0
    for valve in values(valves)
        if statii[valve.name]
            speed += valve.flow_rate
        end
    end

    speed_cache[key] = speed
    return speed
end


function current_speed_with_restriction(
    valves::Dict{String, Valve}, allowed::Set{String},
    statii::Dict{String, Bool})

    key = hash((statii, allowed))

    if haskey(speed_cache, key)
        return speed_cache[key]
    end

    speed = 0
    for valve in values(valves)
        if statii[valve.name] && (valve.name in allowed)
            speed += valve.flow_rate
        end
    end

    speed_cache[key] = speed
    return speed
end


function find_highest_possible(
    current_valve::String, valves::Dict{String, Valve},
    statii::Dict{String, Bool}, time_remain::Int64)

    key = hash((current_valve, statii, time_remain))
    if haskey(steam_cache, key)
        return steam_cache[key]
    end

    rate = current_speed(valves, statii)

    if time_remain == 1
        return rate
    else
        scenario_results = Vector{Int64}()
        if !statii[current_valve] && valves[current_valve].flow_rate > 0
            new_statii = copy(statii)
            new_statii[current_valve] = true
            push!(
                scenario_results, 
                find_highest_possible(current_valve, valves, new_statii, time_remain-1)
            )
        end
        for next_valve in valves[current_valve].leads
            push!(
                scenario_results, 
                find_highest_possible(next_valve, valves, statii, time_remain-1)
            )
        end 

        result = rate + maximum(scenario_results)
        steam_cache[key] = result

        return result
    end
end


function find_highest_possible_with_restrictions(
    current_valve::String, valves::Dict{String, Valve},
    allowed::Set{String},
    statii::Dict{String, Bool}, time_remain::Int64)

    key = hash((current_valve, statii, allowed, time_remain))
    if haskey(steam_cache, key)
        return steam_cache[key]
    end

    rate = current_speed_with_restriction(valves, allowed, statii)

    if time_remain == 1
        return rate
    else
        scenario_results = Vector{Int64}()
        if !statii[current_valve] && valves[current_valve].flow_rate > 0 && (current_valve in allowed)
            # The subset separation should only apply to valves being open, 
            # not valves being visited
            new_statii = copy(statii)
            new_statii[current_valve] = true
            push!(
                scenario_results, 
                find_highest_possible_with_restrictions(
                    current_valve, valves, allowed, new_statii, time_remain-1
                )
            )
        end

        for next_valve in valves[current_valve].leads
            push!(
                scenario_results, 
                find_highest_possible_with_restrictions(
                    next_valve, valves, allowed, statii, time_remain-1
                )
            )
        end 

        if length(scenario_results) != 0
            result = rate + maximum(scenario_results)
        else
            result = 0
        end

        steam_cache[key] = result
        return result
    end
end


function solution1(path::String)
    lines = parse_input_lines(path, "\r\n")
    valves = parse_line.(lines)

    statii = Dict{String, Bool}()
    valves_by_name = Dict{String, Valve}()
    for valve in valves
        statii[valve.name] = false
        valves_by_name[valve.name] = valve
    end

    highest = find_highest_possible("AA", valves_by_name, statii, 26)

    println(highest)
end


function generate_possible_subsets(valves_by_name::Dict{String, Valve})
    possibles = Set{Tuple{Set{String}, String}}()

    push!(possibles, (Set(["AA"]), "AA"))

    for _ in 1:25
        orig_pos = copy(possibles)
        for (visited, curr) in orig_pos
            curr = valves_by_name[curr]
            nexts = curr.leads
            delete!(possibles, (visited, curr))
            for next in nexts
                if !(next in visited)
                    new_visited = copy(visited)
                    push!(new_visited, next)
                    push!(possibles, (new_visited, next))
                end
            end
        end
    end

    subsets = Set{Set{String}}()

    for (visited, _) in possibles
        push!(subsets, visited)
    end

    println("Possible subsets: $(length(subsets))")

    return subsets
end


function solution2(path::String)
    lines = parse_input_lines(path, "\r\n")
    valves = Set(parse_line.(lines))

    valve_set = Set{String}()

    statii = Dict{String, Bool}()
    valves_by_name = Dict{String, Valve}()

    for valve in valves
        statii[valve.name] = false
        valves_by_name[valve.name] = valve
        push!(valve_set, valve.name)
    end

    possible_subsets = generate_possible_subsets(valves_by_name)
    result = 0

    for subset in possible_subsets
        empty!(speed_cache)
        empty!(steam_cache)

        sub2 = setdiff(valve_set, subset)
        push!(sub2, "AA")

        new_result = find_highest_possible_with_restrictions(
            "AA", valves_by_name, subset, statii, 26
        ) + find_highest_possible_with_restrictions(
            "AA", valves_by_name, sub2, statii, 26
        )

        result = max(result, new_result)
    end

    println(result)
end

# @time solution1("./input_example.txt")
# @time solution1("./input.txt")
@time solution2("./input_example.txt")
@time solution2("./input.txt")
