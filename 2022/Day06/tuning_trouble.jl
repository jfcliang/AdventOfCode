include("../../utils/io.jl")


function solution1(path::String)
    signals = input_to_raw_str(path)
    size = length(signals)

    for i in 1:(size-4)
        subsignal = signals[i:i+3]
        unique_signals = Set(subsignal)
        if length(unique_signals) == 4
            return i + 3
        end
    end
end


function solution2(path::String)
    signals = input_to_raw_str(path)
    size = length(signals)

    for i in 1:(size-14)
        subsignal = signals[i:i+13]
        unique_signals = Set(subsignal)
        if length(unique_signals) == 14
            return i + 13
        end
    end
end

println(solution1("./input.txt"))
println(solution2("./input.txt"))