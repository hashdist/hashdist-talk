#!/usr/bin/env bash
pandoc --slide-level 2 -t slidy  --standalone --self-contained  -s slides.md -o slides.html
