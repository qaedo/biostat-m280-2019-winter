# autoSim.R

for (arg in commandArgs(TRUE)) {
  eval(parse(text=arg))
}

nVals <- seq(100, 1000, by=100)

for (n in nVals) {
  for (dist in c("gaussian", "t1", "t5")) {
    oFile <- paste("n", n, "dist", dist, ".txt", sep="")
    sysCall <- paste("nohup Rscript runSim.R seed=", seed, " rep=", rep, " n=", n, 
                    " dist=", shQuote(shQuote(dist)), " > ", oFile, sep="")
    system(sysCall)
    print(paste("sysCall=", sysCall, sep=""))
  }
}