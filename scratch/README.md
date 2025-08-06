# Feature Testing Directory

This directory contains minimal test documents for each feature branch to demonstrate changes and prepare PR materials.

## Directory Structure

- `enhanced-quote-system/` - Tests the improved quote system with conditional attribution
- `statblock-layout-refinements/` - Tests refined statblock spacing and layout
- `statblock-dotted-borders/` - Tests dotted borders for print/cut workflow
- `centered-ability-tables/` - Tests centered ability score columns in statblocks
- `chapter-title-formatting/` - Tests chapter titles with em-dash instead of colon
- `description-list-enhancements/` - Tests improved description list formatting
- `title-page-improvements/` - Tests title page layout refinements
- `complete-font-system/` - Tests the complete font system overhaul

## Usage

### Build All Features
```bash
./build-tests.sh
```

### Build Specific Feature
```bash
./build-tests.sh enhanced-quote-system
```

### Manual Testing
For each feature directory:

1. **Build BEFORE version:**
   ```bash
   cd feature-directory/
   git checkout main
   lualatex test-file.tex
   mv test-file.pdf test-file-before.pdf
   ```

2. **Build AFTER version:**
   ```bash
   git checkout feature/branch-name  # or private-customizations
   lualatex test-file.tex
   mv test-file.pdf test-file-after.pdf
   ```

3. **Compare PDFs** to see the difference

## Notes

- The build script automatically switches branches and builds both versions
- Some features may not build on the main branch if they depend on new functionality
- Font system tests require WotC fonts to be installed
- PDFs are automatically renamed to `-before.pdf` and `-after.pdf` for comparison
- Auxiliary LaTeX files are cleaned up automatically

## Feature Descriptions

### Enhanced Quote System
- **Before:** Simple quote function, attribution always shows
- **After:** Conditional attribution - empty/missing attribution is handled gracefully

### Statblock Layout Refinements
- **Before:** Default spacing and margins
- **After:** Refined spacing (3pt top, 3mm bottom), improved float positioning

### Statblock Dotted Borders
- **Before:** Solid borders
- **After:** Dotted borders for print/cut workflow

### Centered Ability Tables
- **Before:** Left-aligned ability score columns (YYYYYY format)
- **After:** Centered ability score columns (cccccc format)

### Chapter Title Formatting
- **Before:** "Chapter 1: Title" with colon
- **After:** "Chapter 1 — Title" with em-dash

### Description List Enhancements
- **Before:** Default description list formatting
- **After:** Improved spacing (nolistsep, listparindent=3pt, topsep=6pt, bold sans font)

### Title Page Improvements
- **Before:** Original title page layout
- **After:** Refined spacing and typography improvements

### Complete Font System
- **Before:** Basic font system
- **After:** Complete overhaul with WotC font support, contour system, 350+ options