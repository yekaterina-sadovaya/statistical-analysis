setwd('C:/Users/sadov/source/repos/statistics/06 Functional Data Models')
library(lme4)


## Question 1
data<-read.table(file="depression.txt", sep="\t", dec=".", header=TRUE)
head(data)
tail(data)
attach(data)
Y<-cbind(T0, T1, T3, T6)
X<-as.integer(treatment=="treated")
data$treatment<-X
model<-lm(Y~X)
# a)
newdata1<-data.frame(X=1)
BP_treated<-predict(model, newdata=newdata1)
newdata2<-data.frame(X=0)
BP_control<-predict(model, newdata=newdata2)
plot(c(0, 1, 3, 6), BP_treated, xlab = "T number", ylab = "T value")
par(new=TRUE)
plot(c(0, 1, 3, 6), BP_control, col=2, ann=FALSE, axes=FALSE)
# b)
L<-t(t((1/4)*rep(1,4)))
YL<-Y%*%L
head(Y)
head(YL)
model<-lm(YL~X)
summary(modeL)
model.H0<-lm(YL~1)
anova(model.H0, model)
# c)
t<-c(0,1,3,6)
T<-cbind(rep(1,4),t)
Y.star<-Y%*%T%*%solve(t(T)%*%T)
model<-lm(Y.star~X-1)
summary(model)
Theta<-coef(model)
Theta
# d)
model.H0<-lm(Y.star~-1)
anova(model.H0, model)
# e)
xf<-cbind(282,186,0,0)
BP<-T%*%t(Theta)%*%xf
BP
X<-model.matrix(model)
E<-Y-X%*%Theta%*%t(T)
Sigma<-t(E)%*%E/model$df
PT<-T%*%solve(t(T)%*%T)%*%t(T)
cov.error<-Sigma+(as.numeric(t(xf)%*%solve(t(X)%*%X)%*%xf)*PT%*%Sigma%*%PT)
lower.bound<-BP-qnorm(0.9)*diag(cov.error)^0.5
upper.bound<-BP+qnorm(0.9)*diag(cov.error)^0.5
lower.bound
upper.bound

## Question 2
rm(list = ls())
data<-read.table(file="RatWeight.txt", sep="\t", dec=".", header=TRUE)
