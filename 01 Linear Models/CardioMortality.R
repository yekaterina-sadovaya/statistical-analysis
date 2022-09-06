setwd('./01 Linear Models')
library(nlme)
data<-read.table("cmort.txt", sep="\t", dec=".", head=TRUE)
head(data)
tail(data)
# add unknown next value to predict it in future
data[nrow(data) + 1,] = c(509, NA)
newdata<-data
t<-data$t
x1<-t
x2<-t^2
x3<-t^3
x4<-cos(2*pi*t/52)
x5<-sin(2*pi*t/52)
y<-data$y
training<-data.frame(x1,x2,x3,x4,x5,y)
M<-lm(y~x1+x2+x3+x4+x5,data=training)
summary(M)
e<-residuals(M)
plot(e,type="n")
lines(e)
# estimate of the AR parameters
ar(e, aic = FALSE, order.max = 1)
M_GLS<-gls(y~x1+x2+x3+x4+x5,
           data=training,correlation=corAR1())
summary(M_GLS)
paramsAR<-coef(M_GLS$model$corStruct,unconstrained=FALSE)

# alternative linear model
M0<-lm(y~x1+x2+x3,data=training)
modelH0<-gls(y~x1+x2+x3,data=training,
             correlation=corAR1(), method="ML")
summary(modelH0)
modelH1<-gls(y~x1+x2+x3+x4+x5,data=training,
             correlation=corAR1(), method="ML")
summary(modelH1)
anova(modelH0, modelH1)

# predict model's value at the next step
nn<-dim(data)[1]
T<-data.frame(t=1:nn)
cs<-corAR1(paramsAR,form = ~ 1)
cs<-Initialize(cs, data = T)
Sigma<-corMatrix(cs)
V<-Sigma[1:(nn-1),1:(nn-1)]
w<-Sigma[1:(nn-1),nn]
# predict value at t=509
predict(M_GLS,newdata=newdata)

blup<-predict(M_GLS,newdata=newdata)+t(w)%*%solve(V)%*%residuals(M_GLS)
blup
blup[509]

# 80 % interval of prediction 
sigma2<-summary(M_GLS)$sigma^2
X<-model.matrix(~x1+x2+x3+x4+x5, data=training)
vf<-Sigma[nn,nn]
xf<-t(t(c(1,73.33,57.58)))
var.error<-sigma2*(vf-t(w)%*%solve(V)%*%w+(t(xf)-t(w)%*%solve(V)%*%X)%*%solve(t(X)%*%solve(V)%*%X)%*%(xf-t(X)%*%solve(V)%*%w))

lowerbound<-blup-qnorm(0.9)*sqrt(var.error)
lowerbound

upperbound<-blup+qnorm(0.9)*sqrt(var.error)
upperbound