using DataStructures

include("../../utils/io.jl")


struct Instruction
    num::Int64
    from::Int64
    to::Int64
end

function create_stack(row::Vector{Char})
    pile = Stack{Char}()
    size = length(row)
    for c in row
        push!(pile, c)
    end

    return pile
end

function create_ins(words::Vector)
    num = parse(Int64, words[2])
    from = parse(Int64, words[4])
    to = parse(Int64, words[6])

    return Instruction(num, from, to)
end


function load_instructions(path::String)
    lines = parse_input_lines(path, "\n")
    ins = [create_ins(split(line, " ")) for line in lines]

    return ins
end


function load_crate_map(path::String)
    lines = parse_input_lines(path, "\r\n")
    return [
        create_stack([char for char in line]) for line in lines
    ]
end


function move_crates!(crate_map::Vector{Stack{Char}}, ins::Instruction)
    for i in 1:ins.num
        crate = pop!(crate_map[ins.from])
        push!(crate_map[ins.to], crate)
    end
end


function move_crates_9001!(crate_map::Vector{Stack{Char}}, ins::Instruction)
    crane = Stack{Char}()
    for i in 1:ins.num
        crate = pop!(crate_map[ins.from])
        push!(crane, crate)
    end

    for i in 1:ins.num
        crate = pop!(crane)
        push!(crate_map[ins.to], crate)
    end
end

function solution1(ins_path::String, map_path::String)
    ins_list = load_instructions(ins_path)
    map = load_crate_map(map_path)
    for ins in ins_list
        move_crates!(map, ins)
    end

    for pile in map
        print(pop!(pile))
    end
end

function solution2(ins_path::String, map_path::String)
    ins_list = load_instructions(ins_path)
    map = load_crate_map(map_path)
    for ins in ins_list
        move_crates_9001!(map, ins)
    end

    for pile in map
        print(pop!(pile))
    end
end


solution2("instructions.txt", "crate_map.txt")