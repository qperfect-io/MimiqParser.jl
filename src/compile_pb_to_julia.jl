using Symbolics
using ProtoBuf
using Bijections: Bijection
using MimiqCircuitsBase

include("build_proto/build_julia.jl")
compile_pb_to_julia("proto")


