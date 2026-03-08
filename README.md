# RubyMastery

`RubyMastery` is a production-grade static analysis and refactoring engine designed to help developers write idiomatic, clean, and maintainable Ruby code. It is based on the principles from authoritative Ruby literature.

## Core Features

- **AST Analysis**: Deep code inspection using the `parser` and `rubocop-ast` gems.
- **Clean Ruby Enforcement**: Detects procedural loops (`for`), long methods, and deep nesting.
- **Ruby Object Model Rules**: Identifies procedural classes and encourages proper mixin usage.
- **Refactoring Engine**: Automatic transformation of AST to improve code quality (e.g., replacing `for` with `.each`).
- **Flexible Reporting**: Output violations in CLI tables, JSON, or Markdown formats.

## Installation

```bash
bundle install
```

## Usage

### Analyze a path
```bash
bin/ruby_mastery analyze app/
```

### Generate a JSON report
```bash
bin/ruby_mastery report app/ --format=json
```

### Apply refactors (Experimental)
```bash
bin/ruby_mastery refactor app/models/order.rb
```

## Configuration

Create a `ruby_mastery.yml` in your project root:

```yaml
method_length: 10
class_length: 200
nesting_depth: 2
controller_length: 50
model_length: 300
```

## Development

Run tests with RSpec:

```bash
bundle exec rspec
```
