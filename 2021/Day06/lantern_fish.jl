include("../../utils/io.jl")

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    start_school = [parse(Int64, element) for element in split(raw_str, ",")]
    return start_school
end

function school_to_dict(school)
    school_count = Dict(i => 0 for i in 0:8)
    for fish in school
        school_count[fish] += 1
    end
    return school_count
end

function evolve!(school_count)
    reproduce = school_count[0]
    for i in 0:7
        school_count[i] = school_count[i+1]
    end
    school_count[6] += reproduce
    school_count[8] = reproduce
end

function solution(path::String, days::Int64)
    start_school = parse_input(path)
    school_count = school_to_dict(start_school)

    for i in 1:days
        evolve!(school_count)
    end

    print("Total fish count: ", sum(values(school_count)), "\n")
end

solution("input.txt", 80)
solution("input.txt", 256)