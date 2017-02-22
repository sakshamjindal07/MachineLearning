stevens = read.csv("stevens.csv")
str(stevens)

library("caTools")
set.seed(3000)
split = sample.split(stevens$Reverse , SplitRatio = 0.7)

Train = subset(stevens, split == TRUE)
Test = subset(stevens, split == FALSE)

installed.packages("rpart")

library("rpart")
install.packages("rpart.plot")
library(rpart.plot)

StevensTree = rpart(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst , data = Train , method = "class",control =rpart.control(minbucket=25)) 
prp(StevensTree)

PredictCART = predict(StevensTree, newdata = Test , type = "class")
table(Test$Reverse, PredictCART)

library(ROCR)

PredictROC = predict(StevensTree, newdata = Test)
PredictROC

pred = prediction(PredictROC[,2],Test$Reverse)
perf = performance(pred,"tpr","fpr")
plot(perf)

installed.packages("randomForest")
library(randomForest)


StevensForest = randomForest(Reverse ~ Circuit + Issue + Petitioner + Respondent + LowerCourt + Unconst , data = Train , nodesize = 25 , ntree = 200)





