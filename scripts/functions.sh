#!/bin/bash

error(arguments...) {
    echo "ERROR: ${arguments[*]}" 1>&2
    exit 1
}

initialize(arguments...) {
    if [[ -z "${arguments[*]}" ]]; then
        arguments=(run)
    fi
    function=${arguments[0]}
    "$function" "${arguments[@]:1}"
}

# generate a uniform random sample of penguin configurations
create-sample(n) {
    if [[ ! -f "$SCRIPTS_DIRECTORY"/penguin.xml ]]; then
        error "Penguin feature model not generated yet."
    fi
    sed -i 's/(.*$//' "$SCRIPTS_DIRECTORY"/penguin.xml
    docker build "$SCRIPTS_DIRECTORY" -q --platform linux/amd64 -t tikzpingurs > /dev/null
    docker run --rm --platform linux/amd64 tikzpingurs "$n" | grep -v \\.$
}

# render all the penguins in the sample as PDF files
render-penguins(sample) {
    if [[ ! -f "$sample" ]]; then
        error "Penguin sample not generated yet."
    fi
    i=1
    latexmk=(docker run --rm -v "$PWD"/scripts:/home -w /home texlive/texlive latexmk)
    while read -r configuration; do
        echo "Rendering penguin #$i ..."
        sed "s/#/${configuration//\\/\\\\}/" "$SCRIPTS_DIRECTORY"/template.tex > "$SCRIPTS_DIRECTORY"/template.gen.tex
        "${latexmk[@]}" -quiet -silent -pdf -pdflatex='pdflatex -interaction=batchmode -synctex=1 -halt-on-error' template.gen.tex #>/dev/null
        mv "$SCRIPTS_DIRECTORY"/template.gen.pdf "$(dirname "$sample")"/$i.pdf
        "${latexmk[@]}" -quiet -silent -C template.tex >/dev/null 2>&1
        "${latexmk[@]}" -quiet -silent -C template.gen.tex >/dev/null 2>&1
        rm -rf "$SCRIPTS_DIRECTORY"/template.gen.*
        i=$((i+1))
    done < "$sample"
}

run(n=2) {
    rm -rf "$SCRIPTS_DIRECTORY"/../build
    mkdir -p "$SCRIPTS_DIRECTORY"/../build
    create-sample "$n" > "$SCRIPTS_DIRECTORY"/../build/sample.tex
    render-penguins "$SCRIPTS_DIRECTORY"/../build/sample.tex
    docker run --rm -v "$PWD"/build:/work/files --platform linux/amd64 ghcr.io/bogosj/merge-pdfs
}