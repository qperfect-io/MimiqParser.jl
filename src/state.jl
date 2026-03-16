abstract type AbstractState end


struct StateVectorLight <: AbstractState
    sv_size::Int
end
struct MPSLight <: AbstractState
    numtensors::Int
    physical_dims::Vector{Int}
    max_bond_dim::Int
    bond_dims::Vector{Int}
    ortho_center::Int
end
struct TensorWeaverLight <: AbstractState end

struct StateInfo
    numqubits::Int

    state::AbstractState

    c::Vector{Bool}
    z::Vector{ComplexF64}
end