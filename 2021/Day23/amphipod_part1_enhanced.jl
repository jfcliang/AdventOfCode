using Memoize
using DataStructures

ROOM1_FIN = ['A', 'A']
ROOM2_FIN = ['B', 'B']
ROOM3_FIN = ['C', 'C']
ROOM4_FIN = ['D', 'D']

CHAMBER_NUM_DICT = Dict(
    1 => 'A', 2 => 'B', 3 => 'C', 4 => 'D'
)

AMPHIPOD_CHAMBER_DICT = Dict(
    'A' => 1, 'B' => 2, 'C' => 3, 'D' => 4
)

HALLWAY_ENTS = Dict(
    1 => 3, 
    2 => 5, 
    3 => 7, 
    4 => 9
)

MOVE_COSTS = Dict(
    'A' => 1, 
    'B' => 10, 
    'C' => 100, 
    'D' => 1000
)

TEMP_HW = [1, 2, 4, 6, 8, 10, 11]

struct ImState
    hallway::NTuple{11, Char}
    rooms::NTuple{4, NTuple{2, Char}}
end

mutable struct State
    hallway::Array{Char}
    rooms::Array{Array{Char}}
end

function ImState(state::State)
    return ImState(
        tuple(state.hallway...), 
        (
            tuple(state.rooms[1]...),
            tuple(state.rooms[2]...),
            tuple(state.rooms[3]...), 
            tuple(state.rooms[4]...)    
        )
    )
end

function State(imstate::ImState)
    return State(
        [imstate.hallway...], 
        [
            [imstate.rooms[1]...], 
            [imstate.rooms[2]...], 
            [imstate.rooms[3]...], 
            [imstate.rooms[4]...]
        ]
    )
end

INI_STATE = ImState(
    Tuple(['E' for i in 1:11]), 
    (
        ('D', 'B'), 
        ('C', 'C'), 
        ('A', 'D'), 
        ('B', 'A')
    )
)

function check_state_finished(state::State)
    return state.rooms[1] == ROOM1_FIN &&
        state.rooms[2] == ROOM2_FIN &&
        state.rooms[3] == ROOM3_FIN &&
        state.rooms[4] == ROOM4_FIN
end

function check_available_spot(room::Array{Char}, target_char::Char)
    found = false
    first_empty = 0
    for (i, char) in enumerate(room)
        if char != 'E'
            if !found
                first_empty = i-1
                found = true
            end
            if char != target_char
                return 0
            end
        end
    end

    if room[1] != 'E'
        return 0
    end

    if !found
        return 2
    end

    return first_empty
end

function check_poppable_amphi(room::Array{Char}, legal_amphi)
    amphi = 'E'
    pos = 0
    found = false

    # a fully legal chamber can't be popped
    for (i, char) in enumerate(room)
        if char != 'E' && !found
            amphi = char
            pos = i
            found = true
        end

        if char != legal_amphi && char != 'E'
            return (pos, amphi)
        end

    end

    return (0, 'E')
end

function get_hallway_path(p1, p2)
    if p1 >= p2
        return p2:(p1-1)
    else
        return (p1+1):p2
    end
end

function get_hallway_path_incl_self(p1, p2)
    if p1 >= p2
        return p2:p1
    else
        return p1:p2
    end
end

function generate_new_states(state::State)
    new_states = []
    # print(state, "\n")

    for (i, hw_char) in enumerate(state.hallway)
        if hw_char != 'E'
            # can only move from hallway to rooms
            lroom_num = AMPHIPOD_CHAMBER_DICT[hw_char]
            available_space = check_available_spot(
                state.rooms[lroom_num], hw_char)
            if available_space != 0 
                room_entrance = HALLWAY_ENTS[lroom_num]
                hw_path = get_hallway_path(i, room_entrance)
                if all([space == 'E' for space in state.hallway[hw_path]])
                    cost = (
                        length(hw_path) + available_space) * MOVE_COSTS[hw_char]
                    new_state = State(ImState((state)))
                    new_state.hallway[i] = 'E'
                    new_state.rooms[lroom_num][available_space] = hw_char
                    push!(new_states, (new_state, cost))
                end
            end
        end
    end

    for i in 1:4
        legal_char = CHAMBER_NUM_DICT[i]
        rm_space, rm_char = check_poppable_amphi(state.rooms[i], legal_char)
        hw_exit = HALLWAY_ENTS[i]
        if rm_space != 0
            lroom_num = AMPHIPOD_CHAMBER_DICT[rm_char] # where it belongs
            if lroom_num != i # move out and back is pointless for a room-to-room move
                available_space = check_available_spot(state.rooms[lroom_num], rm_char) 
                if available_space != 0 # move room to room is possible
                    room_entrance = HALLWAY_ENTS[lroom_num]
                    hw_path = get_hallway_path_incl_self(hw_exit, room_entrance)
                    if all([space == 'E' for space in state.hallway[hw_path]])
                        cost = (
                            rm_space + length(hw_path) + available_space - 1
                            ) * MOVE_COSTS[rm_char]
                        new_state = State(ImState((state)))
                        new_state.rooms[i][rm_space] = 'E'
                        new_state.rooms[lroom_num][available_space] = rm_char
                        push!(new_states, (new_state, cost))
                    end
                end
            end
            
            for hw_space in TEMP_HW
                if state.hallway[hw_space] == 'E'
                    hw_path = get_hallway_path_incl_self(hw_exit, hw_space)
                    if all([space == 'E' for space in state.hallway[hw_path]])
                        cost = (
                            length(hw_path) + rm_space - 1) * MOVE_COSTS[rm_char]
                        new_state = State(ImState((state)))
                        new_state.hallway[hw_space] = rm_char
                        new_state.rooms[i][rm_space] = 'E'
                        push!(new_states, (new_state, cost))
                    end
                end
            end
        end 
    end
    # print(new_states, "\n")
    return new_states
end


function dijkstra_amphipod()

    function process_current!(unvisited, current, current_cost)
        neighbors_cost = generate_new_states(current)
        for (nb, cost) in neighbors_cost
            new_cost = cost + current_cost
            imnb = ImState(nb)
            if get!(unvisited, imnb, Inf) > new_cost
                unvisited[imnb] = new_cost
            end
        end
    end

    unvisited = PriorityQueue()
    enqueue!(unvisited, INI_STATE => 0.0)

    while length(unvisited) > 0
        im_current, cost = dequeue_pair!(unvisited)
        current = State(im_current)
        # print("Current energy: ", cost,  "\n")
        process_current!(unvisited, current, cost)
        if check_state_finished(current)
            print("Find solution, minimal energy: ", cost, "\n")
            return
        end
    end
    
    print("Didn't find solution!", "\n")
end

function test_gen_new_state()
    current_state = State(
        ['A', 'A', 'E', 'E', 'E', 'B', 'E', 'E', 'E', 'E', 'E'],
        [
            ['B', 'A'], 
            ['B', 'B'], 
            ['C', 'C'], 
            ['D', 'D']
        ]
    )

    print(generate_new_states(current_state))

end

# test_gen_new_state()
dijkstra_amphipod()