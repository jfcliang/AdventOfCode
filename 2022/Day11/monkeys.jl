using DataStructures

mutable struct Monkey
    starting_items::Queue{Int64}
    operate::Function
    test_divisor::Int64
    t_dest::Int64
    f_dest::Int64
    count::Int64
end

function Monkey(starting_items::Vector{Int64}, 
    operate::Function, test_divisor:: Int64, 
    t_dest::Int64, f_dest::Int64)

    item_queue = Queue{Int64}()
    for item in starting_items
        enqueue!(item_queue, item)
    end

    return Monkey(item_queue, operate, test_divisor, 
        t_dest, f_dest, 0)
end


function generate_monkeys()
    m1 = Monkey(
        [50, 70, 54, 83, 52, 78],
        x -> x * 3,
        11,
        2, 7
    )

    m2 = Monkey(
        [71, 52, 58, 60, 71],
        x -> x * x,
        7,
        0, 2
    )

    m3 = Monkey(
        [66, 56, 56, 94, 60, 86, 73],
        x -> x + 1,
        3,
        7, 5
    )

    m4 = Monkey(
        [83, 99],
        x -> x + 8,
        5,
        6, 4
    )

    m5 = Monkey(
        [98, 98, 79],
        x -> x + 3,
        17,
        1, 0
    )

    m6 = Monkey(
        [76],
        x -> x + 4,
        13,
        6, 3
    )

    m7 = Monkey(
        [52, 51, 84, 54],
        x -> x * 17,
        19,
        4, 1
    )

    m8 = Monkey(
        [82, 86, 91, 79, 94, 92, 59, 94],
        x -> x + 7,
        2,
        5, 3
    )


    return [m1, m2, m3, m4, m5, m6, m7, m8]
end


function generate_monkeys_example()
    m1 = Monkey(
        [79, 98],
        x -> x * 19,
        23,
        2, 3
    )

    m2 = Monkey(
        [54, 65, 75, 74],
        x -> x + 6,
        19,
        2, 0
    )

    m3 = Monkey(
        [79, 60, 97],
        x -> x * x,
        13,
        1, 3
    )

    m4 = Monkey(
        [74],
        x -> x + 3,
        17,
        0, 1
    )

    return [m1, m2, m3, m4]
end


function update_monkey!(monkeys::Vector{Monkey}, idx::Int64)
    current_monkey = monkeys[idx]
    while !isempty(current_monkey.starting_items)
        item = dequeue!(current_monkey.starting_items)
        worry = current_monkey.operate(item)
        worry = Integer(floor(worry / 3))

        if mod(worry, current_monkey.test_divisor) == 0
            target = current_monkey.t_dest + 1
            enqueue!(monkeys[target].starting_items, worry)
        else
            target = current_monkey.f_dest + 1
            enqueue!(monkeys[target].starting_items, worry)
        end

        current_monkey.count += 1
    end
end


function update_monkey2!(monkeys::Vector{Monkey}, idx::Int64)
    total_divisor = 11 * 7 * 3 * 5 * 17 * 13 * 19 * 2
    current_monkey = monkeys[idx]
    while !isempty(current_monkey.starting_items)
        item = dequeue!(current_monkey.starting_items)
        worry = current_monkey.operate(item)
        worry = mod(floor(worry), total_divisor)

        if mod(worry, current_monkey.test_divisor) == 0
            target = current_monkey.t_dest + 1
            enqueue!(monkeys[target].starting_items, worry)
        else
            target = current_monkey.f_dest + 1
            enqueue!(monkeys[target].starting_items, worry)
        end

        current_monkey.count += 1
    end
end


function solution1()
    # monkeys = generate_monkeys_example()
    monkeys = generate_monkeys()
    for i in 1:20
        for j in 1:8
            update_monkey!(monkeys, j)
        end
    end

    mbs = sort([monkey.count for monkey in monkeys])
    println(mbs)
    println(mbs[end] * mbs[end-1])
end

function solution2()
    # monkeys = generate_monkeys_example()
    monkeys = generate_monkeys()
    for i in 1:10000
        for j in 1:8
            update_monkey2!(monkeys, j)
        end
    end

    mbs = sort([monkey.count for monkey in monkeys])
    println(mbs)
    println(mbs[end] * mbs[end-1])
end


solution1()
solution2()