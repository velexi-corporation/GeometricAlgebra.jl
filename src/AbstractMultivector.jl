"""
AbstractMultivector.jl defines the AbstractMultivector type and basic functions

------------------------------------------------------------------------------
COPYRIGHT/LICENSE. This file is part of the GeometricAlgebra.jl package. It
is subject to the license terms in the LICENSE file found in the top-level
directory of this distribution. No part of the GeometricAlgebra.jl package,
including this file, may be copied, modified, propagated, or distributed
except according to the terms contained in the LICENSE file.
------------------------------------------------------------------------------
"""
# --- Exports

# Types
export AbstractMultivector

# Function
export dim, grades, blades
import Base.getindex
import LinearAlgebra.norm
export norm

# Comparison operators
import Base.:(==), Base.:(≈)

# Unary operators
import Base.:(-)
export reverse, dual

# Binary operators
import Base.:(+), Base.:(-), Base.:(*), Base.:(/)
export wedge, contractl, proj, dual

# Operator aliases
export ∧
import LinearAlgebra.dot
export dot
import Base.:(<)

# Utility functions
import Base.convert

# --- Type definitions

"""
    AbstractMultivector{<:AbstractFloat}

Supertype for all multivector types.

Interface
---------

Note: the return value of all methods should preserve the precision of the
AbstractMultivector instance (when possible).

### Attributes

    dim(M::AbstractMultivector)::Int
    grades(M::AbstractMultivector)::Vector{Int}
    blades(M::AbstractMultivector)::Vector{<:AbstractBlade}
    norm(M::AbstractMultivector{T})::T where {T<:AbstractFloat}

### Unary Operators

    -(M::AbstractMultivector)::AbstractMultivector
    reverse(M::AbstractMultivector)::AbstractMultivector

### Binary Operators

    +(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector
    -(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

    *(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector
    /(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

    wedge(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector
    ∧(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

    dot(M::AbstractMultivector, N::AbstractMultivector;
        left=true)::AbstractMultivector
    ⋅(M::AbstractMultivector, N::AbstractMultivector;
        left=true)::AbstractMultivector

    contractl(M::AbstractMultivector,
              N::AbstractMultivector)::AbstractMultivector
    <(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

    contractr(M::AbstractMultivector,
              N::AbstractMultivector)::AbstractMultivector
    >(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

### Functions

    dual(M::AbstractMultivector)::AbstractMultivector
    dual(M::AbstractMultivector, B::AbstractBlade)::AbstractMultivector
    proj(M::AbstractMultivector, B::AbstractBlade)::AbstractMultivector

    getindex(M::AbstractMultivector, k::Int)::Vector{<:AbstractBlade}
"""
abstract type AbstractMultivector{T<:AbstractFloat} end

# --- Utility functions

"""
    assert_dim_equal(M, N)

Assert that the dimensions of `M` and `N` are the same.

Valid arguments
---------------
    assert_dim_equal(M::AbstractMultivector, N::AbstractMultivector)
    assert_dim_equal(M::AbstractMultivector, v::Vector)
    assert_dim_equal(v::Vector, M::AbstractMultivector)
"""
function assert_dim_equal(M::AbstractMultivector, N::AbstractMultivector)
    if dim(M) != dim(N)
        throw(DimensionMismatch("`dim(M)` not equal to `dim(N)`"))
    end
end

function assert_dim_equal(M::AbstractMultivector, v::Vector)
    if dim(M) != length(v)
        throw(DimensionMismatch("`dim(M)` not equal to `length(v)`"))
    end
end
assert_dim_equal(v::Vector, M::AbstractMultivector) = assert_dim_equal(M, v)
