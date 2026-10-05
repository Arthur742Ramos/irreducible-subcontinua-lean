Let C be a compact connected subset of a Hausdorff space, and let A be a nonempty subset of C. There is a compact connected K with A ⊆ K ⊆ C such that every compact connected L with A ⊆ L ⊆ K equals K. This package proves that statement, its two-point instance, and the connectedness of directed compact intersections.

The witness is minimal under inclusion. The theorem does not assert that K is contained in every other candidate or that K is unique. On a circle, the two arcs joining a pair of distinct points illustrate why these stronger conclusions fail. The points in the two-point corollary are allowed to coincide.

The three public declarations in `Solution.lean` are:

| Declaration in `MinimalSubcontinuum` | Content |
| --- | --- |
| `isConnected_iInter_of_directed_compact` | A nonempty downward directed family of compact connected sets has a nonempty connected intersection. |
| `exists_minimal_subcontinuum` | A nonempty subset of a compact connected set lies in a minimal compact connected subset. |
| `exists_minimal_subcontinuum_pair` | Two points lie in such a minimal subcontinuum. |

The proofs use Mathlib's `IsCompact`, `IsConnected`, and set inclusion. Mathlib's `IsIrreducible` has a different meaning and does not express this continuum-theoretic minimality. There is no metric or local connectedness assumption, and the result makes no assertion about arcs.

The intersection proof separates two compact pieces by disjoint open neighborhoods. Compactness forces a family member into the union of those neighborhoods, and connectedness puts it into one side. Zorn's lemma then gives a minimal element among the compact connected subsets of C containing A.

The primary source is Paul Bankston, [Metric Topology: A First Course, Proposition 28.1](https://www.mscsnet.mu.edu/~paul/Paper/4450102text.pdf#page=89). Proposition 27.1 supplies the supporting intersection argument. See `PROVENANCE.md` for scope and prior-library checks.

The exact dependency pins are Lean `v4.35.0-rc2` and Mathlib `065356127b1dc0016f66b7283ce0ce2c4055aa55`. With elan and Python installed, run:

```sh
python3 scripts/verify.py --lake-build
```

This runs an ordinary Lake build, a fresh direct source compilation, a Challenge compilation under a random module name with only dependency paths, exact comparison of all selected declaration types, and a transitive axiom audit. `Challenge.lean` contains three deliberate theorem holes. The allowed axioms are `propext`, `Classical.choice`, and `Quot.sound`. GitHub Actions runs the same checks; see `VERIFICATION.md` for the checks actually run on the desktop.

The repository uses Apache-2.0. The responsible maintainers are Arthur Freitas Ramos, David Barros Hulak, and Ruy Jose Guerra Barretto de Queiroz.
