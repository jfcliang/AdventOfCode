include("../utils/io.jl")

using DataStructures

LEFT = Set(['{', '(', '[', '<'])
RIGHT = Set(['}', ')', ']', '>'])

SUCCESS_FLAG = ' '

R2L = Dict(
    '}' => '{', ')' => '(', 
    ']' => '[', '>' => '<'
)

L2R = Dict(
    '{' => '}', '(' => ')', 
    '[' => ']', '<' => '>'
)

SYNTAX_ERROR_SCORES =  Dict(
    '}' => 1197, ')' => 3, 
    ']' => 57, '>' => 25137,
    ' ' => 0
)

AUTOCOMPLETE_SCORES = Dict(
    '}' => 3, ')' => 1, 
    ']' => 2, '>' => 4
)

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    return [collect(row) for row in split(raw_str)]
end


function inspect_row(row)
    code = Stack{Char}()

    for char in row
        if char in LEFT
            push!(code, char)
        end
        if char in RIGHT
            closing = pop!(code)
            if closing != R2L[char]
               return SYNTAX_ERROR_SCORES[char], 0
            end
        end
    end

    if isempty(code)
        return 0, 0
    else
        auto_score = 0
        while !isempty(code)
            complete = L2R[pop!(code)]
            auto_score = auto_score * 5 + AUTOCOMPLETE_SCORES[complete]
        end

        return 0, auto_score
    end
end


function solution(path::String)
    rows = parse_input(path)
    syntax_score = 0
    autocomplete_scores = []

    for row in rows
        s, a = inspect_row(row)
        syntax_score += s
        if a != 0
            append!(autocomplete_scores, a)
        end
    end

    idx = convert(Int64, (length(autocomplete_scores)+1)/2)
    auto_score = sort(autocomplete_scores)[idx]

    print("Total syntax error score is ", syntax_score, "\n")
    print("Total autocomplete score is ", auto_score, "\n")

end


solution("./input.txt")