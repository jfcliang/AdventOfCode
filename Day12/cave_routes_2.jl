include("../utils/io.jl")

struct Route
    seq::Array{String}
    dupe::Bool
end

Route(seq::Array{String}) = Route(seq, false)

function parse_input(path::String)
    function add_points!(point_dict, p1, p2)
        if !(p1 in keys(point_dict))
            point_dict[p1] = Set([p2])
        elseif !(p2 in point_dict[p1])
            push!(point_dict[p1], p2)
        end
    end

    point_dict = Dict{String, Set{String}}()

    for row in split(input_to_raw_str(path), '\n')
        p1, p2 = strip.(string.(split(row, '-')))
        add_points!(point_dict, p1, p2)
        add_points!(point_dict, p2, p1)
    end

    return point_dict
end

function new_point_eligible!(point, route)

    function is_start_end(point)
        return point == "start" || point == "end"
    end

    if all(isuppercase.(collect(point)))
        return true, route.dupe
    end

    if !(point in route.seq)
        return true, route.dupe
    end

    if (!route.dupe) && !is_start_end(point)
        return true, true
    end

    return false, route.dupe

end

function find_new_routes(route, point_dict)
    possible = point_dict[last(route.seq)]
    routes = Set{Route}()

    for point in possible
        old_seq = copy(route.seq)
        eligible, dupe = new_point_eligible!(point, route)
        if eligible
            push!(routes, Route(append!(old_seq, [point]), dupe))
        end
    end

    return routes
end

function assign_route!(all_routes, finished_routes, route)
    if last(route.seq) == "end"
        push!(finished_routes, route)
    else
        push!(all_routes, route)
    end
end

function solution(path::String)
    point_dict = parse_input(path)
    print(point_dict, '\n')
    all_routes = Set{Route}()
    finished_routes = Set{Route}()
    push!(all_routes, Route(["start"]))

    while length(all_routes) > 0
        for route in all_routes
            delete!(all_routes, route)
            new_routes = find_new_routes(route, point_dict)
            if length(new_routes) >= 1
                [assign_route!(all_routes, finished_routes, new_route) 
                    for new_route in new_routes]
            end
        end
    end
    print("Total possible route count: ",  length(finished_routes), "\n")
end


# solution("./input_example.txt")
solution("./input.txt")