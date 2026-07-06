# Nijenhuis and Haantjes Torsion Computation in Maple

**Author:** Ondřej Kubů (ICMAT, Madrid)  
**Version:** 1.0 (February 2026)  
**License:** Free for academic and research use

## Overview

This Maple package computes the Nijenhuis and Haantjes torsions of (1,1)-tensor fields. These geometric invariants are fundamental tools in:
- Separation of variables for integrable systems
- Classification of Hamiltonian systems
- Study of Haantjes algebras and symplectic-Haantjes manifolds
- Differential geometry of almost-complex structures

## Mathematical Background

### Nijenhuis Torsion
For a (1,1)-tensor field L on a manifold with coordinates x = (x¹,...,xⁿ), the Nijenhuis torsion is the (1,2)-tensor:

```
(T_L)^i_{jk} = Σ_α [ (∂L^i_k/∂x^α)L^α_j - (∂L^i_j/∂x^α)L^α_k 
                    + (∂L^α_j/∂x^k - ∂L^α_k/∂x^j)L^i_α ]
```

**Properties:**
- Skew-symmetric: T^i_{jk} = -T^i_{kj}
- Vanishes if and only if L has integrable eigendistributions (in the semisimple case)
- Has n²(n-1)/2 independent components

### Haantjes Torsion
The Haantjes torsion is a weaker condition defined by:

```
(H_L)^i_{jk} = L^i_a L^a_b T^b_{jk} + T^i_{ab} L^a_j L^b_k 
              - (T^a_{bk} L^b_j + T^a_{jb} L^b_k) L^i_a
```

**Properties:**
- Also skew-symmetric: H^i_{jk} = -H^i_{kj}
- T_L = 0 ⟹ H_L = 0 (but not conversely)
- Critical for local diagonalizability of L

## Installation

Download the file `NijenhuisHaantjesTorsion.mpl` and copy the functions into your workbook. 

## Usage

### Basic Usage

```maple
# Define a (1,1)-tensor as an n×n matrix
L := Matrix([[x, 0, 0], [0, y, 0], [0, 0, z]]);
coords := [x, y, z];

# Compute Nijenhuis torsion
T := NijenhuisTorsion(L, coords);

# Compute Haantjes torsion  
H := HaantjesTorsion(L, coords);

# Access components
T[1,2,3];  # Component T^1_{23}
```

### Main Functions

#### `NijenhuisTorsion(L_tensor, coords, options)`
Computes the full Nijenhuis torsion tensor.

**Parameters:**
- `L_tensor`: n×n Matrix representing L^i_j
- `coords`: List [x1, ..., xn] of coordinate symbols
- `simplify_each` (optional, default `true`): Simplify each component
- `verbose` (optional, default `false`): Print progress

**Returns:** n×n×n Array with T[i,j,k] = T^i_{jk}

#### `HaantjesTorsion(L_tensor, coords, options)`
Computes the full Haantjes torsion tensor.

**Parameters:** Same as `NijenhuisTorsion`  
**Returns:** n×n×n Array with H[i,j,k] = H^i_{jk}

#### `NijenhuisComponent(i, j, k, L_tensor, coords)`
Computes a single component T^i_{jk}.

#### `IsNijenhuis(L_tensor, coords)`
Returns `true` if all Nijenhuis torsion components vanish.

#### `IsHaantjes(L_tensor, coords)`
Returns `true` if all Haantjes torsion components vanish.

### Options and Performance

For large systems or symbolic expressions:

```maple
# Disable automatic simplification (faster, but messier output)
T := NijenhuisTorsion(L, coords, simplify_each=false);

# Simplify afterward
T_simplified := map(simplify, T);

# Verbose mode to track progress
H := HaantjesTorsion(L, coords, verbose=true);
```

For computing only specific components:

```maple
# Batch computation of selected components
components := [[1,2,3], [2,1,3], [1,1,2]];
results := NijenhuisComponentsBatch(components, L, coords);
results[[1,2,3]];  # Access T^1_{23}
```

## Examples

See `QUICKSTART.md` for worked examples covering the common use cases. The package has been validated on:

1. **3D Harmonic Oscillator** (diagonal tensor, Nijenhuis case)
2. **Generic 2×2 tensor** (non-Nijenhuis)
3. **Lie algebra cases** (so(3), A_{4,2})
4. **Batch computation** of specific components

Quick example:

```maple
# Diagonal tensor with distinct eigenvalues is always Nijenhuis
L := Matrix([[x, 0, 0], [0, y, 0], [0, 0, z]]);
IsNijenhuis(L, [x,y,z]);  # Returns: true
```

## Implementation Notes

- **Index conventions:** L is L^i_j (row index = upper, column index = lower)
- **Formulas:** Based on equations (5) and (7) from [Reyes-Tempesta-Tondo 2022]
- **Efficiency:** Exploits antisymmetry T^i_{jk} = -T^i_{kj} to reduce computations by factor of 2
- **Haantjes computation:** Precomputes L² and L³ once for efficiency
- **Memory:** For n×n tensors, stores n²(n-1)/2 independent components

## Common Pitfalls

1. **Coordinate ordering matters**: `coords` must match the matrix indexing
2. **Simplification can hang**: For large symbolic expressions, use `simplify_each=false`
3. **coords must be a list**: Use `[x, y, z]` not `x, y, z`
4. **Metric tensors**: This code is for (1,1)-tensors, not Riemannian metrics

## Mathematical References

1. D. Reyes, P. Tempesta, G. Tondo, "Classical multiseparable Hamiltonian systems, superintegrability and Haantjes geometry", *Commun. Nonlinear Sci. Numer. Simul.* **104** (2022) 106021.  
   DOI: [10.1016/j.cnsns.2021.106021](https://doi.org/10.1016/j.cnsns.2021.106021)

2. P. Tempesta, G. Tondo, "Higher Haantjes Brackets and Integrability", *Commun. Math. Phys.* **389** (2022) 1647–1671.  
   DOI: [10.1007/s00220-021-04233-5](https://doi.org/10.1007/s00220-021-04233-5)

3. J. Haantjes, "On X_m-forming sets of eigenvectors", *Nederl. Akad. Wetensch. Proc. Ser. A* **58** (1955) 158–162.

4. A. Nijenhuis, "X_{n-1}-forming sets of eigenvectors", *Nederl. Akad. Wetensch. Proc. Ser. A* **54** (1951) 200–212.

## Changelog

**Version 1.0 (February 2026)**
- Initial public release
- Dimension inference from matrix (no global `n` parameter)
- Input validation (square matrix, coordinate count)
- Verbose and simplify_each options
- Utility functions (IsNijenhuis, IsHaantjes)
- Comprehensive documentation and examples

## Contact

For questions, bug reports, or collaboration inquiries:
- **Ondřej Kubů** - ICMAT (Instituto de Ciencias Matemáticas), Madrid
- Website: [ondrejkubu.github.io](https://ondrejkubu.github.io)
- Email: ondrej.kubu@icmat.es

## Acknowledgments

This code was developed as part of research on integrable systems and Haantjes geometry. OK's postdoctoral fellowship is financed by project FOSTERING ICMAT'S STRATEGIC SCIENTIFIC LINES (reference 202450E223) of ICMAT-CSIC, Spain, supported by the Severo Ochoa Programme for Centres of Excellence in R&D (CEX2019-000904-S).

## License

This software is provided free for academic and research use. Commercial use requires permission.

**Disclaimer:** This is research code provided "as is" without warranty. While tested, users should verify results for their specific applications.
