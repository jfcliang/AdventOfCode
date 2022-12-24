include("../../utils/io.jl")
include("./dijkstra.jl")

dirs = ['<', '>', '^', 'v']


function read_input(path::String)
    input = parse_char_matrix(path)
    ym, xm = size(input)

    blizzards = Dict(
        '>' => Set{Tuple{Int64, Int64}}(), '^' => Set{Tuple{Int64, Int64}}(),
        '<' => Set{Tuple{Int64, Int64}}(), 'v' => Set{Tuple{Int64, Int64}}()
    )

    for y in 1:ym
        for x in 1:xm
            c = input[y, x]
            if haskey(blizzards, c)
                push!(blizzards[c], (y, x))
            end
        end
    end

    return blizzards, ym, xm
end


function update_winds!(
    blizzards::Dict{Char, Set{Tuple{Int64, Int64}}}, 
    ym::Int64, xm::Int64)

    right_set = blizzards['>']
    new_set = Set()
    for (y, x) in right_set
        if x+1 == xm
            push!(new_set, (y, 2))
        else
            push!(new_set, (y, x+1))
        end
    end
    blizzards['>'] = new_set

    left_set = blizzards['<']
    new_set = Set()
    for (y, x) in left_set
        if x-1 == 1
            push!(new_set, (y, xm-1))
        else
            push!(new_set, (y, x-1))
        end
    end
    blizzards['<'] = new_set

    up_set = blizzards['^']
    new_set = Set()
    for (y, x) in up_set
        if y-1 == 1
            push!(new_set, (ym-1, x))
        else
            push!(new_set, (y-1, x))
        end
    end
    blizzards['^'] = new_set

    down_set = blizzards['v']
    new_set = Set()
    for (y, x) in down_set
        if y+1 == ym
            push!(new_set, (2, x))
        else
            push!(new_set, (y+1, x))
        end
    end
    blizzards['v'] = new_set
end

function add_sides!(
    walls::Set{Tuple{Int64, Int64, Int64}}, 
    t::Int64, ym::Int64, xm::Int64)
    
    for x in 1:xm
        push!(walls, (1, x, t))
        push!(walls, (ym, x, t))
    end
    
    for y in 1:ym
        push!(walls, (y, 1, t))
        push!(walls, (y, xm, t))
    end

    delete!(walls, (1, 2, t)) # entrance
    delete!(walls, (ym, xm-1, t)) # exit
end

function update_3d_map!(
    walls::Set{Tuple{Int64, Int64, Int64}}, 
    blizzards::Dict{Char, Set{Tuple{Int64, Int64}}}, 
    t::Int64, ym::Int64, xm::Int64)

    for dir in dirs
        bliz = blizzards[dir]
        for pt in bliz
            push!(walls, (pt[1], pt[2], t))
        end
    end

    add_sides!(walls, t, ym, xm)
end

function construct_3d_map(
    blizzards::Dict{Char, Set{Tuple{Int64, Int64}}}, 
    ym::Int64, xm::Int64)

    period = lcm(xm-2, ym-2)
    walls = Set{Tuple{Int64, Int64, Int64}}()

    for t in 1:period
        update_3d_map!(walls, blizzards, t, ym, xm)
        update_winds!(blizzards, ym, xm)
    end
    
    return walls
end


function solution1(path::String)
    blizzards, ym, xm = read_input(path)
    period = lcm(xm-2, ym-2)
    walls = construct_3d_map(blizzards, ym, xm)

    println(dijkstra(walls, (1, 2, 1), (ym, xm-1), ym, period))
end


function solution2(path::String)
    blizzards, ym, xm = read_input(path)
    period = lcm(xm-2, ym-2)
    walls = construct_3d_map(blizzards, ym, xm)

    goal, t1 = dijkstra(walls, (1, 2, 1), (ym, xm-1), ym, period)
    back, t2 = dijkstra(walls, goal, (1, 2), ym, period)
    _, t3 = dijkstra(walls, back, (ym, xm-1), ym, period)

    println(t1+t2+t3)
end


@time solution1("./input.txt")
@time solution2("./input.txt")
