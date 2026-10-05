module

public import Mathlib.Topology.Separation.Hausdorff
public import Mathlib.Topology.Connected.Clopen
public import Mathlib.Order.Zorn

/-!
Minimal compact connected subsets containing a prescribed nonempty set.
The intersection argument follows the compact Hausdorff version of Bankston,
Metric Topology: A First Course, Propositions 27.1 and 28.1.
-/

public section

open Set

namespace MinimalSubcontinuum

variable {X : Type*} [topology : TopologicalSpace X] [hausdorff : T2Space X]

/-- A nonempty downward directed family of compact connected sets has connected
intersection in a Hausdorff space. -/
theorem isConnected_iInter_of_directed_compact {ι : Type*} [familyNonempty : Nonempty ι]
    (F : ι → Set X) (hdir : Directed (fun s t => t ⊆ s) F)
    (hcompact : ∀ i, IsCompact (F i)) (hconnected : ∀ i, IsConnected (F i)) :
    IsConnected (⋂ i, F i) := by
  sorry

/-- Every nonempty subset of a compact connected set in a Hausdorff space is
contained in a compact connected subset minimal under inclusion among such
subsets. Minimality compares only subsets of the chosen witness. -/
theorem exists_minimal_subcontinuum {A C : Set X} (hCcompact : IsCompact C)
    (hCconnected : IsConnected C) (hA : A.Nonempty) (hAC : A ⊆ C) :
    ∃ K, IsCompact K ∧ IsConnected K ∧ A ⊆ K ∧ K ⊆ C ∧
      ∀ L, IsCompact L → IsConnected L → A ⊆ L → L ⊆ K → L = K := by
  sorry

/-- Two points of a compact connected set lie in a subcontinuum minimal among
the compact connected subsets containing both points. The points may coincide. -/
theorem exists_minimal_subcontinuum_pair {C : Set X} (hCcompact : IsCompact C)
    (hCconnected : IsConnected C) {x y : X} (hx : x ∈ C) (hy : y ∈ C) :
    ∃ K, IsCompact K ∧ IsConnected K ∧ x ∈ K ∧ y ∈ K ∧ K ⊆ C ∧
      ∀ L, IsCompact L → IsConnected L → x ∈ L → y ∈ L → L ⊆ K → L = K := by
  sorry

end MinimalSubcontinuum
