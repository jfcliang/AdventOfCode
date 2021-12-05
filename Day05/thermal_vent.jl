include("../utils/io.jl")

struct ThermalLine
    point_a::Tuple{Int, Int}
    point_b::Tuple{Int, Int}
end

function ThermalLine(raw_line)
    coordinates = split(raw_line, " -> ")
    point_a = [parse(Int64, num) for num in split(coordinates[1], ",")]
    point_b = [parse(Int64, num) for num in split(coordinates[2], ",")]

    return ThermalLine((point_a...,), (point_b...,))
end

function is_line_valid(line::ThermalLine)
    return (line.point_a[1] == line.point_b[1]) || (line.point_a[2] == line.point_b[2])
end

function is_line_diag(line::ThermalLine)
    disx = line.point_a[1] - line.point_b[1]
    disy = line.point_a[2] - line.point_b[2]

    return (disx == disy) || (disx == -disy)
end

function is_line_valid_2(line::ThermalLine)
    return is_line_valid(line) || is_line_diag(line)
end

function parse_raw(input_path::String)
    raw_str = input_to_raw_str(input_path)
    raw_line_arr = [ThermalLine(str) for str in split(raw_str, "\n")]
    valid_lines = [line for line in raw_line_arr if is_line_valid(line)]

    return valid_lines
end

function parse_raw_2(input_path::String)
    raw_str = input_to_raw_str(input_path)
    raw_line_arr = [ThermalLine(str) for str in split(raw_str, "\n")]
    valid_lines = [line for line in raw_line_arr if is_line_valid_2(line)]

    return valid_lines
end

function add_line!(seabed, line)
    if line.point_a[1] == line.point_b[1]
        x = line.point_a[1]
        start = min(line.point_a[2], line.point_b[2])
        fin = max(line.point_a[2], line.point_b[2])

        line_range = start:fin
        for y in line_range
            seabed[x, y] += 1
        end

    else
        y = line.point_a[2]
        start = min(line.point_a[1], line.point_b[1])
        fin = max(line.point_a[1], line.point_b[1])

        line_range = start:fin
        for x in line_range
            seabed[x, y] += 1
        end
    end
end

function step_dir(x1, x2)
    if x1 < x2
        return 1
    else
        return -1
    end
end

function add_line_diag!(seabed, line)
    if line.point_a[1] == line.point_b[1] || line.point_a[2] == line.point_b[2]
        add_line!(seabed, line)
    elseif line.point_a[1] != line.point_b[1]
        x_step = step_dir(line.point_a[1], line.point_b[1])
        y_step = step_dir(line.point_a[2], line.point_b[2])

        x_range = line.point_a[1]: x_step: line.point_b[1]
        y_range = line.point_a[2]: y_step: line.point_b[2]

        for i in 1:length(x_range)
            seabed[x_range[i], y_range[i]] += 1
        end
    end
end

function solution()
    # Part 1
    valid_lines = parse_raw("./input.txt")
    seabed = fill(0, (1000, 1000))

    for line in valid_lines
        add_line!(seabed, line)
    end

    print("Danger zone: ", sum(point >= 2 for point in seabed), "\n")

    # Part 2
    valid_lines = parse_raw_2("./input.txt")
    seabed = fill(0, (1000, 1000))

    for line in valid_lines
        add_line_diag!(seabed, line)
    end

    print("Danger zone: ", sum(point >= 2 for point in seabed), "\n")

end

solution()