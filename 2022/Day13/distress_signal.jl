using JSON

include("../../utils/io.jl")

@enum STATUS good cont bad


function parse_pair(pair_str::String)
    pair = split(pair_str, "\r\n")

    return [JSON.parse(String(signal_str)) for signal_str in pair]
end


function parse_input(path::String)

    pair_strs = parse_input_lines(path, "\r\n\r\n")
    return [parse_pair(pair) for pair in pair_strs]

end


function parse_input2(path::String)
    input_str = input_to_raw_str(path)
    cleaned = replace(input_str, "\r\n\r\n" => "\r\n")
    signal_strs = String.(strip.(split(cleaned, "\r\n")))

    return [JSON.parse(signal_str) for signal_str in signal_strs]
end

function compare_vectors(v1::Vector, v2::Vector)

    i = 1
    result = cont
    while i <= length(v1) && result == cont
        if i > length(v2)
            return bad
        end
        result = compare_vectors(v1[i], v2[i])
        # println(v1[i], " ", v2[i], " ", result)
        i += 1
    end

    if result == cont && length(v2) > length(v1)
        return good
    end
        
    return result 
end


function compare_vectors(v1::Int64, v2::Vector)
    return compare_vectors([v1], v2)
end


function compare_vectors(v1::Vector, v2::Int64)
    return compare_vectors(v1, [v2])
end


function compare_vectors(v1::Int64, v2::Int64)
    if v1 < v2
        return good
    elseif v1 == v2
        return cont
    else
        return bad
    end    
end


function solution1(path::String)

    pairs = parse_input(path)
    score = 0

    for (idx, pair) in enumerate(pairs)
        result = compare_vectors(pair[1], pair[2])
        # println(idx, " ", result)
        if result != bad
            score += idx
        end
    end
    
    println(score)
end


function compare(a, b)
    return !(compare_vectors(a, b) == bad)
end


function solution2(path::String)

    signals = parse_input2(path)
    push!(signals, [[2]])
    push!(signals, [[6]])

    sorted = sort(signals, lt=compare)

    result = 1

    for (i, signal) in enumerate(sorted)
        if signal == [[2]]
            result *= i
        end
        if signal == [[6]]
            result *= i
        end
    end
    
    println(result)

end


# solution1("./input_example.txt")
solution1("./input.txt")

solution2("./input.txt")
