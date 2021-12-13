include("../utils/io.jl")

function parse_points(raw_points)
    function parse_row(row)
        return [parse(Int64, i) for i in split(row, ',')]
    end

    return [parse_row(row) for row in split(raw_points, '\n')]
end

function parse_instructs(raw_instructs)
    function parse_row(row)
        ins = split(row, ' ')[3]
        axis = split(ins, '=')[1]
        pos = parse(Int64, split(ins, '=')[2])
        return (axis, pos)
    end

    return [parse_row(row) for row in split(raw_instructs, '\n')]
end


function fold!(pts, instruction)
    axis, pos = instruction
    if axis == "x"
        for point in pts
            if point[1] > pos
                point[1] = 2 * pos - point[1]
            end
        end
    else
        for point in pts
            if point[2] > pos
                point[2] = 2 * pos - point[2]
            end
        end
    end
end


function render(pts)
    canvas_size = maximum(pt[2] for pt in pts) + 1,  maximum([pt[1] for pt in pts]) + 1
    canvas = fill('.', canvas_size)
    for pt in pts
        canvas[pt[2] + 1, pt[1] + 1] = '#'
    end
    print(canvas)
end

function solution(path::String)
    raw_str = input_to_raw_str(path)
    points, instructs = strip.(split(raw_str, "\n\n"))
    pts = parse_points(points)
    ins = parse_instructs(instructs)

    fold!(pts, ins[1])
    print("Numver of visible points: ", length(Set(pts)), '\n')

    for instruction in ins[2:end]
        fold!(pts, instruction)
    end

    render(pts)
end


solution("./input.txt")