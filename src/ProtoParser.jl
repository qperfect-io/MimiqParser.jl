module ProtoParser

using ProtoBuf
include("build_proto/build_julia.jl")

compile_pb_to_julia(pwd() * "/src/proto/mimiqcircuits")

include("julia/bitvector_pb.jl")
include("julia/pauli_pb.jl")
include("julia/hamiltonian_pb.jl")
include("julia/circuit_pb.jl")
include("julia/qcsresults_pb.jl")
include("julia/optim_pb.jl")
include("julia/noisemodel_pb.jl")

end # module ProtoParser
