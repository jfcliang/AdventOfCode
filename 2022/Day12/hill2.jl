using DataStructures

include("../../utils/io.jl")

mutable struct HeatMap
    heatmap::Matrix{Int64}
    i_range::Int64
    j_range::Int64
    starts::Set{Tuple{Int64, Int64}}
    pt_end
end

function parse_input(path::String)
    hm_char = parse_char_matrix(path)

    hm = HeatMap(
        zeros(size(hm_char)), size(hm_char)[1], size(hm_char)[2],
        Set(), (0, 0))
    
    for i in 1:size(hm_char)[1]
        for j in 1:size(hm_char)[2]
            if 'a' <= hm_char[i, j] <= 'z'
                hm.heatmap[i, j] = hm_char[i, j] - 'a' + 1
                if hm_char[i, j] == 'a'
                    push!(hm.starts, (i, j))
                end
            elseif hm_char[i, j] == 'S'
                hm.heatmap[i, j] = 0
            elseif hm_char[i, j] == 'E'
                hm.heatmap[i, j] = 27
                hm.pt_end = (i, j)
            end
        end
    end
    return hm
end


function dijkstra_min(hm::HeatMap)
    function find_neighbors(hm, i, j, unvisited)
        height = hm.heatmap[i, j]
        cands = [
            (i-1, j), (i+1, j), (i, j-1), (i, j+1)
        ]

        return [cand for cand in cands if (
            (1 <= cand[1] <= hm.i_range) && (1 <= cand[2] <= hm.j_range) 
            && (cand in unvisited) && (hm.heatmap[cand[1], cand[2]] <= height + 1)
        )]
    end

    function process_current!(hm, i, j, tentative, unvisited)
        neighbors = find_neighbors(hm, i, j, unvisited)
        dis_current = tentative[i, j]
        for nb in neighbors
            i_n, j_n = nb
            new_dis = dis_current + 1
            if tentative[i_n, j_n] > new_dis
                tentative[i_n, j_n] = new_dis
            end
        end
        delete!(unvisited, (i, j))
    end

    function find_current(tentative, unvisited)
        mini = Inf
        smallest = (1, 1)
        for cand in unvisited
            i, j = cand
            if tentative[i, j] <= mini
                mini = tentative[i, j]
                smallest = (i, j)
            end
        end
        return smallest
    end

    distances = Vector{Float64}()

    for (start_i, start_j) in hm.starts
        #TODO: it's faster to start from the end and search backwards
        
        unvisited = Set([(i, j) for i in 1:hm.i_range for j in 1:hm.j_range])
        tentative = fill(Inf, (hm.i_range, hm.j_range))
        tentative[start_i, start_j] = 0

        while (hm.pt_end[1], hm.pt_end[2]) in unvisited
            current = find_current(tentative, unvisited)
            process_current!(hm, current[1], current[2], tentative, unvisited)
        end

        push!(distances, tentative[hm.pt_end[1], hm.pt_end[2]])
    end

    return minimum(distances)
end


function solution(path::String)
    hm = parse_input(path)
    dis = dijkstra_min(hm)
    print(dis)
end


solution("./input.txt")
