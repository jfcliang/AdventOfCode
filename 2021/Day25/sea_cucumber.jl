include("../../utils/io.jl")

function make_east_cands(mat)
    vsize = size(mat)[1]
    hsize = size(mat)[2]

    cands = []
    for i in 1:vsize
        for j in 1:hsize
            if mat[i, j] == '>'
                if j == hsize
                    available = mat[i, 1] == '.'
                else
                    available = mat[i, j+1] == '.'
                end
                if available
                    push!(cands, (i, j))
                end
            end
        end
    end

    return cands
end

function make_south_cands(mat)
    vsize = size(mat)[1]
    hsize = size(mat)[2]

    cands = []
    for i in 1:vsize
        for j in 1:hsize
            if mat[i, j] == 'v'
                if i == vsize
                    available = mat[1, j] == '.'
                else
                    available = mat[i+1, j] == '.'
                end
                if available
                    push!(cands, (i, j))
                end
            end
        end
    end

    return cands
end

function move_east!(mat, cands)

    hsize = size(mat)[2]
    for cand in cands
        i, j = cand
        mat[i, j] = '.'
        if j == hsize 
            mat[i, 1] = '>'
        else
            mat[i, j+1] = '>'
        end
    end       
end

function move_south!(mat, cands)
    vsize = size(mat)[1]
    for cand in cands
        i, j = cand
        mat[i, j] = '.'
        if i == vsize
            mat[1, j] = 'v'
        else
            mat[i+1, j] = 'v'
        end
    end
end

function solution(path::String)
    seabed = parse_char_matrix(path)
    step = 0
    while true
        moved = false
        east_cands = make_east_cands(seabed)
        if length(east_cands) > 0
            move_east!(seabed, east_cands)
            moved = true
        end
        south_cands = make_south_cands(seabed)
        if length(south_cands) > 0
            move_south!(seabed, south_cands)
            moved = true
        end

        step += 1
        moved || break 
    end

    print(step)

end


solution("./input.txt")
# solution("./input_example.txt")