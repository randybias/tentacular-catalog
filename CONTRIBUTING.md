# Contributing to the Tentacular Catalog

## Adding a Template

1. Create a `templates/<name>/` directory.
2. Add a `template.yaml` with the required metadata (see format below).
3. Add your workflow files:
   - `workflow.yaml` (required)
   - `nodes/*.ts` (your workflow node source files)
   - `tests/fixtures/` (optional test fixtures)
   - `.secrets.yaml.example` (optional, documents required secrets)
   - `README.md` (optional, template-specific documentation)
4. Run `./scripts/build-index.sh` to regenerate `catalog.yaml`.
5. Submit a PR.

## template.yaml Format

```yaml
name: my-workflow
displayName: "My Workflow"
description: "What it does"
category: starter          # starter | data-pipeline | monitoring | automation | reporting
tags: [tag1, tag2]
author: your-github-handle
minTentacularVersion: "0.1.0"
complexity: simple         # simple | moderate | advanced
```

## Categories

| Category | Description |
|---|---|
| `starter` | Learning examples, minimal dependencies |
| `data-pipeline` | Fetch, transform, output data |
| `monitoring` | Health checks, metrics collection |
| `automation` | Triggered actions, PR reviews, webhooks |
| `reporting` | Digest generation, notifications |

## Complexity Levels

- **simple** -- Single node or minimal DAG, no external dependencies.
- **moderate** -- Multiple nodes, some external dependencies or secrets.
- **advanced** -- Complex DAG, multiple dependencies, cron triggers, error handling.
