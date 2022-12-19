
abstract type Piece end

function get_coords(piece::Piece) :: Vector{Tuple{Int64, Int64}} end
get_left(piece::Piece) = piece.ref[1]
function get_right(piece::Piece) :: Int64 end
function get_top(piece::Piece) :: Int64 end


mutable struct HLine <: Piece
    ref::Tuple{Int64, Int64}
end

function get_coords(piece::HLine) :: Vector{Tuple{Int64, Int64}}
    x, y = piece.ref
    return [
        (x, y), (x+1, y), (x+2, y), (x+3, y)
    ]
end

get_right(piece::HLine) = piece.ref[1] + 3
get_top(piece::HLine) = piece.ref[2]


mutable struct VLine <: Piece
    ref::Tuple{Int64, Int64}
end

function get_coords(piece::VLine) :: Vector{Tuple{Int64, Int64}}
    x, y = piece.ref
    return [
        (x, y), (x, y+1), (x, y+2), (x, y+3)
    ]
end

get_right(piece::VLine) = piece.ref[1]
get_top(piece::VLine) = piece.ref[2] + 3


mutable struct Cross <: Piece
    ref::Tuple{Int64, Int64}
end

function get_coords(piece::Cross) :: Vector{Tuple{Int64, Int64}}
    x, y = piece.ref
    return [
        (x, y+1), (x+1, y+1), (x+1, y+2), (x+1, y), (x+2, y+1)
    ]
end

get_right(piece::Cross) = piece.ref[1] + 2
get_top(piece::Cross) = piece.ref[2] + 2


mutable struct LShape <: Piece
    ref::Tuple{Int64, Int64}
end

function get_coords(piece::LShape) :: Vector{Tuple{Int64, Int64}}
    x, y = piece.ref
    return [
        (x, y), (x+1, y), (x+2, y), (x+2, y+1), (x+2, y+2)
    ]
end

get_right(piece::LShape) = piece.ref[1] + 2
get_top(piece::LShape) = piece.ref[2] + 2


mutable struct Block <: Piece
    ref::Tuple{Int64, Int64}
end

function get_coords(piece::Block) :: Vector{Tuple{Int64, Int64}}
    x, y = piece.ref
    return [
        (x, y), (x+1, y), (x+1, y+1), (x, y+1)
    ]
end

get_right(piece::Block) = piece.ref[1] + 1
get_top(piece::Block) = piece.ref[2] + 1


function move_left!(piece::Piece)
    x, y = piece.ref
    piece.ref = (x-1, y)
end

function move_right!(piece::Piece)
    x, y = piece.ref
    piece.ref = (x+1, y)
end

function move_down!(piece::Piece)
    x, y = piece.ref
    piece.ref = (x, y-1)
end
