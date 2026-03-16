
mutable struct Tracefile
    trace_active::Bool
    original_circuit::Circuit
    optimized_circuit::Circuit
    state_evolution::Vector{AbstractState}
end


function Tracefile(save_trace::Bool)

    return Tracefile(save_trace, Circuit(), Circuit(), AbstractState[])
end

is_trace_active(trace::Tracefile) = trace.trace_active