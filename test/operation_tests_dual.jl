"""
Unit tests for the dual(x, y) function

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
import LinearAlgebra
using Test

# GeometricAlgebra.jl
using GeometricAlgebra

# --- Tests

# ------ M::Multivector

@testset "dual(M::Multivector, N::Blade)" begin
    @test_skip 1
end

@testset "dual(M::Multivector, N::Pseudoscalar)" begin
    @test_skip 1
end

@testset "dual(M::Multivector, N::Scalar)" begin
    @test_skip 1
end

@testset "dual(M::Multivector, N::One)" begin
    @test_skip 1
end

@testset "dual(M::Multivector, N::Real)" begin
    @test_skip 1
end

@testset "dual(M::Multivector, N::Vector)" begin
    @test_skip 1
end

# --- B::Blade

@testset "dual(B::Blade, C::Blade)" begin
    # --- Preparations

    test_dim = 20

    C = Blade(rand(test_dim, 7))

    # --- Tests

    # ------ dim(B) == dim(C), grade(B) < grade(C)

    for grade_B in 2:5
        B_vectors = basis(C)[:, 1:grade_B] * rand(grade_B, grade_B)
        B = Blade(B_vectors)

        B_dual_C = dual(B, C)

        # --- Check dim, grade, and norm

        @test dim(B_dual_C) == test_dim
        @test grade(B_dual_C) == grade(C) - grade_B
        @test norm(B_dual_C) == norm(B)

        # --- Check that B and dual(B) are orthogonal complements

        @test LinearAlgebra.norm(transpose(basis(B_dual_C)) * basis(B)) <
            10 * eps(Float64)

        # --- Check sign(dual(B, C))

        # Compute sign of I_C formed from basis(B) and basis(dual(B, C))
        sign_Q = sign(LinearAlgebra.det(
            transpose(hcat(basis(B), basis(B_dual_C))) * basis(C)))

        # Compute expected_sign
        expected_sign = sign(B) * sign_Q

        # Account for sign of I_C^{-1} relative to I_C
        if mod(grade(C), 4) >= 2
            expected_sign = -expected_sign
        end

        # Account for reversals required to eliminate B
        if mod(grade(B), 4) >= 2
            expected_sign = -expected_sign
        end

        @test sign(B_dual_C) == expected_sign

        # Check dual(dual(B, C), C) = (-1)^(grade(C) * (grade(C) - 1) / 2) B
        if mod(grade(C), 4) < 2
            @test dual(B_dual_C, C) ≈ B
        else
            @test dual(B_dual_C, C) ≈ -B
        end
    end

    # ------ dim(B) == dim(C), grade(B) == grade(C)

    coefficients = rand(grade(C), grade(C))
    B_vectors = basis(C) * coefficients
    B = Blade(B_vectors)

    relative_orientation =
        sign(LinearAlgebra.det(transpose(basis(B)) * basis(C)))
    expected_result = mod(grade(B), 4) < 2 ?
        Scalar(relative_orientation * volume(B)) :
        Scalar(-relative_orientation * volume(B))

    @test dual(B, C) ≈ expected_result

    # ------ Error cases

    for grade_B in 2:5
        # dim(B) != dim(C)
        B = Blade(rand(test_dim + 1, grade_B))
        @test_throws DimensionMismatch dual(B, C)

        # `B` not contained in `C`
        B = Blade(rand(test_dim, grade_B))
        while LinearAlgebra.norm(reject(basis(B), C)) < sqrt(eps(Float64))
            B = Blade(rand(test_dim, grade_B))
        end
        @test_throws ArgumentError dual(B, C)
    end
end

@testset "dual(B::Blade, C::Pseudoscalar)" begin
    # --- Preparations

    test_dim = 10

    test_value = rand()
    test_value = rand() > 0.5 ? test_value : -test_value

    # --- Tests

    # dim(B) == dim(C)
    for test_grade in 2:5
        B = Blade(rand(test_dim, test_grade))
        C = Pseudoscalar(test_dim, test_value)

        B_dual_C = dual(B, C)
        @test B_dual_C == dual(B)

        # Check dual(dual(B, C), C) = (-1)^(grade(C) * (grade(C) - 1) / 2) B
        if mod(grade(C), 4) < 2
            @test dual(B_dual_C, C) ≈ B
        else
            @test dual(B_dual_C, C) ≈ -B
        end
    end

    # dim(B) != dim(C)
    B = Blade(rand(test_dim, 3))
    C = Pseudoscalar(test_dim + 1, test_value)
    @test_throws DimensionMismatch dual(B, C)
end

@testset "dual(B::Blade, C::Scalar)" begin
    test_dim = 14
    test_value = rand()
    test_value = rand() > 0.5 ? test_value : -test_value

    for test_grade in 5:8
        B = Blade(randn(test_dim, test_grade))
        C = Scalar(test_value)
        @test iszero(dual(B, C))
    end
end

@testset "dual(B::Blade, C::One)" begin
    test_dim = 12
    for test_grade in 5:8
        B = Blade(randn(test_dim, test_grade))
        C = One()
        @test iszero(dual(B, C))
    end
end

@testset "dual(B::Blade, C::Real)" begin
    @test_skip 1
end

@testset "dual(B::Blade, C::Vector)" begin
    @test_skip 1
end

# --- B::Pseudoscalar

@testset "dual(B::Pseudoscalar, C::Blade)" begin
    # --- Preparations

    test_dim = 10

    test_value = rand()
    test_value = rand() > 0.5 ? test_value : -test_value

    # --- Tests

    # dim(B) == dim(C)
    for test_grade in 2:5
        B = Pseudoscalar(test_dim, test_value)
        C = Blade(rand(test_dim, test_grade))
        @test iszero(dual(B, C))
    end

    # dim(B) != dim(C)
    B = Pseudoscalar(test_dim + 1, test_value)
    C = Blade(rand(test_dim, 3))
    @test_throws DimensionMismatch dual(B, C)
end

@testset "dual(B::Pseudoscalar, C::Pseudoscalar)" begin
    # --- Preparations

    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2

    # --- Tests

    # dim(B) == dim(C)
    for test_dim in 10:13
        B = Pseudoscalar(test_dim, test_value_1)
        C = Pseudoscalar(test_dim, test_value_2)
        B_dual_C = dual(B, C)
        @test B_dual_C isa AbstractScalar
        @test B_dual_C == test_value_1

        # Check dual(dual(B, C), C) = (-1)^(grade(C) * (grade(C) - 1) / 2) B
        if mod(grade(C), 4) < 2
            @test dual(B_dual_C, C) == B
        else
            @test dual(B_dual_C, C) == -B
        end
    end

    # dim(B) != dim(C)
    test_dim = 10
    B = Pseudoscalar(test_dim, test_value_1)
    C = Pseudoscalar(test_dim + 1, test_value_2)
    @test_throws DimensionMismatch dual(B, C)
end

@testset "dual(B::Pseudoscalar, C::Scalar)" begin
    # --- Preparations

    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2

    # --- Tests

    for test_dim in 10:13
        B = Pseudoscalar(test_dim, test_value_1)
        C = Scalar(test_value_2)
        @test iszero(dual(B, C))
    end
end

@testset "dual(B::Pseudoscalar, C::One)" begin
    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value

    for test_dim in 10:13
        B = Pseudoscalar(test_dim, test_value)
        C = One()
        @test iszero(dual(B, C))
    end
end

@testset "dual(B::Pseudoscalar, C::Real)" begin
    # --- Preparations

    # Test values
    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2

    for test_dim in 9:12
        B = Pseudoscalar(test_dim, test_value_1)
        C = test_value_2
        @test iszero(dual(B, C))
    end
end

@testset "dual(B::Pseudoscalar, C::Vector)" begin
    @test_skip 1
end

# --- B::Scalar

@testset "dual(B::Scalar, C::Blade)" begin
    # --- Preparations

    test_dim = 15

    test_value = rand()
    test_value = rand() > 0.5 ? test_value : -test_value

    # --- Tests

    for test_grade in 5:8
        B = Scalar(test_value)
        C = Blade(randn(test_dim, test_grade))

        B_dual_C = dual(B, C)
        expected_result = mod(test_grade, 4) < 2 ?
            Blade(C, volume=test_value) :
            Blade(C, volume=-test_value)

        @test B_dual_C isa Blade
        @test B_dual_C == expected_result
    end
end

@testset "dual(B::Scalar, C::Pseudoscalar)" begin
    # --- Preparations

    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2

    # --- Tests

    for test_dim in 5:8
        B = Scalar(test_value_1)
        C = Pseudoscalar(test_dim, test_value_2)

        expected_result = mod(test_dim, 4) < 2 ?
            Pseudoscalar(test_dim, test_value_1) :
            Pseudoscalar(test_dim, -test_value_1)

        @test dual(B, C) == expected_result
    end
end

@testset "dual(B::Scalar, C::Scalar)" begin
    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1
    B = Scalar(test_value_1)

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2
    C = Scalar(test_value_2)

    B_dual_C = dual(B, C)
    @test B_dual_C isa AbstractScalar
    @test B_dual_C == test_value_1
end

@testset "dual(B::Scalar, C::One)" begin
    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value
    B = Scalar(test_value)

    C = One()

    B_dual_C = dual(B, C)
    @test B_dual_C === B
end

@testset "dual(B::Scalar, C::Real)" begin
    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1
    B = Scalar(test_value_1)

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2
    C = test_value_2

    B_dual_C = dual(B, C)
    @test B_dual_C === B
end

@testset "dual(B::Scalar, C::Vector)" begin
    @test_skip 1
end

# --- B::One

@testset "dual(B::One, C::Blade)" begin
    # Preparations
    test_dim = 12

    for test_grade in 5:8
        B = One()
        C = Blade(randn(test_dim, test_grade))

        B_dual_C = dual(B, C)
        expected_result = mod(test_grade, 4) < 2 ?
            Blade(C, volume=1, copy_basis=false) :
            Blade(C, volume=-1, copy_basis=false)

        @test B_dual_C isa Blade
        @test B_dual_C == expected_result
    end
end

@testset "dual(B::One::, C::Pseudoscalar)" begin
    # --- Preparations

    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value

    # --- Tests

    for test_dim in 15:18
        B = One()
        C = Pseudoscalar(test_dim, test_value)

        expected_result = mod(test_dim, 4) < 2 ?
            Pseudoscalar(test_dim, 1) :
            Pseudoscalar(test_dim, -1)

        @test dual(B, C) == expected_result
    end
end

@testset "dual(B::One, C::Scalar)" begin
    B = One()

    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value
    C = Scalar(test_value)

    B_dual_C = dual(B, C)
    @test B_dual_C === B
end

@testset "dual(B::One, C::One)" begin
    B = One()
    C = One()
    B_dual_C = dual(B, C)
    @test B_dual_C === B
end

@testset "dual(B::Scalar, C::Real)" begin
    @test_skip 1
end

@testset "dual(B::Scalar, C::Vector)" begin
    @test_skip 1
end

# --- B::Zero or C::Zero

@testset "dual(B::Zero, C)" begin
    # Note: the case C::Zero is excluded from this set of tests

    # --- Preparations

    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value

    B = Zero()
    expected_error = "The dual of Zero is not well-defined"

    # --- Tests

    # C::One
    C = One()
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Scalar
    C = Scalar(test_value)
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Real
    C = test_value
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Blade
    C = Blade(randn(4, 3))
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Pseudoscalar
    C = Pseudoscalar(5, test_value)
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Multivector
    # C = Multivector(5, test_value)
    @test_skip 1

    # C::Vector
    # C = Vector(5, test_value)
    @test_skip 1
end

@testset "dual(B, C::Zero)" begin
    # --- Preparations

    # Test values
    test_value = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value = rand() > 0.5 ? test_value : -test_value

    C = Zero()
    expected_error = "The dual of anything relative to Zero is not well-defined"

    # --- Tests

    # B::Zero
    B = Zero()
    @test_throws ErrorException(expected_error) dual(B, C)

    # B::One
    B = One()
    @test_throws ErrorException(expected_error) dual(B, C)

    # B::Scalar
    B = Scalar(test_value)
    @test_throws ErrorException(expected_error) dual(B, C)

    # B::Real
    B = test_value
    @test_throws ErrorException(expected_error) dual(B, C)

    # B::Blade
    B = Blade(randn(4, 3))
    @test_throws ErrorException(expected_error) dual(B, C)

    # B::Pseudoscalar
    B = Pseudoscalar(5, test_value)
    @test_throws ErrorException(expected_error) dual(B, C)

    # C::Multivector
    # C = Multivector(5, test_value)
    @test_skip 1

    # C::Vector
    # C = Vector(5, test_value)
    @test_skip 1
end

# ------ B::Real

@testset "dual(B::Real, C::Blade)" begin
    @test_skip 1
end

@testset "dual(B::Real, C::Pseudoscalar)" begin
    # --- Preparations

    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2

    # --- Tests

    for test_dim in 20:23
        B = test_value_1
        C = Pseudoscalar(test_dim, test_value_2)

        B_dual_C = dual(B, C)
        @test B_dual_C isa AbstractScalar
        @test B_dual_C == test_value_1
    end
end

@testset "dual(B::Real, C::Scalar)" begin
    test_value_1 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_1 = rand() > 0.5 ? test_value_1 : -test_value_1
    B = test_value_1

    test_value_2 = rand() + 2  # add 2 to keep value away from 0 and 1
    test_value_2 = rand() > 0.5 ? test_value_2 : -test_value_2
    C = Scalar(test_value_2)

    B_dual_C = dual(B, C)
    @test B_dual_C isa AbstractScalar
    @test B_dual_C == test_value_1
end

@testset "dual(B::Real, C::One)" begin
    @test_skip 1
end

# ------ B::Vector

@testset "dual(B::Vector, C::Blade)" begin
    @test_skip 1
end

@testset "dual(B::Vector, C::Pseudoscalar)" begin
    @test_skip 1
end

@testset "dual(B::Vector, C::Scalar)" begin
    @test_skip 1
end

@testset "dual(B::Vector, C::One)" begin
    @test_skip 1
end
