include("../../utils/io.jl")

mutable struct Valve
    name::String
    flow_rate::Int64
    leads::Vector{String}
end

function parse_line(line::String)
    pattern = r"Valve (?<current>[A-Z]+) has flow rate=(?<flow>[0-9]+); tunnels lead to valves (?<leads>[\,,\ ,A-Z]+)"
    m = match(pattern, line)
    name = m["current"]
    flow = parse(Int64, m["flow"])
    leads = String.(strip.(split(leads, ", ")))

    return Valve(name, flow, leads)
end

function generate_dis_map(valves::Vector{Valve})
    map = Dict{Tuple{Int64, Int64}, Int64}
    for valve in valves
        for next in valve.leads
            


end

function generate_next_step()

end

function solution1()
    lines = parse_input_lines(path)
    valves = parse_line.(lines)
    dis_map = generate_dis_map(valves)

    for remain in 30:-1:0

        

end




