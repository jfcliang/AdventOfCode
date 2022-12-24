using DataStructures


function find_neighbors(
    walls::Set{Tuple{Int64, Int64, Int64}}, 
    pt::Tuple{Int64, Int64, Int64}, 
    visited::Set{Tuple{Int64, Int64, Int64}}, 
    ym::Int64, period::Int64)

    y, x, t = pt
    new_t = t+1 
    if new_t == period + 1
        new_t = 1
    end

    cands = [
        (y, x, new_t), (y+1, x, new_t), (y-1, x, new_t), 
        (y, x-1, new_t), (y, x+1, new_t)
    ]

    return [
        cand for cand in cands if (
            1 <= cand[1] <= ym && !(cand in visited) && !(cand in walls) 
        )
    ]
end


function process_current!(
    walls::Set{Tuple{Int64, Int64, Int64}}, 
    pt::Tuple{Int64, Int64, Int64}, 
    current_time::Float64,
    unvisited::PriorityQueue,
    visited::Set{Tuple{Int64, Int64, Int64}}, 
    ym::Int64, period::Int64)

    neighbors = find_neighbors(
        walls, pt, visited, ym, period)

    new_time = current_time + 1
    for nb in neighbors
        if get!(unvisited, nb, Inf) > new_time
            unvisited[nb] = new_time
        end
    end
end


function dijkstra(
    walls::Set{Tuple{Int64, Int64, Int64}}, 
    start::Tuple{Int64, Int64, Int64}, 
    target::Tuple{Int64, Int64},
    ym::Int64, period::Int64)

    visited = Set{Tuple{Int64, Int64, Int64}}()

    unvisited = PriorityQueue()
    enqueue!(unvisited, start => 0.0)

    while length(unvisited) > 0
        current, current_t = dequeue_pair!(unvisited)
        process_current!(
            walls, current, current_t, 
            unvisited, visited, ym, period
        )
        push!(visited, current)

        if (current[1] == target[1]) && (current[2] == target[2]) 
            return current, current_t
        end
    end
end
