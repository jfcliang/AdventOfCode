include("../utils/io.jl")

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    crabs = [parse(Int64, crab) for crab in split(raw_str, ",")]
    return crabs
end

function gen_depth_table(crabs::Vector{Int64})
    depths = Dict()
    for crab in crabs
        if crab in keys(depths)
            depths[crab] += 1
        else
            depths[crab] = 1
        end
    end
    return depths
end

function calc_fuel(target, depths)
    total = 0
    for key in keys(depths)
        fuel = abs(target - key) * depths[key]
        total += fuel
    end
    return total
end

function calc_fuel_2(target, depths)
    total = 0
    for key in keys(depths)
        dis = abs(target - key)
        fuel = dis *  (dis+1) / 2 * depths[key]
        total += fuel
    end
    return total
end

function solution(path)
    crabs = parse_input(path)
    depths = gen_depth_table(crabs)
    min_depth = minimum(crabs)
    max_depth = maximum(crabs)

    fuels = [calc_fuel(target, depths) for target in min_depth:max_depth]
    print(minimum(fuels), "\n")
    
    fuels2 = [calc_fuel_2(target, depths) for target in min_depth:max_depth]
    print(minimum(fuels2), "\n")
end

solution("./input.txt")