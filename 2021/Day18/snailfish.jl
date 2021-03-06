include("../../utils/io.jl")


mutable struct BinTreeNode
    data
    parent::BinTreeNode
    left::BinTreeNode
    right::BinTreeNode

    BinTreeNode() = new(NaN)
    BinTreeNode(data, parent::BinTreeNode) = new(data, parent)
end

function find_depth(current_node)
    if !isdefined(current_node, :parent)
        return 0
    else
        return 1 + find_depth(current_node.parent)
    end
end

function find_left_most(current_node)
    while isnan(current_node.data)
        current_node = current_node.left
    end
    return current_node

end


function find_right_most(current_node)
    while isnan(current_node.data)
        current_node = current_node.right
    end

    return current_node
end

function find_left_neighbor(current_node)
    if current_node === current_node.parent.right
        return find_right_most(current_node.parent.left)
    else
        return find_left_neighbor(current_node.parent)
    end
end

function find_right_neighbor(current_node)
    if current_node === current_node.parent.left
        return find_left_most(current_node.parent.right)
    else
        return find_right_neighbor(current_node.parent)
    end
end

function check_current_node_explode(current_node)
    if (isdefined(current_node, :parent) &&
        !isnan(current_node.parent.left.data) &&
        !isnan(current_node.parent.right.data) && 
        find_depth(current_node) > 4)
        # explode
        parent = current_node.parent
        left_node = parent.left
        right_node = parent.right
        try
            r_n = find_right_neighbor(right_node)
            # print("Right neighbor: ", r_n.data, "\n")
            r_n.data += right_node.data
        catch e
            # print("No right neighbor for node: ", right_node.data, "\n")
        end
        try 
            l_n = find_left_neighbor(left_node)
            # print("Left neighbor: ", l_n.data, "\n")
            l_n.data += left_node.data
        catch e
            # print("No left neighbor for node: ", left_node.data, "\n")
        end
        if parent === parent.parent.left
            parent.parent.left = BinTreeNode(0, parent.parent)
        else
            parent.parent.right = BinTreeNode(0, parent.parent)
        end
        return false
    end
    return true
end

function check_current_node_split(current_node)
    if current_node.data >= 10
        # split
        rd = div(current_node.data, 2)
        current_node.right = BinTreeNode(current_node.data - rd, current_node)
        current_node.left = BinTreeNode(rd, current_node)
        current_node.data = NaN
        return false
    end
    return true
end


# Need to sequence the action
function traverse_nodes(current_node, check)
    passed = check(current_node)
    if !passed
        return false
    end
    
    if isnan(current_node.data)
        passed = traverse_nodes(current_node.left, check)
        if !passed
            return false
        end
        passed = traverse_nodes(current_node.right, check)
    end
    return passed
end

function print_tree(root)
    current_node = root
    if !isnan(current_node.data)
        print(current_node.data)
        return
    end
    print('[')
    print_tree(root.left)
    print(',')
    print_tree(root.right)
    print(']')
end

function print_from_root(root)
    print_tree(root)
    print("\n")
end

function row_to_bintree(row)
    root = BinTreeNode()
    root.left = BinTreeNode(NaN, root)
    root.right = BinTreeNode(NaN, root)
    current_node = root.left
    
    for i in 2:length(row)
        c = row[i]
        if c == '['
            current_node.left = BinTreeNode(NaN, current_node)
            current_node.right = BinTreeNode(NaN, current_node)
            current_node = current_node.left
        elseif c == ']'
            current_node = current_node.parent
        elseif c == ','
            current_node = current_node.parent.right
        else
            data = parse(Int64, c)
            current_node.data = data
        end

    end

    return root
end

function add_trees(tree1, tree2)
    new_tree = BinTreeNode()
    new_tree.left = tree1
    new_tree.right = tree2

    tree1.parent = new_tree
    tree2.parent = new_tree
    return new_tree
end

function reduce_number!(tree)
    # print_from_root(tree)
    while true
        total = 0
        passed = false
        while !passed
            passed = traverse_nodes(tree, check_current_node_explode)
            # print("After explode: \n")
            # print_from_root(tree)
            if !passed 
                total += 1
            end
        end
        
        # Only check split once, because explode takes priority,
        # and it might be caused by the split
        passed = traverse_nodes(tree, check_current_node_split)
            # print("After split: \n")
            # print_from_root(tree)
        if !passed 
            total += 1
        end
        total != 0 || break
    end
end

function calc_magnitude(tree)
    if !isnan(tree.data)
        return tree.data
    else
        return 3 * calc_magnitude(tree.left) + 2 * calc_magnitude(tree.right)
    end
end

function parse_input(path::String)
    raw_str = input_to_raw_str(path)
    numbers = [strip(string(row)) for row in split(raw_str, '\n')]

    return numbers
end

function test_examples(str)
    root = row_to_bintree(str)
    reduce_number!(root)
    print_tree(root)
end

function test_addition(str1, str2)
    result = add_trees(row_to_bintree(str1), row_to_bintree(str2))
    reduce_number!(result)
    print_tree(result)

end

function solution(path::String)
    numbers = parse_input(path)

    result = row_to_bintree(numbers[1])

    for i in 2:length(numbers)
        print_tree(result)
        print(calc_magnitude(result), "\n")
        result = add_trees(result, row_to_bintree(numbers[i]))
        reduce_number!(result)
    end
    print_tree(result)
    print(calc_magnitude(result), "\n")
end

function solution2(path::String)
    numbers = row_to_bintree.(parse_input(path))
    maximum = 0
    pair_num = nothing

    for (i, _) in enumerate(numbers)
        for (j, _) in enumerate(numbers)
            if i != j
                new_numbers = row_to_bintree.(parse_input(path))
                n1, n2 = new_numbers[i], new_numbers[j]
                add1 = add_trees(n1, n2)
                reduce_number!(add1)
                mag1 = calc_magnitude(add1)
                if mag1 > maximum
                    maximum = mag1
                    pair_num = n1, n2
                end
            end
        end
    end
    print(maximum, "\n") 
    print_from_root.(pair_num)
end


# solution("./input_example.txt")
# solution2("./input_example.txt")
# solution("./input.txt")
solution2("./input.txt")
# test_addition("[[[[7,0],[7,7]],[[7,7],[7,8]]],[[[7,7],[8,8]],[[7,7],[8,7]]]]", "[7,[5,[[3,8],[1,4]]]]")