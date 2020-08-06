# Makefile to assist in building site content
#
# in_file  ?= cv.md

.DEFAULT_GOAL := html

.PHONY: html
html:
	@ inji -t _layouts/base.html.j2 | \
		tidy -qi -utf8 --show-warnings yes > index.html

.PHONY: watch
watch:
	env=dev make html
	env=dev watchmedo shell-command --patterns="*.j2" --recursive \
		--command="cd $$PWD && make html"

.PHONY: serve
serve: html
	@ cd $$(git rev-parse --show-toplevel) && \
		python -m http.server 8000 --bind 0.0.0.0
