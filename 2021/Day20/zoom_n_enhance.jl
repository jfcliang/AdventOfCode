include("../../utils/io.jl")

pixel_map = Dict('#' => '1', '.' => '0')
pixel_back = Dict('1' => '#', '0' => '.')

function neighbors(i, j)
    return [
        (i-1, j-1), (i-1, j  ), (i-1, j+1),
        (i  , j-1), (i  , j  ), (i  , j+1),
        (i+1, j-1), (i+1, j  ), (i+1, j+1)
    ]
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    pattern, screen = strip.(split(raw_str, "\n\n"))

    pixels = [
        [pixel_map[only(n)] for n in split(strip(row), "")]
        for row in split(screen, "\n")
    ]

    screen = fill('0', (length(pixels), length(pixels[1])))
    for i in 1:length(pixels)
        for j in 1:length(pixels[1])
            screen[i, j] = pixels[i][j]
        end
    end

    return pattern, screen
end

function expand_initial_screen(screen)

    expanded = fill('0', (size(screen)[1]+4, size(screen)[2]+4))
    for i in 1:(size(screen)[1])
        for j in 1:(size(screen)[2])
            expanded[i+2, j+2] = screen[i, j]
        end
    end
    return expanded
end

function expand_screen(screen, enhance_count)
    if enhance_count % 2 == 0
        filchar = '0'
    else
        filchar = '1'
    end
    expanded = fill(filchar, (size(screen)[1]+2, size(screen)[2]+2))
    for i in 3:(size(screen)[1]-2)
        for j in 3:(size(screen)[2]-2)
            expanded[i+1, j+1] = screen[i, j]
        end
    end
    return expanded
end

function find_new_pixel(screen, pattern, i, j)
    bin = ""
    for nb in neighbors(i, j)
        i1, j1 = nb 
        bin *= screen[i1, j1]
    end

    count = parse(Int64, bin, base=2)
    return pixel_map[pattern[count+1]]
end


function zoom_screen(screen, pattern, enhance_count)
    screen = expand_screen(screen, enhance_count)

    if enhance_count % 2 == 0
        filchar = '0'
    else
        filchar = '1'
    end
    
    new_screen = fill(filchar, size(screen))

    for i in 3:(size(new_screen)[1]-2)
        for j in 3:(size(new_screen)[2]-2)
            new_screen[i, j] = find_new_pixel(screen, pattern, i, j)
        end
    end

    return new_screen
end


function solution(path::String)

    pattern, screen = (parse_input(path))
    
    screen = expand_initial_screen(screen)
    print_tight_matrix([pixel_back[i] for i in screen])
    
    enhance_count = 0
    zoomed_screen = zoom_screen(screen, pattern, enhance_count)
    enhance_count += 1
    print_tight_matrix([pixel_back[i] for i in zoomed_screen])

    zoomed_screen = zoom_screen(zoomed_screen, pattern, enhance_count)
    enhance_count += 1
    print_tight_matrix([pixel_back[i] for i in zoomed_screen])

    total_lit = 0

    for i in 3:(size(zoomed_screen)[1]-2)
        for j in 3:(size(zoomed_screen)[2]-2)
            if zoomed_screen[i, j] == '1'
                total_lit += 1
            end
        end
    end

    print(total_lit)


end

# For an infinite screen, we need (content_dim + 3)^2 to buffer the infinite surroundings
# pixels within (content_dim + 1)^2 are controlled by content
# pixels outside of that flips every enhancement


# solution("./input_example.txt")
solution("./input.txt")