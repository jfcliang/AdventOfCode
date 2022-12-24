include("../../utils/io.jl")


function parse_input(path::String) :: Vector{Int64}
    input_strs = parse_input_lines(path, "\r\n")
    return parse.(Int64, input_strs)
end


function update_num!(
    nums::Vector{Int64}, 
    new_pos::Vector{Int64}, 
    orig_pos::Vector{Int64},
    orig_i::Int64)

    cur_pos = new_pos[orig_i]
    num = nums[cur_pos]

    updated_pos = mod(num + cur_pos - 1, length(nums)-1) + 1

    if updated_pos == 1 && cur_pos != 1
        updated_pos = length(nums)
    end

    if updated_pos < cur_pos
        # move to the front

        for i in cur_pos:-1:updated_pos+1
            nums[i] = nums[i-1]
            orig_pos[i] = orig_pos[i-1]

            orig = orig_pos[i-1]
            new_pos[orig] = i
        end
    elseif updated_pos > cur_pos
        # move to the back

        for i in cur_pos:updated_pos-1
            nums[i] = nums[i+1]
            orig_pos[i] = orig_pos[i+1]

            orig = orig_pos[i+1]
            new_pos[orig] = i
        end
    end

    nums[updated_pos] = num
    new_pos[orig_i] = updated_pos
    orig_pos[updated_pos] = orig_i
end

function check_state(nums, new_pos, og_pos)
    println(nums)
    println(new_pos)
    println(og_pos)
    println()
end

function mix_nums!(
    nums::Vector{Int64}, 
    new_pos::Vector{Int64},
    og_pos::Vector{Int64})

    for i in 1:length(nums)
        # check_state(nums, new_pos, og_pos)
        update_num!(nums, new_pos, og_pos, i)
    end
    # check_state(nums, new_pos, og_pos)
end


function get_result(nums::Vector{Int64})
    zero_pos = 1
    for (i, num) in enumerate(nums)
        if num == 0
            zero_pos = i
            break
        end
    end

    size = length(nums)

    first = nums[mod(zero_pos+1000-1, size)+1]
    second = nums[mod(zero_pos+2000-1, size)+1]
    third = nums[mod(zero_pos+3000-1, size)+1]

    return first + second + third
end


function solution1(path::String)
    nums = parse_input(path)
        
    new_pos = [i for i in 1:length(nums)]
    # i-th element to update is at new_pos[i]
    og_pos = [i for i in 1:length(nums)]
    # i-th element in the nums is originally at og_pos[i]

    mix_nums!(nums, new_pos, og_pos)
    println(get_result(nums))
end

function solution2(path::String)
    nums = 811589153 * parse_input(path)

    new_pos = [i for i in 1:length(nums)]
    # i-th element to update is at new_pos[i]
    og_pos = [i for i in 1:length(nums)]
    # i-th element in the nums is originally at og_pos[i]

    for i in 1:10
        mix_nums!(nums, new_pos, og_pos)
    end

    println(get_result(nums))
end

@time solution1("./input.txt")
@time solution2("./input.txt")
# solution1("./input_example.txt")
# solution2("./input_example.txt")
