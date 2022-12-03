include("../../utils/io.jl")

struct Rucksack
    input_string::String
    part_1::Set
    part_2::Set
    total::Set

    function Rucksack(input::String)
        part_len = div(length(input), 2)
        p1 = Set([c for c in input[begin:part_len]])
        p2 = Set([c for c in input[(part_len+1):end]])
        total = union(p1, p2)
        new(input, p1, p2, total)
    end
end

function char_to_int(item::Char)
    if 'a' <= item <= 'z'
        return item - 'a' + 1
    end
    if 'A' <= item <= 'Z'
        return item - 'A' + 27
    end
end

function dupe_priority(sack::Rucksack)
    overlap = intersect(sack.part_1, sack.part_2)
    if length(overlap) > 1
        println("wrong set for rucksack: ", sack)
    end
    item = first(overlap)
    return char_to_int(item)
end

function parse_input(path::String)
    input_raw = input_to_raw_str(path)
    sacks = [Rucksack(String(sack_str)) for sack_str in strip.(split(input_raw, "\r\n"))]
    return sacks
end

function solution1(path::String)
    sacks = parse_input(path)
    priorities = [dupe_priority(sack) for sack in sacks]

    println(sum(priorities))
end

function solution2(path::String)
    sacks = parse_input(path)
    n = length(sacks)
    n_groups = div(n, 3)
    grouped = reshape(sacks, (3, n_groups))

    priorities = zeros(n_groups)

    for i in 1:n_groups
        groupsacks = grouped[:, i]
        overlap = intersect(
            groupsacks[1].total, 
            groupsacks[2].total,
            groupsacks[3].total
        )
        priority = char_to_int(first(overlap))
        priorities[i] = priority
    end
    println(sum(priorities))
end


# solution1("./input.txt")
solution2("./input.txt")