# Tentacular Workflow Template Catalog

A browsable catalog of production-ready workflow templates for [Tentacular](https://github.com/randybias/tentacular). Templates can be browsed on the web at [randybias.github.io/tentacular-catalog](https://randybias.github.io/tentacular-catalog) or installed via `tntc catalog init`.

**Documentation:** [Catalog Usage Guide](https://randybias.github.io/tentacular-docs/guides/catalog-usage/) | [Template Reference](https://randybias.github.io/tentacular-docs/reference/catalog/agent-activity-report/)

## Quick Start

```bash
# List all available templates
tntc catalog list

# Search templates by keyword
tntc catalog search monitoring

# View details about a specific template
tntc catalog info uptime-prober

# Scaffold a new workflow from a template
tntc catalog init hn-digest my-news-digest
```

## Ecosystem

| Repository | Description |
|---|---|
| [tentacular](https://github.com/randybias/tentacular) | CLI + workflow engine |
| [tentacular-mcp](https://github.com/randybias/tentacular-mcp) | MCP server for Kubernetes lifecycle |
| [tentacular-skill](https://github.com/randybias/tentacular-skill) | Claude Code skill for building workflows |
| [tentacular-catalog](https://github.com/randybias/tentacular-catalog) | Workflow template catalog (this repo) |
| [tentacular-docs](https://github.com/randybias/tentacular-docs) | [Documentation site](https://randybias.github.io/tentacular-docs) |

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for how to add a new template to the catalog.

## License

Copyright (c) 2025-2026 Mirantis, Inc. All rights reserved. See [LICENSE](LICENSE).
