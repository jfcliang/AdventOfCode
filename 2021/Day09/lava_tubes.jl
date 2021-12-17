include("../../utils/io.jl")

function check_low_point(heatmap, i, j)
    v_edge, h_edge = size(heatmap)
    ontop = (i == 1)
    atbottom = (i == v_edge)
    atleft = (j == 1)
    atright = (j == h_edge)

    is_low = true
    if !ontop 
        is_low = is_low && heatmap[i-1, j] > heatmap[i, j]
    end
    if !atbottom
        is_low = is_low && heatmap[i+1, j] > heatmap[i, j]
    end
    if !atleft
        is_low = is_low && heatmap[i, j-1] > heatmap[i, j]
    end
    if !atright
        is_low = is_low && heatmap[i, j+1] > heatmap[i, j]
    end
    return is_low
end

function make_basin(heatmap, low_point)
    v_edge, h_edge = size(heatmap)
    basin = Set([low_point])
    frontier = Set([low_point])

    while length(frontier) > 0
        new_frontier = Set()

        for point in frontier
            x = point[1]
            y = point[2]
            if (x != 1) && (heatmap[x-1, y] != 9) && !((x-1, y) in basin)
                push!(new_frontier, (x-1, y))
                push!(basin, (x-1, y))
            end

            if (x != v_edge) && (heatmap[x+1, y] != 9) && !((x+1, y) in basin)
                push!(new_frontier, (x+1, y))
                push!(basin, (x+1, y))
            end

            if (y != 1) && (heatmap[x, y-1] != 9) && !((x, y-1) in basin)
                push!(new_frontier, (x, y-1))
                push!(basin, (x, y-1))
            end

            if (y != h_edge) && (heatmap[x, y+1] != 9) && !((x, y+1) in basin)
                push!(new_frontier, (x, y+1))
                push!(basin, (x, y+1))
            end
        end

        frontier = new_frontier
        
    end 

    return basin

end

function make_basins(heatmap, low_points)
    basin_sizes = Dict()
    for low_point in low_points
        basin_set = make_basin(heatmap, low_point)
        basin_sizes[low_point] = length(basin_set)
    end

    return basin_sizes
end


function solution(path::String)
    heatmap = parse_digit_matrix(path)
    v_edge, h_edge = size(heatmap)
    low_points = Set()
    total = 0
    for i in 1:v_edge
        for j in 1:h_edge
            if check_low_point(heatmap, i, j)
                total += heatmap[i, j] + 1
                push!(low_points, (i, j))
            end
        end
    end

    print("Sum of all risk levels is ", total, "\n")

    basin_sizes = sort(collect(values(make_basins(heatmap, low_points))), rev=true)
    m = basin_sizes[1] * basin_sizes[2] * basin_sizes[3]
    print("Multiplication of largest basin sizes is ", m, "\n")

end


solution("./input.txt")