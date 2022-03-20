"""
Unit tests for isapprox(x, y) and !isapprox(x, y)

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

# --- File inclusions

# Test utilities
include("test_utils.jl")

# --- Tests

# ------ B::Pseudoscalar

@testset "isapprox(B::Pseudoscalar, C::Pseudoscalar)" begin
    # Preparations
    dim = 10

    test_value = get_random_value(1)  # add 1 to keep value away from 0

    # dim(B) == dim(C), value(B) == value(C)
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            B = Pseudoscalar(dim, precision_type1(test_value))
            C = Pseudoscalar(dim, precision_type2(test_value))
            @test B ≈ C
        end
    end

    # dim(B) != dim(C), value(B) == value(C)
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            B = Pseudoscalar(dim, precision_type1(test_value))
            C = Pseudoscalar(dim + 1, precision_type2(test_value))
            @test B ≉ C
        end
    end

    # dim(B) == dim(C), value(B) != value(C)
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            B = Pseudoscalar(dim, precision_type1(test_value))
            C = Pseudoscalar(dim, precision_type2(test_value) + 1)
            @test B ≉ C
        end
    end
end

@testset "isapprox(B::Pseudoscalar, C::Scalar)" begin
    test_dim = 10
    test_value = 5

    for precision_type in subtypes(AbstractFloat)
        B = Pseudoscalar{precision_type}(test_dim, test_value)
        C = Scalar{precision_type}(test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Pseudoscalar, C::One)" begin
    test_dim = 10
    test_value = 5

    for precision_type in subtypes(AbstractFloat)
        B = Pseudoscalar{precision_type}(test_dim, test_value)
        C = One{precision_type}()
        @test B ≉ C
    end
end

@testset "isapprox(B::Pseudoscalar, C::Zero)" begin
    test_dim = 10
    test_value = 5

    for precision_type in subtypes(AbstractFloat)
        B = Pseudoscalar{precision_type}(test_dim, test_value)
        C = Zero{precision_type}()
        @test B ≉ C
    end
end

@testset "isapprox(B::Pseudoscalar, C::Real)" begin
    test_dim = 10
    test_value = 5

    for precision_type in subtypes(AbstractFloat)
        B = Pseudoscalar{precision_type}(test_dim, test_value)
        C = precision_type(test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Pseudoscalar, C::Vector)" begin
    test_value = 5

    test_dim_1 = 3
    test_vector_1 = [3; 4; 1]

    test_dim_2 = 1
    test_vector_2 = [test_value]

    for precision_type1 in subtypes(AbstractFloat)
        # B ≉ C
        B = Pseudoscalar{precision_type1}(test_dim_1, test_value)
        C = Vector{precision_type1}(test_vector_1)
        @test B ≉ C

        # B ≈ C
        B = Pseudoscalar{precision_type1}(test_dim_2, test_value)
        for precision_type2 in subtypes(AbstractFloat)
            C = Vector{precision_type2}(test_vector_2)
            @test B ≈ C
        end
    end
end

# ------ B::Scalar

@testset "isapprox(B::Scalar, C::Pseudoscalar)" begin
    test_value = 5
    test_dim = 10
    for precision_type in subtypes(AbstractFloat)
        B = Scalar{precision_type}(test_value)
        C = Pseudoscalar{precision_type}(test_dim, test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Scalar, C::Scalar)" begin
    # Preparations

    test_value = get_random_value(2)  # add 2 to keep value away from 0 and 1

    # B::Scalar, C::Scalar
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            # B ≈ C
            B = Scalar(precision_type1(test_value))
            C = Scalar(precision_type2(test_value))
            @test B ≈ C

            # B ≉ C
            B = Scalar(precision_type1(test_value))
            C = Scalar(precision_type2(test_value + 1))
            @test B ≉ C
        end
    end
end

@testset "isapprox(B::Scalar, C::One)" begin
    for precision_type in subtypes(AbstractFloat)
        C = One{precision_type}()

        # B ≈ C
        test_value = 1 - (√eps(precision_type)) / 2
        B = Scalar{precision_type}(test_value)
        @test B ≈ C

        # B ≉ C
        test_value = 5
        B = Scalar{precision_type}(test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Scalar, C::Zero)" begin
    test_value = 5
    for precision_type in subtypes(AbstractFloat)
        B = Scalar{precision_type}(test_value)
        C = Zero{precision_type}()
        @test B ≉ C

        # B ≈ C is not being tested as isapprox between a Scalar and a
        # Zero can never return true with the default atol and rtol value
    end
end

@testset "isapprox(B::Scalar, C::Real)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        B = Scalar{precision_type1}(test_value)

        # B ≉ C
        C = precision_type1(test_value + 1)
        @test B ≉ C

        # B ≈ C
        for precision_type2 in subtypes(AbstractFloat)
            C = precision_type2(test_value)
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Scalar, C::Vector)" begin
    test_value = 5
    test_vector = [3; 4; 1]
    for precision_type in subtypes(AbstractFloat)
        B = Scalar{precision_type}(test_value)
        C = Vector{precision_type}(test_vector)
        @test B ≉ C
    end
end

# ------ B::One

@testset "isapprox(B::One, C::Pseudoscalar)" begin
    test_dim = 10
    test_value = 5
    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        C = Pseudoscalar{precision_type}(test_dim, test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::One, C::Scalar)" begin
    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()

        # B ≈ C
        test_value = 1 - (√eps(precision_type)) / 2
        C = Scalar{precision_type}(test_value)
        @test B ≈ C

        # B ≉ C
        test_value = 5
        C = Scalar{precision_type}(test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::One, C::One)" begin
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            B = One{precision_type1}()
            C = One{precision_type2}()
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::One, C::Zero)" begin
    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        C = Zero{precision_type}()
        @test B ≉ C
    end
end

@testset "isapprox(B::One, C::Real)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        B = One{precision_type1}()

        # B ≉ C
        C = precision_type1(test_value)
        @test B ≉ C

        # B ≈ C
        for precision_type2 in subtypes(AbstractFloat)
            C = precision_type2(1)
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::One, C::Vector)" begin
    test_vector = [3; 4; 1]
    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        C = Vector{precision_type}(test_vector)
        @test B ≉ C
    end
end

# ------ B::Zero

@testset "isapprox(B::Zero, C::Pseudoscalar)" begin
    test_dim = 10
    test_value = 5
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Pseudoscalar{precision_type}(test_dim, test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Zero, C::Scalar)" begin
    test_value = 5
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Scalar{precision_type}(test_value)
        @test B ≉ C
        
        # B ≈ C is not being tested as isapprox between a Zero and a
        # Scalar can never return true with the default atol and rtol value
    end
end

@testset "isapprox(B::Zero, C::One)" begin
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = One{precision_type}()
        @test B ≉ C
    end
end

@testset "isapprox(B::Zero, C::Zero)" begin
    for precision_type1 in subtypes(AbstractFloat)
        for precision_type2 in subtypes(AbstractFloat)
            B = Zero{precision_type1}()
            C = Zero{precision_type2}()
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Zero, C::Real)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        B = Zero{precision_type1}()

        # B ≉ C
        C = precision_type1(test_value)
        @test B ≉ C

        # B ≈ C
        for precision_type2 in subtypes(AbstractFloat)
            C = precision_type2(0)
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Zero, C::Vector)" begin
    # B ≉ C
    test_vector = [3; 4; 1]
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Vector{precision_type}(test_vector)
        @test B ≉ C
    end

    test_vector = [0.001; 0.002; 0.003]
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Vector{precision_type}(test_vector)
        @test !isapprox(B, C, atol=0.001)
    end

    # B ≈ C
    test_vector = [0; 0; 0]
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Vector{precision_type}(test_vector)
        @test B ≈ C
    end 

    test_vector = [0.001; 0.002; 0.003]
    for precision_type in subtypes(AbstractFloat)
        B = Zero{precision_type}()
        C = Vector{precision_type}(test_vector)
        @test isapprox(B, C, atol=0.01)
    end
end

# ------ B::Real

@testset "isapprox(B::Real, C::Pseudoscalar)" begin
    test_value = 5
    test_dim = 10
    for precision_type in subtypes(AbstractFloat)
        B = precision_type(test_value)
        C = Pseudoscalar{precision_type}(test_dim, test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Real, C::Scalar)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        B = precision_type1(test_value)

        # B ≉ C
        C = Scalar{precision_type1}(test_value + 1)
        @test B ≉ C

        # B ≈ C
        for precision_type2 in subtypes(AbstractFloat)
            C = Scalar{precision_type2}(test_value)
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Real, C::One)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        # B ≉ C
        B = precision_type1(test_value)
        C = One{precision_type1}()
        @test B ≉ C

        # B ≈ C
        B = precision_type1(1)
        for precision_type2 in subtypes(AbstractFloat)
            C = One{precision_type2}()
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Real, C::Zero)" begin
    test_value = 5
    for precision_type1 in subtypes(AbstractFloat)
        # B ≉ C
        B = precision_type1(test_value)
        C = Zero{precision_type1}()
        @test B ≉ C

        # B ≈ C
        B = precision_type1(0)
        for precision_type2 in subtypes(AbstractFloat)
            C = Zero{precision_type2}()
            @test B ≈ C
        end
    end
end

# ------ B::Vector

@testset "isapprox(B::Vector, C::Pseudoscalar)" begin
    test_value = 5

    test_dim_1 = 3
    test_vector_1 = [3; 4; 1]

    test_dim_2 = 1
    test_vector_2 = [test_value]

    for precision_type1 in subtypes(AbstractFloat)
        # B ≉ C
        B = Vector{precision_type1}(test_vector_1)
        C = Pseudoscalar{precision_type1}(test_dim_1, test_value)
        @test B ≉ C

        # B ≈ C
        B = Vector{precision_type1}(test_vector_2)
        for precision_type2 in subtypes(AbstractFloat)
            C = Pseudoscalar{precision_type2}(test_dim_2, test_value)
            @test B ≈ C
        end
    end
end

@testset "isapprox(B::Vector, C::Scalar)" begin
    test_vector = [3; 4; 1]
    test_value = 5
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = Scalar{precision_type}(test_value)
        @test B ≉ C
    end
end

@testset "isapprox(B::Vector, C::One)" begin
    test_vector = [3; 4; 1]
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = One{precision_type}()
        @test B ≉ C
    end
end

@testset "isapprox(B::Vector, C::Zero)" begin
    # B ≉ C
    test_vector = [3; 4; 1]
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = Zero{precision_type}()
        @test B ≉ C
    end

    test_vector = [0.001; 0.002; 0.003]
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = Zero{precision_type}()
        @test !isapprox(B, C, atol=0.001)
    end

    # B ≈ C
    test_vector = [0; 0; 0]
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = Zero{precision_type}()
        @test B ≈ C
    end 

    test_vector = [0.001; 0.002; 0.003]
    for precision_type in subtypes(AbstractFloat)
        B = Vector{precision_type}(test_vector)
        C = Zero{precision_type}()
        @test isapprox(B, C, atol=0.01)
    end
end
