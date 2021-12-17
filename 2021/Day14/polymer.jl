include("../../utils/io.jl")

function parse_instructions(instructions)
    ins = Dict()
    rows = strip.(split(instructions, '\n'))
    for row in rows
        key, value = split(row, " -> ")
        ins[key] = value
    end
    return ins
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    template, instructions = strip.(split(raw_str, "\n\n"))
    print(template, instructions)

    return string(template), parse_instructions(instructions)
end


function insert_polymer(template, ins)
    new_template = ""
    for i in 1:(2*length(template) - 1)
        if i % 2 == 0
            key = join([template[div(i, 2)], template[div(i,2) + 1]])
            new_template = join([new_template, ins[key]])
        else
            new_template = join([new_template, template[div(i+1, 2)]])
        end
    end
    return new_template
end


function template_to_freqs(template)
    pair_freqs = Dict()
    for i in 1:(length(template) - 1)
        new_pair = template[i:i+1]
        pair_freqs[new_pair] = get!(pair_freqs, new_pair, 0) + 1
    end
    return pair_freqs
end


function insert_pair_freqs(freqs, ins)
    new_freqs = copy(freqs)
    for key in keys(freqs)
        if freqs[key] > 0
            new_freqs[key] -= freqs[key] 
            inserted = ins[key]
            new1 = join([key[1], inserted])
            new2 = join([inserted, key[2]])
            new_freqs[new1] = get!(new_freqs, new1, 0) + freqs[key] 
            new_freqs[new2] = get!(new_freqs, new2, 0) + freqs[key]
        end 
    end
    return new_freqs
end


function solution(path::String)
    # part 1
    template, ins = parse_input(path)
    for i in 1:10
        print("Insert step ", i, "\n")
        template = insert_polymer(template, ins)
    end
    freqs = Dict()
    for char in template
        freqs[char] = get!(freqs, char, 0) + 1
    end

    print("Polymer element count: ", freqs, "\n")

    # part 2
    template, ins = parse_input(path)
    boundaries = [template[1], template[end]]
    # everything happens twice except for two chars at both ends
    pair_freqs = template_to_freqs(template)
    for i in 1:40
        print("Insert step ", i, "\n")
        pair_freqs = insert_pair_freqs(pair_freqs, ins)
    end

    # freqs = Dict{Char, UInt128}()
    freqs = Dict()

    for key in keys(pair_freqs)
        char1, char2 = key[1], key[2]
        freqs[char1] = get!(freqs, char1, 0) + pair_freqs[key]
        freqs[char2] = get!(freqs, char2, 0) + pair_freqs[key]
    end

    for char in boundaries
        freqs[char] = get!(freqs, char, 0) + 1
    end

    print(freqs, "\n")

    counts = values(freqs)
    maxi = maximum(counts) / 2
    mini = minimum(counts) / 2 

    print("Subtraction result: ", maxi - mini, "\n")

end


solution("./input.txt")
# solution("./input_example.txt")