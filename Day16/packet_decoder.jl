include("../utils/io.jl")

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

    # remainder = 3 - (current_bit - start_bit + 3) % 4
    # print("literal remainder: ", remainder, '\n')
    # current_bit += remainder
    print("literal finished, now at ", current_bit, '\n')
    return 0, current_bit
end


function decode_operator_packet(packet, current_bit)
    print("operator started, now at ", current_bit, '\n')
    version_sum = 0
    length_type = packet[current_bit]
    if length_type == '1'
        num_packet = parse(Int64, packet[current_bit+1: current_bit+11], base=2)
        current_bit += 12
        print("oprator 1 got ", num_packet, " packets. Now at ", current_bit, '\n')
        for i in 1:num_packet
            current_sum, current_bit = decode(packet, current_bit)
            version_sum += current_sum 
        end
        print("operator 1 finished, now at ", current_bit, '\n')
    else
        length_packet = parse(Int64, packet[current_bit+1: current_bit+15], base=2)
        current_bit += 16
        start_bit = current_bit
        print("oprator 0 got ", length_packet, " digits. Now at ", current_bit, '\n')
        while current_bit < start_bit + length_packet
            current_sum, current_bit = decode(packet, current_bit)
            version_sum += current_sum
        end
        print("operator 0 finished, now at ", current_bit, '\n')
    end

    return version_sum, current_bit
end


function decode(packet, current_bit)
    version_sum = parse(Int64, packet[current_bit:current_bit+2], base=2)
    type_id = parse(Int64, packet[current_bit+3:current_bit+5], base=2)
    print("From ", current_bit, " to ", current_bit+5, ": version, type -> ", version_sum, " , ", type_id, '\n')
    current_bit += 6
    if type_id == 4
        current_sum, current_bit = decode_literal_packet(packet, current_bit)
        version_sum += current_sum
    else
        current_sum, current_bit = decode_operator_packet(packet, current_bit)
        version_sum += current_sum
    end

    return version_sum, current_bit
end


function solution(path::String)
    packet = parse_input(path)
    version_sum, _ = decode(packet, 1)
    print("Total sum of version number is: ", version_sum, "\n")
end


solution("./input.txt")
# print(long_hex_to_binary("D2FE28"))
# print(decode(long_hex_to_binary("8A004A801A8002F478"), 1))
