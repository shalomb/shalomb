+++
title = "Atomic Commit Protocol: A Development Workflow"
date = 2025-11-18
[taxonomies]
tags = ["git", "workflow", "tdd", "bdd", "best-practices"]
+++

A systematic approach to commits that emphasizes single-purpose changes, comprehensive testing, and clear documentation.

## The Problem

How many times have you seen commit messages like "fix stuff" or "WIP" or "various changes"? How often have you needed to revert a change, only to find it tangled with unrelated modifications? Traditional commit practices often lead to:

- Mixed concerns in a single commit
- Unclear change history
- Difficult rollbacks
- Lost context months later

## The Solution: Atomic Commits

An **atomic commit** is a single, self-contained change that:

1. Does exactly one thing
2. Passes all tests
3. Is fully documented
4. Can be reverted independently

## Example: Authentication Fix

Here's what an atomic commit looks like in practice:

```
fix(auth): Implement user authentication and fix login bug

Context and Problem Statement:
- Users were unable to log in due to a bug in the authentication process.
- Lack of user authentication feature in the application.
- Need to ensure secure access to user accounts.
- Improve overall security and user experience.
- Address potential vulnerabilities in the login system.

Solution:
- Implemented user authentication using JWT tokens.
- Fixed the login bug by correcting the validation logic.
- Updated the user model to include authentication fields.
- Added error handling for failed login attempts.

Acceptance Criteria:
- [x] Users can successfully log in with valid credentials.
- [x] Invalid login attempts return appropriate error messages.
- [x] Authentication tokens are securely generated and stored.
- [x] All related tests pass successfully.

References:
- Closes #123
- Relates to #456

Signed-off-by: Your Name <your.name@example.org>
```

## The Workflow Pattern

Every change follows the **RED → GREEN → REFACTOR** cycle:

### 1. Identify Gap
Discover a bug, identify a needed feature, or recognize a gap in functionality.

### 2. BDD/TDD Test Planning (RED)
- Write a BDD specification for the change if it's a new or modified feature
- Write a specific, failing unit test that reproduces the bug or defines the new functionality
- This is the **RED** state

### 3. BDD Step Definitions
If using BDD, write the necessary step definition code to make the BDD scenarios executable.

### 4. Implementation (GREEN)
Write the **minimum** amount of implementation code required to make the failing test(s) pass. This is the **GREEN** state.

### 5. Testing & Validation

**Inner Loop:**
- Run local tests to ensure all tests pass (`make test`)
- If generated code is affected, validate it (`terraform validate`)

**Outer Loop:**
- Run a broader script to verify no regressions in the wider system (`./scripts/outer_loop.sh`)

### 6. Refactor (as needed)
With the safety of passing tests:
- Improve code structure, readability, or performance
- Clean up temporary comments and debugging prints
- Delete unused code, temporary files, or artifacts

### 7. Documentation
Update inline code comments, README files, or other relevant documentation to reflect the changes.

### 8. Atomic Commit
Commit the change atomically with a clear message following [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

The commit message body **should** include:
- Evidence of testing
- Description of expected impact
- References to issues/tickets

## Benefits

**For You:**
- Clear mental model of each change
- Safe experimentation via "save points"
- Easier debugging and git bisect

**For Your Team:**
- Reviewable, focused pull requests
- Clear change history
- Simple rollbacks when needed
- Better collaboration

**For Future You:**
- Understandable git log 6 months later
- Traceable decisions
- Preserved context

## Practical Tips

1. **Commit often**: Each passing test is a potential commit point
2. **One thing at a time**: Refactoring? Separate commit. Bug fix? Separate commit.
3. **Test first**: RED → GREEN → REFACTOR is non-negotiable
4. **Document why, not what**: Code shows what; commits explain why
5. **Sign your work**: `git commit -s` adds accountability

## Common Objections

**"This is too slow"**
Initial overhead pays dividends in debugging time saved and rework avoided.

**"I'll squash it later"**
Squashing loses the safety of incremental checkpoints. Keep granular history.

**"My team doesn't care"**
You'll care when bisecting a production bug at 2am.

## Tools & Resources

- **Conventional Commits**: [conventionalcommits.org](https://www.conventionalcommits.org/)
- **Tim Pope's Guide**: [A Note About Git Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- **Industrial Logic**: [Micro-commits](https://www.industriallogic.com/blog/whats-this-about-micro-commits/)
- **Pro Git Book**: [git-scm.com/book](https://git-scm.com/book/en/v2)

## In Practice

After building 166+ Terraform modules serving 302+ teams, atomic commits have been essential for:

- Tracking infrastructure changes across years
- Debugging platform issues via `git bisect`
- Onboarding new team members
- Maintaining compliance audit trails

The discipline of atomic commits is like the discipline of TDD: initially uncomfortable, ultimately liberating.

## References

- [RFC 2119](https://www.rfc-editor.org/rfc/rfc2119.html) - Requirement Levels
- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/)
- [Tim Pope on Commit Messages](https://tbaggery.com/2008/04/19/a-note-about-git-commit-messages.html)
- [Test-Driven Development: By Example](https://www.goodreads.com/book/show/387190.Test_Driven_Development) - Kent Beck
- [Introducing BDD](https://dannorth.net/introducing-bdd/) - Dan North
- [Refactoring](https://martinfowler.com/books/refactoring.html) - Martin Fowler
- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions) - Michael Nygard
