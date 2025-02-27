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

# re-export penguin feature model as SXFM
transform-model() {
    io/gradlew -q -p io shadowJar
    java -jar "$SCRIPTS_DIRECTORY"/../io/io.jar "$SCRIPTS_DIRECTORY"/../penguin.uvl
}

# generate a uniform random sample of penguin configurations
create-sample(n) {
    if [[ ! -f "$SCRIPTS_DIRECTORY"/penguin.dimacs ]]; then
        error "Penguin feature model not generated yet."
    fi
    docker build "$SCRIPTS_DIRECTORY"  -q --platform linux/amd64 -t tikzpingurs_spur > /dev/null
    docker run --rm --platform linux/amd64 -v "$PWD":/home/tikzpingurs tikzpingurs_spur \
        spur/build/Release/spur -cnf tikzpingurs/"$SCRIPTS_DIRECTORY"/penguin.dimacs -s "$n" -out tikzpingurs/"$SCRIPTS_DIRECTORY"/penguin.spur > /dev/null
    docker run --rm -v "$PWD":/home/ -w /home python:3 python scripts/transform_sample.py
}

render(tex, target) {
    latexmk=(docker run --rm -v "$PWD":/home -w /home/scripts texlive/texlive latexmk)
    "${latexmk[@]}" -quiet -silent -pdf -pdflatex='pdflatex -interaction=batchmode -halt-on-error' "$tex" >/dev/null
    mv "$SCRIPTS_DIRECTORY"/"$tex".pdf "$target"
    "${latexmk[@]}" -quiet -silent -C "$tex" >/dev/null 2>&1
}

# render all the penguins in the sample as PDF files
render-each(sample) {
    if [[ ! -f "$sample" ]]; then
        error "Penguin sample not generated yet."
    fi
    i=1
    while read -r configuration; do
        echo "Rendering penguin #$i ..."
        sed "s/#body#/${configuration//\\/\\\\}/" "$SCRIPTS_DIRECTORY"/template.tex > "$SCRIPTS_DIRECTORY"/template.gen.tex
        sed -i "s/#options#//" "$SCRIPTS_DIRECTORY"/template.gen.tex
        render template.gen "$(dirname "$sample")"/$i.pdf
        i=$((i+1))
    done < "$sample"
}

# render a grid of all the penguins in the sample
render-grid(sample, columns) {
    if [[ ! -f "$sample" ]]; then
        error "Penguin sample not generated yet."
    fi
    i=1
    latexmk=(docker run --rm -v "$PWD"/scripts:/home -w /home texlive/texlive latexmk)
    cp "$SCRIPTS_DIRECTORY"/template.tex "$SCRIPTS_DIRECTORY"/template.gen.tex
    if [[ $columns -gt 0 ]]; then
        sed -i "s/#options#/varwidth=\\\\maxdimen/" "$SCRIPTS_DIRECTORY"/template.gen.tex
    else
        sed -i "s/#options#//" "$SCRIPTS_DIRECTORY"/template.gen.tex
    fi
    while read -r configuration; do
        sed -i "s/#body#/${configuration//\\/\\\\}#body#/" "$SCRIPTS_DIRECTORY"/template.gen.tex
        if [[ $columns -gt 0 && $((i % columns)) -eq 0 ]]; then
            sed -i "s/#body#/\\\\\\\\#body#/" "$SCRIPTS_DIRECTORY"/template.gen.tex
        fi
        i=$((i+1))
    done < "$sample"
    sed -i "s/#body#//" "$SCRIPTS_DIRECTORY"/template.gen.tex
    echo "Rendering penguin grid ..."
    render template.gen "$(dirname "$sample")"/grid.pdf
}

run(n=12, grid=4, each=) {
    rm -rf "$SCRIPTS_DIRECTORY"/../build
    mkdir -p "$SCRIPTS_DIRECTORY"/../build

    transform-model > "$SCRIPTS_DIRECTORY"/penguin.dimacs
    create-sample "$n" > "$SCRIPTS_DIRECTORY"/../build/sample.tex

    if [[ -n "$each" ]]; then
        render-each "$SCRIPTS_DIRECTORY"/../build/sample.tex
        docker run --rm -v "$PWD"/build:/work/files --platform linux/amd64 ghcr.io/bogosj/merge-pdfs
        mv "$SCRIPTS_DIRECTORY"/../build/output.pdf "$SCRIPTS_DIRECTORY"/../build/all.pdf
    fi

    if [[ "$grid" -gt 0 ]]; then
        render-grid "$SCRIPTS_DIRECTORY"/../build/sample.tex "$grid"
    fi
}