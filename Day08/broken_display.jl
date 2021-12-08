include("../utils/io.jl")

UNIQUE_DIGITS = Set([2, 3, 4, 7])

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


function solve_digits(pattern_list)
    solver = Dict()
    pattern_by_count = Dict()
    rev_solver = Dict()

    # Find 1, 4, 7, 8
    for pattern in pattern_list
        count = length(pattern)
        pattern_set = Set(collect(pattern))
        if !(count in keys(pattern_by_count))
            pattern_by_count[count] = Set()
        end
        push!(pattern_by_count[count], pattern_set)

        if count == 2
            solver[pattern_set] = 1
            rev_solver[1] = pattern_set
        elseif count == 3
            solver[pattern_set] = 7
            rev_solver[7] = pattern_set
        elseif count == 4
            solver[pattern_set] = 4
            rev_solver[4] = pattern_set
        elseif count == 7
            solver[pattern_set] = 8
            rev_solver[8] = pattern_set
        end
    end
    
    # Digits with 5 parts: 3, 2, 5
    # Find 3 because 1 is in 3
    for pattern in values(pattern_by_count[5])
        if issubset(rev_solver[1], pattern)
            rev_solver[3] = pattern
            solver[pattern] = 3
            pop!(pattern_by_count[5], pattern)
        end
    end

    # Diff 2 and 5 by whether the different stroke is in 4
    pat25, pat52 = pattern_by_count[5]
    if issubset(setdiff(pat25, pat52), rev_solver[4])
        solver[pat25] = 5
        rev_solver[5] = pat25
        solver[pat52] = 2
        rev_solver[2] = pat52
    else
        solver[pat25] = 2
        rev_solver[2] = pat25
        solver[pat52] = 5
        rev_solver[5] = pat52
    end

    # Digits with 6 parts: 6, 0, 9
    # Find 6 because 1 is not in 6
    for pattern in values(pattern_by_count[6])
        if !issubset(rev_solver[1], pattern)
            rev_solver[6] = pattern
            solver[pattern] = 6
            pop!(pattern_by_count[6], pattern)
        end
    end

    # Diff 0 and 9 by whether 4 is in 9
    pat09, pat90 = pattern_by_count[6]
    if issubset(rev_solver[4], pat09)
        solver[pat09] = 9
        rev_solver[9] = pat09
        solver[pat90] = 0
        rev_solver[0] = pat90
    else
        solver[pat09] = 0
        rev_solver[0] = pat09
        solver[pat90] = 9
        rev_solver[9] = pat90
    end

    return solver
end


function solution(path::String)
    # Part 1
    entry_list = parse_input(path)

    total_1478 = sum(
        [count_1478(entry[2]) for entry in entry_list]
    )

    print("1, 4, 7, or 8 appear ", total_1478, " times. \n")

    # Part 2
    total = 0

    for entry in entry_list
        patterns = entry[1]
        targets = entry[2]

        solver = solve_digits(patterns)
        # print(solver)
        result = [solver[Set(target)] for target in targets]
        result_num = sum([result[i]*10^(length(result)-i) for i in 1:length(result)])
        # print(result_num, "\n")
        total += result_num
    end
    print("Sum of all outputs is ", total, "\n")
end

# solution("./input_example.txt")
solution("./input.txt")