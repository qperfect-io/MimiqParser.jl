using ProtoBuf
using DataStructures

# clean a proto file (arguement: path to the file)
function _clean_proto_file(fname)
    pbpath = _getjuliaprotopath(fname)
    lines = readlines(pbpath)
    for i in eachindex(lines)
        if occursin(r"^import\s(?!\.\.)[\w.]+_pb$", lines[i])
            lines[i] = replace(lines[i], "import " => "import ..")
        end
        if occursin(r"include", lines[i])
            lines[i] = ""
        end
        if occursin(r"# original file", lines[i])
            lines[i] = ""
        end
    end

    open(pbpath, "w") do io
        join(io, lines, "\n")
    end
end

# generate the path to the Julia proto file from the proto file name
function _getjuliaprotopath(fname)
    pbfname = replace(fname, r"\.proto$" => "_pb.jl")
    return joinpath(@__DIR__(), "../julia", pbfname)
end


# generate the proto files, if they don't exist
function _generateproto(path_to_proto, fname)
    pbpath = _getjuliaprotopath(fname)
    print(pbpath)
    if !isfile(pbpath)
        @info "Generating $pbpath from $fname"
        protojl(fname, joinpath(@__DIR__, "../" * path_to_proto), joinpath(@__DIR__, "julia"))
        _clean_proto_file(fname)
        return true
    end
    return false
end

function compile_pb_to_julia(original_folder)
    dir_queue = Queue{String}()
    push!(dir_queue, original_folder * "/.")


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
                generated = _generateproto(curr_root, file)
                if generated
                    _clean_proto_file(file)
                end
            end
        end
    end

end