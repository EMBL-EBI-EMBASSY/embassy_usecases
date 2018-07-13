# Makefile for generating gh-pages
#

.PHONY: help gh-pages

help:
	@echo "Please use \`make <target>' where <target> is one of"
	@echo "  gh-pages   to make github pages"

gh-pages:
	git checkout gh-pages
	rm -rf build _sources _static
	git checkout master docs
	git reset HEAD
	(cd docs && make html)
	mv -fv docs/build/html/* ./
	rm -rf docs
	git add -A
	git commit -m "Generated gh-pages for `git log master -1 --pretty=short --abbrev-commit`" && git push origin gh-pages ; git checkout master
