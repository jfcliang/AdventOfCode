using LinearAlgebra

include("../../utils/io.jl")


function generate_transformation()
    transformations = []
    permus = [
        [1,2,3], [1,3,2], [2,1,3],
        [2,3,1], [3,1,2], [3,2,1]
    ]
    invers = [
        [1, 1, 1], [1, 1, -1], [1, -1, -1], [1, -1, 1],
        [-1, 1, 1], [-1, 1, -1], [-1, -1, -1], [-1, -1, 1]
    ]
    for i in 1:6
        for j in 1:8
            transform = fill(0, (3, 3))
            perm = permus[i]
            inv = invers[j]
            for ix in 1:3
                transform[ix, perm[ix]] = inv[ix]
            end

            # Determinant = 1 => not mirrored, thus a "legal" transformation
            if det(transform) == 1 
                push!(transformations, transform)
            end
        end
    end
    return transformations
end

function find_possible_shifts(coords0, coords1, transform)
    function find_matching(array1, array2)
        return length(
            [element for element in array2 if element in array1]
        )
    end

    for coord1 in coords1
        for coord0 in coords0
            shift = transform * coord1 - coord0
            new_coords1 = [transform * c1 - shift for c1 in coords1]
            if find_matching(new_coords1, coords0) >= 12
                return shift
            end
        end
    end
    return [NaN, NaN, NaN]
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    beacon_readings = split(raw_str, r"--- scanner ([0-9]+) ---\n")[2:end]

    readings = []

    for bstr in beacon_readings
        rows = split(strip(bstr), "\n")
        reading = []
        for row in rows
            coords = parse.(Int64, split(strip(row), ','))
            push!(reading, coords)

        end
        push!(readings, reading)
    end

    return readings
end


function transform_coords(from_coords, shift, transform)
    return [
        transform * coord - shift for coord in from_coords
    ]
end


function make_connection!(conversion, i, scanner_count)
    to_i = [
        k for k in 1:scanner_count 
            if (k != i) && (k != 1) &&
            (k, i) in keys(conversion) &&
            !((k, 1) in keys(conversion))
    ]

    for k in to_i
        shift = conversion[(i, 1)][2] * conversion[(k, i)][1] + conversion[(i, 1)][1]
        transform = conversion[(i, 1)][2] * conversion[(k, i)][2]

        conversion[(k, 1)] = (shift, transform)
    end
end


function make_full_transform!(scanner_count, conversion)
    function direct_transform(count, conversion)
        return [
            i for i in 2:count if (i, 1) in keys(conversion)
        ]
    end

    while length(direct_transform(scanner_count, conversion)) < scanner_count - 1
        for i in 1:scanner_count
            if i != 1 && (i, 1) in keys(conversion)
                make_connection!(conversion, i, scanner_count)
            end
        end                     
    end
end

function calc_manhattan_dist(i, j, conversion)
    if i == 1
        return sum(abs.(conversion[j, 1][1]))
    else
        transform1 = conversion[(i, 1)][1]
        transform2 = conversion[(j, 1)][1]
        transform = transform1 - transform2

        return sum(abs.(transform))
    end
end

function solution(path::String)
    # part 1
    beacons = parse_input(path)

    transforms = generate_transformation()

    conversion = Dict()

    for i in 1:length(beacons)
        for j in 1:length(beacons)
            if i != j
                beacon0 = beacons[i]
                beacon1 = beacons[j]
                for transform in transforms
                    shift = find_possible_shifts(beacon0, beacon1, transform)
                    if !isnan(shift[1])
                        conversion[(j, i)] = (shift, transform)
                        # print(i-1, ", ", j-1, "\n")
                        # print(shift, "\n", transform, "\n")
                    end
                end
            end
        end
    end

    make_full_transform!(length(beacons), conversion)

    for i in 2:length(beacons)
        print((i, 1), "\n")
        print(conversion[(i, 1)], "\n")
    end

    total_beacons = Set(beacons[1])
    for idx in 2:length(beacons)
        shift, transform = conversion[(idx, 1)]
        new_coords = transform_coords(beacons[idx], shift, transform)
        print(idx, "\n")
        print(new_coords, "\n")
        for new_c in new_coords
            push!(total_beacons, new_c)
        end
    end

    print(length(total_beacons), "\n")

    # part 2
    dists = fill(0, (length(beacons), length(beacons)))

    for i in 1:length(beacons)
        for j in i+1:length(beacons)
            dists[i, j] = calc_manhattan_dist(i, j, conversion)
            dists[j, i] = dists[i, j]
        end
    end
    print(maximum(dists), "\n")
end


# solution("./input_example.txt")
solution("./input.txt")