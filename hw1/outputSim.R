#outputSim.R
# grabbing list of outputted files
txtFiles <- list.files(path = "~/biostat-m280-2019-winter/hw1/", pattern = "n.*txt")
txtFiles <- txtFiles[1:30]

# creating lists that will be merged together into final table
nTable <- rev(seq(100, 1000, by=100))
t5TableP <- list()
t1TableP <- list()
gaussTableP <- list()
t5TableC <- list()
t1TableC <- list()
gaussTableC <- list()
methodTableP <- rep("PrimeAvg", 10)
methodTableC <- rep("SampleAvg", 10)

for (f in txtFiles) {
  # extracting N value from file name
  if (is.na((as.numeric((substr(f, 2, 5))))) == TRUE) {
    N <- substr(f, 2, 4)
    # at the same time, determining dist type from file name
    dist <- sub(".*dist", "", f)
    dist <- gsub(".txt", "", dist)
  } else {
    N <- substr(f, 2, 5)
    dist <- sub(".*dist", "", f)
    dist <- gsub(".txt", "", dist)
  }
  # scanning MSE values from file outputs
  tempData = scan(f, what="integer")
  # creating list of MSE values based on dist type
  if (dist == "gaussian") {
    gaussTableP <- c(gaussTableP, tempData[2])
    gaussTableC <- c(gaussTableC, tempData[3])
  }
  if (dist == "t1") {
    t1TableP <- c(t1TableP, tempData[2])
    t1TableC <- c(t1TableC, tempData[3])
  }
  if (dist == "t5") {
    t5TableP <- c(t5TableP, tempData[2])
    t5TableC <- c(t5TableC, tempData[3])
  }
}

# combining lists of prime MSE values and smaple MSE values
methodTable <- list(methodTableP, methodTableC)
gaussTable <- list(gaussTableP, gaussTableC)
t5Table <- list(t5TableP, t5TableC)
t1Table <- list(t1TableP, t1TableC)

# converting lists to data frames and giving column names
dataN <- data.frame(matrix(unlist(nTable), byrow=T),stringsAsFactors=FALSE)
colnames(dataN) <- "N"
dataMethod <- data.frame(matrix(unlist(methodTable), byrow=T),stringsAsFactors=FALSE)
colnames(dataMethod) <- "Method"
dataGauss <- data.frame(matrix(unlist(gaussTable), byrow=T),stringsAsFactors=FALSE)
colnames(dataGauss) <- "Gaussian"
dataT5 <- data.frame(matrix(unlist(t5Table), byrow=T),stringsAsFactors=FALSE)
colnames(dataT5) <- "T5"
dataT1 <- data.frame(matrix(unlist(t1Table), byrow=T),stringsAsFactors=FALSE)
colnames(dataT1) <- "T1"

# merging data frames together
final <- cbind(dataN, dataMethod)
final <- cbind(final, dataGauss)
final <- cbind(final, dataT5)
final <- cbind(final, dataT1)
# generating final table/matrix
print(final)