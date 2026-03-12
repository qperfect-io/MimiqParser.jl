module MimiqParser

using Symbolics
using ProtoBuf
using Bijections: Bijection
using MimiqCircuitsBase

# The generated files should be built manually before compiling
# When doing a merge request the files will be automatically regenerated using src/compile_pb_to_julia.jl before being tested
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

# Some schemas are also prebuilt and unused by this module
include("julia/mpssim_pb.jl")
include("julia/mpstrace_pb.jl")

export saveproto
export loadproto
include("parser/proto.jl")

end # module MimiqParser
