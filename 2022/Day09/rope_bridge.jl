include("../../utils/io.jl")

mutable struct Knot
    x::Int64
    y::Int64
end


struct Instruction
    dir::String
    dis::Int64
end


function is_stretched(diff_x, diff_y)
    return abs(diff_x) > 1 || abs(diff_y) > 1
end

function move_head!(head::Knot, dir::String)
    if dir == "U"
        head.y += 1
    elseif dir == "D"
        head.y -= 1
    elseif dir == "L"
        head.x -= 1
    elseif dir == "R"
        head.x += 1
    else
        throw(ErrorException("Unidentified dir: $dir"))
    end
end

function move_tail!(head::Knot, tail::Knot)
    diff_x = head.x - tail.x
    diff_y = head.y - tail.y
    if is_stretched(diff_x, diff_y)
        tail.x += sign(diff_x)
        tail.y += sign(diff_y)
    end
end


function parse_instruction(line::String)
    parsed_lines = split(line, " ")
    return Instruction(
        String(parsed_lines[1]),
        parse(Int64, parsed_lines[2])
    )
end

function get_instructions(path::String)
    lines = parse_input_lines(path, "\r\n")
    instructions = [
        parse_instruction(String(line)) for line in lines
    ]

    return instructions
end

function solution1(path::String)
    instructions = get_instructions(path)
    head = Knot(0, 0)
    tail = Knot(0, 0)

    tail_locs = Set()
    push!(tail_locs, (tail.x, tail.y))

    for ins in instructions
        for i in 1:ins.dis
            move_head!(head, ins.dir)
            move_tail!(head, tail)
            push!(tail_locs, (tail.x, tail.y))
        end
    end

    println(length(tail_locs))
end

function solution2(path::String)
    instructions = get_instructions(path)
    rope = [Knot(0,0) for i in 1:10]
    
    tail_locs = Set()
    push!(tail_locs, (rope[10].x, rope[10].y))

    for ins in instructions
        for i in 1:ins.dis
            move_head!(rope[1], ins.dir)
            for j in 2:10
                move_tail!(rope[j-1], rope[j])
            end
            push!(tail_locs, (rope[10].x, rope[10].y))
        end
    end

    println(length(tail_locs))
end

solution1("./input.txt")
solution2("./input.txt")
            