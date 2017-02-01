library(fpp2)

# Check if model has already been fitted
isnewmodel <- function(k1,k2,results)
{
  if(k1<0 | k2<0)
    return(FALSE)
  n <- nrow(results)
  for(i in 1:n)
  {
    if(identical(c(k1,k2),results[i,1:2]))
      return(FALSE)
  }
  return(TRUE)
}


nextbest <- function(results, print=TRUE)
{
  # Check inputs
  best <- which.min(results[,3])
  bestaicc <- results[best,3]
  i <- results[best,1]
  j <- results[best,2]
  k <- NROW(results)

  # First increase orders
  # Bottom right
  if(isnewmodel(i+1,j+1,results))
  {
    aicc <- fitmodel(i+1,j+1, print=print)
    results <- rbind(results,c(i+1,j+1,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Bottom centre
  if(isnewmodel(i+1,j,results))
  {
    aicc <- fitmodel(i+1,j, print=print)
    results <- rbind(results,c(i+1,j,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Centre right
  if(isnewmodel(i,j+1,results))
  {
    aicc <- fitmodel(i,j+1, print=print)
    results <- rbind(results,c(i,j+1,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Now try decreasing orders
  # Top centre
  if(i > 0 & isnewmodel(i-1,j,results))
  {
    aicc <- fitmodel(i-1,j, print=print)
    results <- rbind(results,c(i-1,j,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Centre left
  if(j > 0 & isnewmodel(i,j-1,results))
  {
    aicc <- fitmodel(i,j-1, print=print)
    results <- rbind(results,c(i,j-1,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Top right
  if(i > 0 & isnewmodel(i-1,j+1,results))
  {
    k <- k+1
    aicc <- fitmodel(i-1,j+1, print=print)
    results <- rbind(results,c(i-1,j+1,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Bottom left
  if(j > 0 & isnewmodel(i+1,j-1,results))
  {
    k <- k+1
    aicc <- fitmodel(i+1,j-1, print=print)
    results <- rbind(results,c(i+1,j-1,aicc))
    if(aicc < bestaicc)
      return(results)
  }
  # Top left
  if(j > 0 & i > 0 & isnewmodel(i-1,j-1,results))
  {
    aicc <- fitmodel(i-1,j-1, print=print)
    results <- rbind(results,c(i-1,j-1,aicc))
    if(aicc < bestaicc)
      return(results)
  }

  # Can't find anything better than current model
  return(results)
}

# Function to fit model and return criterion (to be minimized)
fitmodel <- function(k1, k2, print=TRUE)
{
  if(k1==0 & k2==0)
    out <- Arima(calls, order=c(2,0,2), lambda=0)$aicc
  else
    out <- Arima(calls, order=c(2,0,2), lambda=0,
                 xreg=fourier(calls,K=c(k1,k2)))$aicc
  if(print)
    print(c(k1,k2,out))
  return(out)
}

# Cycle through many models in a step-wise fashion starting with startk1 and startk2
startk1 <- 10
startk2 <- 10
results <- matrix(c(startk1,startk2,fitmodel(startk1,startk2)), nrow=1)
newmodels <- TRUE
print <- TRUE

while(newmodels)
{
  oldresults <- results
  results <- nextbest(results, print=print)
  if(NROW(results) > 100)
    break;
  newmodels <- !identical(results,oldresults)
}

print(results)

save(results, file='~/Dropbox/results.rda')



