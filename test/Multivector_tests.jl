"""
Unit tests for the Multivector type.

------------------------------------------------------------------------------
COPYRIGHT/LICENSE. This file is part of the GeometricAlgebra.jl package. It
is subject to the license terms in the LICENSE file found in the top-level
directory of this distribution. No part of the GeometricAlgebra.jl package,
including this file, may be copied, modified, propagated, or distributed
except according to the terms contained in the LICENSE file.
------------------------------------------------------------------------------
"""
# --- Imports

# Standard library
import InteractiveUtils.subtypes
using Test

# GeometricAlgebra.jl
using GeometricAlgebra


# --- Constructor tests

@testset "Multivector: inner constructor tests" begin
    # Notes
    # -----
    # * Test value of constructed instance

    # --- Preparations

    vectors = [3 3; -4 -4; 0 1]
    one_vector = [3; 4; 0]

    test_value = rand() + 1  # add 1 to avoid 0
    test_value = rand() > 0.5 ? test_value : -test_value

    dim = length(one_vector)

    # --- Multivector{T}(blades::Vector{AbstractBlade{T}};
    #                    reduced::Bool=false) where {T<:AbstractFloat}

    for precision_type in subtypes(AbstractFloat)
        # Preparations
        scalar = Scalar{precision_type}(test_value)
        one_blade = Blade{precision_type}(one_vector)
        two_blade = Blade{precision_type}(vectors)
        pseudoscalar = Pseudoscalar{precision_type}(dim, test_value)

        blades = Vector([scalar, one_blade, two_blade, pseudoscalar])

        # default value for `reduced`
        M = Multivector{precision_type}(blades)
        @test length(M.summands) == length(blades)
        for B in blades
            @test haskey(M.summands, grade(B))
            @test length(M.summands[grade(B)]) == 1
        end
    end
end

@testset "Multivector: outer constructor tests" begin
    # Notes
    # -----
    # * Test type of constructed instances. Correct construction of instances
    #   is tested by the inner constructor tests.
    #
    # * Test behavior of keyword arguments: `TODO`
end

# --- Function tests

@testset "Multivector: AbstractMultivector interface tests" begin
    # --- Preparations

    vectors = [3 3; -4 -4; 0 1]
    one_vector = [3; 4; 0]

    test_value = rand() + 1  # add 1 to avoid 0
    test_value = rand() > 0.5 ? test_value : -test_value

    dim = length(one_vector)

    # --- Multivector{T}(blades::Vector{AbstractBlade{T}};
    #                    reduced::Bool=false) where {T<:AbstractFloat}

    for precision_type in subtypes(AbstractFloat)
        # Preparations
        scalar = Scalar{precision_type}(test_value)
        two_blade = Blade{precision_type}(vectors)
        one_blade = Blade{precision_type}(one_vector)
        pseudoscalar = Pseudoscalar{precision_type}(dim, test_value)
        blades = Vector([scalar, one_blade, two_blade, pseudoscalar])
        M = Multivector{precision_type}(blades)

        # summands()
        expected_summands = Dict(0=>Vector([scalar]),
                                 1=>Vector([one_blade]),
                                 2=>Vector([two_blade]),
                                 dim=>Vector([pseudoscalar]))
        @test summands(M) isa Dict{Int, Vector{AbstractBlade}}
        @test summands(M) == expected_summands
    end
end

@testset "Multivector: convert(B) tests" begin
    for precision_type_converted in subtypes(AbstractFloat)
        for precision_type_src in subtypes(AbstractFloat)
        end
    end
end
