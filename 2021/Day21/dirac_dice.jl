include("../../utils/io.jl")

# Input
# Player 1 starting position: 8
# Player 2 starting position: 1

mutable struct Die 
    number::Int8
    roll_count::Int64
end


function roll!(current_die::Die)
    current_num = current_die.number
    new_num = current_num + 1

    if new_num > 100
        new_num -= 100
    end

    current_die.number = new_num
    current_die.roll_count += 1

    return current_num
end


function possible_rolls_per_turn()
    # Every turn the die is cast 3 times. Possible outcome can be 3-9
    # Among all 27 scenarios, outcome 3-9 have different corresponding number of them

    rolls = [
        (i, j, k) for i in 1:3 for j in 1:3 for k in 1:3
    ]

    count = Dict()
    for roll in rolls
        total = sum(roll)
        count[total] = get!(count, total, 0) + 1
    end

    return count
end


function take_turn!(die, player_pos)
    move = 0
    for _ in 1:3
        move += roll!(die)
    end

    return (player_pos + move - 1) % 10 + 1
end



function solution1()
    p1_pos = 8
    p1_score = 0
    p2_pos = 1
    p2_score = 0
    die = Die(1, 0)
    count = 0

    while true
        p1_pos = take_turn!(die, p1_pos)
        p1_score += p1_pos
        p1_score < 1000 || break

        p2_pos = take_turn!(die, p2_pos)
        p2_score += p2_pos
        p2_score < 1000 || break
    end

    print(minimum([p1_score, p2_score]) * die.roll_count)

end


function game_proc(start_position, sequence)

    position = start_position
    score = 0

    for (i, num) in enumerate(sequence)
        position += num
        if position > 10
            position -= 10
        end
        score += position
        score < 21 || return true
    end

    return false
end

function possible_unis(winning_seq, moves)
    total = 1
    for step in winning_seq
        total *= moves[step]
    end
    return total
end

function find_scenario_counts(start_pos)
    moves = possible_rolls_per_turn()
    possible_sequence = Dict()
    possible_sequence[1] = Set([[i] for i in keys(moves)])

    winning = []
    not_winning = []
    

    for i in 2:10 # maximum possible turns before one turns 21 is 9
        new_possible_seqs = Set()
        winning_senario = 0
        not_winning_scenario = 0
        for prev_seq in possible_sequence[i-1]
            for move in keys(moves)
                new_seq = append!(copy(prev_seq), move)
                push!(new_possible_seqs, new_seq)
            end
        end
        for seq in new_possible_seqs
            result = game_proc(start_pos, seq)
            if result
                winning_senario += possible_unis(seq, moves)
                delete!(new_possible_seqs, seq)
            else
                not_winning_scenario += possible_unis(seq, moves)
            end
        end
        append!(winning, winning_senario)
        append!(not_winning, not_winning_scenario)
        delete!(possible_sequence, i-1)
        possible_sequence[i] = new_possible_seqs
    end

    return (winning, not_winning)
end



function solution2()
    p1_scenario_counts = find_scenario_counts(8)
    p2_scenario_counts = find_scenario_counts(1)

    total1 = 0
    total2 = 0

    for (p1, p2) in zip(p1_scenario_counts[1], p2_scenario_counts[2])
        total1 += p1 * p2
    end

    for (p1, p2) in zip(p1_scenario_counts[2], p2_scenario_counts[1])
        total2 += p1 * p2
    end



    print(p1_scenario_counts, "\n")
    print(p2_scenario_counts, "\n")
    print(total1, "\n")
    print(total2, "\n")

end

# solution1()
solution2()