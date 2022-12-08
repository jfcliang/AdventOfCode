include("../../utils/io.jl")


function solution1(path::String)
    trees = parse_digit_matrix(path)

    dimx, dimy = size(trees)
    println(dimx, " ",  dimy)
    
    visible = Set()
    # add edge trees as they are always visible
    for x in 1:dimx
        push!(visible, (x, 1))
        push!(visible, (x, dimy))
    end

    for y in 1:dimy
        push!(visible, (1, y))
        push!(visible, (dimx, y))
    end

    # seen from the top
    for x in 2:(dimx-1)
        highest = trees[x, 1]
        for y in 2:(dimy-1)
            if trees[x, y] > highest
                push!(visible, (x, y))
                highest = trees[x, y]
            end
        end
    end

    for x in 2:(dimx-1)
        highest = trees[x, dimy]
        for y in (dimy-1):-1:2
            if trees[x, y] > highest
                push!(visible, (x, y))
                highest = trees[x, y]
            end
        end
    end

    for y in 2:(dimy-1)
        highest = trees[1, y]
        for x in 2:(dimx-1)
            if trees[x, y] > highest
                push!(visible, (x, y))
                highest = trees[x, y]
            end
        end
    end

    for y in 2:(dimy-1)
        highest = trees[dimx, y]
        for x in (dimx-1):-1:2
            if trees[x, y] > highest
                push!(visible, (x, y))
                highest = trees[x, y]
            end
        end
    end

    println(length(visible))

end


function calc_scenic_scores(trees, x, y, dimx, dimy)
    if x == 0 || x == dimx || y == 0 || y == dimy
        return 0
    end
    self = trees[x, y]

    up, down, left, right = 0, 0, 0, 0
    for i in x-1:-1:1
        left += 1
        if trees[i, y] >= self
            break
        end
    end
    
    for i in x+1:dimx
        right += 1
        if trees[i, y] >= self
            break
        end
    end

    for j in y-1:-1:1
        up += 1
        if trees[x, j] >= self
            break
        end
    end

    for j in y+1:dimy
        down += 1
        if trees[x, j] >= self
            break
        end
    end
    return up * down * left * right
end

function solution2(path::String)
    trees = parse_digit_matrix(path)

    dimx, dimy = size(trees)
    println(dimx, " ",  dimy)

    
    # calc_scenic_scores(trees, 4, 3, dimx, dimy)

    scores = zeros(dimx, dimy)
    for i in 1:dimx
        for j in 1:dimy
            scores[i, j] = calc_scenic_scores(trees, i, j, dimx, dimy)

        end
    end
    # println(scores)
    println(maximum(scores))

end


# solution1("./input_example.txt")
# solution1("./input.txt")

solution2("./input_example.txt")
solution2("./input.txt")