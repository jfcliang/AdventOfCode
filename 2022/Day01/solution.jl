include("../../utils/io.jl")


function parse_input(path::String)
    input_str = input_to_raw_str(path)
    elves = strip.(split(input_str, "\r\n\r\n"))

    elves_cal = [parse.(Int64, strip.(split(elf, "\r\n"))) for elf in elves]
    
    return elves_cal
end


function solution(input_path::String)
    elves_cal = parse_input(input_path)
    cals = [sum(elf_cal) for elf_cal in elves_cal]

    print(maximum(cals), "\n")

    sorted = sort(cals, rev=true)
    print(sorted[1] + sorted[2] + sorted[3])

end


solution("./input.txt")
