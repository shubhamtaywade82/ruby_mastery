# Rails API Best Practices

## Controllers
- **Thin Controllers**: Only parameter validation and service orchestration.
- **Strong Parameters**: Explicitly permit only required attributes.
- **Status Codes**: Always return appropriate HTTP status codes (e.g., `:created`, `:unprocessable_entity`).

## Services
- **Single Responsibility**: Each service should perform exactly one action.
- **Command Pattern**: Services should typically respond to a `call` method.
- **No Side Effects**: Services should return a result object rather than raising errors for domain logic.

## Models
- **Fat Models/Thin Services**: Prefer putting domain logic in models if it doesn't involve multiple domain objects.
- **Encapsulate Domain Invariants**: Use validations and callbacks sparingly; prefer explicit domain methods.

## Performance
- **Avoid N+1 Queries**: Use `includes`, `preload`, or `eager_load`.
- **Batch Processing**: Use `find_each` for large datasets.
