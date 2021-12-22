function input_to_raw_str(path::String)
    open(path) do file
        total_str = read(file, String)
        return strip(total_str)
    end
end

function parse_digit_matrix(path::String)
    raw_str = input_to_raw_str(path)
    mat = [
        [parse(Int8, n) for n in split(strip(row), "")] 
            for row in split(raw_str, "\n")
    ]
    mat = transpose(hcat(mat...))
    return mat
end

function adjacent_idx(i, j, ym, xm)
    function within_bound(idx, max)
        return (1 <= idx) && (idx <= max)
    end

    cands = [
        (i-1, j-1), (i-1, j), (i-1, j+1),
        (i, j-1), (i, j+1),
        (i+1, j-1), (i+1, j), (i+1, j+1)
    ]
        
    return [cand for cand in cands if (
                within_bound(cand[1], ym) && 
                within_bound(cand[2], xm))]

end


function hex_to_binary(hex_string)
    return lpad(
                string(parse(Int8, hex_string, base=16), base=2),
                4, '0')
end

function binary_to_hex(hex_string)
    return string(parse(Int8, hex_string, base=2), base=16)
end

function long_hex_to_binary(hex_string)
    binary = ""
    for char in hex_string
        binary *= hex_to_binary(char)
    end
    return binary
end


function print_tight_matrix(matrix)
    for i in 1:size(matrix)[1]
        for j in 1:size(matrix)[2]
            print(matrix[i, j])
        end
        print("\n")
    end
end