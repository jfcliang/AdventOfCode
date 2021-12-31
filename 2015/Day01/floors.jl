include("../../utils/io.jl")


function solution(path::String)
    str = input_to_raw_str(path)
    start_floor = 0
    reached = false
    when_reached = 0
    for (i, char) in enumerate(str)
        if char == '('
            start_floor += 1
        else
            start_floor -= 1
        end

        if start_floor == -1 && !reached
            when_reached = i
            reached = true
        end
    end

    print("End floor at: ", start_floor, "\n")
    print("First reached basement at: ", when_reached)

end


solution("./input.txt")