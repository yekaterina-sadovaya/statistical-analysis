setwd('C:/Users/sadov/source/repos/statistics/04 Multi-variative models')
library(lme4)


## Question 1
data<-read.table(file="morbidity.txt", sep="\t", dec=".", header=TRUE)
head(data)
tail(data)
coplot(data$poorappetite~data$visit|data$treatment)
# a
model<-glmer(poorappetite~visit*treatment+boy+(1+visit|ID), 
               data=data, family=binomial(link="logit"))
summary(model)
ranef(model)
# b
newdata<-data.frame(visit=11, boy=0, treatment=1)
predict(model, newdata=newdata, re.form=NA, type="response")

mu.hat<-predict(model, newdata=data, re.form=NA, type="response")
mu.pred<-predict(model, newdata=data, type="response")=
plot(data$visit,data$poorappetite)
for(i in 1:length(data$ID)){
  lines(data$visit[data$ID==data$ID[i]],
        mu.hat[data$ID==data$ID[i]], col="red")
}
# c
model_no_treatment<-glmer(poorappetite~visit+boy+(1+visit|ID), 
             data=data, family=binomial(link="logit"))
anova(model_no_treatment, model)
# d
beta<-t(t(fixef(model)))
X<-getME(model, "X")
Z<-getME(model, "Z")
b<-as.numeric(stack(data.frame(t(ranef(model)$ID)))[,1])
xf<-t(t(rep(0,5)))
xf[1]<-1
xf[2]<-11

sigma2<-sigma(model)^2
ST<-getME(model, "ST")$ID
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)

zf<-t(t(rep(0,782)))
zf[1]<-1
zf[2]<-11
zf<-as.matrix(zf)

G<-kronecker(diag(391), F)
V<-diag(dim(X)[1])+Z%*%G%*%t(Z)

w<-Z%*%G%*%zf
vf<-1+t(zf)%*%G%*%zf

var.error<-sigma2*(vf-t(w)%*%solve(V)%*%w+(t(xf)-t(w)%*%solve(V)%*%X)%*%solve(t(X)%*%solve(V)%*%X)%*%(xf-t(X)%*%solve(V)%*%w))

lowerbound<-blup-qnorm(0.75)*sqrt(var.error)
lowerbound

upperbound<-blup+qnorm(0.75)*sqrt(var.error)
upperbound


## Question 2
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
# a
B.hat<-coef(model)
B.hat
# b
# check if there are points with the gravity and obesity values exist in dataset
sub_data = Data[which(Data$gravity == 30 & Data$obesity == "Group IV")]
# compute estimate
newdata<-data.frame(gravity=30, obesity="Group IV")
mu<-predict(model, newdata=newdata,re.form=NA)
mu
# c
newdata<-data.frame(gravity=35,obesity="Group III")
BP<-predict(model, newdata=newdata)
BP

Sigma = sigma(model)

X<-model.matrix(model)
xf<-t(cbind(1,newdata))
cov.error<-Sigma*as.numeric(1+t(xf)%*%solve(t(X)%*%X)%*%xf)

lower.bound<-BP-qnorm(0.9)*diag(cov.error)^0.5
upper.bound<-BP+qnorm(0.9)*diag(cov.error)^0.5
lower.bound
upper.bound
# d
yf1<-c(25,29.50)
Bt<-t(coef(model))
B1t<-Bt[1:2,]
B2t<-Bt[3,]
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
