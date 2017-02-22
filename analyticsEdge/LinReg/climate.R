climate = read.csv("climate_change.csv")
str(climate)
train = subset(climate,Year <= 2006)
test = subset(climate , Year>2006)
model1 = lm (Temp ~ MEI + CO2 + CH4 + N2O + CFC.11 + CFC.12 + TSI + Aerosols , data = train)
summary(model1)
cor(train)
model2 = lm(Temp ~ MEI + N2O + TSI + Aerosols , data = train)
summary(model2)
model3 = step(model1)
summary(model3)
model4 = lm(Temp ~ MEI + N2O + CFC.11 +  TSI + Aerosols , data = train)
summary(model4)

predictTest = predict(model3 , newdata = test)
predictTest
SSE = sum((test$Temp - predictTest)^2)
SST = sum((test$Temp - mean(train$Temp))^2)
1 - SSE/SST

tempPredict = predict(model3, newdata = test)
SSE = sum((tempPredict - test$Temp)^2)
SST = sum( (mean(test$Temp) - test$Temp)^2)
R2 = 1 - SSE/SSTs