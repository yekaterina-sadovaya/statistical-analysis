setwd('./02 Mixed Models')
library(lme4)
rm(list = ls())
data<-read.table("heightchildren.txt", sep="\t", dec=".", header=TRUE)
attach(data)
head(data)
tail(data)
interaction.plot(ID,gender,height)
# a
model<-lmer(height~age + poly(age, degree=2) + poly(age, degree=3) + (1+ID|gender), data=data)
summary(model)
# b
ranef(model)
ranef(model)$ID[[93]]
# c
model.H0<-lmer(height~age + poly(age, degree=2) + poly(age, degree=3) + (1+ID|gender), data=data, REML=FALSE)
model.H1<-lmer(height~(age + poly(age, degree=2) + poly(age, degree=3))*gender + (1+ID|gender), data=data, REML=FALSE)
anova(model.H0, model.H1)
anova(model.H0, model.H1)$Chisq[2]
# d
newdata<-expand.grid(ID=3, gender='girl', age=19)
mu.pred<-predict(model, newdata=newdata)
mu.pred

rm(list = ls())
data<-read.table("treemoisture.txt", header=TRUE, sep="\t", dec=".")

