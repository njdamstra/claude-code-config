# Python Context Primer

## Core Concepts
- Modern Python features (3.10+ with pattern matching)
- Type hints and static analysis
- Async/await patterns for I/O operations
- Data processing and pipeline architecture

## Project Structure
```
src/
├── models/         # Data models (Pydantic)
├── services/       # Business logic
├── utils/          # Utility functions
├── tests/          # Test suite
└── scripts/        # CLI and automation
```

## Data Handling
- **Validation**: Pydantic models
- **Processing**: Pandas or Polars
- **Async I/O**: aiohttp, asyncio
- **Database**: SQLAlchemy, asyncpg

## Development Tools
- **Formatting**: black, isort
- **Linting**: ruff, mypy
- **Testing**: pytest, hypothesis
- **Dependency**: poetry, pip-tools

## Common Patterns
- Context managers for resource handling
- Generators for memory efficiency
- Dataclasses for structured data
- Dependency injection for testability

## Performance Considerations
- Use generators for large datasets
- Profile with cProfile and memory_profiler
- Consider asyncio for I/O-bound operations
- Optimize hot paths with proper algorithms

## Configuration Management
- `pyproject.toml` for modern packaging
- Environment variables for configuration
- Structured logging with loguru or stdlib
- Error handling with custom exceptions