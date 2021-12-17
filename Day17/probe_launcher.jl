include("../utils/io.jl")

target_x = 94:151
target_y = -156:-103


mutable struct Probe
    x
    y
    ymax
    vx
    vy
    in_target
end

Probe(vx, vy) = Probe(0, 0, 0, vx, vy, false)

function update!(probe)
    probe.x += probe.vx
    probe.y += probe.vy

    if probe.y > probe.ymax
        probe.ymax = probe.y
    end

    if probe.x in target_x && probe.y in target_y
        probe.in_target = true
    end 

    if probe.vx > 0
        probe.vx -= 1
    end
    probe.vy -= 1

end

function passed_target(probe)
    return probe.y < -156
end

function simulate_probe(vx, vy)
    probe = Probe(vx, vy)
    while !passed_target(probe)
        update!(probe)
    end
    return probe
end

function solution()
    probes = [
        simulate_probe(vx, vy) for vx in 1:152 for vy in -156:200
    ]
    successes =[probe for probe in probes if probe.in_target]

    max_height = maximum([
        probe.ymax for probe in successes])

    print("Maximum height is ", max_height, "\n")
    print("Total possible initial v number is ", length(successes), "\n")
end


solution()