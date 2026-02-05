# Quick Start Guide

## For Collaborators and First-Time Users

### Installation (30 seconds)

1. Copy and paste functions in `NijenhuisHaantjesTorsion.mpl`into your workbook
2. Done!

### Your First Computation (2 minutes)

```maple
# Copy and paste the functions in "NijenhuisHaantjesTorsion.mpl" into your workbook.

# Define your tensor L as an n×n matrix (example: 3×3)
L := Matrix([[f11, f12, f13], 
             [f21, f22, f23], 
             [f31, f32, f33]]);

# Define coordinates
coords := [x, y, z];

# Compute Haantjes torsion
H := HaantjesTorsion(L, coords);

# Check a specific component
H[1,2,3];

# Or check if it vanishes everywhere
IsHaantjes(L, coords);
```

### Key Functions (what you need 95% of the time)

```maple
# Full Nijenhuis torsion
T := NijenhuisTorsion(L, coords);

# Full Haantjes torsion
H := HaantjesTorsion(L, coords);

# Quick check if tensor is Nijenhuis/Haantjes
IsNijenhuis(L, coords);   # Returns true/false
IsHaantjes(L, coords);    # Returns true/false
```

### Common Use Cases

#### Case 1: You have a specific L from your research
```maple
# Example: Stäckel lift with magnetic field
G := Matrix([[alpha, 0], [0, beta]]);
Omega := Matrix([[0, u1 + f12], [-u1 - f12, 0]]);
L := LinearAlgebra:-MatrixInverse(G) . Omega;

H := HaantjesTorsion(L, [u1, u2]);
```

#### Case 2: You want to check if L is Haantjes
```maple
if IsHaantjes(L, coords) then
    print("YES! L is Haantjes");
else
    print("NO - L is not Haantjes");
    # Look at non-zero components:
    H := HaantjesTorsion(L, coords);
end if;
```

#### Case 3: Large system - you only need specific components
```maple
# Instead of computing all n²(n-1)/2 components:
components := [[1,2,3], [2,1,3]];
H_batch := HaantjesComponentsBatch(components, L, coords);
H_batch[[1,2,3]];  # Access result
```

### Performance Tips

**Slow?** Try this:
```maple
# Disable automatic simplification
H := HaantjesTorsion(L, coords, simplify_each=false);

# Simplify only the components you need
simplify(H[1,2,3]);
```

**Want to see progress?**
```maple
H := HaantjesTorsion(L, coords, verbose=true);
# Prints: "Computed H[1,1,2] and H[1,2,1]" etc.
```

### Troubleshooting

**Error: "Matrix index out of range"**
- Check that L is square (n×n)
- Check that coords has exactly n elements
- Example: 3×3 matrix ⟹ 3 coordinates

**Error: "Number of coordinates must match matrix dimension"**
```maple
# WRONG:
L := Matrix(3, 3, ...);
coords := [x, y];  # Only 2 coords for 3×3 matrix!

# RIGHT:
coords := [x, y, z];  # 3 coords for 3×3 matrix
```

**Computation taking forever?**
```maple
# For symbolic L with many parameters, simplification is slow
# Solution: turn off auto-simplification
H := HaantjesTorsion(L, coords, simplify_each=false);
```

### Interpreting Results

**All components zero?**
- If `IsNijenhuis(L, coords) = true`: L has integrable eigendistributions
- If `IsHaantjes(L, coords) = true`: L is locally diagonalizable

**Some components non-zero?**
- L is NOT Nijenhuis/Haantjes
- Examine which components are non-zero to understand the obstruction

### Need Help?

1. Read the full README.md for details
2. Contact: Ondrej.kubu@icmat.es

**That's it! You're ready to compute torsions.**

For the full documentation, see README.md.
