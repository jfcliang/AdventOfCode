include("../../utils/io.jl")
include("../../utils/misc.jl")


function solution(path::String)
    instructions = input_to_raw_str(path)
    y, x = 0, 0
    visited = Set()
    push!(visited, (y, x))
    for c in instructions
        y, x = arrow_to_move(y, x, c)
        push!(visited, (y, x))
    end

    print(length(visited))

end

function solution2(path::String)
    instructions = input_to_raw_str(path)
    y_santa, x_santa = 0, 0
    y_robot, x_robot = 0, 0
    visited = Set()
    push!(visited, (0, 0))
    for (i, c) in enumerate(instructions)
        if i % 2 == 1
            y_santa, x_santa = arrow_to_move(y_santa, x_santa, c)
            push!(visited, (y_santa, x_santa))
        else
            y_robot, x_robot = arrow_to_move(y_robot, x_robot, c)
            push!(visited, (y_robot, x_robot))
        end
    end

    print(length(visited))

end

solution2("./input.txt")
