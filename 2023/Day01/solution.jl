include("../../utils/io.jl")

num_by_word = Dict(
    "one" => "1",
    "two" => "2",
    "three" => "3",
    "four" => "4",
    "five" => "5",
    "six" => "6",
    "seven" => "7",
    "eight" => "8",
    "nine" => "9"
)

function parse_input(path::String)
    strs = parse_input_lines(path, "\r\n")
    
    return strs
end

function is_a_digit(c::Char) 
    return '0' <= c <= '9'
end


function find_num_in_line(line::String) 
    num_str = ""
    num_str = num_str * find_first_num_in_line(line)
    num_str = num_str * find_last_num_in_line(line)

    return parse(Int64, num_str)
end


function find_first_num_in_line(line::String) 
    for i in 1:length(line)
        if is_a_digit(line[i])
            return line[i]
        end
    end
end

function find_last_num_in_line(line::String) 
    for j in length(line):-1:1
        if is_a_digit(line[j])
            return line[j]
        end
    end
end


function solution1(path::String)
    strs = parse_input(path)
    nums = find_num_in_line.(strs)
    print(sum(nums))
end

function replace_str_num(str::String)
    return replace(
        str, 
        "one" => "1",
        "two" => "2",
        "three" => "3",
        "four" => "4",
        "five" => "5",
        "six" => "6",
        "seven" => "7",
        "eight" => "8",
        "nine" => "9"
        )
end

function replace_reversed_str_num(str::String)
    return replace(
        str, 
        "eno" => "1",
        "owt" => "2",
        "eerht" => "3",
        "ruof" => "4",
        "evif" => "5",
        "xis" => "6",
        "neves" => "7",
        "thgie" => "8",
        "enin" => "9"
        )
end

function find_num_in_line_with_words(line::String)
    num = "" 

    forward_replacement = replace_str_num(line)

    num = num * find_first_num_in_line(forward_replacement)

    back_replacement = replace_reversed_str_num(reverse(line))
    num = num * find_first_num_in_line(back_replacement)

    return parse(Int64, num)
end

function solution2(path::String)
    strs = parse_input(path)
    nums = find_num_in_line_with_words.(strs)
    print(sum(nums))
end


solution1("./input.txt")
solution2("./input.txt")