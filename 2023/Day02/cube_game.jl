include("../../utils/io.jl")

function parse_input(path::String)
    strs = parse_input_lines(path, "\r\n")
    return strs
end

function parse_game_record(record::String)
    result = split(record, ": ")[2]
    draws = strip.(split(result, "; "))
    bounds = draw_to_bound.(draws)
    return bounds
end


function draw_to_bound(draw) 
    bound = Dict()

    cube_counts = strip.(split(draw, ", "))
    for count in cube_counts
        (num_str, color) = split(count, " ")
        num = parse(Int64, num_str)
        bound[color] = get!(bound, color, 0) + num
    end
    return bound
end

function bound_possible(bound) 
    return (
        get(bound, "red", 0) <= 12 &&
        get(bound, "green", 0) <= 13 &&
        get(bound, "blue", 0) <= 14
    )
end

function solution1(path::String) 
    records = parse_input(path)
    bounds = parse_game_record.(records)

    total = 0
    for (i, bound) in enumerate(bounds)
        possible = true
        for single_bound in bound
            if !bound_possible(single_bound)
                possible = false
            end
        end
        if possible
            total += i
        end
    end

    print(total)
end

function find_least_possible(bounds)
    leasts = Dict()
    for bound in bounds
        for (key, value) in bound
            if (get!(leasts, key, 0) < value)
                leasts[key] = value
            end
        end
    end
    return get(leasts, "red", 0) * get(leasts, "green", 0) * get(leasts, "blue", 0)
end

function solution2(path::String) 
    records = parse_input(path)
    bounds = parse_game_record.(records)
    powers = find_least_possible.(bounds)

    print(sum(powers))
end

# solution1("./input.txt")
solution2("./input.txt")
# solution1("./example.txt")
# solution2("./example.txt")
