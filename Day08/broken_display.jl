include("../utils/io.jl")

UNIQUE_DIGITS = Set([2, 3, 4, 7])
DIGIT_MAP = Dict(
    Set(collect("abcefg"))  => 0,
    Set(collect("cf"))      => 1, 
    Set(collect("acdeg"))   => 2,
    Set(collect("acdfg"))   => 3,
    Set(collect("bcdf"))    => 4,
    Set(collect("abdfg"))   => 5, 
    Set(collect("abdefg"))  => 6,
    Set(collect("acf"))     => 7,
    Set(collect("abcdefg")) => 8,
    Set(collect("abcdfg"))  => 9
)

function parse_line(line)
    patterns, output = split(line, "|")
    patterns = split(strip(patterns), " ")
    output = split(strip(output), " ")
    return patterns, output
    
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    lines = split(raw_str, "\n")
    entry_list = parse_line.(lines)
    return entry_list
end

function count_1478(list)
    return sum(
        [(length(digit) in UNIQUE_DIGITS) for digit in list])
end


function solution(path::String)
    entry_list = parse_input(path)

    total_1478 = sum(
        [count_1478(entry[2]) for entry in entry_list]
    )

    print("1, 4, 7, or 8 appear ", total_1478, " times. \n")

    
end

solution("./input.txt")
