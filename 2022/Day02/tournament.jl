include("../../utils/io.jl")

function parse_input(path::String)
    input_str = input_to_raw_str(path)
    tips = strip.(split(input_str, "\r\n"))

    match_tips = [strip.(split(tip, " ")) for tip in tips]

    return match_tips
end


function match_result(i, j)
    result = mod(j - i, 3)
    if result == 0
        return 3
    elseif result == 1 
        return 6
    else
        return 0
    end
end

function gen_strat(elf, result)
    if result == 1
        return mod(elf + 2, 3)
    elseif result == 2
        return elf
    else
        return mod(elf + 1, 3)
    end
end


function process_match(elf, me)

    result = me + match_result(elf, me)

    return result
end


function calc_points(path::String)
    match_tips = parse_input(path)

    scores = Dict(
        # Rock 1, Paper 2, Scissors 3 
        "A" => 1, "B" => 2, "C" => 3,
        "X" => 1, "Y" => 2, "Z" => 3
    )

    total = 0
    for match in match_tips
        total = total + process_match(scores[match[1]], scores[match[2]])
    end
    print(total)

end


function calc_points_2(path::String)
    match_tips = parse_input(path)
    scores = Dict(
        # Rock 1, Paper 2, Scissors 3 
        "A" => 1, "B" => 2, "C" => 3,
        "X" => 1, "Y" => 2, "Z" => 3
    )

    total = 0
    for match in match_tips
        strat = gen_strat(scores[match[1]], scores[match[2]])
        if strat == 0
            strat = 3
        end
        total = total + process_match(scores[match[1]], strat)
    end
    print(total)
end


calc_points_2("./input.txt")