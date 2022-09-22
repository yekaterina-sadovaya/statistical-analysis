setwd('C:/Users/sadov/source/repos/statistics/03 Generalized Linear Mixed Effects Models')
library(brolgar)
library(lme4)
library(MASS)
library(merTools)
library(nlme)

# Question 1
data(wages)
attach(wages)
head(wages)
# denote the variables
Y = wages$ln_wages
X1 = wages$xp
X2 = wages$ged
# fit the model
model = glmer(Y~X1+X2 + (1+X1|id), family=inverse.gaussian(link="log"), data=wages)
summary(model)
# a) maximum likelihood estimate for the covariance matrix
sigma2<-sigma(model)^2
ST<-getME(model, "ST")$id
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)
cov.bi<-sigma2*F
cov.bi
# b) 95 % confidence interval
se <- sqrt(diag(vcov(model)))
coefs <- fixef(model)
upperCI <- coefs + 1.96*se
lowerCI <- coefs  - 1.96*se
upperCI
lowerCI
# c) 80 % prediction interval
newdata<-data.frame(id=31, X1=8, X2=1)
mu_pred<-predict(model, newdata=newdata, type="response")
mu_pred
predictInterval(model, newdata = newdata, level = 0.8, n.sims = 999)


## Question 2
rm(list = ls())
data<-read.table("gamblinggsas.txt", sep="\t",dec=".", header=TRUE)
head(data)
attach(data)
Y<-data$GSAS
X1<-data$Treatment
X2<-data$Adherence
t<-data$Time
m1<-glmer(Y~(X1 + X2)*t + (1|Id), family=inverse.gaussian(link="log"), data=data)
m2<-glmer(Y~(X1 + X2)*t + (1|Id), family=gaussian(link="inverse"), data=data)
AIC(m1, m2)
m3<-glmer(Y~X1*X2*t + (1|Id), family=gaussian(link="inverse"), data=data)
AIC(m2, m3)
summary(m2)
# a)
newdata<-data.frame(Treatment="Naloxone",Time=12, Adherence="High")
predict(m2, newdata=newdata, re.form=NA)
fixef(m2)
# b) 95 % confidence interval
se <- sqrt(diag(vcov(m2)))
# table of estimates with 95% CI
tab <- cbind(Est = fixef(m2), LL = fixef(m2) - 1.96 * se, UL = fixef(m2) + 1.96 * se)
print(exp(tab), digits=3)
# c) 80 % prediction interval
newdata<-data.frame(X1="Naloxone", X2="High", Id=1, t=15)
predict(m2, newdata, interval="predict") 
predictInterval(m2, newdata = newdata, level = 0.8, n.sims = 999)
