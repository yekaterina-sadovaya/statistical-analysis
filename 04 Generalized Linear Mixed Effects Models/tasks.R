setwd('C:/Users/sadov/source/repos/statistics/04 Generalized Linear Mixed Effects Models')
library(lme4)


## Question 1
rm(list = ls())
data<-read.table("cd4.txt", sep="\t",dec=".", header=TRUE)
head(data)
# try different distribution assumptions
model.m1<-glmer(cd4~time + age + drugs + (1+time|person), 
                    data=data, family=gaussian(link="log"))
summary(model.m1)
model.m2<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                    family=poisson(link="log"))
summary(model.m2)
model.m3<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                    family=Gamma(link="log"))
summary(model.m3)
AIC(model.m1, model.m2, model.m3)
# for the distribution, which provided the best fit try different link function
model.m3_1<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                  family=Gamma(link="log"))
model.m3_2<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                  family=Gamma(link="sqrt"))
AIC(model.m3_1, model.m3_2)
# a
newdata<-expand.grid(time=4, drugs=1, age=40)
muhat<-predict(model.m3_2,newdata=newdata, re.form=NA)
muhat
# b
newdata<-expand.grid(time=4.531143, drugs=0, age=37.63, person=41829)
muhat<-predict(model.m3_2,newdata=newdata)
muhat
# c
sigma2<-sigma(model.m3_2)^2
ST<-getME(model.m3_2, "ST")$person
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)
cov.bi<-sigma2*F
cov.bi
# d
model.hyp1<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                               family=Gamma(link="sqrt"))
model.hyp2<-glmer(cd4~time + age + (1+time|person), data=data, 
                               family=Gamma(link="sqrt"))
anova(model.hyp1, model.hyp2)


## Question 2
rm(list = ls())
data<-read.table("locust.txt", sep="\t",dec=".", header=TRUE)
head(data)
model = glmer(move~time+feed + (1+time|id), data=data, 
              family=binomial(link="logit"))
summary(model)
# a
fixef(model)
fixef(model)[2]
# b
newdata<-data.frame(id=24, time=1.35, feed=0)
muhat<-predict(model,newdata=newdata)
muhat
# c
k1<-c(0,1,0)
k2<-c(0,0,1)
K<-cbind(k1,k2)
beta<-t(t(fixef(model)))
Wald<-t(t(K)%*%beta)%*%solve(t(K)%*%vcov(model)%*%K)%*%t(K)%*%beta
Wald
p.value<-1-pchisq(as.numeric(Wald), df=15)
p.value
# d
ST<-getME(model, "ST")$id
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)
# no sigma due to the binary response
cov.bi<-F
cov.bi

