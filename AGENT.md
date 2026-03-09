# AGENT.md: Ruby Mastery Global Invariants

This document defines the core standards for the `ruby_mastery` project.

## 1. Core Mandates
- **AST-First**: Perform all static analysis via the `parser` gem's AST.
- **Architecture First**: Focus on DDD, service boundaries, and dependency health.
- **Test-Driven Refactoring**: Include specs for every new refactoring rule.

## 2. Technical Stack
- **Ruby 3.x**: Use modern Ruby features (pattern matching, keyword args).
- **Parser/Unparser**: Essential for all AST transformations.
- **RSpec**: The only supported testing framework.

## 3. Workflow
1. **Introspection**: Before writing code, use the runtime introspection tool to verify class/method existence.
2. **Strategy**: Propose changes based on AST analysis.
3. **Execution**: Apply surgical edits via the `replace` tool.
4. **Validation**: Run `bin/rspec` to verify correctness.

## 4. Code Standards
- **Frozen String Literal**: Mandatory in every Ruby file.
- **Keyword Arguments**: Preferred for clear method signatures.
- **No Implicit Nil**: Prefer explicit `nil` or `Result` objects.
- **Small Classes/Methods**: Keep logic focused and modular.

## 5. Performance
- **Avoid N+1**: Always eager-load associations in Rails/DB contexts.
- **Memory Efficiency**: Use `find_each` or similar for large collection processing.
- **AST Performance**: Cache parsed ASTs for multiple analysis passes.
