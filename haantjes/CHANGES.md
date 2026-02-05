# Changes from Original Version to v1.0

## Summary of Improvements

This document explains what changed between the version you sent to Giorgio and the new public release version.

---

## High Priority Fixes (CRITICAL)

### 1. **FIXED: Dimension Mismatch Bug**
**Problem:** Original code had global `n := 5` but used 3×3 matrices, causing "Matrix index out of range" errors.

**Solution:** 
```maple
# OLD (broken):
n := 5;  # Global variable
tau := proc(N, i, j, k) ... a = 1..n ...  # Uses n=5 for 3×3 matrix!

# NEW (fixed):
NijenhuisComponent := proc(i, j, k, L_tensor, coords)
    n := LinearAlgebra:-RowDimension(L_tensor);  # Infers from matrix
    ...
end proc;
```

### 2. **ADDED: Input Validation**
**Problem:** No checks for invalid input (non-square matrices, mismatched dimensions).

**Solution:**
```maple
# Checks added to all main functions:
if n <> LinearAlgebra:-ColumnDimension(L_tensor) then
    error "L_tensor must be a square matrix";
end if;
if n <> nops(coords) then
    error "Number of coordinates must match matrix dimension";
end if;
```

### 3. **ADDED: Documentation Header**
**Problem:** No explanation of conventions, formulas, or citations.

**Solution:**
- 100+ line header with:
  - Mathematical formulas (equations 5 and 7 from your paper)
  - Index conventions (L^i_j means row=upper, column=lower)
  - Usage examples
  - Citations to Reyes-Tempesta-Tondo 2022

---

## Medium Priority Improvements

### 4. **ADDED: Verbose Control**
**Problem:** Original code always printed "Computed H[i,j,k]..." for every component (spam for large n).

**Solution:**
```maple
# NEW: Optional verbose parameter (default false)
H := HaantjesTorsion(L, coords, verbose=true);   # Prints progress
H := HaantjesTorsion(L, coords, verbose=false);  # Silent (default)
```

### 5. **IMPROVED: Simplify Control**
**Problem:** Auto-simplification can hang on large symbolic expressions.

**Solution:**
```maple
# NEW: Optional control (default true for backward compatibility)
H := HaantjesTorsion(L, coords, simplify_each=false);  # Faster
H_simplified := map(simplify, H);  # User simplifies afterward if needed
```

### 6. **ADDED: Utility Functions**
**Problem:** No easy way to check if L is Nijenhuis/Haantjes.

**Solution:**
```maple
# NEW functions:
IsNijenhuis(L, coords);   # Returns true/false
IsHaantjes(L, coords);    # Returns true/false
```

### 7. **RENAMED: Main Functions (with backward compatibility)**
**Problem:** Names `NijenhuisTorsionFull` and `HaantjesTorsionFull` are verbose.

**Solution:**
```maple
# NEW preferred names:
NijenhuisTorsion(L, coords);
HaantjesTorsion(L, coords);

# OLD names still work (backward compatible):
NijenhuisTorsionFull := NijenhuisTorsion:
HaantjesTorsionFull := HaantjesTorsion:
```

---

## Code Quality Improvements

### 8. **Consistent Function Signatures**
All main functions now have consistent parameter ordering:
```maple
proc(L_tensor, coords, {simplify_each := true, verbose := false})
```

### 9. **Removed Deprecated Code**
Removed old functions (`tau`, `haan`) that were superseded by the more efficient versions.

### 10. **Better Comments**
Every function now has:
- Purpose description
- Input parameter documentation
- Output format specification
- Example usage

---

## What DIDN'T Change

✓ **Formulas:** Still use equations (5) and (7) from Reyes-Tempesta-Tondo 2022  
✓ **Efficiency:** Still exploit antisymmetry T^i_{jk} = -T^i_{kj}  
✓ **Haantjes computation:** Still precompute L² and L³  
✓ **Batch functions:** `NijenhuisComponentsBatch` and `HaantjesComponentsBatch` unchanged  

---

## Migration Guide for Giorgio

If you're updating code that uses the old version:

### Minimal changes (everything still works):
```maple
# Your old code:
H := HaantjesTorsionFull(L, [u1, u2, u3]);

# Still works! No changes needed.
```

### Recommended updates:
```maple
# OLD:
H := HaantjesTorsionFull(L, [u1, u2, u3]);

# NEW (cleaner):
H := HaantjesTorsion(L, [u1, u2, u3]);

# NEW (with options):
H := HaantjesTorsion(L, [u1, u2, u3], verbose=true, simplify_each=false);
```

### Bug fixes you'll benefit from:
```maple
# OLD: This would fail with "Matrix index out of range"
n := 5;
L := Matrix(3, 3, ...);  # 3×3 matrix
H := HaantjesTorsionFull(L, [u1, u2, u3]);  # ERROR!

# NEW: This just works
L := Matrix(3, 3, ...);
H := HaantjesTorsion(L, [u1, u2, u3]);  # Dimension inferred automatically
```

---

## Testing

All changes were validated against:
1. **Your examples** from the original file (so(3), A_{4,2} cases)
2. **Known results**: 3D harmonic oscillator (diagonal ⟹ Nijenhuis)
3. **Edge cases**: 2×2 generic tensor, large symbolic expressions

---

## Files Included in Package

1. **NijenhuisHaantjesTorsion.mpl** - Main code (production ready)
2. **README.md** - Complete documentation
3. **QUICKSTART.md** - 5-minute guide for users
4. **TestExamples.mpl** - Worked examples
5. **CHANGES.md** - This file

---

## Recommendation for Publication

**Ready to publish on your website** with these additions:

1. Add a one-line description at the top:
   ```
   Maple code for computing Nijenhuis and Haantjes torsions
   Download: NijenhuisHaantjesTorsion.mpl
   Documentation: README.md | Quick Start: QUICKSTART.md
   ```

2. Optional: Create a simple webpage with:
   - Brief description
   - Download links
   - One example (3D harmonic oscillator)
   - Citation to your papers that use this code

3. Consider adding to:
   - Maple Application Center (optional, but increases visibility)
   - Your GitHub/GitLab (version control + issues tracking)

---

## Questions?

Contact Ondřej Kubů at ICMAT.
