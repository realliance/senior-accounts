# Game Accounts Service
### Senior Design CEN4914 Spring 2021

## Dependencies

- Git
- Ruby 3.0.0 with RubyGems

## Getting Started

```bash
# Install gems
bundle install

# Start local rails server
rails server
```

## Pre-Commit

This repository uses the [pre-commit](https://pre-commit.com/) tool to facilitate some automatic code corrections.

Before beginning coding, [install pre-commit](https://pre-commit.com/#install) and setup the hook:

```bash
# Install git hook
pre-commit install

# Manually run pre-commit
pre-commit run --all-files
```

## Running tools

```bash
# Lint and check style of code
rubocop

# Run unit tests
rails spec

# Check database consistency
database_consistency
```
