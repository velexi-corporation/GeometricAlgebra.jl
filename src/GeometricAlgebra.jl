"""
The GeometricAlgebra.jl module defines geometric algebra types and functions.

------------------------------------------------------------------------------
COPYRIGHT/LICENSE. This file is part of the GeometricAlgebra.jl package. It
is subject to the license terms in the LICENSE file found in the top-level
directory of this distribution. No part of the GeometricAlgebra.jl package,
including this file, may be copied, modified, propagated, or distributed
except according to the terms contained in the LICENSE file.
------------------------------------------------------------------------------
"""
module GeometricAlgebra


# --- Submodules

include("abstract_types.jl")

include("blade.jl")
include("blade_comparison_operators.jl")
include("blade_operators.jl")
include("blade_operators_mgs.jl")

include("multivector.jl")
include("multivector_operators.jl")


end  # End of GeometricAlgebra.jl module
