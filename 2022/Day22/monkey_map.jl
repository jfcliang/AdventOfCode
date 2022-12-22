include("../../utils/io.jl")
include("./cube_wrapping.jl")

turns = Dict{Char, Dict{Char, Char}}(
    'L' => Dict{Char, Char}(
        '^' => '<', '<' => 'v', 
        'v' => '>', '>' => '^'
    ), 
    'R' => Dict{Char, Char}(
        '^' => '>', '<' => '^', 
        'v' => '<', '>' => 'v'
    )
)

moves = Dict{Char, Tuple{Int64, Int64}}(
    '^' => (-1, 0), 'v' => (1, 0),
    '<' => (0, -1), '>' => (0, 1)
)

facing = Dict{Char, Int64}(
    '^' => 3, 'v' => 1,
    '<' => 2, '>' => 0
)


function load_map(path::String)
    lines = String.(split(input_to_raw_str(path, false), "\r\n"))
    x_max = maximum(length.(lines))
    y_max = length(lines)

    map = fill(' ', (y_max, x_max))
    for y in 1:y_max
        for x in 1:length(lines[y])
            map[y, x] = lines[y][x]
        end
    end

    return map
end


function load_directions(path::String)
    line = input_to_raw_str(path)
    dirs = []
    cache = ""
    for (i, c) in enumerate(line)
        if c == 'R' || c == 'L'
            push!(dirs, parse(Int64, cache))
            cache = ""
            push!(dirs, c)
        else
            cache *= c
        end
    end

    if cache != ""
        push!(dirs, parse(Int64, cache))
    end

    return dirs
end


function find_start(map::Matrix{Char})
    for (i, c) in enumerate(map[1,:])
        if c != ' ' && c != '#'
            return (1, i)
        end
    end
end


function wrap_around(
    map::Matrix{Char}, point::Tuple{Int64, Int64}, 
    dir::Char)

    y, x = point
    check_not_void = c -> c != ' '
    if dir == 'v'
        new_y = findall(check_not_void, map[:, x])[begin]
        return (new_y, x), dir
    elseif dir == '^'
        new_y = findall(check_not_void, map[:, x])[end]
        return (new_y, x), dir
    elseif dir == '<'
        new_x = findall(check_not_void, map[y, :])[end]
        return (y, new_x), dir
    elseif dir == '>'
        new_x = findall(check_not_void, map[y, :])[begin]
        return (y, new_x), dir
    else
        throw(ErrorException("Unknown direction: $dir"))
    end
end


function walk!(
    map::Matrix{Char}, 
    pos::Tuple{Int64, Int64}, 
    dir::Char, steps::Int64, wrap::Function) :: Tuple{Tuple{Int64, Int64}, Char}
    
    y_m, x_m = size(map)

    for _ in 1:steps
        y, x = pos
        map[y, x] = dir
        dy, dx = moves[dir]

        if (x+dx < 1 || x+dx > x_m || y+dy < 1 || y+dy > y_m || map[y+dy, x+dx]==' ')
            (ynew, xnew), new_dir = wrap(map, (y,x), dir)
            if map[ynew, xnew] == '#'
                return (y, x), dir                                                                       
            else
                pos = (ynew, xnew)
                dir = new_dir
            end
        else
            xnew, ynew = x+dx, y+dy
            if map[ynew, xnew] == '#'
                return (y, x), dir
            else
                pos = (ynew, xnew)
            end
        end
    end

    return pos, dir
end

function solution1(path_map::String, path_dir::String)
    map = load_map(path_map)
    instructions = load_directions(path_dir)

    point = find_start(map)
    println(point)
    dir = '>'

    for ins in instructions
        if ins == 'R' || ins == 'L'
            dir = turns[ins][dir]
        else
            point, dir = walk!(map, point, dir, ins, wrap_around)
        end
    end

    y, x = point
    println(point)
    println(dir)
    println(y*1000 + x*4 + facing[dir])

end

function solution2(path_map::String, path_dir::String)
    map = load_map(path_map)
    instructions = load_directions(path_dir)

    point = find_start(map)
    println(point)
    dir = '>'

    for ins in instructions
        if ins == 'R' || ins == 'L'
            dir = turns[ins][dir]
        else
            point, dir = walk!(map, point, dir, ins, cube_wrap)
        end
    end

    y, x = point
    println(point)
    println(dir)
    println(y*1000 + x*4 + facing[dir])

end

@time solution1("./input_map_example.txt", "input_dirs_example.txt")
@time solution1("./input_map.txt", "input_dirs.txt")
@time solution2("./input_map.txt", "input_dirs.txt")
