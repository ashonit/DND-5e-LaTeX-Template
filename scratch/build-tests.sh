#!/bin/bash

# Build script for testing features before/after
# Usage: ./build-tests.sh [feature-name]
# If no feature specified, builds all

set -e

FEATURES=(
    "enhanced-quote-system"
    "statblock-layout-refinements" 
    "statblock-dotted-borders"
    "centered-ability-tables"
    "chapter-title-formatting"
    "description-list-enhancements"
    "title-page-improvements"
    "complete-font-system"
)

build_feature() {
    local feature=$1
    echo "=== Building $feature ==="
    
    cd "$feature"
    
    # Find the tex file
    tex_file=$(find . -name "*.tex" -type f | head -1)
    if [ -z "$tex_file" ]; then
        echo "No .tex file found in $feature"
        cd ..
        return
    fi
    
    base_name=$(basename "$tex_file" .tex)
    
    echo "Building BEFORE version (main branch)..."
    git checkout main >/dev/null 2>&1
    lualatex --interaction=nonstopmode "$tex_file" >/dev/null 2>&1 || echo "Build failed (expected for some features on main)"
    if [ -f "${base_name}.pdf" ]; then
        mv "${base_name}.pdf" "${base_name}-before.pdf"
    fi
    
    echo "Building AFTER version (feature branch)..."
    # Try different branch naming patterns
    git checkout "feature/$feature" >/dev/null 2>&1 || git checkout "feature/${feature//-/}" >/dev/null 2>&1 || git checkout "feature/description-lists" >/dev/null 2>&1 || git checkout "private-customizations" >/dev/null 2>&1
    lualatex --interaction=nonstopmode "$tex_file" >/dev/null 2>&1 || echo "Build failed"
    if [ -f "${base_name}.pdf" ]; then
        mv "${base_name}.pdf" "${base_name}-after.pdf"
    fi
    
    # Clean up auxiliary files
    rm -f *.aux *.log *.toc *.fdb_latexmk *.fls *.synctex.gz
    
    echo "Built: ${base_name}-before.pdf and ${base_name}-after.pdf"
    cd ..
}

# Go to scratch directory
cd "$(dirname "$0")"

# Save current branch
original_branch=$(git branch --show-current)

if [ $# -eq 0 ]; then
    # Build all features
    for feature in "${FEATURES[@]}"; do
        if [ -d "$feature" ]; then
            build_feature "$feature"
        else
            echo "Directory $feature not found, skipping..."
        fi
    done
else
    # Build specific feature
    if [ -d "$1" ]; then
        build_feature "$1"
    else
        echo "Directory $1 not found!"
        exit 1
    fi
fi

# Return to original branch
git checkout "$original_branch" >/dev/null 2>&1

echo "=== Build complete ==="
echo "Check the PDFs in each feature directory to compare before/after"