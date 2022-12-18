library(lme4)


## Depression
data<-read.table(file="depression.txt", sep="\t", dec=".", header=TRUE)
head(data)
tail(data)
attach(data)
# combine variables and create multi-var. model
Y<-cbind(T0, T1, T3, T6)
X<-as.integer(treatment=="treated")
data$treatment<-X
model<-lm(Y~X)
# prediction with the model if patient was treated
newdata1<-data.frame(X=1)
BP_treated<-predict(model, newdata=newdata1)
# if being controled
newdata2<-data.frame(X=0)
BP_control<-predict(model, newdata=newdata2)
plot(c(0, 1, 3, 6), BP_treated, xlab = "T number", ylab = "T value")
par(new=TRUE)
plot(c(0, 1, 3, 6), BP_control, col=2, ann=FALSE, axes=FALSE)
# test average equality hypotheses
L<-t(t((1/4)*rep(1,4)))
YL<-Y%*%L
head(Y)
head(YL)
model<-lm(YL~X)
summary(modeL)
model.H0<-lm(YL~1)
anova(model.H0, model)
# growth curve model
t<-c(0,1,3,6)
T<-cbind(rep(1,4),t)
Y.star<-Y%*%T%*%solve(t(T)%*%T)
model<-lm(Y.star~X-1)
summary(model)
Theta<-coef(model)
Theta
# test significance of the variable "treatment"
model.H0<-lm(Y.star~-1)
anova(model.H0, model)
# 80 % confidence interval
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


## Rat Weight
rm(list = ls())
data<-read.table(file="RatWeight.txt", sep="\t", dec=".", header=TRUE)
head(data)
attach(data)

Y<-cbind(wt0, wt1, wt2, wt3, wt4)
# convert string values to numerical for simpler plotting and analisys
X<-trt
X[X=="Control"] = 0
X[X=="Thiouracil"] = 1
X[X=="Thyroxin"] = 2
X<-as.numeric(X)
data$trt<-X
# plot original data
# observation from the data is that scatters are not clustered based on the week number
plot(c(0,2),c(0,200), type="n", xlab="", ylab="")
for (i in 1:5) {
  par(new=TRUE)
  plot(X, Y[,i], ann=FALSE, axes=FALSE,col=i)
}
# consider simple multi-var. linear model
multi_linear_model<-lm(Y~X)
summary(multi_linear_model)
predicted = predict(multi_linear_model)
plot(c(0, 180), c(0,180), type="n", xlab='Predicted Values',
      ylab='Actual Values')
for (i in 1:5) {
  par(new=TRUE)
  plot(predicted[,i], Y[,i], ann=FALSE, axes=FALSE,col=i)
}
# under assumption of normal distribution
E<-residuals(multi_linear_model)
Sigma<-(t(E)%*%E)/model$df
plot(c(0, 180), c(0,180), type="n", xlab='Predicted Values',
     ylab='Actual Values')
for (i in 1:5) {
  predicted[,i]<-predicted[,i]+rnorm(n=27,mean=0,sd=Sigma^2)
  par(new=TRUE)
  plot(predicted[,i], Y[,i], ann=FALSE, axes=FALSE,col=i)
}
multi_linear_model.H0<-lm(Y~1)
# if the model is reasonable, we should see the impact of treatment
# therefore, test this hypothesis
anova(multi_linear_model.H0, model)
# growth curve model is considered 
t<-c(0,1,2,3,4)
T<-cbind(rep(1,5),t)
Y.star<-Y%*%T%*%solve(t(T)%*%T)
model_growth<-lm(Y.star~X-1)
summary(model_growth)

Theta<-coef(model_growth)
x1<-cbind(1,0)
x2<-cbind(0,1)
mu1<-T%*%t(Theta)%*%x1
mu2<-T%*%t(Theta)%*%x2
plot(c(0, 4), c(0,100), type="n")
points(t, mu1[,1], col="red")
lines(t, mu1[,1], col="red")
points(t, mu2[,2], col="blue")
lines(t, mu2[,2], col="blue")
plot( predict(model_growth), Y, xlab='Predicted Values',
      ylab='Actual Values')
# introducing t^2 
T2<-cbind(rep(1,5),t,t^2)
Y.star2<-Y%*%T2%*%solve(t(T2)%*%T2)
model_growth2<-lm(Y.star2~X-1)
anova(model_growth, model_growth2)
