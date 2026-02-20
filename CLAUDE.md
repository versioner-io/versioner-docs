# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

Versioner public documentation site, built with MkDocs Material and deployed to docs.versioner.io.

## Cross-Repo Context

This repo is part of the Versioner ecosystem. Before starting work:
- Use the `/kanban-markdown` skill or read `versioner-dev-docs/.devtool/features/` for current status and priorities
- Update feature file status in `versioner-dev-docs/.devtool/features/` as you complete tasks, add entries to `changelog.md`

## Commands

```bash
pip install -r requirements.txt     # Install MkDocs + plugins (Python 3.11+)
mkdocs serve                        # Local preview at http://localhost:8000
mkdocs build --strict               # Production build (verify no errors)
```

## Structure

- `public/` - All user-facing documentation in Markdown
- `mkdocs.yml` - Site configuration (navigation, theme, plugins)
- `requirements.txt` - Python dependencies
- `terraform/` - Infrastructure as code for docs hosting

## Deployment

- Push to `main` deploys to docs.versioner.io
- Push to `develop` deploys to dev-docs.versioner.io
- GitHub Actions builds and deploys automatically

## Conventions

- All documentation goes in `public/` subdirectory
- Navigation is defined in `mkdocs.yml` - update when adding pages
- Use relative links for internal pages
- Use admonitions for notes/warnings (`!!! note`, `!!! warning`)
- Include code examples with language tags
- This is a public repo - no secrets or internal information
