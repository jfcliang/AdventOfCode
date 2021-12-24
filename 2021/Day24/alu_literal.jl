include("../../utils/io.jl")

mutable struct Instruction
    operation::String
    target1::String
    istarget2int::Bool
    target2int::Int64
    target2str::String
end


function parse_instruction(row)
    eles = split(row, " ")
    if length(eles) == 2
        return Instruction("inp", eles[2], false, 0, "")
    else
        istarget2int = !(eles[3] in ["x", "y", "z", "w"])
        if istarget2int
            target2int = parse(Int64, eles[3])
            return Instruction(eles[1], eles[2], true, target2int, "")
        else
            return Instruction(eles[1], eles[2], false, 0, eles[3])
        end
    end
end


function operate!(alu::Dict{String, Int64}, ins::Instruction, serial::String, ptr::Int64)
    function arithmetic!(alu, ins, func::Function)
        if ins.istarget2int
            alu[ins.target1] = func(alu[ins.target1], ins.target2int)
        else
            alu[ins.target1] = func(alu[ins.target1], alu[ins.target2str])
        end
    end

    if ins.operation == "inp"
        target = parse(Int64, serial[ptr])
        ptr += 1
        alu[ins.target1] = target
    elseif ins.operation == "add"
        arithmetic!(alu, ins, +)
    elseif ins.operation == "mul"
        arithmetic!(alu, ins, *)
    elseif ins.operation == "div"
        arithmetic!(alu, ins, div)
    elseif ins.operation == "mod"
        arithmetic!(alu, ins, mod)
    elseif ins.operation == "eql"
        if ins.istarget2int
            target2 = ins.target2int
        else
            target2 = alu[ins.target2str]
        end

        if alu[ins.target1] == target2
            alu[ins.target1] = 1
        else
            alu[ins.target1] = 0
        end
    else
        throw(ErrorException("Wrong operation type! "))
    end

    return ptr
end


function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    rows = strip.(split(raw_str, "\n"))

    instructions = []
    for row in rows
        push!(instructions, parse_instruction(row))
    end

    return instructions

end


function solution(path::String)
    instructions = parse_input(path)

    alu = Dict([(str, 0) for str in ["x", "y", "z", "w"]])

    for i in 99999999999999:-1:1111111111111
        serial = string(i)
        if '0' in serial
            continue
        else
            print(serial, "\n")
            ptr = 1
            for ins in instructions
                ptr = operate!(alu, ins, serial, ptr)
            end
            
            if alu["z"] == 0
                print(serial)
                break
            end
        end
    end

end


solution("./input.txt")