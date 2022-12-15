library(lme4)


## Urine of young men
library(reshape)
rm(list = ls())
data<-read.table(file="excretory.txt", sep="\t", dec=".", header=TRUE)
attach(data)
Y<-cbind(creatinine, chloride, chlorine)
model<-lm(Y~gravity+obesity)
# Data = melt(data, id.vars=1:2, variable_name='Y')
# Data$Y = factor(gsub('Y(.+)', '\\1', Data$Y))
# model<-lmer(value~Y+gravity+(1|obesity), data=Data)
summary(model)
# maximum likelihood estimate of B
B.hat<-coef(model)
B.hat
# maximum likelihood estimate when obesity == "Group IV" and gravity == 30
# check if there are points with the gravity and obesity values exist in dataset
sub_data = data[which(data$gravity == 30 & data$obesity == "Group IV")]
# compute estimate
newdata<-data.frame(gravity=30, obesity="Group IV")
mu<-predict(model, newdata=newdata,re.form=NA)
mu
# value of y when gravity=35,obesity="Group III"
newdata<-data.frame(gravity=35,obesity="Group III")
BP<-predict(model, newdata=newdata)
BP

Sigma = sigma(model)

X<-model.matrix(model)
xf<-t(cbind(1, 35, 0, 1, 0))
cov.error<-Sigma*as.numeric(1+t(xf)%*%solve(t(X)%*%X)%*%xf)

lower.bound<-BP-qnorm(0.9)*(cov.error)^0.5
upper.bound<-BP+qnorm(0.9)*(cov.error)^0.5
lower.bound
upper.bound

# 80 prediction intervals
yf1<-c(13.5,9.0)
Bt<-t(coef(model))
B1t<-Bt[1:2,]
B2t<-Bt[3,]
Sigma<-diag(Sigma)
Sigma11<-Sigma[1:2,1:2]
Sigma12<-Sigma[1:2,3]
Sigma21<-Sigma[3,1:2]
Sigma22<-Sigma[3,3]

BP<-B2t%*%xf+Sigma21%*%solve(Sigma11)%*%(yf1-B1t%*%xf)
BP
cov.error<-Sigma22-Sigma21%*%solve(Sigma11)%*%Sigma12

lower.bound<-BP-qnorm(0.9)*diag(cov.error)^0.5
upper.bound<-BP+qnorm(0.9)*diag(cov.error)^0.5
lower.bound
upper.bound
