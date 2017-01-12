formats <- commandArgs(TRUE)

options(warn=1)

# provide default formats if necessary
if (length(formats) == 0)
	formats <- "bookdown::gitbook" #c('bookdown::pdf_book', 'bookdown::gitbook')

# render the book to all formats
for (fmt in formats)
  bookdown::render_book("index.Rmd",fmt,quiet=FALSE)

# Publish to OTexts
#if (length(formats) > 1) bookdown::publish_book()
