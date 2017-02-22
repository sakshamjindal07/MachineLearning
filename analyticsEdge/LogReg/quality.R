quality = read.csv("quality.csv")
str(quality)
table(quality$PoorCare)

library(caTools)

set.seed(88)
split = sample.split(quality$PoorCare , SplitRatio = 0.75)
qualityTrain = subset(quality , split == TRUE)
qualityTest = subset(quality , split == FALSE)

QualityLog = glm(PoorCare ~ OfficeVisits + Narcotics, data = qualityTrain , family = binomial)
summary(QualityLog)

predictTrain = predict(QualityLog, type = "response")
summary(predictTrain)

tapply(predictTrain,qualityTrain$PoorCare , mean)

table(qualityTrain$PoorCare, predictTrain > 0.5)
library(ROCR)

ROCRpred = prediction(predictTrain,qualityTrain$PoorCare)
ROCRperf = performance(ROCRpred,"tpr","fpr")
plot(ROCRperf,colorize=TRUE)

