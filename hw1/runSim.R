## parsing command arguments
MSE_data <- data.frame("Prime" = 0, "Classic" = 0, stringsAsFactors = FALSE)

for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

set.seed(seed)

for (number in 1:rep) {
## check if a given integer is prime
isPrime = function(n) {
  if (n <= 3) {
    return (TRUE)
  }
  if (any((n %% 2:floor(sqrt(n))) == 0)) {
    return (FALSE)
  }
  return (TRUE)
}

## estimate mean only using observation with prime indices
estMeanPrimes = function(x) {
  n = length(x)
  ind = sapply(1:n, isPrime)
  return (mean(x[ind]))
}

# simulate data
if (dist == "gaussian"){
  x = rnorm(n)
}
if (dist == "t1"){
  x = dt(n, 1)
}
if (dist == "t5"){
  x = dt(n, 5)
}

# estimate mean
primeMean = estMeanPrimes(x)
classicMean = mean(x)
# adding observations to data frame used to calculate MSE
MSE_data <- rbind(MSE_data, c(primeMean, classicMean))
}

PrimeMSEValue <- sum((MSE_data$Prime-0)^2)/rep
ClassicMSEValue <- sum((MSE_data$Classic-0)^2)/rep
MSE_final <- c(PrimeMSEValue, ClassicMSEValue)
print(MSE_final)