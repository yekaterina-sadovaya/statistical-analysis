setwd('./02 Mixed Models')
library(lme4)
rm(list = ls())
data<-read.table("heightchildren.txt", sep="\t", dec=".", header=TRUE)
attach(data)
head(data)
tail(data)
interaction.plot(ID,gender,height)
# a
model<-lmer(height~(age + poly(age, degree=2) + poly(age, degree=3))*gender + (1+gender|ID), data=data)
summary(model)
# b
ranef(model)
ranef(model)$ID[[93, 2]]
# c
model.H0<-lmer(height~age + poly(age, degree=2) + poly(age, degree=3) + (1+gender|ID), data=data, REML=FALSE)
model.H1<-lmer(height~(age + poly(age, degree=2) + poly(age, degree=3))*gender + (1+gender|ID), data=data, REML=FALSE)
anova(model.H0, model.H1)
anova(model.H0, model.H1)$Chisq[2]
# d
newdata<-expand.grid(ID=3, gender='girl', age=19)
mu.pred<-predict(model, newdata=newdata)
mu.pred

rm(list = ls())
data<-read.table("treemoisture.txt", header=TRUE, sep="\t", dec=".")
x1=data$Location
x2=data$Species
x3=data$Transpiration
y=data$Moisture
z=data$Branch.ID
model<-lmer(y~(x1+x2+x3)*z + (1|z), data=data)
summary(model)
# a
coef(model)
# b
ranef(model)
# c
sigma2<-sigma(model)^2
sigma2
# d
model.H0<-lmer(y~(x1+x2)*z + (1|z), data=data, REML=FALSE)
model.H1<-lmer(y~(x1+x2+x3)*z + (1|z), data=data, REML=FALSE)
anova(model.H0, model.H1)
# e
newdata<-expand.grid(x1='Central', x2='Yellow Poplar', x3='Slow', z=15)
mu.pred<-predict(model, newdata=newdata)
mu.pred
