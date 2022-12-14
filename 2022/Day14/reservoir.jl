include("../../utils/io.jl")

@enum DIRECTION down left right none out


function parse_coords(coords::String)
    return parse.(Int64, split(coords, ","))
end

function parse_line(line::String)
    return parse_coords.(String.(split(line, " -> ")))
end

function parse_input(path::String)
    input_lines = parse_input_lines(path, "\r\n")

    lines = [parse_line(line) for line in input_lines]

    max_xs = [maximum([coord[1] for coord in line]) for line in lines]
    min_xs = [minimum([coord[1] for coord in line]) for line in lines]
    max_ys = [maximum([coord[2] for coord in line]) for line in lines]
    min_ys = [minimum([coord[2] for coord in line]) for line in lines]

    println("Rock range x: $(minimum(min_xs)) - $(maximum(max_xs))")
    println("Rock range y: $(minimum(min_ys)) - $(maximum(max_ys))")

    return lines
end


function generate_map(lines)
    # range x : 473 - 527, y: 13 - 165
    # shift: x - 471
    # new range: x: 2 - 56, y: 13 - 165

    map = fill(false, (57, 166))
    
    for line in lines
        for i in 1:(length(line) - 1)
            start = line[i]
            finish = line[i+1]
            for j in min(start[2], finish[2]):max(start[2], finish[2])
                for k in min(start[1], finish[1]):max(start[1], finish[1])
                    map[k-471, j] = true
                end
            end
        end
    end
    
    return map
end

function check_space(sand, map)
    sand_x, sand_y = sand[1], sand[2]

    if sand_y == 166
        return out
    end

    if !map[sand_x, sand_y + 1]
        return down
    elseif !map[sand_x - 1, sand_y + 1]
        return left
    elseif !map[sand_x + 1, sand_y + 1]
        return right
    else
        return none
    end
end

function move_sand!(sand, map, dir)

    if dir == out
        return 
    end

    if dir == down
        sand[2] += 1
    elseif dir == left
        sand[1] -= 1
        sand[2] += 1
    elseif dir == right
        sand[1] += 1
        sand[2] += 1
    else
        map[sand[1], sand[2]] = true
    end
end

function drop_sand!(map)
    sand = [500 - 471, 0]

    dir = down

    while dir != none && dir != out
        dir = check_space(sand, map)
        move_sand!(sand, map, dir)
    end

    return dir
end
        
function solution1(path::String)
    lines = parse_input(path)
    map = generate_map(lines)

    total = 0
    dir = down
    while dir != out
        dir = drop_sand!(map)
        total += 1
    end

    println(total - 1)
    
end


# solution1("./input_example.txt")
solution1("./input.txt")