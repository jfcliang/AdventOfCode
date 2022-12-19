using Plots

include("../../utils/io.jl")
include("./tetris.jl")


function hypothetical_down(piece::Piece) :: Vector{Tuple{Int64, Int64}}
    points = get_coords(piece)
    return [(x, y-1) for (x, y) in points]
end

function bottom_reached(piece::Piece, accum::Set{Tuple{Int64, Int64}})
    hypo = hypothetical_down(piece)
    no_overlap = all([!(point in accum) for point in hypo])
    no_bottom = all([y > 0 for (x, y) in hypo])
    return !no_overlap || !no_bottom
end

function can_move_left(piece::Piece, accum::Set{Tuple{Int64, Int64}})
    if get_left(piece) == 1
        return false
    else
        points = get_coords(piece)
        hypo = [(x-1, y) for (x, y) in points]
        return all([!(point in accum) for point in hypo])
    end
end

function can_move_right(piece::Piece, accum::Set{Tuple{Int64, Int64}})
    if get_right(piece) == 7
        return false
    else
        points = get_coords(piece)
        hypo = [(x+1, y) for (x, y) in points]
        return all([!(point in accum) for point in hypo])
    end
end

function read_winds(path::String)
    return strip(input_to_raw_str(path))
end

function solution1(path::String)
    jets = read_winds(path)
    jets_len = length(jets)
    accum = Set{Tuple{Int64, Int64}}()

    jet_counter = 1
    top = 0
    new_piece = HLine((3, 4))

    for counter in 1:2022
        type = mod(counter, 5)
        new_ref = (3, top+4)

        if type == 1
            new_piece = HLine(new_ref)
        elseif type == 2
            new_piece = Cross(new_ref)
        elseif type == 3
            new_piece = LShape(new_ref)
        elseif type == 4
            new_piece = VLine(new_ref)
        elseif type == 0
            new_piece = Block(new_ref)
        end

        while true
            jet = jets[jet_counter]
            if jet == '<' && can_move_left(new_piece, accum)
                move_left!(new_piece)
            elseif jet == '>' && can_move_right(new_piece, accum)
                move_right!(new_piece)
            end

            jet_counter += 1

            if jet_counter > jets_len
                jet_counter = 1
            end

            reached = bottom_reached(new_piece, accum)

            if !reached
                move_down!(new_piece)
            else
                break
            end
        end

        new_accums = get_coords(new_piece)

        for point in new_accums
            push!(accum, point)
        end

        top = max(top, get_top(new_piece))
    end

    println(top)
end


function solution2(path::String)
    jets = read_winds(path)
    jets_len = length(jets)
    accum = Set{Tuple{Int64, Int64}}()

    jet_counter = 1
    top = 0
    delta_tops = []
    new_piece = HLine((3, 4))

    for counter in 1:40000
        type = mod(counter, 5)
        new_ref = (3, top+4)

        if type == 1
            new_piece = HLine(new_ref)
        elseif type == 2
            new_piece = Cross(new_ref)
        elseif type == 3
            new_piece = LShape(new_ref)
        elseif type == 4
            new_piece = VLine(new_ref)
        elseif type == 0
            new_piece = Block(new_ref)
        end

        while true
            jet = jets[jet_counter]
            if jet == '<' && can_move_left(new_piece, accum)
                move_left!(new_piece)
            elseif jet == '>' && can_move_right(new_piece, accum)
                move_right!(new_piece)
            end

            jet_counter += 1

            if jet_counter > jets_len
                jet_counter = 1
            end

            reached = bottom_reached(new_piece, accum)

            if !reached
                move_down!(new_piece)
            else
                break
            end
        end

        new_accums = get_coords(new_piece)

        for point in new_accums
            push!(accum, point)
        end

        new_top = get_top(new_piece)
        push!(delta_tops, new_top - top)
        top = max(new_top, top)
    end

    # from heuristics by plotting top/count vs. count
    for cycle in 1000:2500
        repeat = true
        for i in 2000:10000
            if i+cycle <= 20000
                if delta_tops[i] != delta_tops[i+cycle]
                    repeat = false
                    break
                end
            end
        end
        if repeat
            println("find cycle with length $cycle")
        end
    end

    # starting from about 2000, there is a cycle 1710

    first_2000 = sum(max.(delta_tops[1:2000], 0))
    cycle = max.(delta_tops[2001:3710], 0)
    sum_cycle = sum(cycle)

    num_cycles = div(1000000000000-2000, 1710)
    remainder = mod(1000000000000-2000, 1710)

    println(first_2000 + num_cycles*sum_cycle + sum(cycle[1:remainder]))

end

solution1("./input.txt")
solution2("./input.txt")
