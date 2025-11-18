# Makefile to assist in building site content
#
# in_file  ?= cv.md

export PATH := $(PATH):/opt/buildhome/.local/bin:$(HOME)/.local/bin

.DEFAULT_GOAL := html

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
	@ echo "  blog-serve     - Start Zola dev server with live reload (http://127.0.0.1:1111)"
	@ echo "  blog-build     - Build static site to public/"
	@ echo "  blog-check     - Validate content and templates"
	@ echo "  blog-clean     - Remove public/ directory"
	@ echo "  blog-new       - Create new post: make blog-new TITLE=\"Post Title\" TAGS=\"tag1,tag2\""
	@ echo "  blog-list      - List all blog posts"
	@ echo "  blog-drafts    - List draft posts"
	@ echo "  blog-help      - Show this help"
