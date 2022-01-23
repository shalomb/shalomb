# Makefile to generate output formats of cv.html
#
# in_file  ?= cv.md

.DEFAULT_GOAL := all

ifeq (,$(in_file))
    $(warning in_file '$(in_file)' not set in $(origin in_file))
    ifneq (,$(wildcard cv.md))
        in_file := cv.md
    else ifneq (,$(wildcard cv.mkd))
        in_file := cv.mkd
    else ifneq (,$(wildcard cv.markdown))
        in_file := cv.markdown
    endif
endif

ifeq (,$(findstring md,$(in_file)))
    $(error in_file '$(in_file)' is not a markdown file?)
endif

$(warning in_file '$(in_file)' set in $(origin in_file))
# .PHONY: out_file = $(in_file)
out_file := $(in_file:.md=)
$(warning out_file base_name '$(out_file)' set in $(origin out_file))

check_defined = \
    $(foreach 1,$1,$(__check_defined))
__check_defined = \
    $(if $(value $1),, \
      $(error Variable/Flag '$1$(if $(value 2), ($(strip $2)))' is undefined.))

$(call check_defined, in_file)
$(call check_defined, out_file)

.PHONY: txt
txt: $(in_file)
	pandoc -s $(in_file) -f markdown -t plain -o $(out_file).txt \
		--tab-stop=2 --columns=78

.PHONY: odt
odt: $(in_file)
	pandoc -s $(in_file) -f markdown -t odt   -o $(out_file).odt

.PHONY: tex
tex: $(in_file)
	pandoc -s $(in_file) -f markdown -t tex   -o $(out_file).tex

.PHONY: docx
docx: $(in_file)
	pandoc -s $(in_file) -f markdown -t docx  -o $(out_file).docx

.PHONY: rtf
rtf: $(in_file)
	pandoc -s $(in_file) -f markdown -t rtf   -o $(out_file).rtf

.PHONY: lander
lander:
	ln -sf cv.html index.html || true

.PHONY: html
html: lander $(in_file)
	pandoc -s $(in_file) -f markdown -t html5 -o $(out_file).html \
		--toc -c style.css --template=default.html5

# aptitude install texlive-xetex texlive-fonts-recommended lmodern
.PHONY: pdf
pdf: $(in_file)
	pandoc -s \
		--variable geometry:margin=1in        \
		--highlight-style=tango               \
		--variable mainfont="Liberation Sans" \
		--variable sansfont="Liberation Sans" \
		--variable monofont="Liberation Mono" \
		--variable fontsize=11pt              \
		--variable version=1.10               \
		--highlight-style=tango               \
		--pdf-engine=xelatex                  \
		$(in_file) -o $(out_file).pdf
	ln -svf $(out_file).pdf shalom_bhooshi-cv.pdf

.PHONY: webpdf
webpdf: $(in_file)
	wkhtmltopdf --print-media-type --orientation portrait --page-size A4 \
		--encoding UTF-8 -L 20mm -R 20mm -T 20mm -B 20mm \
		$(out_file).html $(out_file).web.pdf

.PHONY: clean
clean:
	rm -f $(out_file).txt $(out_file).odt $(out_file).docx $(out_file).rtf \
		$(out_file).html $(out_file).pdf $(out_file).web.pdf

.PHONY: release
release: all
	git add cv.*
	git commit -m "Build binaries - $$(date)"
	git push --all
	git push --tags

.PHONY: all
all: html odt docx rtf txt pdf
