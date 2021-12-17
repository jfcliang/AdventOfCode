include("../../utils/io.jl")


function evolve!(octopii)
    octopii .+= 1
end

function update_adjacent!(octopii, i, j)
    ym, xm = size(octopii)

end

function flash!(octopii, flashed)
    ym, xm = size(octopii)
    spread_idx = []
    for i in 1:ym
        for j in 1:xm
            if octopii[i, j] > 9 && !((i, j) in flashed)
                push!(flashed, (i, j))
                append!(spread_idx, adjacent_idx(i, j, ym, xm))
            end
        end
    end

    for idx in spread_idx
        x, y = idx
        octopii[x, y] += 1
    end
end

function reset_flashed(octopii, flashed)
    total = 0
    for idx in flashed
        total += 1
        x, y = idx
        octopii[x, y] = 0
    end
    return total
end

function check_flashable(octopii, flashed)
    ym, xm = size(octopii)
    return !all(
        octopii[i, j] <= 9 || (i, j) in flashed 
            for i in 1:ym for j in 1:xm)
end

function solution(path::String, steps::Int64)
    octopii = parse_digit_matrix(path)
    flash_count = 0

    for i in 1:steps
        evolve!(octopii)
        flashed = Set()
        while check_flashable(octopii, flashed)
            flash!(octopii, flashed)
        end
        flash_count += reset_flashed(octopii, flashed)
        if length(flashed) == 100
            print("Sync! step: ", i, "\n")
            return 
        end
    end

    print("Total flash count is : ", flash_count, "\n")

end

solution("./input.txt", 5000)