using ProtoBuf
using DataStructures


dir_queue = Queue{String}()
push!(dir_queue, "src/proto/.")

while !isempty(dir_queue)

    curr_root = popfirst!(dir_queue)
    for (root, dirs, files) in walkdir(curr_root)

        println(root)
        julia_root = replace(root, "/proto/" => "/julia/"; count=1)

        for dir in dirs
            new_pb_path = joinpath.(root, dir)
            push!(dir_queue, new_pb_path)

            new_julia_path = joinpath.(julia_root, dir)
            mkpath(new_julia_path)
        end

        for file in files
            protojl(file, root, julia_root)
        end
    end
end