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
  classical
  let S := ⋂ i, F i
  have hclosed : IsClosed S := isClosed_iInter fun i => (hcompact i).isClosed
  let i₀ : ι := familyNonempty.some
  have hScompact : IsCompact S :=
    (hcompact i₀).of_isClosed_subset hclosed (iInter_subset F i₀)
  refine ⟨IsCompact.nonempty_iInter_of_directed_nonempty_isCompact_isClosed F hdir
    (fun i => (hconnected i).nonempty) hcompact (fun i => (hcompact i).isClosed), ?_⟩
  apply (isPreconnected_iff_subset_of_fully_disjoint_closed hclosed).2
  intro u v hu hv hcover hdisjoint
  have hcu : IsCompact (S ∩ u) := hScompact.inter_right hu
  have hcv : IsCompact (S ∩ v) := hScompact.inter_right hv
  obtain ⟨U, V, hU, hV, huU, hvV, hUV⟩ :=
    SeparatedNhds.of_isCompact_isCompact hcu hcv
      (hdisjoint.mono inter_subset_right inter_subset_right)
  have hSU : S ⊆ U ∪ V := by
    intro x hx
    rcases hcover hx with hxu | hxv
    · exact Or.inl (huU ⟨hx, hxu⟩)
    · exact Or.inr (hvV ⟨hx, hxv⟩)
  have hbadcompact : IsCompact (F i₀ ∩ (U ∪ V)ᶜ) :=
    (hcompact i₀).inter_right (hU.union hV).isClosed_compl
  have hbaddisjoint : Disjoint (F i₀ ∩ (U ∪ V)ᶜ) (⋂ i, F i) := by
    apply disjoint_left.2
    intro x hx hxs
    exact hx.2 (hSU hxs)
  obtain ⟨j, hj⟩ := hbadcompact.elim_directed_family_closed F
    (fun i => (hcompact i).isClosed) hbaddisjoint hdir
  obtain ⟨k, hk₀, hkj⟩ := hdir i₀ j
  have hkcover : F k ⊆ U ∪ V := by
    intro x hx
    by_contra hout
    exact disjoint_left.1 hj ⟨hk₀ hx, hout⟩ (hkj hx)
  have hkdisjoint : F k ∩ (U ∩ V) = ∅ := by
    rw [hUV.inter_eq, inter_empty]
  rcases isPreconnected_iff_subset_of_disjoint.1 (hconnected k).isPreconnected
      U V hU hV hkcover hkdisjoint with hkU | hkV
  · left
    intro x hx
    rcases hcover hx with hxu | hxv
    · exact hxu
    · exact False.elim (disjoint_left.1 hUV (hkU (iInter_subset F k hx))
        (hvV ⟨hx, hxv⟩))
  · right
    intro x hx
    rcases hcover hx with hxu | hxv
    · exact False.elim (disjoint_left.1 hUV (huU ⟨hx, hxu⟩)
        (hkV (iInter_subset F k hx)))
    · exact hxv

/-- Every nonempty subset of a compact connected set in a Hausdorff space is
contained in a compact connected subset minimal under inclusion among such
subsets. Minimality compares only subsets of the chosen witness. -/
theorem exists_minimal_subcontinuum {A C : Set X} (hCcompact : IsCompact C)
    (hCconnected : IsConnected C) (hA : A.Nonempty) (hAC : A ⊆ C) :
    ∃ K, IsCompact K ∧ IsConnected K ∧ A ⊆ K ∧ K ⊆ C ∧
      ∀ L, IsCompact L → IsConnected L → A ⊆ L → L ⊆ K → L = K := by
  classical
  let candidates : Set (Set X) :=
    {K | IsCompact K ∧ IsConnected K ∧ A ⊆ K ∧ K ⊆ C}
  have hchain : ∀ c ⊆ candidates, IsChain (· ⊆ ·) c → c.Nonempty →
      ∃ lb ∈ candidates, ∀ s ∈ c, lb ⊆ s := by
    intro c hc htotal hnonempty
    let : Nonempty c := hnonempty.to_subtype
    let F : c → Set X := fun i => i.1
    have hdir : Directed (· ⊇ ·) F := by
      intro i j
      rcases htotal.total i.2 j.2 with hij | hji
      · exact ⟨i, Subset.rfl, hij⟩
      · exact ⟨j, hji, Subset.rfl⟩
    have hcompact : ∀ i, IsCompact (F i) := fun i => (hc i.2).1
    have hconnected : ∀ i, IsConnected (F i) := fun i =>
      ⟨hA.mono (hc i.2).2.2.1, (hc i.2).2.1.isPreconnected⟩
    have hAinter : A ⊆ ⋂ i, F i := by
      intro x hx
      exact mem_iInter.2 fun i => (hc i.2).2.2.1 hx
    let i₀ : c := Classical.arbitrary c
    have hinterC : (⋂ i, F i) ⊆ C :=
      (iInter_subset F i₀).trans (hc i₀.2).2.2.2
    refine ⟨⋂ i, F i, ⟨?_, ?_, hAinter, hinterC⟩, ?_⟩
    · exact hCcompact.of_isClosed_subset
        (isClosed_iInter fun i => (hcompact i).isClosed) hinterC
    · exact isConnected_iInter_of_directed_compact F hdir hcompact hconnected
    · intro s hs
      exact iInter_subset F ⟨s, hs⟩
  obtain ⟨K, hKC, hKminimal⟩ := zorn_superset_nonempty candidates hchain C
    ⟨hCcompact, hCconnected, hAC, Subset.rfl⟩
  refine ⟨K, hKminimal.prop.1, hKminimal.prop.2.1,
    hKminimal.prop.2.2.1, hKC, ?_⟩
  intro L hLcompact hLconnected hAL hLK
  exact hKminimal.eq_of_subset ⟨hLcompact, hLconnected, hAL, hLK.trans hKC⟩ hLK

/-- Two points of a compact connected set lie in a subcontinuum minimal among
the compact connected subsets containing both points. The points may coincide. -/
theorem exists_minimal_subcontinuum_pair {C : Set X} (hCcompact : IsCompact C)
    (hCconnected : IsConnected C) {x y : X} (hx : x ∈ C) (hy : y ∈ C) :
    ∃ K, IsCompact K ∧ IsConnected K ∧ x ∈ K ∧ y ∈ K ∧ K ⊆ C ∧
      ∀ L, IsCompact L → IsConnected L → x ∈ L → y ∈ L → L ⊆ K → L = K := by
  have hpairC : ({x, y} : Set X) ⊆ C := by
    intro z hz
    simp only [mem_insert_iff, mem_singleton_iff] at hz
    rcases hz with rfl | rfl
    · exact hx
    · exact hy
  obtain ⟨K, hKcompact, hKconnected, hpairK, hKC, hminimal⟩ :=
    exists_minimal_subcontinuum hCcompact hCconnected (by simp) hpairC
  refine ⟨K, hKcompact, hKconnected, hpairK (by simp), hpairK (by simp), hKC, ?_⟩
  intro L hLcompact hLconnected hxL hyL hLK
  apply hminimal L hLcompact hLconnected ?_ hLK
  intro z hz
  simp only [mem_insert_iff, mem_singleton_iff] at hz
  rcases hz with rfl | rfl
  · exact hxL
  · exact hyL

end MinimalSubcontinuum
