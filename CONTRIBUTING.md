# Contributing to RailsIAM

First of all, thank you for your interest in contributing to RailsIAM! 🎉

Whether you're reporting a bug, improving documentation, fixing a typo, or implementing a new feature, your contribution is greatly appreciated.

## Before You Start

Please check the existing:

- [Issues](https://github.com/salmanx/rails_iam/issues)
- [Pull Requests](https://github.com/salmanx/rails_iam/pulls)

to make sure your idea or bug hasn't already been discussed.

If you're planning a significant feature or architectural change, please open an issue first so we can discuss the design before implementation.

---

# Reporting Bugs

When opening a bug report, please include as much information as possible:

- Rails version
- Ruby version
- RailsIAM version
- Authentication strategy
- Database adapter
- Steps to reproduce
- Expected behavior
- Actual behavior
- A minimal reproducible example if possible

---

# Feature Requests

RailsIAM aims to remain simple, predictable, and database-driven.

If you'd like to propose a new feature:

1. Open an issue describing the problem you're trying to solve.
2. Explain your proposed solution.
3. Wait for discussion before starting implementation.

Features that increase complexity without broad usefulness may not be accepted.

---

# Documentation

Documentation improvements are always welcome.

This includes:

- README improvements
- Wiki pages
- API examples
- Typo fixes
- Better explanations
- Additional authorization examples

---

# Development

Clone the repository:

```bash
git clone https://github.com/salmanx/rails_iam.git
cd rails_iam
```

Install dependencies:

```bash
bundle install
```

Run the test suite:

```bash
bundle exec rspec
```

Please ensure all tests pass before submitting a Pull Request.

---

# Pull Requests

Please follow these guidelines:

- Create a new branch from `main`
- Keep Pull Requests focused on a single change
- Follow the existing coding style
- Add or update tests when applicable
- Update documentation when behavior changes
- Update the CHANGELOG for user-facing changes
- Keep commit messages clear and descriptive

Example:

```
Add support for custom authorization strategies
```

---

# Code Style

Please follow the existing project conventions:

- Follow Ruby and Rails style guidelines
- Prefer small, focused classes
- Keep public APIs backward compatible whenever possible
- Write expressive, readable code

---

# Testing

Every new feature or bug fix should include appropriate tests whenever possible.

RailsIAM uses RSpec for testing.

---

# Versioning

Please do **not** update the gem version in your Pull Request.

Version numbers are managed by the project maintainers during release.

---

# Questions

If something isn't clear, feel free to open a GitHub Discussion or Issue.

Constructive feedback and questions are always welcome.

---

Thank you for helping make RailsIAM better! 🚀
