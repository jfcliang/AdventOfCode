using DataStructures

include("../../utils/io.jl")


function preprocess_elves(map)
    elves = Set{Tuple{Int64, Int64}}()
    ym, xm = size(map)
    for y in 1:ym
        for x in 1:xm
            if map[y, x] == '#'
                push!(elves, (y, x))
            end
        end
    end
    return elves
end 


function no_elf(points::Vector{Tuple{Int64, Int64}}, elves::Set{Tuple{Int64, Int64}})
    return all([!(pt in elves) for pt in points])
end


function update_elf_props!(elf_to_prop::Dict, prop_counts::Dict, from::Tuple, to::Tuple)
    elf_to_prop[from] = to
    if haskey(prop_counts, to)
        prop_counts[to] += 1
    else
        prop_counts[to] = 1
    end
end


function propose_dir(dir::Char, adjs::Vector, elf::Tuple)
    if dir == 'N'
        cands = [adj for adj in adjs if adj[1] == elf[1] - 1]
        new_point = (elf[1]-1, elf[2])
    elseif dir == 'S'
        cands = [adj for adj in adjs if adj[1] == elf[1] + 1]
        new_point = (elf[1]+1, elf[2])
    elseif dir == 'W'
        cands = [adj for adj in adjs if adj[2] == elf[2] - 1]
        new_point = (elf[1], elf[2]-1)
    elseif dir == 'E'
        cands = [adj for adj in adjs if adj[2] == elf[2] + 1]
        new_point = (elf[1], elf[2]+1)
    end
    return cands, new_point
end


function gen_adjacents(x, y)
    return [
        (x-1, y-1), (x, y-1), (x+1, y-1),
        (x-1, y), (x+1, y),
        (x-1, y+1), (x, y+1), (x+1, y+1)
    ]
end


function propose_move(elves::Set{Tuple{Int64, Int64}}, seq::Queue{Char})
    elf_to_prop = Dict()
    prop_counts = Dict()

    for elf in elves
        adjs = gen_adjacents(elf[1], elf[2])
        if !no_elf(adjs, elves)
            for dir in seq
                cands, new_point = propose_dir(dir, adjs, elf)
                if no_elf(cands, elves)
                    update_elf_props!(elf_to_prop, prop_counts, elf, new_point)
                    break
                end
            end
        end
    end
    return elf_to_prop, prop_counts
end


function solution1(path::String)
    map = parse_char_matrix(path)
    
    elves = preprocess_elves(map)

    orig_seq = ['N', 'S', 'W', 'E']
    seq = Queue{Char}()
    for i in orig_seq
        enqueue!(seq, i)
    end

    for _ in 1:10
        elf_to_prop, prop_counts = propose_move(elves, seq)

        orig_elves = copy(elves)
        for elf in orig_elves
            if haskey(elf_to_prop, elf)
                prop = elf_to_prop[elf]
                if prop_counts[prop] == 1
                    delete!(elves, elf)
                    push!(elves, prop)
                end
            end
        end

        popped = dequeue!(seq)
        enqueue!(seq, popped)
    end

    xs = [j for (_, j) in elves]
    ys = [i for (i, _) in elves]

    empty_tiles = (maximum(xs) - minimum(xs) + 1) * (maximum(ys) - minimum(ys) + 1) - length(elves)

    println(empty_tiles)
    println(length(elves))
end


function solution2(path::String)
    map = parse_char_matrix(path)
    
    elves = preprocess_elves(map)

    orig_seq = ['N', 'S', 'W', 'E']
    seq = Queue{Char}()
    for i in orig_seq
        enqueue!(seq, i)
    end

    
    elf_to_prop, prop_counts = propose_move(elves, seq)
    count = 0

    while !isempty(elf_to_prop)

        orig_elves = copy(elves)
        for elf in orig_elves
            if haskey(elf_to_prop, elf)
                prop = elf_to_prop[elf]
                if prop_counts[prop] == 1
                    delete!(elves, elf)
                    push!(elves, prop)
                end
            end
        end
        count += 1
        popped = dequeue!(seq)
        enqueue!(seq, popped)

        elf_to_prop, prop_counts = propose_move(elves, seq)
        
    end

    println(count+1)
end


# @time solution1("input_example.txt")
@time solution1("input.txt")
@time solution2("input.txt")
