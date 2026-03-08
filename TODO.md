# Ruby Mastery: Agent Roadmap (TODO)

This roadmap highlights tasks that AI agents should prioritize to enhance the `ruby_mastery` engine.

## 1. CLI Refinements
- [ ] Replace "Mock Building Logic" in `cli.rb` with a real `Architecture::GraphBuilder` runner.
- [ ] Add more granular command descriptions.

## 2. Advanced Analyzers
- [ ] Implement an `InheritanceAbuseAnalyzer` (identifying deep hierarchies).
- [ ] Add `RailsServiceBoundaryAnalyzer` to detect services calling other services.

## 3. AST Transformations
- [ ] Add `UnusedVariableRemovalTransform`.
- [ ] Implement a `LawOfDemeterRefactor` (converting multiple dot-chains to delegate).

## 4. Documentation & Examples
- [ ] Add "RealWorld" examples for all design patterns in `examples/design_patterns/`.
- [ ] Create a `CONTRIBUTING.md` for human-agent collaboration.

## 5. Integration
- [ ] Add a `GitHub Action` to run `ruby_mastery architecture score` on every PR.
- [ ] Integrate the `ContextGenerator` with common AI coding standards.
