include("../../utils/io.jl")

@enum INEQUALITY larger smaller

function parse_input_line(line::String)
    pattern = r".*x=(?<x1>[-,0-9]+), y=(?<y1>[-,0-9]+):.*x=(?<x2>[-,0-9]+), y=(?<y2>[-,0-9]+)"
    m = match(pattern, line)

    x1, y1, x2, y2 = parse.(Int64, (m["x1"], m["y1"], m["x2"], m["y2"]))
    return (x1, y1), (x2, y2)
end


function find_manhattan_dis(sensor::Tuple{Int64, Int64}, beacon::Tuple{Int64, Int64})
    d_x = abs(sensor[1] - beacon[1])
    d_y = abs(sensor[2] - beacon[2])
    return d_x + d_y
end


function in_exclusion_zone(
    target::Tuple{Int64, Int64},
    sensor::Tuple{Int64, Int64}, 
    beacon::Tuple{Int64, Int64})

    return find_manhattan_dis(target, sensor) <= find_manhattan_dis(beacon, sensor)
end


function excl_adjacent!(
    sensor::Tuple{Int64, Int64}, 
    beacon::Tuple{Int64, Int64},
    cands::Set{Tuple{Int64, Int64}})

    # because we know already there are only one possible position
    # that means it must be just outside of the edge of squares
    d = find_manhattan_dis(sensor, beacon)
    x, y = sensor
    
    for d_x in -(d+1):(d+1)
        d_y = d+1 - abs(d_x)
        if 0 <= x+d_x <= 4000000
            if 0 <= y-d_y <= 4000000
                push!(cands, (x+d_x, y-d_y))
            end
            if 0 <= y+d_y <= 4000000
                push!(cands, (x+d_x, y+d_y))
            end
        end
    end               
end


function count_excl_overlap!(
    sensor::Tuple{Int64, Int64}, 
    beacon::Tuple{Int64, Int64}, 
    excl::Set{Int64}, y::Int64)
    dis = find_manhattan_dis(sensor, beacon)
    y_d = abs(2000000 - sensor[2])
    if y_d <= dis
        x_d = dis - y_d
        for x in -x_d:x_d
            push!(excl, x + sensor[1])
        end
    end
end


function solution1(path::String, y::Int64)
    lines = parse_input_lines(path, "\r\n")
    readings = parse_input_line.(lines)
    excl = Set{Int64}()
    beacons = Set{Int64}()

    for (sensor, beacon) in readings
        if beacon[2] == y
            push!(beacons, beacon[1])
        end
        count_excl_overlap!(sensor, beacon, excl, y)
    end

    excl = setdiff(excl, beacons)
    println(length(excl))
end


function solution2(path::String)
    lines = parse_input_lines(path, "\r\n")
    readings = parse_input_line.(lines)

    candidates = Set{Tuple{Int64, Int64}}()
    
    for (sensor, beacon) in readings
        excl_adjacent!(sensor, beacon, candidates)
    end

    println("Total $(length(candidates)) candidates")

    for cand in candidates
        in_excl = false
        for (sensor, beacon) in readings
            if in_exclusion_zone(cand, sensor, beacon)
                in_excl = true
                break
            end
        end

        if !in_excl
            println(cand[1] * 4000000 + cand[2])
            return
        end
    end
end


# solution1("./input.txt", 2000000)
solution2("./input.txt")
# solution1("./input_example.txt", 20)
