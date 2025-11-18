# Zola Blog Setup

This repository now includes a minimalist Zola-based blog system with man-page inspired design.

## Structure

```
shalomb/
├── config.toml              # Zola configuration
├── content/
│   ├── _index.md           # Homepage
│   └── blog/
│       ├── _index.md       # Blog index
│       └── *.md            # Blog posts (dated: YYYY-MM-DD-slug.md)
├── templates/
│   ├── base.html           # Base template with man-page nav
│   ├── index.html          # Homepage (man-page style)
│   ├── blog.html           # Blog listing
│   └── blog-page.html      # Single post template
└── static/
    └── style.css           # Minimal CSS (~120 lines)
```

## Installation

Install Zola (static site generator written in Rust):

### Linux/macOS
```bash
# Download latest release
wget https://github.com/getzola/zola/releases/download/v0.19.2/zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz
tar xzf zola-v0.19.2-x86_64-unknown-linux-gnu.tar.gz
sudo mv zola /usr/local/bin/

# Or use package managers
brew install zola           # macOS
snap install zola --edge    # Linux
```

### Verify installation
```bash
zola --version
```

## Usage

### Build the site
```bash
zola build
# Output in public/
```

### Development server with live reload
```bash
zola serve
# Visit http://127.0.0.1:1111
```

### Create a new blog post
```bash
# Manual method (recommended for control)
cat > content/blog/2025-11-18-my-new-post.md <<'EOF'
+++
title = "My New Post"
date = 2025-11-18
[taxonomies]
tags = ["devops", "terraform"]
+++

Your content here in markdown.

## Code blocks work

\`\`\`bash
echo "Hello, World!"
\`\`\`
EOF
```

## Design Philosophy

**Man-Page Aesthetic + CV Style:**
- Clean sans-serif body text (Liberation Sans)
- Monospace for code, timestamps, navigation
- Bold uppercase section headers (like man pages)
- Underlined links
- Max-width: 80 characters (terminal width)
- No JavaScript, minimal CSS
- Fast builds (<100ms)

**Content-First:**
- Zero client-side JavaScript
- Single CSS file (~120 lines)
- Semantic HTML5
- RSS feed auto-generated
- Syntax highlighting (optional)

## Blog Post Format

```markdown
+++
title = "Your Post Title"
date = 2025-11-18
[taxonomies]
tags = ["tag1", "tag2"]
+++

Your markdown content here.

## Section headers

Regular **markdown** _formatting_ works.

\`\`\`python
# Code blocks with syntax highlighting
def hello():
    print("Hello, World!")
\`\`\`
```

## RSS Feed

Automatically generated at `/rss.xml`

## Deployment

### GitHub Pages
```bash
zola build
# Push public/ directory to gh-pages branch
```

### Netlify/Vercel
```toml
# netlify.toml
[build]
  command = "zola build"
  publish = "public"

[build.environment]
  ZOLA_VERSION = "0.19.2"
```

### Simple deployment
```bash
zola build
rsync -avz public/ user@server:/var/www/html/
```

## Customization

### Change colors
Edit `static/style.css` - all styling in one file

### Add sections
Create new directories in `content/` with `_index.md`

### Modify templates
All templates in `templates/` use Tera syntax (like Jinja2)

## Performance

- Build time: <100ms for small sites
- No runtime dependencies
- Static HTML only
- Lighthouse score: 100/100

## See Also

- [Zola Documentation](https://www.getzola.org/documentation/)
- [Tera Template Engine](https://keats.github.io/tera/)
