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