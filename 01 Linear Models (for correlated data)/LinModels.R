### Statistical Modeling 2
### Linear Models
### 2022

############################
### Example 1.8

library(nlme)

library(faraway)
data(irrigation)
head(irrigation)

irrigation

y<-irrigation$yield
y
X<-model.matrix(~variety+irrigation, data=irrigation)
X

aitken<-gls(yield~variety+irrigation, correlation = corCompSymm(form=~1|field), data=irrigation)
summary(aitken)
rho<-coef(aitken$model$corStruct,unconstrained=FALSE)

cs<-corCompSymm(rho,form = ~1|field)
cs<-Initialize(cs, data = irrigation)
R<-corMatrix(cs)
R
V<-diag(8)%x%R$f1
V

############################
### Example 1.10

library(nlme)


model.matrix(~variety*irrigation, data=irrigation)


model.main<-gls(yield~variety+irrigation, correlation = corCompSymm(form=~1|field), data=irrigation)
model.12<-gls(yield~variety*irrigation, correlation = corCompSymm(form=~1|field), data=irrigation)

summary(model.12)

## a)

betahat<-coef(model.12)
betahat
rho<-coef(model.12$model$corStruct,unconstrained=FALSE)
rho
sigma2<-sigma(model.12)^2
sigma2


## b)

anova(model.main, model.12)

## c)

X<-model.matrix(~variety*irrigation, data=irrigation)
X

x.star<-rep(0,8)
x.star[1]<-1
x.star[2]<-1
x.star[5]<-1
x.star[8]<-1

x.star<-t(t(x.star))

mu.hat<-t(x.star)%*%betahat
mu.hat

predict(model.12)

rho<-coef(model.12$model$corStruct,unconstrained=FALSE)
cs<-corCompSymm(rho,form = ~1|field)
cs<-Initialize(cs, data = irrigation)
R<-corMatrix(cs)
R
V<-diag(8)%x%R$f1
V

lower<-mu.hat-qnorm(0.975)*sqrt(sigma(model.12)^2*t(x.star)%*%solve(t(X)%*%solve(V)%*%X)%*%x.star)
upper<-mu.hat+qnorm(0.975)*sqrt(sigma(model.12)^2*t(x.star)%*%solve(t(X)%*%solve(V)%*%X)%*%x.star)



############################
### Example 1.11

data<-read.table("pollutiondata.txt",header=TRUE,sep="\t")
data<-as.matrix(data)
edata<-embed(data,2)
data<-data.frame(edata[,c(1,5,6)])
colnames(data)<-c("Mortality","TemperatureT1","ParticulatesT1")

training<-data[-507,]
newdata<-data[507,]

plot(training)

modelLM<-lm(Mortality~TemperatureT1+ParticulatesT1,data=training)
summary(modelLM)

### We are using residuals to investigate the ARMA process 

e<-residuals(modelLM)

plot(e,type="n")
lines(e)

acf(e)
pacf(e)

ar(e,demean=FALSE)

## a) 

library(nlme)

modelGLS<-gls(Mortality~TemperatureT1+ParticulatesT1,data=training,correlation=corARMA(p=1,q=0))
summary(modelGLS)

modelGLS<-gls(Mortality~TemperatureT1+ParticulatesT1,data=training,correlation=corARMA(p=4,q=0))
summary(modelGLS)

paraARMA<-coef(modelGLS$model$corStruct,unconstrained=FALSE)
paraARMA

## b) 

modelH1<-gls(Mortality~TemperatureT1+ParticulatesT1,data=training,correlation=corARMA(p=1,q=0), method="ML")
summary(modelH1)

modelH0<-gls(Mortality~TemperatureT1,data=training,correlation=corARMA(p=1,q=0), method="ML")
summary(modelH0)

anova(modelH0, modelH1)

## c)

nn<-dim(data)[1]
T<-data.frame(t=1:nn)
cs<-corARMA(paraARMA,form = ~ 1,p=1,q=0)
cs<-Initialize(cs, data = T)

Sigma<-corMatrix(cs)
V<-Sigma[1:(nn-1),1:(nn-1)]
w<-Sigma[1:(nn-1),nn]

predict(modelGLS,newdata=newdata)

blup<-predict(modelGLS,newdata=newdata)+t(w)%*%solve(V)%*%residuals(modelGLS)
blup

xf<-t(t(c(1,73.33,57.58)))
beta<-coef(modelGLS)
X<-model.matrix(~TemperatureT1+ParticulatesT1, data=training)
y<-training$Mortality

blup<-t(xf)%*%beta+t(w)%*%solve(V)%*%(y-X%*%beta)
blup

## d)

sigma2<-summary(modelGLS)$sigma^2
X<-model.matrix(~TemperatureT1+ParticulatesT1, data=training)
vf<-Sigma[nn,nn]
xf<-t(t(c(1,73.33,57.58)))
var.error<-sigma2*(vf-t(w)%*%solve(V)%*%w+(t(xf)-t(w)%*%solve(V)%*%X)%*%solve(t(X)%*%solve(V)%*%X)%*%(xf-t(X)%*%solve(V)%*%w))

lowerbound<-blup-qnorm(0.9)*sqrt(var.error)
lowerbound

upperbound<-blup+qnorm(0.9)*sqrt(var.error)
upperbound


# how to extract subdata
sub_data<-data[data$Position %in% c("Light seat"), ]

