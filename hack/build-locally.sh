#!/bin/bash

# navigating to project root
cd "$(dirname ${0})/.."

outdir=build-$(date +"%y-%m-%d")

echo "creating dir ${outdir}"
mkdir ${outdir}

for FILE in $(find . -type f -name '*.tex')
do
    tex_file=$(basename ${FILE})
    result_pdf=$(echo ${tex_file} | sed "s/tex/pdf/g")

    pushd $(dirname ${FILE}) &> /dev/null
        echo "begin building ${tex_file}..."
        latexmk -interaction=nonstopmode -pdf ${tex_file} &> /dev/null
        latexmk -c &> /dev/null
        mv ${result_pdf} ../${outdir}/$(dirname ${FILE})_${result_pdf}
        echo "done building ${tex_file}"
    popd &> /dev/null
    echo ""
done

echo "build is done"
