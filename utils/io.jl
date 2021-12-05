function input_to_raw_str(path::String)
    open(path) do file
        total_str = read(file, String)
        return strip(total_str)
    end
end