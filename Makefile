hw2: ./hw2/hw2.Rmd
  Rscript -e 'rmarkdown::render("$<")'
  
clean:
  rm -rf *.html *.md