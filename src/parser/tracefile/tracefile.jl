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
        mps.physical_dims,
        mps.max_bond_dim,
        mps.bond_dims,
        mps.ortho_center
    )
end

function toproto(state::AbstractState)
    error("This state is not supported by MimiqParser")
end

function _build_oneof_backend(backend)
    backend isa mpssim_pb.MPSLight ? OneOf(:mps, backend) :
    backend isa tensorweaver_pb.TensorWeaverLight ? OneOf(:tensorweaver, backend) :
    backend isa statevecsim_pb.StateVectorLight ? OneOf(:sv, backend) :
    throw(ArgumentError(lazy"The Backend is not supported"))
end

function toproto(c::Vector{Bool})
    return mpssim_pb.ClassicalState(c)
end

# The toproto for the different states have to be overwritten by the modules inheriting
function toproto(state::StateInfo)
    return tracefile_pb.StateInfo(state.numqubits, _build_oneof_backend(toproto(state.state)), toproto(state.c), toprotoZ(state.z))
end

function toproto(state_evo::Vector{StateInfo})
    states = tracefile_pb.StateInfo[]
    for state in state_evo
        push!(states, toproto(state))
    end
    return states
end


function toproto(backend::Backend)

    if backend == MPS
        return tracefile_pb.Backend.MatrixProductState
    elseif backend == SV
        return tracefile_pb.Backend.StateVector
    elseif backend == TensorWeaver
        return tracefile_pb.Backend.TensorWeaver
    end

    return tracefile_pb.Backend.Undefined
end

function toproto(trace::Tracefile)
    og_circ = toproto(trace.original_circuit)
    opt_circ = toproto(trace.optimized_circuit)

    state_evo = toproto(trace.state_evolution)
    return tracefile_pb.Tracefile(toproto(trace.backend), og_circ, opt_circ, state_evo)
end

function fromproto(state::statevecsim_pb.StateVectorLight)
    return StateVectorLight(state.sv_size)
end

function fromproto(::tensorweaver_pb.TensorWeaverLight)
    return TensorWeaverLight()
end

function fromproto(state::mpssim_pb.MPSLight)
    return MPSLight(state.numtensors, state.physical_dims, state.max_bond_dim, state.bond_dims, state.ortho_center)
end

function fromproto(state::tracefile_pb.StateInfo)
    return StateInfo(state.num_qubits, fromproto(state.state), state.c, fromproto(state.z))
end

function fromproto(states::Vector{tracefile_pb.StateInfo})
    result = StateInfo[]
    for state in states
        push!(result, fromproto(state))
    end
    return result
end

function fromproto(back::tracefile_pb.Backend.T)
    if back == tracefile_pb.Backend.MatrixProductState
        return MPS
    elseif back == tracefile_pb.Backend.StateVector
        return SV
    elseif back == tracefile_pb.Backend.TensorWeaver
        return TensorWeaver
    end
    return Undefined
end

function fromproto(trace::tracefile_pb.Tracefile)
    return Tracefile(length(trace.state_evolution) == 0, fromproto(trace.backend), fromproto(trace.original_circuit), fromproto(trace.optimized_circuit), fromproto(trace.state_evolution))
end