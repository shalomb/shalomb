+++
title = "The Declarative Repository: Self-Documenting Code for Humans and AI"
date = 2025-11-18
[taxonomies]
tags = ["architecture", "documentation", "platform-engineering", "ai", "best-practices"]
+++

A specification for repositories that explicitly declare their purpose, capabilities, and relationships - enabling both humans and AI agents to understand and contribute without external context.

## The Problem

How many times have you cloned a repository only to find:

- No clear explanation of what it does
- Undocumented build processes
- Mysterious dependencies
- Tribal knowledge requirements
- "Just ask Sarah" comments

Traditional repositories are **opaque boxes** requiring external knowledge that may not exist when you need it. This creates barriers for:

- **New team members** trying to understand project purpose and structure
- **AI agents** attempting to interact with or modify codebases
- **Integration teams** seeking to understand dependencies and interfaces
- **Maintainers** trying to communicate conventions and requirements

After serving 302+ product teams with 166+ infrastructure modules, I've learned: **repositories should be self-evident**.

## The Solution: Declarative Repositories

A **Declarative Repository** is one that explicitly declares its:

1. **Purpose** - What it is and why it exists
2. **Capabilities** - What it produces and how to use it
3. **Relationships** - How it fits into the broader ecosystem
4. **Contribution Model** - How to improve it

Think of it as a repository that follows the **Unix philosophy**: each piece should be self-describing and composable.

## Specification Requirements

### Internal Declaration (MUST Have)

#### 1. Self-Description via `docs/`

Structure documentation following the [Diátaxis framework](https://diataxis.fr/):

```
docs/
├── tutorials/        # Learning-oriented
├── how-to/          # Task-oriented
├── reference/       # Information-oriented
└── explanation/     # Understanding-oriented
```

#### 2. Output Declaration

Declare what you produce:

```yaml
# For services
openapi.yaml          # API specification

# For libraries
docs/api/            # Interface documentation

# For infrastructure
outputs.tf           # Terraform outputs
README.md            # Module interface
```

#### 3. Integration Documentation

`README.md` must answer:

- What does this repository produce?
- How do I use its outputs?
- What are the prerequisites?
- How do I run it locally?

#### 4. Contribution Framework

Required files:

```
CONTRIBUTING.md      # How to contribute
CODEOWNERS          # Who owns what
.github/
  ISSUE_TEMPLATE/   # Bug reports, feature requests
  PULL_REQUEST_TEMPLATE.md
```

#### 5. Navigation Support

Provide signposting without external guidance:

```markdown
# README.md
## Quick Links
- [Getting Started](docs/tutorials/quickstart.md)
- [API Reference](docs/reference/api.md)
- [Architecture Decisions](docs/adr/)
- [Troubleshooting](docs/how-to/troubleshooting.md)
```

#### 6. Activity Documentation

Document workflows and patterns:

```
docs/
├── workflows/
│   ├── development.md
│   ├── release.md
│   └── incident-response.md
└── adr/              # Architecture Decision Records
    ├── 0001-use-terraform.md
    └── 0002-module-structure.md
```

#### 7. Change Conditions

Define "Definition of Done":

```markdown
## Conditions of Satisfaction

Before merging:
- [ ] All tests pass
- [ ] Documentation updated
- [ ] CHANGELOG.md updated
- [ ] ADR created (if architectural change)
- [ ] Breaking changes noted
```

### External Interface (MUST Have)

#### 8. Discovery Documentation

Enable self-service onboarding:

```
docs/
├── onboarding.md        # New contributor guide
├── troubleshooting.md   # Common issues
└── reference/
    └── api.md           # Interface reference
```

#### 9. Change Communication

Maintain `CHANGELOG.md` with semantic versioning:

```markdown
# Changelog

## [2.0.0] - 2025-11-18

### Breaking Changes
- Removed legacy authentication (see ADR-0042)

### Added
- JWT token support (see ADR-0043)

### Fixed
- Login validation bug (#123)
```

#### 10. Ecosystem Metadata

Define your context:

```json
// package.json or .repo/metadata.json
{
  "ecosystem": "platform-engineering",
  "team": "cloud-solutions",
  "product": "terraform-modules",
  "related": [
    "github:org/vpc-module",
    "github:org/rds-module"
  ]
}
```

#### 11. Ecosystem Definition

Be explicit about boundaries:

```markdown
## Ecosystem

This module is part of the **Takeda Cloud Platform** ecosystem:

- Organization: `github:takeda/cloud-platform`
- Product Suite: Infrastructure-as-Code Building Blocks
- Related Modules: See [module catalog](../catalog.md)
```

## Implementation Pattern: Sense → Plan → Act

When interacting with a Declarative Repository:

### Sense
Understand current state and requirements by reading:
- `README.md` - What is this?
- `CONTRIBUTING.md` - How do I change it?
- `docs/` - Where do I learn more?

### Plan
Determine appropriate action based on:
- Issue templates - What kind of change?
- ADRs - What patterns exist?
- Tests - What's the safety net?

### Act
Execute with confidence:
- Local development documented
- Tests provide feedback
- CI/CD enforces quality gates

## Declarative Template Repositories

Organizations **should** establish template repositories providing:

### Convention Establishment
```
.github/
  ISSUE_TEMPLATE/
  PULL_REQUEST_TEMPLATE.md
CONTRIBUTING.md
CODEOWNERS
README.md
```

### Technology Scaffolding
```
templates/
├── go-service/
├── node-api/
├── python-library/
└── terraform-module/
```

### Practice Enforcement
```
.pre-commit-config.yaml
.editorconfig
Makefile
pyproject.toml
```

### Overlay Capability
Apply templates to existing repos:

```bash
# Overlay declarative structure
cookiecutter gh:org/template-declarative-repo \
  --output-dir . \
  --overwrite-if-exists
```

## Real-World Example

From building 166+ Terraform modules:

```
terraform-aws-vpc/
├── README.md                    # Module purpose, usage
├── CHANGELOG.md                 # Semantic version releases
├── CONTRIBUTING.md              # PR process, testing
├── CODEOWNERS                   # @platform-team
├── examples/
│   ├── basic/                  # Minimal usage
│   └── complete/               # Production pattern
├── docs/
│   ├── tutorials/
│   │   └── getting-started.md
│   ├── how-to/
│   │   ├── multi-az.md
│   │   └── peering.md
│   ├── reference/
│   │   └── variables.md        # Auto-generated
│   └── adr/
│       └── 0001-cidr-allocation.md
├── tests/
│   └── integration/
├── main.tf
├── variables.tf
├── outputs.tf                  # Declared interface
└── .github/
    └── workflows/
        └── ci.yml
```

Result: **Weeks to hours** onboarding time for 302+ teams.

## Benefits

After implementing across an enterprise platform:

**For New Contributors:**
- Self-service onboarding
- Clear contribution paths
- Documented patterns

**For AI Agents:**
- Discoverable interfaces
- Explicit constraints
- Error resolution paths

**For Integration Teams:**
- Documented dependencies
- API specifications
- Version compatibility

**For Maintainers:**
- Reduced "how do I..." questions
- Clear ownership boundaries
- Audit trail via ADRs

## Compliance Checklist

A repository is **compliant** when it has:

- [ ] `README.md` with purpose, usage, prerequisites
- [ ] `docs/` directory (Diátaxis-aligned)
- [ ] `CONTRIBUTING.md` and `CODEOWNERS`
- [ ] `CHANGELOG.md` with semantic versions
- [ ] API/interface specification
- [ ] Issue and PR templates
- [ ] Architecture Decision Records
- [ ] Troubleshooting documentation
- [ ] Ecosystem metadata
- [ ] Local development instructions

## Anti-Patterns

**Don't:**
- Rely on tribal knowledge
- Hide conventions in Slack threads
- Assume context exists
- Make people ask for basics
- Document in external wikis (they drift)

**Do:**
- Declare everything in-repo
- Link to external resources
- Version documentation with code
- Make repository self-sufficient
- Enable autonomous work

## Tools & References

- **Diátaxis Framework**: [diataxis.fr](https://diataxis.fr/)
- **ADR Tools**: [github.com/npryce/adr-tools](https://github.com/npryce/adr-tools)
- **OpenAPI Spec**: [spec.openapis.org](https://spec.openapis.org/)
- **Conventional Commits**: [conventionalcommits.org](https://www.conventionalcommits.org/)
- **Keep a Changelog**: [keepachangelog.com](https://keepachangelog.com/)

## Conclusion

Declarative Repositories aren't just documentation—they're a **philosophy of transparency**.

In platform engineering, we build systems other engineers depend on. Making those systems self-evident isn't optional; it's professional courtesy.

When done right, repositories become:
- **Self-documenting** - No external context needed
- **Self-onboarding** - New contributors autonomous
- **AI-friendly** - Agents can understand and modify
- **Ecosystem-aware** - Clear relationships to other repos

The goal: **Any developer, human or AI, should be able to contribute within 30 minutes of cloning.**

## See Also

- [Atomic Commit Protocol](../2025-11-18-atomic-commit-protocol) - For change management
- [On Terraform Module Design](../2025-11-18-on-terraform-modules) - For IaC patterns

---

*Building platforms for 302+ teams taught me: if it's not in the repo, it doesn't exist.*
