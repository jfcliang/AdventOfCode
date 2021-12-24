include("../../utils/io.jl")

function get_number_from_row(row)
    nums = strip.(split(row, " "))
    return parse(Int64, nums[3])
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    blocks = strip.(split(raw_str, "\nadd z y\n"))
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

# z will not be smaller than 0
# On step 14, because no matter what z is, z*26 + w + xy_mat[i, 3] cannot be zero
# Thus on step 14 the first branch must have been taken, and z needs to be between 0 and 25
# z % 26 + xy_mat[14, 2]  == w
# z % 26 - 14  == w
# if z == 25 then w can be 11
# if z == 24 then w can be 10 
# if z == 23 then w can be 9
# ...
# if z == 15 then w can be 1
# Thus for step 14, possible input z is 15 -> 23

# For step 13
# it must have been gone through branch one, otherwise z would be larger than 26
# z % 26 + xy_mat[13, 2]  == w
# z % 26 -16  == w

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

function solution(path::String)
    xy_mat = parse_input(path)

    print(xy_mat[:, 1], "\n")
    print(xy_mat[:, 2], "\n")
    print(xy_mat[:, 3], "\n")

    for serial in 99999999999999:-1:11111111111111
        z = 0
        new_num = serial
        if serial % 10000000 == 1111111
            print(serial, "\n")
        end
        for i in 1:14
            denom = 10^(14-i)
            num = div(new_num, denom)
            z = operate_simple(z, xy_mat, num, i)
            new_num %= denom
        end
        if z == 0 
            print(serial, "\n")
            break
        end
    end
end


solution("./input.txt")