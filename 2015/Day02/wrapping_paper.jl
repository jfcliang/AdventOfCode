include("../../utils/io.jl")

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    area = 0
    ribbon = 0
    for row in strip.(split(raw_str, '\n'))
        nums = sort(parse.(Int64, split(row, 'x')))
        area += (
            2*nums[1]*nums[2] + 2*nums[2]*nums[3] + 
            2*nums[1]*nums[3] + nums[2]*nums[1])

        ribbon += 2*(nums[2] + nums[1]) + nums[1]*nums[2]*nums[3]

    end

    return area, ribbon

end


function solution(path::String)
    print(parse_input(path))

end


solution("./input.txt")