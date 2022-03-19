"""
wedge.jl defines methods for the wedge(x, y) function

------------------------------------------------------------------------------
COPYRIGHT/LICENSE. This file is part of the GeometricAlgebra.jl package. It
is subject to the license terms in the LICENSE file found in the top-level
directory of this distribution. No part of the GeometricAlgebra.jl package,
including this file, may be copied, modified, propagated, or distributed
except according to the terms contained in the LICENSE file.
------------------------------------------------------------------------------
"""
# --- Exports

export wedge, ∧

# --- Operator aliases

∧(M::AbstractMultivector, N::AbstractMultivector) = wedge(M, N)

∧(M::AbstractMultivector, x::Real) = wedge(M, x)
∧(x::Real, M::AbstractMultivector) = wedge(x, M)

∧(M::AbstractMultivector, v::Vector{<:Real}) = wedge(M, v)
∧(v::Vector{<:Real}, M::AbstractMultivector) = wedge(v, M)

∧(v::Vector{<:Real}, w::Vector{<:Real}) = wedge(v, w)

# --- Method definitions

"""
    wedge(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector
    ∧(M::AbstractMultivector, N::AbstractMultivector)::AbstractMultivector

Compute the outer product of `M` and `N`.
"""
function wedge end

# ------ Specializations involving an AbstractMultivector instance

# M::AbstractMultivector, B::AbstractBlade
# B::AbstractBlade, M::AbstractMultivector
wedge(M::AbstractMultivector, B::AbstractBlade) =
    Multivector(map(C -> wedge(C, B), blades(M)))

wedge(B::AbstractBlade, M::AbstractMultivector) =
    Multivector(map(C -> wedge(B, C), blades(M)))

# M::AbstractMultivector, v::Vector
# v::Vector, M::AbstractMultivector
wedge(M::AbstractMultivector, v::Vector{<:Real}) = 
    Multivector(map(C -> wedge(C, v), blades(M)))

wedge(v::Vector{<:Real}, M::AbstractMultivector) = 
    Multivector(map(C -> wedge(v, C), blades(M)))

# M::AbstractMultivector, B::AbstractScalar
# B::AbstractScalar, M::AbstractMultivector
wedge(B::AbstractMultivector, C::AbstractScalar) = B * C
wedge(B::AbstractScalar, C::AbstractMultivector) = B * C

# M::AbstractMultivector, B::One
# B::One, M::AbstractMultivector
wedge(M::AbstractMultivector, B::One) = M
wedge(B::One, M::AbstractMultivector) = M

# M::AbstractMultivector, B::Zero
# B::Zero, M::AbstractMultivector
wedge(B::Zero, M::AbstractMultivector) = B
wedge(M::AbstractMultivector, B::Zero) = B

# M::AbstractMultivector, x::Real
# x::Real, M::AbstractMultivector
wedge(M::AbstractMultivector, x::Real) = x * M
wedge(x::Real, M::AbstractMultivector) = x * M

# ------ Specializations involving an AbstractBlade instance

# B::AbstractBlade, C::AbstractScalar
# B::AbstractScalar, C::AbstractBlade
wedge(B::AbstractBlade, C::AbstractScalar) = B * C
wedge(B::AbstractScalar, C::AbstractBlade) = B * C

# B::AbstractBlade, C::One
# B::One, C::AbstractBlade
wedge(B::AbstractBlade, C::One) = B
wedge(B::One, C::AbstractBlade) = C

# B::AbstractBlade, C::Zero
# B::Zero, C::AbstractBlade
wedge(B::AbstractBlade, C::Zero) = zero(B)
wedge(B::Zero, C::AbstractBlade) = zero(C)

# B::AbstractBlade, x::Real
# x::Real, B::AbstractBlade
wedge(B::AbstractBlade, x::Real) = B * x
wedge(x::Real, B::AbstractBlade) = x * B

# ------ Specializations involving a Blade instance

# B::Blade, C::Blade
function wedge(B::Blade, C::Blade)
    # --- Check arguments

    assert_dim_equal(B, C)

    if grade(B) + grade(C) > dim(B)
        return zero(B)
    end

    # --- Construct new blade

    volume(B) * volume(C) * Blade(hcat(basis(B), basis(C)))
end

# B::Blade, C::Pseudoscalar
# B::Pseudoscalar, C::Blade
function wedge(B::Blade, C::Pseudoscalar)
    assert_dim_equal(B, C)
    zero(B)
end

wedge(B::Pseudoscalar, C::Blade) = wedge(C, B)

# B::Blade, v::Vector
# v::Vector, B::Blade
function wedge(B::Blade, v::Vector{<:Real})
    assert_dim_equal(B, v)

    # Note: volume(B) is incorporated into the norm of `v`
    Blade(hcat(basis(B), volume(B) * v))
end

function wedge(v::Vector{<:Real}, B::Blade)
    assert_dim_equal(v, B)

    # Note: volume(B) is incorporated into the norm of `v`
    Blade(hcat(volume(B) * v, basis(B)))
end

# v::Vector, w::Vector
wedge(v::Vector{<:Real}, w::Vector{<:Real}) = Blade(hcat(v, w))

# ------ Specializations involving a Pseudoscalar instance

# B::Pseudoscalar, C::Pseudoscalar
function wedge(B::Pseudoscalar, C::Pseudoscalar)
    assert_dim_equal(B, C)
    zero(B)
end

# B::Pseudoscalar, v::Vector
# v::Vector, B::Pseudoscalar
function wedge(B::Pseudoscalar, v::Vector{<:Real})
    assert_dim_equal(B, v)
    zero(B)
end

wedge(v::Vector{<:Real}, B::Pseudoscalar) = B ∧ v

# ------ Specializations involving an AbstractScalar instance

# B::AbstractScalar, C::One
# B::One, C::AbstractScalar
wedge(B::AbstractScalar, C::One) = B
wedge(B::One, C::AbstractScalar) = C

# B::AbstractScalar, C::Zero
# B::Zero, C::AbstractScalar
wedge(B::AbstractScalar, C::Zero) = C
wedge(B::Zero, C::AbstractScalar) = B

# B::AbstractScalar, x::Real
# x::Real, B::AbstractScalar
wedge(B::AbstractScalar, x::Real) = B * x
wedge(x::Real, B::AbstractScalar) = x * B

# B::AbstractScalar, v::Vector
# v::Vector, B::AbstractScalar
wedge(B::AbstractScalar, v::Vector{<:Real}) = value(B) * Blade(v)
wedge(v::Vector{<:Real}, B::AbstractScalar) = wedge(B, v)

# ------ Specializations involving a Scalar instance

# B::Scalar, C::Scalar
wedge(B::Scalar, C::Scalar) = B * C

# ------ Specializations involving a One instance

# B::One, C::One
wedge(B::One, C::One) = B

# B::One, C::Zero
# B::Zero, C::One
wedge(B::One, C::Zero) = C
wedge(B::Zero, C::One) = B

# ------ Specializations involving a Zero instance

# B::Zero, C::Zero
wedge(B::Zero, C::Zero) = B
