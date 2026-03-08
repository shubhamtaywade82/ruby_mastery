# Ruby Mastery: Agent Mandates

This document provides foundational mandates for AI agents interacting with the `ruby_mastery` codebase.

## 1. Core Principles
- **AST-First Analysis**: All static analysis must be performed using the `parser` gem's AST (Abstract Syntax Tree). Avoid regex-based code analysis.
- **Architecture over Style**: While RuboCop handles style, `ruby_mastery` focuses on **architectural health** (Domain-Driven Design, service boundaries, and dependency cycles).
- **Test-Driven Refactoring**: Any new refactoring rule *must* include a corresponding spec in `spec/transforms/` or `spec/refactors/`.

## 2. Technical Stack
- **Parser**: Use `Parser::CurrentRuby` for parsing.
- **Unparser**: Use the `unparser` gem for generating code from modified ASTs.
- **Graph Analysis**: The architecture graph is built in `lib/ruby_mastery/architecture/graph/`.

## 3. Workflow for Agents
- **Context Generation**: When asked to analyze a new codebase, always run `bin/ruby_mastery architecture score [PATH]` first to get a baseline.
- **Refactoring Safety**: Before applying a refactor, run the existing specs to ensure no regressions in the engine itself.
- **New Rules**: To add a rule:
  1. Define the rule in `lib/ruby_mastery/rules/`.
  2. Add it to the `Engine::AnalyzerEngine`.
  3. Create a spec in `spec/rules/`.

## 4. Key Directories
- `lib/ruby_mastery/architecture/`: Graph builders and domain analyzers.
- `lib/ruby_mastery/engine/`: Orchestration logic for analysis and refactoring.
- `lib/ruby_mastery/rules/`: Individual linting and architectural rules.
- `lib/ruby_mastery/transforms/`: AST-to-AST transformation logic.

## 5. Agent Tools
- `bin/ruby_mastery architect [PATH]`: Generates high-level AI context for a target project. Use this when you need to "explain" a project to yourself or another agent.
