#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CATALOG_FILE="$REPO_ROOT/catalog.yaml"
TEMPLATES_DIR="$REPO_ROOT/templates"

check_dependencies() {
  if ! command -v yq &> /dev/null; then
    echo "ERROR: yq is required but not installed." >&2
    echo "Install: https://github.com/mikefarah/yq#install" >&2
    exit 1
  fi
}

list_template_files() {
  local template_dir="$1"
  # List all files relative to the template directory.
  # Exclude hidden files except .secrets.yaml.example.
  find "$template_dir" -type f \
    | sed "s|^${template_dir}/||" \
    | grep -v '^\.' \
    | sort
  # Include .secrets.yaml.example if it exists
  if [ -f "$template_dir/.secrets.yaml.example" ]; then
    echo ".secrets.yaml.example"
  fi
}

build_template_entry() {
  local template_dir="$1"
  local name
  name="$(basename "$template_dir")"
  local tmpl="$template_dir/template.yaml"

  if [ ! -f "$tmpl" ]; then
    echo "WARNING: skipping $name -- no template.yaml" >&2
    return
  fi

  if [ ! -f "$template_dir/workflow.yaml" ]; then
    echo "WARNING: skipping $name -- no workflow.yaml" >&2
    return
  fi

  # Read metadata fields from template.yaml
  local display_name description category author min_version complexity
  display_name="$(yq eval '.displayName' "$tmpl")"
  description="$(yq eval '.description' "$tmpl")"
  category="$(yq eval '.category' "$tmpl")"
  author="$(yq eval '.author' "$tmpl")"
  min_version="$(yq eval '.minTentacularVersion' "$tmpl")"
  complexity="$(yq eval '.complexity' "$tmpl")"

  # Build tags array
  local tags
  tags="$(yq eval '.tags' "$tmpl")"

  # Build files array
  local files_yaml=""
  while IFS= read -r file; do
    [ -z "$file" ] && continue
    files_yaml="${files_yaml}      - \"${file}\""$'\n'
  done < <(list_template_files "$template_dir")

  printf '    - name: "%s"\n' "$name"
  printf '      displayName: "%s"\n' "$display_name"
  printf '      description: "%s"\n' "$description"
  printf '      category: "%s"\n' "$category"
  printf '      tags: %s\n' "$tags"
  printf '      author: "%s"\n' "$author"
  printf '      minTentacularVersion: "%s"\n' "$min_version"
  printf '      complexity: "%s"\n' "$complexity"
  printf '      path: "templates/%s"\n' "$name"
  printf '      files:\n'
  printf '%s' "$files_yaml"
}

build_catalog() {
  local generated
  generated="$(date -u +"%Y-%m-%dT%H:%M:%SZ")"

  local header
  header="$(cat <<HEADER
version: "1"
generated: "${generated}"
templates:
HEADER
)"

  local entries=""
  # Sort template directories by name
  for template_dir in $(find "$TEMPLATES_DIR" -mindepth 1 -maxdepth 1 -type d | sort); do
    local entry
    entry="$(build_template_entry "$template_dir")"
    if [ -n "$entry" ]; then
      entries="${entries}${entry}"$'\n'
    fi
  done

  if [ -z "$entries" ]; then
    # No templates found -- write empty catalog
    cat > "$CATALOG_FILE" <<EOF
version: "1"
generated: "${generated}"
templates: []
EOF
  else
    printf '%s\n%s' "$header" "$entries" > "$CATALOG_FILE"
  fi

  echo "Generated $CATALOG_FILE"
}

main() {
  check_dependencies

  if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "No templates/ directory found. Creating empty catalog." >&2
    mkdir -p "$TEMPLATES_DIR"
  fi

  build_catalog
}

main "$@"
