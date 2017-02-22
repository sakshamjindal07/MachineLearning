pisaTrain = read.csv("pisa2009train.csv")
tapply(pisaTrain$readingScore, pisaTrain$male , mean) 
pisaTest = read.csv("pisa2009test.csv")
pisaTrain = na.omit(pisaTrain) 
pisaTest = na.omit(pisaTest)
str(pisaTrain)

pisaTrain$raceeth = relevel(pisaTrain$raceeth, "White")
pisaTest$raceeth = relevel(pisaTest$raceeth , "White")

LinReg = lm (readingScore ~ . , data = pisaTrain)
summary(LinReg)
SSE = sum(LinReg$residuals^2)
RMSE = sqrt(SSE/nrow(pisaTrain))
