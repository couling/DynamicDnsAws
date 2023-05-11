#!/bin/sh

set -ex

project_dir="$(dirname "$0")"

rm -rf "$project_dir/dist"

poetry self add poetry-dynamic-versioning
poetry build
poetry export --only main > "dist/requirements-export.txt"

# shellcheck disable=SC2039
read package_name version << EOF
$(poetry version | sed 's/+/_/g')
EOF

docker build "${project_dir}" -t "${package_name}:${version}"

echo "image built ${package_name}:${version}"