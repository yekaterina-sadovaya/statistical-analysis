library(lme4)


## AIDS
rm(list = ls())
data<-read.table("cd4.txt", sep="\t",dec=".", header=TRUE)
head(data)
# try different distribution assumptions for GLMM to undestand which one provides a better fit
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
# maximum likelihood estimate
newdata<-expand.grid(time=4, drugs=1, age=40)
muhat<-predict(model.m3_2,newdata=newdata, re.form=NA)
muhat
# calculate the prediction for unknown data point using the model
newdata<-expand.grid(time=4.531143, drugs=0, age=37.63, person=41829)
muhat<-predict(model.m3_2,newdata=newdata)
muhat
# estimate for the covariance matrix
sigma2<-sigma(model.m3_2)^2
ST<-getME(model.m3_2, "ST")$person
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)
cov.bi<-sigma2*F
cov.bi
# check if drugs is a significant variable
model.hyp1<-glmer(cd4~time + age + drugs + (1+time|person), data=data, 
                               family=Gamma(link="sqrt"))
model.hyp2<-glmer(cd4~time + age + (1+time|person), data=data, 
                               family=Gamma(link="sqrt"))
anova(model.hyp1, model.hyp2)


## Locust
rm(list = ls())
data<-read.table("locust.txt", sep="\t",dec=".", header=TRUE)
head(data)
model = glmer(move~time+feed + (1+time|id), data=data, 
              family=binomial(link="logit"))
summary(model)
# maximum likelihood estimate of Beta (fixed effect)
fixef(model)
fixef(model)[2]
# prediction
newdata<-data.frame(id=24, time=1.35, feed=0)
muhat<-predict(model,newdata=newdata)
muhat
# use Wald type of test statistic to test the hyphothesis 
k1<-c(0,1,0)
k2<-c(0,0,1)
K<-cbind(k1,k2)
beta<-t(t(fixef(model)))
Wald<-t(t(K)%*%beta)%*%solve(t(K)%*%vcov(model)%*%K)%*%t(K)%*%beta
Wald
p.value<-1-pchisq(as.numeric(Wald), df=15)
p.value
# estimate for the covariance matrix
ST<-getME(model, "ST")$id
S<-diag(diag(ST))
T<-ST-S+diag(2)
F<-T%*%S%*%S%*%t(T)
# no sigma due to the binary response
cov.bi<-F
cov.bi


## Morbidity
data<-read.table(file="morbidity.txt", sep="\t", dec=".", header=TRUE)
head(data)
tail(data)
coplot(data$poorappetite~data$visit|data$treatment)
# describe the data with model
model<-glmer(poorappetite~visit*treatment+boy+(1+visit|ID), 
               data=data, family=binomial(link="logit"))
summary(model)
# prediction for the random effect
ranef(model)
# mu estimate 
newdata<-data.frame(visit=11, boy=0, treatment=1)
predict(model, newdata=newdata, re.form=NA, type="response")

mu.hat<-predict(model, newdata=data, re.form=NA, type="response")
mu.pred<-predict(model, newdata=data, type="response")
plot(data$visit,data$poorappetite)
for(i in 1:length(data$ID)){
  lines(data$visit[data$ID==data$ID[i]],
        mu.hat[data$ID==data$ID[i]], col="red")
}
# significance of treatment
model_no_treatment<-glmer(poorappetite~visit+boy+(1+visit|ID), 
             data=data, family=binomial(link="logit"))
anova(model_no_treatment, model)
# predict how many of these children are having poor appetite if 
# the number of visits = 11, gender = boy
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

blup<-t(xf)%*%beta+t(zf)%*%b

lowerbound<-blup-qnorm(0.75)*sqrt(var.error)
lowerbound

upperbound<-blup+qnorm(0.75)*sqrt(var.error)
upperbound
