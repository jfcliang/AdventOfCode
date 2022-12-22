include("../../utils/io.jl")

calc_dict = Dict(
    '+' => +, '-' => -,
    '*' => *, '/' => /, 
    '=' => ==
)


mutable struct Monkey
    dep1::String
    # first_num::Int64
    dep2::String
    # second_num::Int64
    calc::Char
    num::Int64
end

function Monkey(dep1::String, dep2::String, calc::Char)
    return Monkey(dep1, dep2, calc, -1)
end

function Monkey(num::Int64)
    return Monkey("", "", ' ', num)
end

function calculate_monkey(name::String, monkeys::Dict{String, Monkey})
    monkey = monkeys[name]
    if monkey.num != -1
        return monkey.num
    else
        calc = calc_dict[monkey.calc]
        return calc(
            calculate_monkey(monkey.dep1, monkeys), 
            calculate_monkey(monkey.dep2, monkeys)
        )
    end
end


function parse_monkey!(input::String, monkeys::Dict{String, Monkey})
    elements = String.(strip.(split(input, " ")))
    name = elements[1][1:4]
    if length(elements) == 2
        num = parse(Int64, elements[2])
        monkeys[name] = Monkey(num)
    else
        dep1 = elements[2]
        dep2 = elements[4]
        calc = elements[3][1]
        monkeys[name] = Monkey(dep1, dep2, calc)
    end
end

function parse_monkeys(path::String)
    mk_strs = parse_input_lines(path, "\r\n")
    monkeys = Dict{String, Monkey}()
    for input in mk_strs
        parse_monkey!(input, monkeys)
    end
    return monkeys
end


function solution1(path::String)

    monkeys = parse_monkeys(path)
    result = calculate_monkey("root", monkeys)
    println(convert(Int64, result))

end

function try_calc(name::String, monkeys::Dict{String, Monkey})
    if haskey(monkeys, name)
        monkey = monkeys[name]
        if monkey.num != -1
            return true
        else
            dep1 = monkey.dep1
            dep2 = monkey.dep2
            return try_calc(dep1, monkeys) && try_calc(dep2, monkeys)
        end
    else
        return false

    end
end


function find_root(name::String, monkeys::Dict{String, Monkey}, result)
    if !haskey(monkeys, name)
        result = convert(Int64, result)
        println(result)
    else
        monkey = monkeys[name]
        left = try_calc(monkey.dep1, monkeys)
        right = try_calc(monkey.dep2, monkeys)
        if left
            l_result = calculate_monkey(monkey.dep1, monkeys)
            r_result = -1
            if monkey.calc == '+'
                r_result = result - l_result
            elseif monkey.calc == '-'
                r_result = l_result - result
            elseif monkey.calc == '*'
                r_result = result / l_result
            elseif monkey.calc == '/'
                r_result = l_result / result
            elseif monkey.calc == '='
                r_result = l_result
            end
            find_root(monkey.dep2, monkeys, r_result)
        elseif right
            r_result = calculate_monkey(monkey.dep2, monkeys)
            l_result = -1
            if monkey.calc == '+'
                l_result = result - r_result
            elseif monkey.calc == '-'
                l_result = result + r_result
            elseif monkey.calc == '*'
                l_result = result / r_result
            elseif monkey.calc == '/'
                l_result = result * r_result                
            elseif monkey.calc == '='
                l_result = r_result
            end
            find_root(monkey.dep1, monkeys, l_result)
        end
    end
end


function solution2(path::String)

    monkeys = parse_monkeys(path)
    monkeys["root"].calc = '='
    delete!(monkeys, "humn")
    
    find_root("root", monkeys, 0)

end

# @time solution1("./input.txt")
@time solution2("./input.txt")
