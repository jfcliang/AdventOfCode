include("../../utils/io.jl")

struct Step
    direction
    x_range
    y_range
    z_range
end


function parse_input(path::String)
    function parse_coord_range(str)
        start, finish = split(str, "..")
        start = parse(Int64, start)
        finish = parse(Int64, finish)

        return (start, finish)
    end

    raw_str = input_to_raw_str(path)
    rows = strip.(split(raw_str, "\n"))
    steps = []
    for row in rows
        direction, range = split(row, " ")
        xyz = split(range, ",")
        x_range = parse_coord_range(xyz[1][3:end])
        y_range = parse_coord_range(xyz[2][3:end])
        z_range = parse_coord_range(xyz[3][3:end])

        step = Step(direction, x_range, y_range, z_range)
        append!(steps, [step])
    end
    
    return steps
    
end


function make_relevant_range(range)

    left = max(-50, range[1])
    right = min(50, range[2])
    
    if right >= left
        return left:right
    else
        return []
    end

end


function operate!(cube, step)
    x_range = make_relevant_range(step.x_range)
    y_range = make_relevant_range(step.y_range)
    z_range = make_relevant_range(step.z_range)



    for x in x_range
        for y in y_range
            for z in z_range 
                if step.direction == "on"
                    cube[x+51, y+51, z+51] = true
                else
                    cube[x+51, y+51, z+51] = false
                end    
            end
        end
    end
end


function solution(path::String)
    steps = parse_input(path)
    cube = fill(false, (101, 101, 101))

    for step in steps
        operate!(cube, step)

    end
    print(sum(cube))
end

function check_if_overlap(step1::Step, step2::Step)
    function check_range_overlap(tuple1, tuple2)
        return !(tuple1[2] < tuple2[1] || tuple2[2] < tuple1[1])
    end

    return (
        check_range_overlap(step1.x_range, step2.x_range) &&
        check_range_overlap(step1.y_range, step2.y_range) &&
        check_range_overlap(step1.z_range, step2.z_range))
end


function solution2(path::String)
    total_steps = parse_input(path)
    # within the initial zone: 601104 lit
    steps = total_steps[21:end]

    for (i, step1) in enumerate(steps)
        for step2 in steps[i+1:end]
            if step1.direction == "off" && step2.direction == "off"
                if check_if_overlap(step1, step2)
                    print(step1, step2, "\n")
                end
            end
        end
    end


end


# solution("./input.txt")
solution2("./input.txt")