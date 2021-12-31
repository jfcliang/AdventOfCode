function arrow_to_move(i, j, dir)
    # i and j are the row and column count, 
    # which are equivalent to y, x

    if dir == '>'
        return i, j+1 
    elseif dir == '<'
        return i, j-1
    elseif dir == '^'
        return i-1, j
    elseif dir == 'v'
        return i+1, j
    else
        throw(ErrorException(string("Invalid direction character: ", dir, "\n")))
    end

end