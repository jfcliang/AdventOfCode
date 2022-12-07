include("../../utils/io.jl")

@enum LINE enter=1 exit=2 folder=3 file=4 pass=5


function read_logs(input_path::String)
    return parse_input_lines(input_path, "\r\n")
end


function parse_line(line::String)
    substrings = split(line, " ")

    if line[begin] == '$'
        # command
        if substrings[2] == "cd"
            if substrings[3] == ".." 
                return (exit, "", 0)
            else
                return (enter, String(substrings[3]), 0)
            end
        else
            return (pass, "", 0)
        end
    elseif line[1:3] == "dir"
        # folder
        folder_name = String(substrings[2])
        return (folder, folder_name, 0)

    else
        # file
        file_size = parse(Int64, substrings[1])
        file_name = String(substrings[2])
        return (file, file_name, file_size)

    end
end

function go_to_folder(disk::Dict, path::String)
    current_folder = disk
    for folder in split(path, "/")
        if folder != ""
            current_folder = current_folder[folder]
        end
    end
    return current_folder
end

function path_to_folders(path::String)
    folders = [
        String(folder) for folder in split(path, "/") if folder != ""
    ]
    return folders
end

function folders_to_path(folders::Vector{String})
    path = ""
    for folder in folders
        path *= (folder * "/")
    end
    return path
end

function construct_disk(lines::Vector)
    disk = Dict()
    current_folder = disk
    current_path = ""
    for line in lines
        (option, name, size) = parse_line(String(line))
        if option == enter
            current_folder = current_folder[name]
            current_path = current_path * name * "/"
        elseif option == exit
            path_folders = path_to_folders(current_path)
            current_path = folders_to_path(path_folders[begin:end-1]) 
            current_folder = go_to_folder(disk, current_path)
        elseif option == folder
            current_folder[name] = Dict()
        elseif option == file
            if "files" in keys(current_folder)
                current_folder["files"] += size
            else
                current_folder["files"] = size
            end
        end
    end
    return disk
end

function update_folder_size!(folder::Dict, sizes::Dict, path::String)
    size = get(folder, "files", 0)
    for key in keys(folder)
        if key != "files"
            sub_path = path * key * "/"
            size += update_folder_size!(folder[key], sizes, sub_path)
        end
    end
    sizes[path] = size
end

function solution(input_path::String)
    lines = read_logs(input_path)
    disk = construct_disk(lines)

    disk_size = Dict()
    
    update_folder_size!(disk, disk_size, "")

    # part 1
    total = 0
    for value in values(disk_size)
        if value <= 100000
            total += value
        end
    end
    println(total)

    # part 2
    disk_total = disk_size[""]
    limit = 70000000 - 30000000
    target_removal = disk_total - limit

    remove = disk_total
    for value in values(disk_size)
        if value >= target_removal && value < remove
            remove = value
        end
    end
    println(remove)

end

solution("input.txt")