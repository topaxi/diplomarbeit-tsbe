all: pdf icml

clean: src/title.md src/dipl.md
	rm -rf dist && mkdir dist

pdf: clean src/title.md src/dipl.md
	pandoc -s src/title.md src/dipl.md -o dist/dipl.pdf

icml: clean src/title.md src/dipl.md
	pandoc -s src/title.md src/dipl.md -o dist/dipl.icml
