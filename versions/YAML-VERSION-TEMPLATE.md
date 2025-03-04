---
version: 2.0.0
date: 2025-03-04
type: template-doc
status: public
tags: [william, template, versioning]
related:
  - WILL-System.md
  - Three-Stage-Architecture.md
  - NATURAL-Framework.md
changelog:
  - version: 2.0.0
    date: 2025-03-04
    changes:
      - "MAJOR: Switch to YAML frontmatter"
      - "MAJOR: Enhanced metadata structure"
      - "MAJOR: Improved version tracking"
    references:
      - "NATURAL-Framework"
  - version: 1.0.0
    date: 2025-03-03
    changes:
      - "MAJOR: Initial version template"
    references:
      - "Badge-System"
---

# YAML Version Template

## Required Fields

1. `version`: Semantic version (MAJOR.MINOR.PATCH)
2. `date`: ISO format date (YYYY-MM-DD)
3. `type`: Document type, one of:
   - `system-doc`: System documentation
   - `framework-doc`: Framework documentation
   - `architecture-doc`: Architecture documentation
   - `component-doc`: Component documentation
   - `guide-doc`: User guides and tutorials
   - `template-doc`: Templates and examples
4. `status`: Document status, one of:
   - `public`: Public documentation
   - `internal`: Internal documentation
   - `draft`: Work in progress
   - `archived`: Historical version

## Optional Fields

1. `tags`: List of relevant tags
2. `related`: List of related documents
3. `changelog`: Version history with:
   - version number
   - date
   - list of changes
   - references

## Example Usage

```yaml
---
version: 2.0.0
date: 2025-03-04
type: framework-doc
status: public
tags: [william, framework, example]
related:
  - Related-Doc-1.md
  - Related-Doc-2.md
changelog:
  - version: 2.0.0
    date: 2025-03-04
    changes:
      - "MAJOR: Important change"
      - "MINOR: Small improvement"
    references:
      - "Reference-Doc"
---
```

## Migration Guidelines

1. Always place YAML frontmatter at the top of the file
2. Use consistent indentation (2 spaces)
3. Follow semantic versioning:
   - MAJOR: Breaking changes
   - MINOR: New features, backward compatible
   - PATCH: Bug fixes, backward compatible
4. Keep changelog entries clear and concise
5. Reference related documents for context
