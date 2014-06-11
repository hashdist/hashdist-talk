## HashDist Talk
## About this Repository

This repository contains only the source text for building the presentation, `slides.md`, but you will find the file 
to be perfectly readable.  The slides are written in pandoc Markdown (built with syntax highlighting enabled), and 
are converted to html with the following command: 

    pandoc --slide-level 2 -t slidy  --standalone --self-contained  -s slides.md -o slides.html
