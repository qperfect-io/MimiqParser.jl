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

    write(pbpath, join(lines, "\n"))
end

# generate the path to the Julia proto file from the proto file name
function _getjuliaprotopath(fname)
    pbfname = replace(fname, r"\.proto$" => "_pb.jl")
    return joinpath(@__DIR__, "../julia", pbfname)
end

function path_from_folder(path, folder)
    parts = splitpath(path)
    i = findfirst(==(folder), parts)
    i === nothing && error("Folder not found in absolute path")
    return joinpath(parts[i+1:end]...)
end

# generate the proto files, if they don't exist
function _generateproto(root, path_to_proto, fname)
    pbpath = _getjuliaprotopath(fname)
    if !isfile(pbpath)
        relative_path = path_from_folder(path_to_proto, root)
        file = joinpath(relative_path, fname)
        @info "Generating $pbpath from $file"
        protojl(file, root, joinpath(@__DIR__, "../julia"))
    end
end

function compile_pb_to_julia(original_folder)

    mkpath(joinpath(@__DIR__, "../julia"))
    files_to_clean = []
    for (root, _, files) in walkdir(joinpath(@__DIR__, "../../" * original_folder))
        for file in files
            if length(file) > 5 && file[end-5:end] == ".proto"
                _generateproto(original_folder, root, file)
                push!(files_to_clean, file)
            end
        end
    end
    for file in files_to_clean
        _clean_proto_file(file)
    end

end