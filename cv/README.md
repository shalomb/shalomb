# Overview

This directory contains the source to build [https://shalomb.id/cv](https://shalomb.id/cv)

- Curriculum Vitae (not resume) managed entirely in git
- Managed as source in markdown (see [cv.md](./cv.md))
- Distributed in various output formats (pdf, docx, txt, etc) built using [pandoc](https://pandoc.ord)
- [HTML version](https://shalomb.id/cv/) styled with [css](./style.css)


The [Makefile](./Makefile) provides these targets for easy management
```
make dev       # Build HTML with live reload (then: npm run serve / watch)
make html      # Build the HTML page only
make all       # Build all formats using pandoc
make dist      # Build all formats and collect them in dist/
make clean     # Clean up generated files
```

Generated outputs are not committed to git; they are built from `cv.md`.

Please feel free to fork and/or make pull-requests for improvements
