setwd('C:/Users/sadov/source/repos/statistics/04 Generalized Linear Mixed Effects Models')
library(lme4)


## Question 1
rm(list = ls())
data<-read.table("cd4.txt", sep="\t",dec=".", header=TRUE)
head(data)
# try different distribution assumptions
model.m1<-glmer(cd4~time + age + drugs + (1|person), 
                    data=data, family=gaussian(link="log"))
summary(model.m1)
model.m2<-glmer(cd4~time + age + drugs + (1|person), data=data, 
                    family=poisson(link="log"))
summary(model.m2)
model.m3<-glmer(cd4~time + age + drugs + (1|person), data=data, 
                    family=Gamma(link="log"))
summary(model.m3)
AIC(model.m1, model.m2, model.m3)
# for the distribution, which provided the best fit try different link function
model.m3_1<-glmer(cd4~time + age + drugs + (1|person), data=data, 
                  family=Gamma(link="log"))
model.m3_2<-glmer(cd4~time + age + drugs + (1|person), data=data, 
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
sigma<-sigma(model.m3_2)
sigma2<-sigma^2
cov.bi<-matrix(c(sigma2, sigma, sigma, sigma2), 2, 2, byrow=TRUE)
cov.bi
# d
model.hyp1<-glmer(cd4~time + age + drugs + (1|person), data=data, 
                               family=Gamma(link="sqrt"))
model.hyp2<-glmer(cd4~time + age + (1|person), data=data, 
                               family=Gamma(link="sqrt"))
anova(model.hyp1, model.hyp2)


## Question 2
rm(list = ls())
data<-read.table("locust.txt", sep="\t",dec=".", header=TRUE)
head(data)
model = glmer(move~time + feed + (1|id), data=data, 
              family=binomial)
# a
fixef(model)
fixef(model)[2]
# b