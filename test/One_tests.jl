"""
Unit tests for the One type.

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


# --- Tests

@testset "One: constructor tests" begin
    # --- Inner constructor

    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        @test B isa One{precision_type}
        @test B === One{precision_type}()
    end

    # --- Outer constructor

    B = One()
    @test B isa One{Float64}
end

@testset "one()" begin
    # one(B::AbstractMultivector)
    for precision_type in subtypes(AbstractFloat)
        # --- B::AbstractScalar

        # B::Zero
        B = one(Zero{precision_type}())
        @test B isa One{precision_type}

        # B::One
        B = one(One{precision_type}())
        @test B isa One{precision_type}

        # B::Scalar
        B = one(Scalar{precision_type}(5))
        @test B isa One{precision_type}

        # --- B::AbstractBlade

        # B::Blade
        B = one(Blade{precision_type}([1 2 3]))
        @test B isa One{precision_type}

        # B::Pseudoscalar
        B = one(Pseudoscalar{precision_type}(10, 5))
        @test B isa One{precision_type}

        # --- B::AbstractMultivector

        # B::Multivector
        B = one(Multivector{precision_type}([Scalar(3)]))
        @test B isa One{precision_type}
    end

    # one(::Type{<:AbstractMultivector{T}})
    for precision_type in subtypes(AbstractFloat)
        # --- Type{<:AbstractScalar{T}}

        B = one(AbstractScalar{precision_type})
        @test B isa One{precision_type}

        B = one(Zero{precision_type})
        @test B isa One{precision_type}

        B = one(One{precision_type})
        @test B isa One{precision_type}

        B = one(Scalar{precision_type})
        @test B isa One{precision_type}

        # --- Type{<:AbstractBlade{T}}

        B = one(AbstractBlade{precision_type})
        @test B isa One{precision_type}

        B = one(Blade{precision_type})
        @test B isa One{precision_type}

        B = one(Pseudoscalar{precision_type})
        @test B isa One{precision_type}

        # --- Type{<:AbstractMultivector{T}}

        B = one(AbstractMultivector{precision_type})
        @test B isa One{precision_type}

        B = one(Multivector{precision_type})
        @test B isa One{precision_type}
    end
end

@testset "One: AbstractMultivector interface functions" begin
    # --- Preparations

    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        @test dim(B) == 0
        @test grades(B) == [0]
        @test blades(B) == [B]
        @test B[0] == [B]
        @test B[1] == []
        @test norm(B) == 1
        @test norm(B) isa precision_type
    end
end

@testset "One: AbstractBlade interface functions" begin
    # --- Preparations

    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        @test grade(B) == 0
        @test basis(B) == 1
        @test volume(B) == 1
        @test volume(B) isa precision_type
        @test sign(B) == 1
    end
end

@testset "One: AbstractScalar interface functions" begin
    # --- Preparations

    for precision_type in subtypes(AbstractFloat)
        B = One{precision_type}()
        @test value(B) == 1
        @test value(B) isa precision_type
    end
end
