# Architecture Best Practices

## Domain-Driven Design (DDD)
- **Aggregates**: Group related entities and value objects.
- **Bounded Contexts**: Define clear boundaries between different parts of the system.
- **Service Objects**: Use for cross-aggregate orchestration.

## SOLID Principles
- **S**: Single Responsibility Principle.
- **O**: Open/Closed Principle.
- **L**: Liskov Substitution Principle.
- **I**: Interface Segregation Principle.
- **D**: Dependency Inversion Principle.

## Refactoring Protocol
- **AST-First**: Always analyze code using AST before refactoring.
- **Test-First**: Write or update specs before applying changes.
- **Zero Hallucination**: Verify method existence via runtime introspection.
