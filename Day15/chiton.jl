include("../utils/io.jl")

using Memoize

@memoize function min_cost(i, j, chiton_map)

    range = size(chiton_map)[1]

    if i == 1 && j == 1
        return 0
    end

    if i < 1 || i > range || j < 1 || j > range
        return 10 * range^2
    end

    return minimum([min_cost(i-1, j, chiton_map), min_cost(i, j-1, chiton_map)]) + chiton_map[i, j]
end

function generate_larger_map(chiton_map)

    range = size(chiton_map)[1]
    lrange = 5 * range
    larger = fill(0, (lrange, lrange))

    for i in 1:lrange
        for j in 1:lrange
            itimes = div(i - 1, range)
            jtimes = div(j - 1, range)
            irem = (i - 1) % range + 1
            jrem = (j - 1) % range + 1

            larger[i, j] = (chiton_map[irem, jrem] + itimes + jtimes - 1) % 9 + 1
        end
    end
    return larger
end


function dijkstra_min(chiton_map)
    function find_neighbors(i, j, range, unvisited)
        cands = [
            (i-1, j), (i+1, j), (i, j-1), (i, j+1)
        ]

        return [cand for cand in cands if (
            (1 <= cand[1] <= range) && (1 <= cand[2] <= range) && (cand in unvisited)
        )]
    end

    function process_current!(i, j, chiton_map, range, tentative, unvisited)
        neighbors = find_neighbors(i, j, range, unvisited)
        dis_current = tentative[i, j]
        for nb in neighbors
            i_n, j_n = nb
            new_dis = chiton_map[i_n, j_n] + dis_current
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

    range = size(chiton_map)[1]
    print("Total number of elements is: ", range^2, "\n")
    unvisited = Set([(i, j) for i in 1:range for j in 1:range])

    tentative = fill(Inf, (range, range))
    tentative[1, 1] = 0

    while (range, range) in unvisited
        current = find_current(tentative, unvisited)
        process_current!(current[1], current[2], chiton_map, range, tentative, unvisited)
    end

    return tentative[range, range]

end


function solution(path::String)
    input = parse_digit_matrix(path)
    range = size(input)[1]

    print("Lowest cost is: ", min_cost(range, range, input), "\n")
    print("Improved lowest cost is: ", dijkstra_min(input), "\n")

    larger = generate_larger_map(input)
    lrange = size(larger)[1]
    print("Lowest cost for larger is: ", min_cost(lrange, lrange, larger), "\n")
    # This doesn't work because only going lower and right

    # Dijkstra's algorithm
    print("Improved lowest cost for larger is: ", dijkstra_min(larger), "\n")

end

# solution("./input_example.txt")
solution("./input.txt")
