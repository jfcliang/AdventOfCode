
function cube_wrap(
    map::Matrix{Char}, point::Tuple{Int64, Int64}, 
    dir::Char)

    d = 50 # by reading the input

    y, x = point

    if y == 1 && (d+1 <= x <= 2*d) && dir == '^'
        return (3*d + (x-d), 1), '>'

    elseif y == 1 && (2*d+1 <= x <= 3*d) && dir == '^'
        return (4*d, x - 2*d), '^'

    elseif (1 <= y <= d) && x == d+1 && dir == '<'
        return (2*d + (d+1 - y) , 1), '>'

    elseif (1 <= y <= d) && x == 3*d && dir == '>'
        return (2*d + (d+1 - y) , 2*d), '<'

    elseif y == d && (2*d+1 <= x <= 3*d) && dir == 'v'
        return (x-d, 2*d), '<'

    elseif (d+1 <= y <= 2d) && x == d+1 && dir == '<'
        return (2*d+1, y-d), 'v'

    elseif (d+1 <= y <= 2d) && x == 2*d && dir == '>'
        return (d, y+d), '^'

    elseif y == 2*d+1 &&  (1 <= x <= d) && dir == '^'
        return (d+x, d+1), '>'

    elseif (2*d+1 <= y <= 3*d) && x == 1 && dir == '<'
        return (3*d+1 - y, d+1), '>'

    elseif (2*d+1 <= y <= 3*d) && x == 2*d && dir == '>'
        return (3*d+1 -y, 3*d), '<'

    elseif y == 3*d && (d+1 <= x <= 2*d) && dir == 'v'
        return (x-d + 3*d, d), '<'

    elseif (3*d+1 <= y <= 4*d) && x == 1 && dir == '<'
        return (1, y-3*d + d), 'v'

    elseif (3*d+1 <= y <= 4*d) && x == d && dir == '>'
        return (3*d, y-3*d + d), '^'

    elseif y == 4d && (1 <= x <= d) && dir == 'v'
        return (1, x+2*d), 'v'

    else
        throw(ErrorException("Unknown wrapping: $dir at $point"))
    end
end