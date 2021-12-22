
struct Cube
    ranges::Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}, Tuple{Int64, Int64}}
    # 3 directions, each with start and end
end

function make_cube(
    ranges::Tuple{Tuple{Int64, Int64}, Tuple{Int64, Int64}, Tuple{Int64, Int64}})
    if all([range[1] <= range[2] for range in ranges])
        return Cube(ranges)
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
        cube.ranges[2], hole.ranges[2]
    ))
    push!(new_ranges, (
        (hole.ranges[1][2]+1, cube.ranges[1][2]),
        cube.ranges[2], hole.ranges[2]
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
        new_cube = make_cube(new_range)
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

function make_overlap(cube::Cube, hole::Cube)
    cranges = cube.ranges
    hranges = hole.ranges
    return make_cube((
            (max(cranges[1][1], hranges[1][1]), min(cranges[1][2], hranges[1][2])),
            (max(cranges[2][1], hranges[2][1]), min(cranges[2][2], hranges[2][2])),
            (max(cranges[3][1], hranges[3][1]), min(cranges[3][2], hranges[3][2]))
    ))
end


ranges_cube = (
    (1, 100), (1, 100), (1, 100)
)
ranges_hole = (
    (95, 105), (5, 14), (5, 14)
)
cube = make_cube(ranges_cube)
hole = make_cube(ranges_hole)
overlap = make_overlap(cube, hole)

print("Volume of the cube is ", cube_volume(cube), "\n")
print("Volume of the hole is ", cube_volume(hole), "\n")
print("Volume of the overlap is ", cube_volume(overlap), "\n")

print(overlap, "\n")
    
new_cubes = make_hole(cube, overlap)
print(new_cubes)
print("Total volume is ", sum(cube_volume.(new_cubes)), "\n")
