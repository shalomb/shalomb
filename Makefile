# Makefile to assist in building site content
#
# in_file  ?= cv.md

export PATH := $(PATH):/opt/buildhome/.local/bin:$(HOME)/.local/bin

.DEFAULT_GOAL := html

.PHONY: deps
deps:
	pip3 install inji
	pip3 list
	which inji
	inji --version

.PHONY: html html-tidy
html:
	inji _layouts/base.html.j2 > index.html

.PHONY: build
build: deps html

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
