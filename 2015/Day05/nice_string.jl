include("../../utils/io.jl")

VOWELS = Set(['a', 'e', 'i', 'o', 'u'])
FORBID = Set(["ab", "cd", "pq", "xy"])

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    strings = strip.(split(raw_str, '\n'))
    return strings
end

function check_string(str)
    has_double = false
    vowels = 0
    for (i, c) in enumerate(str)
        if c in VOWELS
            vowels += 1
        end
        if i > 1
            if str[i] == str[i-1]
                has_double = true
            end
            if str[i-1:i] in FORBID
                return false
            end
        end
    end
    return (vowels >= 3) && has_double
end


function check_string2(str)
    doubles = Dict{String, Array{Int64}}()
    has_jumps = false
    has_double = false

    for (i, c) in enumerate(str)
        if i > 2
            if !has_jumps && str[i] == str[i-2]
                has_jumps = true
            end
        end

        if i > 1   
            push!(get!(doubles, str[i-1:i], []), i)
        end
    end

    for (key, value) in doubles
        print(key, value, "\n")
        if length(value) >= 3
            has_double = true
            break
        elseif length(value) == 2
            has_double = (value[2] - value[1] > 1)
            if has_double
                break
            end
        end
    end

    # print(has_double, has_jumps)

    return has_double && has_jumps

end


function solution(path::String)
    strings = parse_input(path)

    print(sum(check_string.(strings)))

end

function solution2(path::String)
    strings = parse_input(path)

    print(sum(check_string2.(strings)))

end

function test_string(str)
    print(check_string2(str))
end

# test_string("qjhvhtzxzqqjkmpb")
solution2("./input.txt")