include("../../utils/io.jl")

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    numbers = [parse(Int64, row) for row in split(raw_str, "\n")]

    return numbers
end


function solution(path::String)
    numbers = parse_input(path)
    found = false

    # Part 1
    matches = Set()
    for num in numbers
        if num in matches
            print(num * (2020-num), "\n")
            found = true
        else
            push!(matches, 2020-num)
        end
        if found
            break
        end
    end

    # Part 2
    matches = Dict()
    found = false
    for n1 in numbers
        for n2 in numbers
            if n2 in keys(matches)
                print(n2 * matches[n2][1] * matches[n2][2] , "\n")
                found = true
            else
                matches[2020-n1-n2] = (n1, n2)
            end

            if found
                break
            end
        end
        if found
            break
        end
    end
end


solution("./input.txt")