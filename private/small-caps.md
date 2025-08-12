# Global Text Substitution for "Dungeons & Dragons" to Small-Caps

## Implementation Approach

I'll implement this as a **custom Jinja2 filter** in the LaTeX template engine, which is the ideal location for global text transformations. This approach:

- ✅ Applies to all generated LaTeX content
- ✅ Integrates cleanly with existing text processing pipeline  
- ✅ Works consistently across all templates
- ✅ Maintains proper LaTeX escaping

## Implementation Steps

### 1. Add Small-Caps Filter to LaTeX Template Engine
**File**: `src/dnd5e/renderers/latex/template_engine.py`
- Add new filter function `dnd_smallcaps()` in `_add_latex_filters()` method
- Register it as `self.env.filters["dnd_smallcaps"] = dnd_smallcaps`

**Filter Logic**:
```python
def dnd_smallcaps(value: str) -> str:
    """Convert 'Dungeons & Dragons' text to LaTeX small-caps."""
    if not isinstance(value, str):
        value = str(value)
    
    # Replace variations of D&D text with small-caps LaTeX command
    patterns = [
        (r'Dungeons\s*&\s*Dragons', r'\\textsc{Dungeons \\& Dragons}'),
        (r'D&D', r'\\textsc{d\\&d}'),  # Lowercase for better small-caps appearance
    ]
    
    for pattern, replacement in patterns:
        value = re.sub(pattern, replacement, value, flags=re.IGNORECASE)
    
    return value
```

### 2. Apply Filter Globally in Templates  
**Approach**: Modify the base template to apply the filter to all content

**Option A - Template-level**: Add the filter to key content variables in templates
**Option B - Engine-level**: Apply automatically during text processing (cleaner)

I recommend **Option B** - modify the `latex_escape` function to also apply the small-caps transformation automatically, so it happens transparently without requiring template changes.

### 3. Integration Points

**Modified Function**: `escape_latex_text()` in `src/dnd5e/core/latex_utils.py`
- Add small-caps conversion as the final step before returning
- This ensures ALL text going through LaTeX escaping gets the treatment

**Template Usage**: No changes needed - the transformation happens automatically during the existing `| latex_escape` filter calls throughout all templates.

### 4. Testing Strategy

- Test with content containing "Dungeons & Dragons", "D&D", and variations
- Verify LaTeX compiles correctly with `\textsc{}` commands
- Ensure proper escaping of the ampersand (`\&`) within small-caps
- Test case variations (case insensitive matching)

## Benefits of This Approach

1. **Global Coverage**: Affects all generated LaTeX content automatically
2. **No Template Changes**: Works with existing template structure  
3. **Maintains Security**: Integrates with existing LaTeX escaping pipeline
4. **Consistent Application**: No risk of missing occurrences
5. **Easy to Extend**: Can add more text transformations using same pattern

## Small-Caps LaTeX Output
The transformation will convert:
- "Dungeons & Dragons" → `\textsc{Dungeons \& Dragons}`
- "D&D" → `\textsc{d\&d}` (lowercase for better small-caps appearance)

This leverages the proper Mrs Eaves Small Caps font we configured in the WotC fontset.