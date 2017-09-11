getTAList <- function(){
  c("ADX", "BBands", "EMA", "CCI","RSI", "MACD", "Momentum", "MFI","SMA", "WMA"  )
}

getTA <- function(indicators){
  
  # Volume always added.
  indicatorList <- 'addVo()'
  
  if ('BBands' %in% indicators)
    indicatorList <- paste(indicatorList,';addBBands()')
  
  if ('MFI' %in% indicators)
    indicatorList <- paste(indicatorList,';addMFI()')
  
  if ('RSI' %in% indicators)
    indicatorList <- paste(indicatorList,';addRSI()')
  
  if ('CCI' %in% indicators)
    indicatorList <- paste(indicatorList,';addCCI()')
  
  if ('EMA' %in% indicators)
    indicatorList <- paste(indicatorList,';addEMA()') 
  
  if ('SMA' %in% indicators)
    indicatorList <- paste(indicatorList,';addSMA()')  
  
  if ('WMA' %in% indicators)
    indicatorList <- paste(indicatorList,';addWMA()') 
  
  if ('MACD' %in% indicators)
    indicatorList <- paste(indicatorList,';addMACD()') 
  
  if ('ADX' %in% indicators)
    indicatorList <- paste(indicatorList,';addADX()')
  
  if ('Momentum' %in% indicators)
    indicatorList <- paste(indicatorList,';addMomentum()')
  
  indicatorList
}