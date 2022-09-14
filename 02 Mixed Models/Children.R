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
# make 3 different models
m1<-aov(y~x1*x2*x3*z, data=data)
m2<-aov(y~(x1+x2+x3)*z, data=data)
m3<-aov(y~x1*x2*x3, data=data)
# test these models with the Akaike information criterion
AIC(m1, m2, m3)
# use the one, which gave the best score
model_mixed_eff<-lmer(y~x1*x2*x3 + (1|z), data=data)
summary(model_mixed_eff)
# a
# all estimation for mu
mu_all = model_mixed_eff@resp$mu
# next, we need to specify the indices where x1 = Central, x2 = Yellow Poplar, 
# and xi∗3 = Slow
sub_data = data[which(data$Location == "Central" & data$Species == "Yellow Poplar" 
           & data$Transpiration == "Slow"), ]
indexes_string = row.names(sub_data)
indexes = as.numeric(unlist(strsplit(indexes_string, ",", fixed=TRUE)))
# finally, we can obtain the estimate for the required values
mu_all[indexes]
# b
ranef(model_mixed_eff)$z[10,1]
# c
sigma2<-sigma(model_mixed_eff)^2
sigma2
# d
model.H0<-lmer(y~(x1+x2)*z + (1|z), data=data, REML=FALSE)
model.H1<-lmer(y~(x1+x2+x3)*z + (1|z), data=data, REML=FALSE)
anova(model.H0, model.H1)
# e
newdata<-expand.grid(x1='Central', x2='Yellow Poplar', x3='Slow', z=15)
mu.pred<-predict(model, newdata=newdata)
mu.pred


rm(list = ls())
data<-read.table("foreststage.txt", sep="\t", dec=".", header=TRUE)
model<-lmer(height.m~dbhib.cm+I(dbhib.cm^2)+(1+dbhib.cm|ID)+(1|Forest.ID), data=data)
summary(model)
v <- VarCorr(model)
