include("../../utils/io.jl")

struct Cube
    direction::String
    ranges::Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}, Tuple{Int64, Int64}}
    # 3 directions, each with start and end
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

        step = Cube(direction, (x_range, y_range, z_range))
        push!(steps, step)
    end
    
    return steps
    
end

function make_cube(direction::String,
    ranges::Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}, Tuple{Int64, Int64}})
    if all([range[1] <= range[2] for range in ranges])
        return Cube(direction, ranges)
    end
    return nothing 
end

function make_hole(cube::Cube, hole::Cube)
    new_ranges = []
    new_cubes = []

    # upper and bottom
    push!(new_ranges, (
        cube.ranges[1], cube.ranges[2],
        (cube.ranges[3][1], hole.ranges[3][1]-1)
    ))
    push!(new_ranges, (
        cube.ranges[1], cube.ranges[2],
        (hole.ranges[3][2]+1, cube.ranges[3][2])
    ))

    # left and right
    push!(new_ranges, (
        (cube.ranges[1][1], hole.ranges[1][1]-1),
        cube.ranges[2], hole.ranges[3]
    ))
    push!(new_ranges, (
        (hole.ranges[1][2]+1, cube.ranges[1][2]),
        cube.ranges[2], hole.ranges[3]
    ))

    # front and back
    push!(new_ranges, (
        hole.ranges[1], 
        (cube.ranges[2][1], hole.ranges[2][1]-1),
        hole.ranges[3]
    ))
    push!(new_ranges, (
        hole.ranges[1], 
        (hole.ranges[2][2]+1, cube.ranges[2][2]),
        hole.ranges[3]
    ))

    
    for new_range in new_ranges
        new_cube = make_cube("on", new_range)
        if new_cube !== nothing
            push!(new_cubes, new_cube)
        end
    end

    return new_cubes
end

function cube_volume(cube::Cube)
    vol = 1
    for i in 1:3
        vol *= cube.ranges[i][2] - cube.ranges[i][1] + 1
    end
    return vol
end

function check_if_overlap(c1::Cube, c2::Cube)
    function check_range_overlap(tuple1, tuple2)
        return !(tuple1[2] < tuple2[1] || tuple2[2] < tuple1[1])
    end

    return (
        check_range_overlap(c1.ranges[1], c2.ranges[1]) &&
        check_range_overlap(c1.ranges[2], c2.ranges[2]) &&
        check_range_overlap(c1.ranges[3], c2.ranges[3]))
end

function make_overlap(cube::Cube, hole::Cube)
    cranges = cube.ranges
    hranges = hole.ranges
    return make_cube("off", (
            (max(cranges[1][1], hranges[1][1]), min(cranges[1][2], hranges[1][2])),
            (max(cranges[2][1], hranges[2][1]), min(cranges[2][2], hranges[2][2])),
            (max(cranges[3][1], hranges[3][1]), min(cranges[3][2], hranges[3][2]))
    ))
end


function collide_cubes(c1::Cube, c2::Cube)
    overlap = make_overlap(c1, c2)
    new_cubes = make_hole(c2, overlap)

    return new_cubes
end


function solution(path::String)
    cubes = parse_input(path)
    all_cubes = [cubes[1]]

    for new_cube in cubes[2:end]
        del_old = []
        if new_cube.direction == "off"
            add_new = []
        else
            add_new = [new_cube]
        end

        for old_cube in all_cubes
            if check_if_overlap(old_cube, new_cube)
                overlap = make_overlap(old_cube, new_cube)
                split_cubes = make_hole(old_cube, overlap)
                push!(del_old, old_cube)
                append!(add_new, split_cubes)
            end
        end
        all_cubes = [cube for cube in all_cubes if !(cube in del_old)]
        append!(all_cubes, add_new)
    end

    print("Total number of fractured cubes: ", length(all_cubes), "\n")
    print("Total volume is ", sum(cube_volume.(all_cubes)), "\n")

end

function print_cube_points(cube::Cube)
    # only for testing!
    for i in cube.ranges[1][1]:cube.ranges[1][2]
        for j in cube.ranges[2][1]:cube.ranges[2][2]
            for k in cube.ranges[3][1]:cube.ranges[3][2]
                print((i, j, k))
            end
        end
    end

end


function test_cube_action()
    ranges_cube = (
        (11, 12), (10, 10), (11, 12)
    )
    ranges_hole = (
        (9, 11), (9, 11), (9, 11)
    )
    cube = make_cube("on", ranges_cube)
    hole = make_cube("off", ranges_hole)
    overlap = make_overlap(cube, hole)

    print("Volume of the cube is ", cube_volume(cube), "\n")
    print("Volume of the hole is ", cube_volume(hole), "\n")
    print("Volume of the overlap is ", cube_volume(overlap), "\n")

    print(overlap, "\n")
        
    new_cubes = make_hole(cube, overlap)
    print(new_cubes, "\n")
    print("Total volume is ", sum(cube_volume.(new_cubes)), "\n")

end


solution("./input.txt")
# solution("./input_example.txt")
# test_cube_action()