GNU nano 2.5.3                                              File: README.md                                                                                         Modified  


## TAKEN AND MODIFIED FROM ERIN'S SZ_PINT.

#note: you must update the file called  _bookdown.yml with a list of what to knit into the bookdown.

# These notebooks contain a workflow for SPINS PLS Connectivity.

These are collected into an bookdown book.

To render the book:

```sh
module load R/3.5.0 rstudio
```

## make sure the current working directory is set to SPINS_PLS_Conn/notebooks/Rmd
This part of the script will remove any existing reports and overwrite them with new bookdown.

```sh
rm -rf ../../reports/Rmd_rendered/*
rm SPINS_PLS_Conn_bookdown.*
rm 0*.md
```
Then open up rstudio and run this line :)
```{r}
bookdown::render_book('index.Rmd', output_format = "bookdown::gitbook", output_dir = '../../reports/Rmd_rendered')
```
