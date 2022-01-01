include("../../utils/io.jl")

using MD5

function get_md5(input, num)
    numstr = string(num)
    combined = input * numstr
    return bytes2hex(md5(combined))
end

function solution()
    input = "yzbqklnj"
    num = 1
    while get_md5(input, num)[1:6] != "000000"
        num += 1
    end

    print(num)
end


solution()