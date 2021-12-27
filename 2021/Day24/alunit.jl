include("../../utils/io.jl")

function get_number_from_row(row)
    nums = strip.(split(row, " "))
    return parse(Int64, nums[3])
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    blocks = strip.(split(raw_str, "\r\nadd z y\r\n"))
    xy_mat = fill(0, (14, 3))

    for (i, block) in enumerate(blocks)
        rows = strip.(split(block, "\n"))
        xy_mat[i, 1] = get_number_from_row(rows[5])
        xy_mat[i, 2] = get_number_from_row(rows[6])
        xy_mat[i, 3] = get_number_from_row(rows[16])
    end

    return xy_mat
end



function operate(z, xy_mat, serial, i)
    x = (z % 26 + xy_mat[i, 2] != serial[i])
    z = div(z, xy_mat[i, 1])
    z = z * (25 * x + 1) + (serial[i] + xy_mat[i, 3]) * x

    return z
end

function operate_simple(z, xy_mat, w, i)
    if (z % 26 + xy_mat[i, 2]) == w
        z = div(z, xy_mat[i, 1])
    else
        z = div(z, xy_mat[i, 1])
        z = z * 26 + w + xy_mat[i, 3]
    end

    return z
end

function check_mat(xy_mat, w1, w2)
    found = false
    for i in 1:13
        if (w1 + xy_mat[i, 3]) % 26 + xy_mat[i+1, 2] == w2
            print(i, "\t")
            found = true
        end
    end
    if found
        print("\n")
        print(w1, ", ", w2, "\n")
    end
end

# Numbers are written in deduction.txt
# There are certain restrictions for the w input at every step.
# See Function operate_simple: at every step, if it goes in first branch, z gets possibly reduced
# if it goes second, z gets multiplied by 26 and then add some (according to the input matrix)
# because z starts out to be 0, to be back to 0 in the end, it must go through 7 steps of branch 2 
# with multiplication and 7 steps of branch 1. 
# 
# Because in order to get reduction from the div, there are only 7 in xy_mat[:, 1], thus for these
# 7 steps it has to go through branch 1, and the other 7 steps it can go through branch 2.
# 
# because in the if check, the result from (z % 26 + xy_mat[i, 2]) is actually just
#     w[i-1] + xy_mat[i-1, 3]
# in order to make the calculation go into branch 1, this must be satisfied:
#     w[i-1] + xy_mat[i-1, 3] = w[i]
# if there are consecutive 26s in xy_mat[:, 1], the w[i-1] is then taken from whatever last time 
# branch 2 is processed, kind of like a stack operation. 

# With these restrictions, there are only 30240 possible combinations, a big reduction from the 
# brute-force 9^14 possibilities

function generate_possible_serials()
    return [
        (w1, w2, w3, w4, w4+4, w6, w6+2, w8, 9, 1, w8+5, w3, w2-6, w1+1)
            for w1 in 8:-1:1 
            for w2 in 9:-1:7
            for w3 in 9:-1:1    
            for w4 in 5:-1:1
            for w6 in 7:-1:1
            for w8 in 4:-1:1
    ]
end

function solution(path::String)
    xy_mat = parse_input(path)

    print(xy_mat[:, 1], "\n")
    print(xy_mat[:, 2], "\n")
    print(xy_mat[:, 3], "\n")
    answers = []
    for serial in generate_possible_serials()
        z = 0
        
        for (i, num) in enumerate(serial)
            z = operate_simple(z, xy_mat, num, i)
        end

        if z == 0 
            push!(answers, serial)
        end
    end
    print(answers[1], "\n") # part 1
    print(answers[end], "\n") # part 2
end

# print(length(generate_possible_serials()))
solution("./input.txt")