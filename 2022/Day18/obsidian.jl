include("../../utils/io.jl")


function str_to_coord(input::String) :: Tuple{Int64, Int64, Int64}
    coord = parse.(Int64, strip.(split(input, ",")))

    return Tuple(Int64(x) for x in coord)
end


function load_coords(path::String) :: Set{Tuple{Int64, Int64, Int64}}
    coord_strs = parse_input_lines(path, "\r\n")
    coords = str_to_coord.(coord_strs)
    xs = [c[1] for c in coords]
    ys = [c[2] for c in coords]
    zs = [c[3] for c in coords]
    println("x range: $(minimum(xs)) - $(maximum(xs))")
    println("y range: $(minimum(ys)) - $(maximum(ys))")
    println("z range: $(minimum(zs)) - $(maximum(zs))")

    return Set(coords)
end


function generate_adjacent(
    coord::Tuple{Int64, Int64, Int64}) :: Vector{Tuple{Int64, Int64, Int64}}
    x, y, z = coord

    return [
        (x+1, y, z), (x-1, y, z),
        (x, y+1, z), (x, y-1, z), 
        (x, y, z+1), (x, y, z-1)
    ]
end


function filtered_adjacent(
    coord::Tuple{Int64, Int64, Int64}) :: Vector{Tuple{Int64, Int64, Int64}}

    adjacents = generate_adjacent(coord)
    return [xyz for xyz in adjacents if (
        # 0 <= xyz[1] <= 7 && 0 <= xyz[2] <= 7 && 0 <= xyz[3] <= 7
        -1 <= xyz[1] <= 22 && -1 <= xyz[2] <= 22 && -1 <= xyz[3] <= 22
    )]

end


function count_sides(
    coord::Tuple{Int64, Int64, Int64}, 
    all_coords::Set{Tuple{Int64, Int64, Int64}}) :: Int64

    adjacents = generate_adjacent(coord)
    count = 0
    for adj in adjacents
        if adj in all_coords
            count += 1
        end
    end
    return 6 - count
end


function solution1(path::String)
    all_coords = load_coords(path)
    sides = 0
    for coord in all_coords
        sides += count_sides(coord, all_coords)
    end

    println(sides)
end


function solution2(path::String)
    all_coords = load_coords(path)
    outside = Set{Tuple{Int64, Int64, Int64}}()
    cands = Set{Tuple{Int64, Int64, Int64}}()

    push!(cands, (-1, -1, -1))
    # push!(cands, (0, 0, 0))

    while !isempty(cands)
        current = pop!(cands)

        if !(current in all_coords)
            push!(outside, current)
        end

        adjacents = filtered_adjacent(current)
        for adj in adjacents
            if !(adj in all_coords) && !(adj in outside)
                push!(cands, adj)
            end
        end
    end

    sides = 0
    for coord in outside
        sides += count_sides(coord, outside)
    end

    println(sides - 24*24*6)
end


# solution1("./input.txt")
solution2("./input.txt")
# solution2("./input_example.txt")
