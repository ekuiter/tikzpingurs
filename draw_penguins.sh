#!/usr/bin/env bash
rm -rf pingus
mkdir -p pingus
i=1
latexmk=(docker run --rm -v $(pwd)/:/home -w /home texlive/texlive latexmk)
while read -r configuration; do
    echo "Drawing penguin #$i ..."
	"${latexmk[@]}" -quiet -silent -C tex/pingu.gen >/dev/null 2>&1
    sed "s/#/$configuration/" tex/pingu.tex > tex/pingu.gen.tex
    "${latexmk[@]}" -quiet -silent -pdf -pdflatex='pdflatex -interaction=batchmode -synctex=1 -halt-on-error' tex/pingu.gen >/dev/null
    mv tex/pingu.gen.pdf pingus/$i.pdf
    i=$((i+1))
done < sample.txt