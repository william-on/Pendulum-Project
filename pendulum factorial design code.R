swingData <- read.csv("part2 Data.csv")
swingDataFull <- swingData[1:16,1:5]

avgData <- swingData[1:8, 8:12]
names(avgData)[2] <- "Avg Period"

### functions for calculating main effects 

mainEffectSL <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(2,4,6,8)){
    effect <- dataTable[i,2] - dataTable[i-1, 2] 
    emptyEffect <- append(emptyEffect, effect)
  }
  return(emptyEffect)
}


mainEffectMas <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(3,4,7,8)){
    effect <- dataTable[i,2] - dataTable[i-2, 2] 
    emptyEffect <- append(emptyEffect, effect)
  }
  return(emptyEffect)
}

mainEffectAmp <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(5,6,7,8)){
    effect <- dataTable[i,2] - dataTable[i-4, 2] 
    emptyEffect <- append(emptyEffect, effect)
  }
  return(emptyEffect)
}


avgMainEffSL <- mean(mainEffectSL())
avgMainEffMA <- mean(mainEffectMas())
avgMainEffAM <- mean(mainEffectAmp())

 
### Functions for calculating interaction effects 

intEffectSLAmp <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(1,5)){
    effect <- (dataTable[i+1,2] + dataTable[i+3, 2])/2 - (dataTable[i,2] + dataTable[i+2, 2])/2 
    emptyEffect <- append(emptyEffect, effect)
  }
  emptyEffect <- (emptyEffect[2] - emptyEffect[1])/2
  return(emptyEffect)
}


intEffectSLMass <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(1,3)){
    effect <- (dataTable[i+5, 2] + dataTable[i + 1, 2])/2 - (dataTable[i + 4, 2] + dataTable[i, 2])/2 
    emptyEffect <- append(emptyEffect, effect)
  }
  emptyEffect <- (emptyEffect[1] - emptyEffect[2]) / 2
  return(emptyEffect)
}

intEffectMassAmp <- function(dataTable = avgData){
  emptyEffect <- numeric()
  for (i in c(1,3)){
    effect <- (dataTable[i+5, 2] + dataTable[i + 4, 2])/2 - (dataTable[i, 2] + dataTable[i + 1, 2])/2 
    emptyEffect <- append(emptyEffect, effect)
  }
  emptyEffect <- (emptyEffect[1] - emptyEffect[2])/2
  return(emptyEffect)
}

tripleEff <- function(dataTable=avgData){
  emptyEffect <- numeric()
  for (i in c(8,4)){
    effect <- ((dataTable[i, 2] - dataTable[i-1,2]) - (dataTable[i-2, 2] - dataTable[i-3, 2])) / 2
    emptyEffect <- append(emptyEffect, effect)
  }
  tripleInt <- (emptyEffect[1] - emptyEffect[2]) / 2
  return(tripleInt)
}



pooledVar <- function(dataTable = swingDataFull){
  emptyDiff <- numeric()
  for (i in seq(1,16,2)){
    difference <- dataTable[i+1, 2] - dataTable[i, 2]
    emptyDiff <- append(emptyDiff,difference)
  }
  pooledVariance <- sum((emptyDiff)^2) / (8 * 2)
  return(pooledVariance)
}


standardError <- sqrt((1/8 + 1/8) * pooledVar())
testStat <- qt(0.025, 8, lower.tail = FALSE)

### Calculating confidence intervals 

cIntervalM1 <- c(avgMainEffSL - testStat*standardError, avgMainEffSL + testStat*standardError)
cIntervalM2 <- c(avgMainEffMA - testStat*standardError, avgMainEffMA + testStat*standardError)
cIntervalM3 <- c(avgMainEffAM - testStat*standardError, avgMainEffAM + testStat*standardError)

cIntervalI1 <- c(intEffectSLAmp() - testStat*standardError, intEffectSLAmp() + testStat*standardError)
cIntervalI2 <- c(intEffectMassAmp() - testStat*standardError, intEffectMassAmp() + testStat*standardError)
cIntervalI3 <- c(intEffectSLMass() - testStat*standardError, intEffectSLMass() + testStat*standardError)

cIntervalI4 <- c(tripleEff() - testStat*standardError, tripleEff() + testStat*standardError)

### Interaction and Daniel Plots 


plot1 <- interaction.plot(swingDataFull$Mass, swingDataFull$String.Length, 
                          swingDataFull$Period)

plot2 <- interaction.plot(swingDataFull$Mass, swingDataFull$Amplitude, 
                          swingDataFull$Period)

plot3 <- interaction.plot(swingDataFull$Amplitude, swingDataFull$String.Length, 
                          swingDataFull$Period)

linModel <- lm(Period~ String.Length * Mass * Amplitude, data = numCodedData)

DanielPlot(linModel, half = TRUE, autolab = F, main= "Half Normal Plot")
