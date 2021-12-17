include("../../utils/io.jl")

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

function find_new_routes(route, point_dict)
    possible = point_dict[last(route)]
    routes = Set()

    for point in possible
        route_base = copy(route)
        if all(isuppercase.(collect(point))) || !(point in route_base)
            push!(routes, append!(route_base, [point]))
        end
    end
    return routes
end

function assign_route!(all_routes, finished_routes, route)
    if last(route) == "end"
        push!(finished_routes, route)
    else
        push!(all_routes, route)
    end
end

function solution(path::String)
    point_dict = parse_input(path)
    print(point_dict, '\n')
    all_routes = Set{Array{String}}()
    finished_routes = Set()
    push!(all_routes, ["start"])

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