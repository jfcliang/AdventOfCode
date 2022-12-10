include("../../utils/io.jl")

function solution1(path::String)
    lines = parse_input_lines(path, "\r\n")
    total = 0
    record_pos = [20, 60, 100, 140, 180, 220]
    cycle = 0
    strength = 1
    for line in lines
        cycle += 1
        if cycle in record_pos
            
            total += strength * cycle
        end
        if line != "noop"
            cycle += 1
            if cycle in record_pos
                
                total += strength * cycle
            end
            strength += parse(Int64, split(line)[2])
        end
    end

    println(total)

end


function draw(drawing_pos, sprite_range)
    if sprite_range[1] <= drawing_pos <= sprite_range[2]
        print('█')
    else
        print(' ')
    end
end


function solution2(path::String)
    lines = parse_input_lines(path, "\r\n")
    cycle = 0
    sprite = 1
    for line in lines
        draw(cycle, (sprite-1, sprite+1))
        cycle += 1

        if mod(cycle, 40) == 0
            cycle = 0
            print('\n')
        end
        
        if line != "noop"
            draw(cycle, (sprite-1, sprite+1))
            cycle += 1
            
            sprite += parse(Int64, split(line)[2])

            if mod(cycle, 40) == 0
                cycle = 0
                print('\n')
            end
        end
    end

end


solution1("./input.txt")
solution2("./input.txt")