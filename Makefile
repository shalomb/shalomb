# Makefile to assist in building site content
#
# in_file  ?= cv.md

export PATH := $(PATH):/opt/buildhome/.local/bin:$(HOME)/.local/bin

.DEFAULT_GOAL := html

.PHONY: help
help:
	@ echo "Makefile targets for shalomb.id"
	@ echo ""
	@ echo "Site Build:"
	@ echo "  build          - Build entire site (deps + cv + html)"
	@ echo "  cv             - Build CV HTML"
	@ echo "  deps           - Install Python dependencies (inji)"
	@ echo "  html           - Generate site HTML from Jinja2 templates"
	@ echo "  serve          - Serve site on http://0.0.0.0:8000"
	@ echo "  tidy           - Clean up HTML formatting"
	@ echo "  watch          - Watch for changes and rebuild"
	@ echo ""
	@ echo "Blog (Zola):"
	@ echo "  blog-build         - Build blog to public/"
	@ echo "  blog-check         - Validate blog content and templates"
	@ echo "  blog-clean         - Remove public/ directory"
	@ echo "  blog-drafts        - List draft posts"
	@ echo "  blog-help          - Show blog-specific help"
	@ echo "  blog-install-zola  - Install latest Zola (auto-detects arch)"
	@ echo "  blog-list          - List all blog posts"
	@ echo "  blog-new           - Create new post (TITLE=\"...\" TAGS=\"...\")"
	@ echo "  blog-serve         - Start blog dev server on http://127.0.0.1:1111"
	@ echo ""
	@ echo "Usage examples:"
	@ echo "  make build                                    # Build entire site"
	@ echo "  make blog-serve                               # Preview blog locally"
	@ echo "  make blog-new TITLE=\"My Post\" TAGS=\"devops\" # Create new blog post"
	@ echo ""
	@ echo "See also: make blog-help for blog-specific targets"

.PHONY: deps
deps:
	pip3 install MarkupSafe==2.0.1
	pip3 install inji
	pip3 list
	which inji
	pip3 install --force-reinstall MarkupSafe==2.0.1
	pip3 install --force-reinstall -U 'importlib-metadata<5.0.0'
	inji --version

.PHONY: html html-tidy
html:
	inji _layouts/base.html.j2 > index.html
	inji _layouts/now.html.j2 > now/index.html
	rm -vfr cv/shalom_bhooshi-cv.pdf .git/
	find ./ -ls

.PHONY: cv
cv:
	cd cv/ && make html && ls -l *.html

.PHONY: build
build: deps cv html

tidy: html
	@ tidy -qi -utf8 --show-warnings yes < index.html > index.html.tidy
	@ mv index.html.tidy index.html

.PHONY: watch
watch:
	env=dev make html
	env=dev watchmedo shell-command --patterns="*.j2;*.md;*.css" --recursive \
		--command="cd $$PWD && make html"

.PHONY: serve
serve: html
	@ cd $$(git rev-parse --show-toplevel) && \
		python -m http.server 8000 --bind 0.0.0.0

# ========================================================================
# Blog (Zola) targets
# ========================================================================

# Zola version to install (update as needed)
ZOLA_VERSION ?= 0.19.2

.PHONY: blog-install-zola
blog-install-zola:
	@ echo "Installing Zola v$(ZOLA_VERSION)..."
	@ if command -v zola >/dev/null 2>&1; then \
		INSTALLED_VERSION=$$(zola --version | awk '{print $$2}' | sed 's/v//'); \
		if [ "$$INSTALLED_VERSION" = "$(ZOLA_VERSION)" ]; then \
			echo "Zola v$(ZOLA_VERSION) already installed at $$(which zola)"; \
			zola --version; \
			exit 0; \
		else \
			echo "Found Zola v$$INSTALLED_VERSION, upgrading to v$(ZOLA_VERSION)..."; \
		fi; \
	fi; \
	ARCH=$$(uname -m); \
	case $$ARCH in \
		x86_64) ZOLA_ARCH="x86_64-unknown-linux-gnu" ;; \
		aarch64|arm64) ZOLA_ARCH="aarch64-unknown-linux-gnu" ;; \
		armv7l) ZOLA_ARCH="armv7-unknown-linux-gnueabihf" ;; \
		*) echo "ERROR: Unsupported architecture: $$ARCH"; exit 1 ;; \
	esac; \
	ZOLA_URL="https://github.com/getzola/zola/releases/download/v$(ZOLA_VERSION)/zola-v$(ZOLA_VERSION)-$${ZOLA_ARCH}.tar.gz"; \
	echo "Detected architecture: $$ARCH ($$ZOLA_ARCH)"; \
	echo "Downloading from: $$ZOLA_URL"; \
	TMP_DIR=$$(mktemp -d); \
	cd $$TMP_DIR && \
	curl -fsSL "$$ZOLA_URL" -o zola.tar.gz && \
	tar xzf zola.tar.gz && \
	if [ -w /usr/local/bin ]; then \
		echo "Installing to /usr/local/bin/zola (system-wide)"; \
		mv zola /usr/local/bin/zola; \
	elif sudo -n true 2>/dev/null; then \
		echo "Installing to /usr/local/bin/zola (with sudo)"; \
		sudo mv zola /usr/local/bin/zola; \
	else \
		echo "Installing to ~/.local/bin/zola (user-local)"; \
		mkdir -p ~/.local/bin; \
		mv zola ~/.local/bin/zola; \
		echo ""; \
		echo "NOTE: Ensure ~/.local/bin is in your PATH"; \
		echo "Add to ~/.bashrc or ~/.zshrc:"; \
		echo "  export PATH=\"\$$HOME/.local/bin:\$$PATH\""; \
	fi; \
	cd - >/dev/null; \
	rm -rf $$TMP_DIR; \
	echo ""; \
	echo "Zola installed successfully:"; \
	zola --version

.PHONY: blog-serve
blog-serve:
	@ command -v zola >/dev/null 2>&1 || { echo "ERROR: zola not installed. See ZOLA_SETUP.md"; exit 1; }
	zola serve

.PHONY: blog-build
blog-build:
	@ command -v zola >/dev/null 2>&1 || { echo "ERROR: zola not installed. See ZOLA_SETUP.md"; exit 1; }
	zola build

.PHONY: blog-check
blog-check:
	@ command -v zola >/dev/null 2>&1 || { echo "ERROR: zola not installed. See ZOLA_SETUP.md"; exit 1; }
	zola check

.PHONY: blog-clean
blog-clean:
	rm -rf public/

# Create a new blog post with today's date
# Usage: make blog-new TITLE="My Post Title" TAGS="tag1,tag2"
.PHONY: blog-new
blog-new:
	@ test -n "$(TITLE)" || { echo "Usage: make blog-new TITLE=\"Post Title\" [TAGS=\"tag1,tag2\"]"; exit 1; }
	@ SLUG=$$(echo "$(TITLE)" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/--*/-/g' | sed 's/^-//' | sed 's/-$$//'); \
	DATE=$$(date +%Y-%m-%d); \
	FILE="content/blog/$${DATE}-$${SLUG}.md"; \
	TAGS="$${TAGS:-draft}"; \
	echo "Creating $$FILE"; \
	echo "+++" > $$FILE; \
	echo "title = \"$(TITLE)\"" >> $$FILE; \
	echo "date = $$DATE" >> $$FILE; \
	echo "[taxonomies]" >> $$FILE; \
	echo "tags = [$$(echo $$TAGS | sed 's/,/", "/g' | sed 's/^/"/;s/$$/"/')]" >> $$FILE; \
	echo "+++" >> $$FILE; \
	echo "" >> $$FILE; \
	echo "Write your content here..." >> $$FILE; \
	echo "" >> $$FILE; \
	cat $$FILE

.PHONY: blog-list
blog-list:
	@ echo "Blog posts:"; \
	ls -1 content/blog/*.md 2>/dev/null | grep -v _index.md | sort -r || echo "No posts found"

.PHONY: blog-drafts
blog-drafts:
	@ echo "Draft posts (tagged 'draft'):"; \
	grep -l 'tags = \[.*"draft".*\]' content/blog/*.md 2>/dev/null || echo "No drafts found"

.PHONY: blog-help
blog-help:
	@ echo "Blog (Zola) targets:"
	@ echo "  blog-build         - Build static site to public/"
	@ echo "  blog-check         - Validate content and templates"
	@ echo "  blog-clean         - Remove public/ directory"
	@ echo "  blog-drafts        - List draft posts"
	@ echo "  blog-help          - Show this help"
	@ echo "  blog-install-zola  - Install latest Zola from GitHub (auto-detects arch)"
	@ echo "  blog-list          - List all blog posts"
	@ echo "  blog-new           - Create new post: make blog-new TITLE=\"Post Title\" TAGS=\"tag1,tag2\""
	@ echo "  blog-serve         - Start Zola dev server with live reload (http://127.0.0.1:1111)"
