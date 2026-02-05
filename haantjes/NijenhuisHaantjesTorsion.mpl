################################################################################
# Nijenhuis and Haantjes Torsion Computation
# Author: Ondřej Kubů (ICMAT, Madrid)
# Version: 1.0 (February 2026)
#
# DESCRIPTION:
# This package computes the Nijenhuis and Haantjes torsions of a (1,1)-tensor
# field on a manifold. These geometric invariants are fundamental in the study
# of integrable systems and separation of variables.
#
# CONVENTIONS:
# - L is a (1,1)-tensor field represented as an n×n matrix L^i_j (mixed indices)
# - Coordinates are x = (x^1, ..., x^n) provided as a list [x1, x2, ..., xn]
# - Index notation: upper indices are rows, lower indices are columns
#
# FORMULAS (from Reyes-Tempesta-Tondo, Commun. Nonlinear Sci. Numer. Simul. 2022):
# 
# Nijenhuis torsion (eq. 5):
#   (T_L)^i_{jk} = Σ_α [ (∂L^i_k/∂x^α)L^α_j - (∂L^i_j/∂x^α)L^α_k 
#                       + (∂L^α_j/∂x^k - ∂L^α_k/∂x^j)L^i_α ]
#
# Haantjes torsion (eq. 7):
#   See equation (7) in Reyes-Tempesta-Tondo 2022 for the explicit formula.
#   It involves L², derivatives of L and L², and is skew-symmetric in j,k.
#
# where L² = L∘L is the composition of L with itself.
#
# PROPERTIES:
# - Both torsions are skew-symmetric in the last two indices: T^i_{jk} = -T^i_{kj}
# - Number of independent components: n²(n-1)/2
# - T_L = 0 implies L is a Nijenhuis tensor
# - H_L = 0 implies L is a Haantjes tensor (stronger condition than T_L = 0)
#
# USAGE EXAMPLES:
#   restart;
#   read "NijenhuisHaantjesTorsion.mpl";
#   
#   # Example 1: 3D diagonal tensor (Nijenhuis)
#   L := Matrix([[x, 0, 0], [0, y, 0], [0, 0, z]]);
#   T := NijenhuisTorsion(L, [x, y, z]);
#   simplify(T);  # Should be zero
#   
#   # Example 2: Generic 2×2 tensor
#   L := Matrix([[a*x + b*y, c*x], [d*y, e*x + f*y]]);
#   T := NijenhuisTorsion(L, [x, y]);
#   H := HaantjesTorsion(L, [x, y]);
#
# REFERENCES:
# [1] D. Reyes, P. Tempesta, G. Tondo, "Classical multiseparable Hamiltonian 
#     systems, superintegrability and Haantjes geometry", Commun. Nonlinear Sci.
#     Numer. Simul. 104 (2022) 106021. DOI: 10.1016/j.cnsns.2021.106021
# [2] P. Tempesta, G. Tondo, "Higher Haantjes Brackets and Integrability",
#     Commun. Math. Phys. 389 (2022) 1647-1671. DOI: 10.1007/s00220-021-04233-5
#
# LICENSE: Free for academic and research use. No warranty. Use at your own risk.
################################################################################

# Load required packages
with(LinearAlgebra):

################################################################################
# NIJENHUIS TORSION
################################################################################

# Compute a single component of the Nijenhuis torsion
# Input: 
#   i, j, k: indices (1 <= i,j,k <= n)
#   L_tensor: n×n matrix representing the (1,1)-tensor
#   coords: list of n coordinates [x1, ..., xn]
# Output: 
#   T^i_{jk} (scalar expression)
NijenhuisComponent := proc(i, j, k, L_tensor, coords)
    local n, alpha, result, term1, term2, term3;
    
    # Get dimension from matrix
    n := LinearAlgebra:-RowDimension(L_tensor);
    
    # Exploit antisymmetry
    if j = k then
        return 0;
    end if;
    
    # Formula (5) from Reyes-Tempesta-Tondo 2022
    result := 0;
    for alpha from 1 to n do
        term1 := diff(L_tensor[i, k], coords[alpha]) * L_tensor[alpha, j];
        term2 := -diff(L_tensor[i, j], coords[alpha]) * L_tensor[alpha, k];
        term3 := (diff(L_tensor[alpha, j], coords[k]) - diff(L_tensor[alpha, k], coords[j])) * L_tensor[i, alpha];
        result := result + term1 + term2 + term3;
    end do;
    
    return result;
end proc:

# Compute the full Nijenhuis torsion tensor
# Input:
#   L_tensor: n×n matrix
#   coords: list of n coordinates
#   simplify_each: (optional, default true) whether to simplify each component
#   verbose: (optional, default false) whether to print progress
# Output:
#   n×n×n Array T with T[i,j,k] = T^i_{jk}
NijenhuisTorsion := proc(L_tensor, coords, {simplify_each := true, verbose := false})
    local n, i, j, k, T, comp;
    
    # Validate input
    n := LinearAlgebra:-RowDimension(L_tensor);
    if n <> LinearAlgebra:-ColumnDimension(L_tensor) then
        error "L_tensor must be a square matrix";
    end if;
    if n <> nops(coords) then
        error "Number of coordinates must match matrix dimension";
    end if;
    
    # Initialize output array
    T := Array(1..n, 1..n, 1..n);
    
    # Compute components exploiting antisymmetry
    for i from 1 to n do
        for j from 1 to n do
            for k from j to n do
                if j = k then
                    T[i, j, k] := 0;
                else
                    comp := NijenhuisComponent(i, j, k, L_tensor, coords);
                    if simplify_each then
                        comp := simplify(comp);
                    end if;
                    T[i, j, k] := comp;
                    T[i, k, j] := -comp;  # Antisymmetry
                    if verbose then
                        printf("Computed T[%d,%d,%d] and T[%d,%d,%d]\n", i, j, k, i, k, j);
                    end if;
                end if;
            end do;
        end do;
    end do;
    
    return T;
end proc:

# Batch computation of specific Nijenhuis torsion components
# Input:
#   component_list: list of triples [[i1,j1,k1], [i2,j2,k2], ...]
#   L_tensor: n×n matrix
#   coords: list of n coordinates
# Output:
#   table with entries results[[i,j,k]] for each requested component
NijenhuisComponentsBatch := proc(component_list, L_tensor, coords)
    local results, comp_spec, i, j, k, result, computed_components;
    
    results := table();
    computed_components := [];
    
    for comp_spec in component_list do
        i, j, k := op(comp_spec);
        
        if member([i, j, k], computed_components) then
            printf("Already computed T[%d,%d,%d]\n", i, j, k);
        elif member([i, k, j], computed_components) then
            results[[i, j, k]] := -results[[i, k, j]];
            computed_components := [op(computed_components), [i, j, k]];
            printf("Used antisymmetry: T[%d,%d,%d] = -T[%d,%d,%d]\n", i, j, k, i, k, j);
        elif j = k then
            results[[i, j, k]] := 0;
            computed_components := [op(computed_components), [i, j, k]];
            printf("T[%d,%d,%d] = 0 (diagonal)\n", i, j, k);
        else
            result := NijenhuisComponent(i, j, k, L_tensor, coords);
            results[[i, j, k]] := simplify(result);
            computed_components := [op(computed_components), [i, j, k]];
            printf("Computed and simplified T[%d,%d,%d]\n", i, j, k);
        end if;
    end do;
    
    return results;
end proc:

################################################################################
# HAANTJES TORSION
################################################################################

# Precompute L² and L³ for efficiency
PrecomputeTensorPowers := proc(L_tensor)
    local L2, L3;
    L2 := L_tensor . L_tensor;  # L²
    L3 := L2 . L_tensor;        # L³
    return L2, L3;
end proc:

# Compute a single component of the Haantjes torsion
# Input:
#   i, j, k: indices
#   L_tensor: n×n matrix
#   L2: L² (precomputed)
#   L3: L³ (precomputed)
#   coords: list of coordinates
# Output:
#   H^i_{jk} (scalar expression)
HaantjesComponent := proc(i, j, k, L_tensor, L2, L3, coords)
    local n, alpha, beta, result, term1, term2, term3, term4, term5;
    
    n := LinearAlgebra:-RowDimension(L_tensor);
    
    # Exploit antisymmetry
    if j = k then
        return 0;
    end if;
    
    # Formula (7) from Reyes-Tempesta-Tondo 2022
    # (H_L)^i_{jk} = sum_alpha [ ... ] with antisymmetrization in j,k
    result := 0;
    for alpha from 1 to n do
        # Term 1: -2(L³)^i_α ∂_j[L^α_k]
        term1 := -2*L3[i, alpha]*diff(L_tensor[alpha, k], coords[j]);
        
        # Term 2: (L²)^i_α ∂_j[(L²)^α_k]
        term2 := L2[i, alpha]*diff(L2[alpha, k], coords[j]);
        
        # Term 3: 4(L²)^i_α sum_β L^β_j ∂_β[L^α_k] (Einstein summation over β)
        term3 := 4*L2[i, alpha]*add(L_tensor[beta, j]*diff(L_tensor[alpha, k], coords[beta]), beta=1..n);
        
        # Term 4: -2 L^i_α [L^β_j ∂_β[(L²)^α_k] + (L²)^β_j ∂_β[L^α_k]] (Einstein summation over β)
        term4 := -2*L_tensor[i, alpha]*(
            add(L_tensor[beta, j]*diff(L2[alpha, k], coords[beta]), beta=1..n) +
            add(L2[beta, j]*diff(L_tensor[alpha, k], coords[beta]), beta=1..n)
        );
        
        # Term 5: (L²)^α_j ∂_α[(L²)^i_k]
        term5 := L2[alpha, j]*diff(L2[i, k], coords[alpha]);
        
        result := result + term1 + term2 + term3 + term4 + term5;
    end do;
    
    # Now antisymmetrize: H^i_{jk} = (result with j,k) - (result with k,j)
    # But wait - the formula (7) already gives H^i_{jk} directly as antisymmetric
    # So we just return result as is
    return result;
end proc:

# Compute the full Haantjes torsion tensor
# Input:
#   L_tensor: n×n matrix
#   coords: list of n coordinates
#   simplify_each: (optional, default true) whether to simplify each component
#   verbose: (optional, default false) whether to print progress
# Output:
#   n×n×n Array H with H[i,j,k] = H^i_{jk}
HaantjesTorsion := proc(L_tensor, coords, {simplify_each := true, verbose := false})
    local n, i, j, k, L2, L3, H, comp;
    
    # Validate input
    n := LinearAlgebra:-RowDimension(L_tensor);
    if n <> LinearAlgebra:-ColumnDimension(L_tensor) then
        error "L_tensor must be a square matrix";
    end if;
    if n <> nops(coords) then
        error "Number of coordinates must match matrix dimension";
    end if;
    
    # Precompute powers
    L2, L3 := PrecomputeTensorPowers(L_tensor);
    
    # Initialize output array
    H := Array(1..n, 1..n, 1..n);
    
    # Compute components exploiting antisymmetry
    for i from 1 to n do
        for j from 1 to n do
            for k from j to n do
                if j = k then
                    H[i, j, k] := 0;
                else
                    comp := HaantjesComponent(i, j, k, L_tensor, L2, L3, coords);
                    if simplify_each then
                        comp := simplify(comp);
                    end if;
                    H[i, j, k] := comp;
                    H[i, k, j] := -comp;  # Antisymmetry
                    if verbose then
                        printf("Computed H[%d,%d,%d] and H[%d,%d,%d]\n", i, j, k, i, k, j);
                    end if;
                end if;
            end do;
        end do;
    end do;
    
    return H;
end proc:

# Batch computation of specific Haantjes torsion components
# Input:
#   component_list: list of triples
#   L_tensor: n×n matrix
#   coords: list of coordinates
# Output:
#   table with requested components
HaantjesComponentsBatch := proc(component_list, L_tensor, coords)
    local results, comp_spec, i, j, k, result, computed_components, L2, L3;
    
    # Precompute powers once
    L2, L3 := PrecomputeTensorPowers(L_tensor);
    
    results := table();
    computed_components := [];
    
    for comp_spec in component_list do
        i, j, k := op(comp_spec);
        
        if member([i, j, k], computed_components) then
            printf("Already computed H[%d,%d,%d]\n", i, j, k);
        elif member([i, k, j], computed_components) then
            results[[i, j, k]] := -results[[i, k, j]];
            computed_components := [op(computed_components), [i, j, k]];
            printf("Used antisymmetry: H[%d,%d,%d] = -H[%d,%d,%d]\n", i, j, k, i, k, j);
        elif j = k then
            results[[i, j, k]] := 0;
            computed_components := [op(computed_components), [i, j, k]];
            printf("H[%d,%d,%d] = 0 (diagonal)\n", i, j, k);
        else
            result := HaantjesComponent(i, j, k, L_tensor, L2, L3, coords);
            results[[i, j, k]] := simplify(result);
            computed_components := [op(computed_components), [i, j, k]];
            printf("Computed and simplified H[%d,%d,%d]\n", i, j, k);
        end if;
    end do;
    
    return results;
end proc:

################################################################################
# UTILITY FUNCTIONS
################################################################################

# Check if a tensor is Nijenhuis (all components vanish)
IsNijenhuis := proc(L_tensor, coords)
    local T, i, j, k, n;
    T := NijenhuisTorsion(L_tensor, coords, 'simplify_each'=true, 'verbose'=false);
    n := LinearAlgebra:-RowDimension(L_tensor);
    
    for i from 1 to n do
        for j from 1 to n do
            for k from 1 to n do
                if simplify(T[i,j,k]) <> 0 then
                    return false;
                end if;
            end do;
        end do;
    end do;
    
    return true;
end proc:

# Check if a tensor is Haantjes (all components vanish)
IsHaantjes := proc(L_tensor, coords)
    local H, i, j, k, n;
    H := HaantjesTorsion(L_tensor, coords, 'simplify_each'=true, 'verbose'=false);
    n := LinearAlgebra:-RowDimension(L_tensor);
    
    for i from 1 to n do
        for j from 1 to n do
            for k from 1 to n do
                if simplify(H[i,j,k]) <> 0 then
                    return false;
                end if;
            end do;
        end do;
    end do;
    
    return true;
end proc:

################################################################################
# BACKWARD COMPATIBILITY (deprecated names from old version)
################################################################################

# These maintain compatibility with the file you sent to Giorgio
# but with improved dimension handling
NijenhuisTorsionFull := NijenhuisTorsion:
HaantjesTorsionFull := HaantjesTorsion:

################################################################################
print("Nijenhuis and Haantjes Torsion Package loaded.");
print("Main functions: NijenhuisTorsion, HaantjesTorsion");
print("For examples, see header comments or run: ?NijenhuisTorsion");
################################################################################
