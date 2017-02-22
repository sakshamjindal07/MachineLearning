FluTrain = read.csv("FluTrain.csv")
str(FluTrain)
which.max(FluTrain$ILI)
FluTrain$Week[303]

hist(FluTrain$ILI)

FluTrain$LogILI = log(FluTrain$ILI)
plot(FluTrain$Queries,FluTrain$LogILI)

FluTrend = lm(LogILI ~ Queries , data = FluTrain)
summary(FluTrend)

FluTest = read.csv("FluTest.csv")
PredictTest1  = exp(predict(FluTrend, newdata = FluTest))
index = which(FluTest$Week == "2012-03-11 - 2012-03-17")
PredictTest1[index]/FluTest$ILI[index]
1 - PredictTest1[index]/FluTest$ILI[index]

SSE = sum((PredictTest1 - FluTest$ILI)^2)
RMSE = sqrt(SSE/nrow(FluTest))

ILILag2 = lag(zoo(FluTrain$ILI), -2, na.pad=TRUE)
FluTrain$ILILag2 = coredata(ILILag2)
summary(FluTrain$ILILag2)
plot(log(FluTrain$ILILag2), log(FluTrain$ILI))

FluTrend2 = lm(log(ILI)~Queries+log(ILILag2), data=FluTrain)
summary(FluTrend2)

ILILag2 = lag(zoo(FluTest$ILI), -2, na.pad=TRUE)
FluTest$ILILag2 = coredata(ILILag2)
summary(FluTest$ILILag2)