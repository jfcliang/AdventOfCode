include("../../utils/io.jl")

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    
end


function solution(path::String)
    print(parse_input(path))

end


solution("./input.txt")