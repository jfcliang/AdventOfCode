include("../../utils/io.jl")

function parse_pair_str(pair::String)
    ranges = strip.(split(pair, ","))
    return [
        parse.(Int64, split(range, "-")) for range in ranges
    ] 
end


function parse_input(path::String)
    raw_string = input_to_raw_str(path)
    pairs = strip.(split(raw_string, "\r\n"))

    ranges = [parse_pair_str(String(pair)) for pair in pairs]

    return ranges
end


function check_fully_contains(range1, range2)
    return (
        (range1[1] >= range2[1] && range1[2] <= range2[2]) ||
        (range1[1] <= range2[1] && range1[2] >= range2[2])
    )
end


function check_overlaps(range1, range2)

    no_overlap = (
        range1[2] < range2[1] || range1[1] > range2[2]
    )

    return !no_overlap
end


function solution(path::String)
    range_pairs = parse_input(path)
    contains = [
        check_fully_contains(ranges[1], ranges[2]) for ranges in range_pairs
    ]
    overlaps = [
        check_overlaps(ranges[1], ranges[2]) for ranges in range_pairs
    ]

    println(sum(contains))
    println(sum(overlaps))
end

solution("./input.txt")