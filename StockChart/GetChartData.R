getChartData <- function(Sym, Extension){
  
  # Construct URL
  url <- paste('https://www.google.ca/finance/historical?q=',Extension,'%3A',Sym,'&ei=_U2fWeiYJISs2AaDhKu4Bg&start=0&num=90',sep='')
  
  # Get webpage
  thePage <- readLines(url)
  
  # Start of the data index
  startIndex <- grep('<div id=prices',thePage)
  
  # Extract start of data to end of page
  table <- thePage[c(startIndex:length(thePage))]
  
  # End of data index
  endIndex <- grep('</table',table)-1
  
  # Start of data index
  startIndex <- grep('<tr>',table)[1]
  
  # Extract data
  table <- table[c(startIndex:endIndex)]
  
  # Function to extract specific data
  getexpr = function(s,g)substring(s,g,g+attr(g,'match.length')-1)
  
  # Extract Date Data
  dPattern = '<td class="lm">([^<]*)'
  dateVector = grep(dPattern,table,value=TRUE)
  dgg = gregexpr(dPattern,dateVector)
  dmatches = mapply(getexpr,dateVector,dgg)
  dresult = as.Date(gsub(dPattern,'\\1',dmatches),"%b %d, %Y")
  names(dresult) = NULL
  dData = as.data.frame(dresult)
  names(dData) = c('Date')
  
  # Extract Numeric Real Data
  nPattern = '<td class="rgt">([^<]*)'
  numericVector = grep(nPattern,table,value=TRUE)
  ngg = gregexpr(nPattern,numericVector)
  nmatches = mapply(getexpr,numericVector,ngg)
  nresult = as.numeric( gsub(nPattern,'\\1',nmatches))
  names(nresult) = NULL
  nData = as.data.frame(matrix(nresult,ncol=4,byrow=TRUE))
  names(nData) = c('Open','High','Low','Close')
  
  # Extract Numeric long Data
  lPattern = '<td class="rgt rm">([^<]*)'
  longVector = grep(lPattern,table,value=TRUE)
  lgg = gregexpr(lPattern,longVector)
  lmatches = mapply(getexpr,longVector,lgg)
  lresult = as.numeric( gsub(",","",gsub(lPattern,'\\1',lmatches)))
  names(lresult) = NULL
  lData = as.data.frame(lresult)
  names(lData) = c('Volume')
  
  # Create data frame to combine all data into specific structure Date, OHLC, Volume
  all_df <- data.frame(dData,nData,lData)
  
  # Convert to time series and daily OHLC object
  data_xts <- as.xts(all_df[,-1],order.by=as.POSIXct(all_df$Date))
  to.daily(data_xts)
  
}

