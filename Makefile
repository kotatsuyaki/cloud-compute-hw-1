.POSIX:
.PHONY: all
all: main.pdf
main.pdf: main.md
	pandoc main.md -o main.pdf --data-dir=. --template=eisvogel --pdf-engine=xelatex --listings
