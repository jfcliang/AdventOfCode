include("../../utils/io.jl")

function parse_input(path::String)
    raw_str = string(input_to_raw_str(path))

    return long_hex_to_binary(raw_str)
end


function decode_literal_packet(packet, current_bit)
    print("literal started, now at ", current_bit, '\n')
    start_bit = current_bit
    num_string = ""
    while (packet[current_bit] != '0')
        part = packet[current_bit+1: current_bit+4]
        num_string *= part
        current_bit += 5
    end

    part = packet[current_bit+1: current_bit+4]
    num_string *= part
    current_bit += 5

    print("literal finished, now at ", current_bit, '\n')
    return parse(Int64, num_string, base=2), current_bit
end


function decode_operator_packet(packet, current_bit, operator)
    print("operator started, now at ", current_bit, '\n')
    total_sums = []
    length_type = packet[current_bit]
    if length_type == '1'
        num_packet = parse(Int64, packet[current_bit+1: current_bit+11], base=2)
        current_bit += 12
        print("oprator 1 got ", num_packet, " packets. Now at ", current_bit, '\n')
        for i in 1:num_packet
            current_sum, current_bit = decode(packet, current_bit)
            append!(total_sums, current_sum)
        end
        print("operator 1 finished, now at ", current_bit, '\n')
    else
        length_packet = parse(Int64, packet[current_bit+1: current_bit+15], base=2)
        current_bit += 16
        start_bit = current_bit
        print("oprator 0 got ", length_packet, " digits. Now at ", current_bit, '\n')
        while current_bit < start_bit + length_packet
            current_sum, current_bit = decode(packet, current_bit)
            append!(total_sums, current_sum)
        end
        print("operator 0 finished, now at ", current_bit, '\n')
    end

    return operator(total_sums), current_bit
end

function multiply(arr)
    total = 1
    for ele in arr
        total *= ele
    end

    return total
end

function largers(arr)
    return arr[1] > arr[2]
end

function smallers(arr)
    return arr[1] < arr[2]
end

function equals(arr)
    return arr[1] == arr[2]
end

function decode(packet, current_bit)
    type_id = parse(Int64, packet[current_bit+3:current_bit+5], base=2)
    current_bit += 6
    if type_id == 4
        return decode_literal_packet(packet, current_bit)
    elseif type_id == 0
        return decode_operator_packet(packet, current_bit, sum)
    elseif type_id == 1
        return decode_operator_packet(packet, current_bit, multiply)
    elseif type_id == 2
        return decode_operator_packet(packet, current_bit, minimum)
    elseif type_id == 3
        return decode_operator_packet(packet, current_bit, maximum)
    elseif type_id == 5
        return decode_operator_packet(packet, current_bit, largers)
    elseif type_id == 6
        return decode_operator_packet(packet, current_bit, smallers)
    elseif type_id == 7
        return decode_operator_packet(packet, current_bit, equals)
    end
end


function solution(path::String)
    packet = parse_input(path)
    
    print("Total result of calculation is: ", decode(packet, 1), "\n")
end


solution("./input.txt")
# print(long_hex_to_binary("D2FE28"))
# print(decode(long_hex_to_binary("D8005AC2A8F0"), 1))
