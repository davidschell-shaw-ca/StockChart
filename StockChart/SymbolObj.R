setClass(Class="SymbolObj",representation(Symbol="character",Extension="character",FQS="character", Company="character", Title="character"))

getSymbol <- function(Symbol)
{
  sym <- Symbol
  extension <- ''
  company <- ''
  
  symbol <- toupper(Symbol)
  if ((grepl(".V",symbol,fixed=TRUE) == TRUE) || (grepl(".T",symbol,fixed=TRUE) == TRUE) || (grepl(".C",symbol,fixed=TRUE) == TRUE))
  {
    if (grepl(".V",symbol,fixed=TRUE) == TRUE)
    {
      extension = "CVE"
      sym <- sub(".V","",symbol,fixed=TRUE)
    }
    else if (grepl(".T",symbol,fixed=TRUE) == TRUE)
    {
      extension = "TSE"
      sym <- sub(".T","",symbol,fixed=TRUE)
    }
    else
    {
      extension = "CNSX"
      sym <- sub(".C","",symbol,fixed=TRUE)  
    }

    # Construct URL
    url <- paste('https://www.google.ca/finance?q=',extension,'%3A',sym,sep='')
  
    # Get webpage
    thePage <- readLines(url)
  
    # Function to extract specific data
    getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
  
    # Extract Date Data
    pattern = '<div class="g-unit g-first"><h3>([^<]*)'
    company = grep(pattern,thePage,value=TRUE)
    gg = gregexpr(pattern,company)
    matches = mapply(getexpr,company,gg)
    result = as.character(gsub(pattern,'\\1',matches))
  
    company <- gsub("&nbsp;","",result[1],fixed=TRUE)
  
  }
  
  fqs <- paste(sym,":",extension,sep='')
  title <- paste(company,' (', fqs, ')',sep='')
  new("SymbolObj", Symbol=sym,Extension=extension,FQS=fqs,Company=company,Title=title)
}
