# Ruby Mastery

Ruby Mastery is a static analysis and refactoring engine for Ruby codebases.

It enforces:

• Ruby idioms  
• Ruby object model correctness  
• Rails architecture best practices  
• Clean code principles

Inspired by:

- Programming Ruby
- The Well-Grounded Rubyist
- Clean Ruby
- Clean Code Principles
- The RSpec Book

---

# Installation

```bash
bundle install
```

---

# CLI Usage

Analyze a project:

```bash
ruby_mastery analyze .
```

Apply refactors:

```bash
ruby_mastery refactor app/
```

Generate reports:

```bash
ruby_mastery report app --format json
```

---

# Configuration

Edit:

```
ruby_mastery.yml
```

Example:

```
method_length: 10
class_length: 200
nesting_depth: 2
```

---

# Supported Analysis

### Code Quality

* Long methods
* Deep nesting
* Large classes
* Temporary variables

### Ruby Idioms

* `for` loops
* manual accumulation
* procedural iteration

### Ruby Object Model

* procedural classes
* misuse of class methods
* inheritance abuse

### Rails Architecture

* fat controllers
* callback abuse
* model bloat

---

# Refactors

The engine can automatically perform:

* replace loops with enumerables
* guard clause introduction
* split large methods
* suggest object extraction
* detect boolean flags

---

# Running Tests

```
bundle exec rspec
```

---

# Example Output

```
File                     Rule              Message
app/models/order.rb      MethodRules       Method too long
app/controllers/users    ObjectModelRules  Fat controller
```

---

# Future Improvements

* advanced AST transforms
* Rails domain modeling analysis
* automatic PR generation
* CI integration

---

# License

MIT
