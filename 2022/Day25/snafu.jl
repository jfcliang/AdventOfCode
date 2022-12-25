include("../../utils/io.jl")

char2num = Dict(
    '0' => 0, '1' => 1, '2' => 2, 
    '-' => -1, '=' => -2
)

num2char = Dict(
    0 => '0', 1 => '1', 2 => '2', 
    -1 => '-', -2 => '='
)

function snafu_to_num(snafu::String) :: Int64
    num = 0
    tot = length(snafu)
    for (i, c) in enumerate(snafu)
        pow = tot - i
        num += char2num[c] * 5^pow
    end
    return num
end


function num_to_snafu(num::Int64) :: String
    snafu = ""
    remain = num

    while remain > 2
        digit = mod(remain, 5)
        remain = div(remain, 5)
        if digit >= 3
            digit -= 5
            remain += 1
        end
        snafu *= num2char[digit]
    end

    if remain != 0
        snafu *= num2char[remain]
    end

    return reverse(snafu)
end


function solution1(path::String)
    snafus = parse_input_lines(path, "\r\n")
    nums = snafu_to_num.(snafus)
    result = num_to_snafu(sum(nums))
    println(result)
end

function test_example(path::String)
    snafus = parse_input_lines(path, "\r\n")
    for snafu in snafus
        num = snafu_to_num(snafu)
        println((num, num_to_snafu(num)))
    end
end

test_example("./input_example.txt")
@time solution1("./input.txt")
