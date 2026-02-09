module ProtoParser

using Symbolics
using ProtoBuf
using Bijections: Bijection
using MimiqCircuitsBase

include("build_proto/build_julia.jl")
println("PATH BELOW")
println(@__DIR__)
println(joinpath(@__DIR__, "proto/mimiqcircuits"))
println("--------------------")
compile_pb_to_julia(joinpath(@__DIR__, "proto/mimiqcircuits"))
include("julia/bitvector_pb.jl")
include("julia/pauli_pb.jl")
include("julia/hamiltonian_pb.jl")
include("julia/circuit_pb.jl")
include("julia/qcsresults_pb.jl")
include("julia/optim_pb.jl")
include("julia/noisemodel_pb.jl")

include("parser/bitstring.jl")
include("parser/pauli.jl")
include("parser/hamiltonian.jl")
include("parser/circuit.jl")
include("parser/qcsresults.jl")
include("parser/optim.jl")
include("parser/noisemodel.jl")

export saveproto
export loadproto
include("parser/proto.jl")

end # module ProtoParser
