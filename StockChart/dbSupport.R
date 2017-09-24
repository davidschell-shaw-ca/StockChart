library(RODBC)
#source('SymbolObj.R')

NOID <- -1

# Returns the Database Connection
databaseConnection <- function(){
  odbcDriverConnect('driver={SQL Server};server=24.108.169.201;database=SecuritesDB;uid=TAUser;pwd=Arxjar98')
}

# Refresh the history
refreshHistory <- function(theMetaData, theData){
  
  # Open a database connection.
  cn <- databaseConnection()

  # Get the company Id
  companyId <- getCompanyId(cn, theMetaData)
  
  # Close the database connection
  odbcClose(cn)
  
  TRUE
  
}

getCompanyId <- function(cn, theMetaData){
  
  # Get the companyId
  companyData <- sqlQuery(cn, paste0("SELECT companyId FROM tblCompany WHERE Symbol='", theMetaData@Symbol, "'"))
  
  # If data does not exist.
  if (nrow(companyData) == 0){
    insert = paste0("INSERT INTO tblCompany (Company,Symbol,ExchangeId) VALUES('",theMetaData@Company,"','",theMetaData@Symbol,"',",theMetaData@ExchangeId,")")
    dumRet <- sqlQuery(cn, insert)
    companyData <- sqlQuery(cn, paste0("SELECT * from tblCompany WHERE Symbol='", theMetaData@Symbol, "'"))
  }
  
  companyId = NOID
  if (nrow(companyData) != 0)
    companyId = companyData[1]
  
}
