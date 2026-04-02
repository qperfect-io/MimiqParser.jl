module MimiqParser

using Symbolics
using ProtoBuf
using Bijections: Bijection
using MimiqCircuitsBase


# The generated files should be built manually before compiling
# When doing a merge request the files will be automatically regenerated using src/compile_pb_to_julia.jl before being tested
include("julia/utils_pb.jl")
include("julia/pauli_pb.jl")
include("julia/hamiltonian_pb.jl")
include("julia/circuit_pb.jl")
include("julia/qcsresults_pb.jl")
include("julia/optim_pb.jl")
include("julia/noisemodel_pb.jl")

include("parser/utils/utils.jl")
include("parser/mimiqcircuits/pauli.jl")
include("parser/mimiqcircuits/hamiltonian.jl")
include("parser/mimiqcircuits/circuit.jl")
include("parser/mimiqcircuits/qcsresults.jl")
include("parser/mimiqcircuits/optim.jl")
include("parser/mimiqcircuits/noisemodel.jl")

# Some schemas are also prebuilt and unused by this module
include("julia/mpssim_pb.jl")
include("julia/statevecsim_pb.jl")
include("julia/tensorweaver_pb.jl")

include("julia/tracefile_pb.jl")

export MPSLight
export StateVectorLight
export TensorWeaverLight
include("state.jl")
export Tracefile
export is_trace_active
export get_state_evolution
export set_state_evolution
export StateInfo
include("tracefile.jl")

include("parser/tracefile/tracefile.jl")
export saveproto
export loadproto
include("parser/proto.jl")

end # module MimiqParser
