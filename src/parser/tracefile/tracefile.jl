# function toproto(mapping::Vector{Tuple{Int,Int}})
#     pairs = MimiqParser.mpstrace_pb.Pair[]
#     for (inst, mpo) in mapping
#         push!(pairs, MimiqParser.mpstrace_pb.Pair(inst, mpo))
#     end
#     return pairs
# end

# function fromproto(mapping::Vector{mpstrace_pb.Pair})
#     result = tuple{Int,Int}[]
#     for pair in mapping
#         push!(result, (pair.first, pair.second))
#     end
#     return result
# end

# function fromproto(trace::MimiqParser.mpstrace_pb.Tracefile)
#     states = fromproto(trace.state_evolution)
#     backend_type = eltype(states)
#     result = Tracefile{backend_type}(
#         fromproto(trace.original_circuit),
#         fromproto(trace.optimized_circuit),
#         states,
#     )
#     return result
# end

function toprotoZ(z::Vector{ComplexF64})
    result = mpssim_pb.ComplexState[]
    for state in z
        push!(result, Vector{Float}([getre(state), getim(state)]))
    end
    return result
end

function toproto(sv::StateVectorLight)
    return statevecsim_pb.StateVectorLight(sv.sv_size)
end

function toproto(tensor::TensorWeaverLight)
    return tensorweaver_pb.TensorWeaverLight()
end

function toproto(mps::MPSLight)
    return mpssim_pb.MPSLight(
        mps.numtensors,
        mps.numqubits,
        mps.physical_dims,
        mps.max_bond_dim,
        mps.bond_dims,
        mps.ortho_center
    )
end

function toproto(state::AbstractState)
    error("This state is not supported by MimiqParser")
end

# The toproto for the different states have to be overwritten by the modules inheriting
function toproto(state::StateInfo)
    return tracefile_pb.StateInfo(state.numqubits, toproto(state.state), state.c, toprotoZ(state.z))

end

function toproto(state_evo::Vector{StateInfo})
    states = tracefile_pb.StateInfo[]
    for state in state_evo
        push!(states, toproto(state))
    end
    return states
end

function toproto(trace::Tracefile)
    og_circ = toproto(trace.original_circuit)
    opt_circ = toproto(trace.optimized_circuit)

    state_evo = toproto(trace.state_evolution)
    return tracefile_pb.Tracefile(og_circ, opt_circ, state_evo)
end

function fromproto(state_evolution::Vector{tracefile_pb.StateInfo})
    error("TODO: convert back to a readable format")
end

function fromproto(trace::tracefile_pb.Tracefile)
    return Tracefile(length(trace.state_evolution) == 0, fromproto(trace.original_circuit), fromproto(trace.optimized_circuit), fromproto(trace.state_evolution))
end