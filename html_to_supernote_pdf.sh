#!/bin/bash
set -e

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 input.html"
    exit 1
fi

input_html="$1"
basename=$(basename "$input_html" .html)
output_tex="${basename}_supernote.tex"
output_pdf="${basename}_supernote.pdf"
log_file="${basename}_conversion.log"

# Step 1: Convert HTML to LaTeX Fragment
# Using -t latex (without -s) creates a fragment, avoiding preamble conflicts
echo "Converting HTML to LaTeX fragment..."
pandoc "$input_html" -f html -t latex -o "fragment.tex" --extract-media=./media 2>> "$log_file"

# Step 2: Create the custom Supernote-optimized LaTeX file
echo "Assembling LaTeX file for Supernote (144mm x 187mm)..."
{
    echo '\documentclass[12pt]{article}' # Slightly larger base font for e-ink
    echo '\usepackage[czech]{babel}'
    echo '\usepackage[T1]{fontenc}'
    echo '\usepackage[utf8]{inputenc}'
    echo '\usepackage{concmath}'
    # Adjusted geometry: Supernote A5X/A6X sizes
    echo '\usepackage[paperwidth=144mm, paperheight=187mm, margin=12mm]{geometry}'
    echo '\usepackage{graphicx}'
    echo '\usepackage{hyperref}'
    echo '\usepackage{microtype}' # Better spacing/kerning
    echo '\pagestyle{empty}'      # Removes page numbers for a cleaner look
    echo '\providecommand{\tightlist}{%'
    echo '  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}' 
    echo '\begin{document}'
    cat "fragment.tex"
    echo '\end{document}'
} > "$output_tex"

# Step 3: Compile LaTeX to PDF
echo "Compiling to PDF..."
# Running twice ensures hyperref links and geometry are calculated correctly
pdflatex -interaction=batchmode "$output_tex" >> "$log_file" 2>&1
pdflatex -interaction=batchmode "$output_tex" >> "$log_file" 2>&1

if [ $? -eq 0 ]; then
    rm fragment.tex
    # Clean up auxiliary files
    rm -f "${basename}_supernote.aux" "${basename}_supernote.log" "${basename}_supernote.out"
    echo "Success! Output saved to $output_pdf"
else
    echo "Error: LaTeX compilation failed. Check $log_file for details."
    exit 1
fi
