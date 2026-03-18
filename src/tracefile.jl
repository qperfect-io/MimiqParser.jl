@enum Backend MPS SV TensorWeaver Undefined



mutable struct Tracefile
    trace_active::Bool
    backend::Backend
    original_circuit::Circuit
    optimized_circuit::Circuit
    state_evolution::Vector{StateInfo}
end

function Tracefile(backend::Backend, save_trace::Bool)

    return Tracefile(save_trace, backend, Circuit(), Circuit(), AbstractState[])
end

function Tracefile(save_trace::Bool)

    return Tracefile(save_trace, Undefined, Circuit(), Circuit(), AbstractState[])
end

is_trace_active(trace::Tracefile) = trace.trace_active

get_state_evolution(trace::Tracefile) = trace.state_evolution

set_state_evolution(trace::Tracefile, states::Vector{StateInfo}) = trace.state_evolution = states