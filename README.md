# pandoc-docx.yazi

A [Yazi](https://github.com/sxyazi/yazi) plugin for bidirectional conversion between Markdown and DOCX using [Pandoc](https://pandoc.org/).

- **Markdown → DOCX**: Converts with custom styling via a reference template
- **DOCX → Markdown**: Extracts text and embedded media for editing in Obsidian or any markdown editor

## Requirements

- [Yazi](https://github.com/sxyazi/yazi) (latest version)
- [Pandoc](https://pandoc.org/installing.html) installed and in PATH

## Installation

```bash
ya pkg add TharithaMurage/pandoc-docx
```

Or manually clone to your Yazi plugins directory:
```bash
# Windows
git clone https://github.com/TharithaMurage/pandoc-docx.yazi %APPDATA%\yazi\config\plugins\pandoc-docx.yazi

# Linux/macOS
git clone https://github.com/TharithaMurage/pandoc-docx.yazi ~/.config/yazi/plugins/pandoc-docx.yazi
```

## Setup

### 1. Create or obtain a reference DOCX (for MD → DOCX conversion)

The reference document controls the styling of your output (fonts, colors, heading styles, etc.). You can:
- Use an existing styled DOCX as your template
- Create one in Word with your preferred styles
- Use the included [reference.docx](./reference.docx)

### 2. Add keybinding

Add to your `keymap.toml`:

```toml
[[manager.prepend_keymap]]
on   = ["c", "w"]
run  = "plugin pandoc-docx -- '/path/to/your/reference.docx'"
desc = "Convert between Markdown and DOCX"
```

**Windows example:**
```toml
[[manager.prepend_keymap]]
on   = ["c", "w"]
run  = "plugin pandoc-docx -- 'C:/Users/YourName/AppData/Roaming/yazi/config/plugins/pandoc-docx.yazi/reference.docx'"
desc = "Convert between Markdown and DOCX"
```

## Usage

1. Navigate to a `.md` or `.docx` file in Yazi
2. Press `c` then `w`
3. The converted file is created in the same directory:
   - `.md` → `.docx` (styled with your reference template)
   - `.docx` → `.md` (with extracted media in a subfolder)

## How It Works

### Markdown → DOCX
Uses Pandoc's `--reference-doc` option to apply styles from your template:
- Fonts and colors
- Heading styles
- Paragraph spacing
- Page layout
- List formatting
- Table styles

### DOCX → Markdown
Uses Pandoc with `--extract-media` to:
- Convert formatted text to clean markdown
- Extract embedded images to a `media/` subfolder
- Preserve document structure (headings, lists, tables)

## Troubleshooting

### "No reference doc specified"
This only applies to MD → DOCX. Make sure your keymap.toml includes the path to your reference document.

### "Unsupported file type"
The plugin only works on `.md`, `.markdown`, or `.docx` files.

### Conversion fails silently
- Ensure Pandoc is installed: `pandoc --version`
- Check the path to your reference document exists
- Try running Pandoc manually to see error messages

## License

MIT License
