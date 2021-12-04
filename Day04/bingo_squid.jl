include("../utils/io.jl")

function parse_raw(input_path::String)
    raw_str = input_to_raw_str(input_path)
    blocks = split(raw_str, "\n\n")
    return blocks
end


function parse_drawn_numbers(numbers_entry)
    numbers = [
        parse(Int64, num) for num in split(numbers_entry, ",")]
    return numbers
end


function parse_bingo_sheet(sheet_entry)
    function parse_row(row_str)

        row_str = lstrip(replace(row_str, "  "=>" "))

        return [parse(Int64, num) for num in split(row_str, " ")]
    end

    sheet = []

    for row in split(sheet_entry, "\n")
        if length(sheet) == 0 
            sheet = parse_row(row)
        else
            sheet = hcat(sheet, parse_row(row))
        end
    end

    return sheet
end


function update_bingo!(number, sheet, bingo)
    nrow, ncol = size(sheet)
    for i in 1:nrow
        for j in 1:ncol
            if number == sheet[i, j]
                bingo[i, j] = true
            end
        end
    end
end


function check_bingo(bingo) 
    nrow, ncol = size(bingo)
    for i in 1:nrow
        if all(bingo[i,:])
            return true
        end
    end

    for j in 1:ncol
        if all(bingo[:, j])
            return true
        end
    end
    
    return false
end

function calc_bingo_score(number, sheet, bingo)
    total = 0
    nrow, ncol = size(sheet)
    for i in 1:nrow
        for j in 1:ncol
            total += sheet[i, j] * !bingo[i, j]
        end
    end

    return total * number
end


function solution()
    blocks = parse_raw("./input.txt")

    numbers = parse_drawn_numbers(blocks[1])
    sheets = [parse_bingo_sheet(sheet) for sheet in blocks[2:end]]
    bingos = [fill(false, (5,5)) for sheet in sheets]

    won_bingos = 0
    won_sheets = Set()

    for number in numbers[1:end]
        for i in 1:length(sheets)
            sheet = sheets[i]
            bingo = bingos[i]
            update_bingo!(number, sheet, bingo)
            if !(i in won_sheets) && check_bingo(bingo)
                won_bingos += 1
                push!(won_sheets, i)
                if won_bingos == 1 || won_bingos == length(sheets)
                    print("Bingo! \n")
                    print(number, "\n")
                    print(sheet, "\n")
                    print(bingo, "\n")
                    print("Score: ", calc_bingo_score(number, sheet, bingo), "\n")
                end
            end
        end
    end
end

solution()
