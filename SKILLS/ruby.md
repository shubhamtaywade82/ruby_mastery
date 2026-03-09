# Ruby 3 Best Practices

## Preferred
- **Frozen string literal** at the top of every file.
- **Pattern matching** (`case ... in`) for complex data structures.
- **Enumerable chaining** over explicit loops.
- **Guard clauses** to reduce nesting.
- **Keyword arguments** for clear method signatures.

## Avoid
- **Deep nesting** beyond 2 levels.
- **Implicit nil returns**; prefer explicit `nil` or `Option`/`Success` objects.
- **Monkey patching** core Ruby classes.
- **Rescue without class**; always specify `StandardError`.

## Examples
### Good
def call(input:)
  return Failure(:invalid) unless valid?(input)
  Success(process(input))
end

### Bad
def call(input)
  if valid?(input)
    process(input)
  else
    nil
  end
end
