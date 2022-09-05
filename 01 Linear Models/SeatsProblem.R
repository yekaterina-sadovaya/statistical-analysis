setwd('./01 Linear Models')
library(nlme)
data<-read.table("seatstride.txt", header=TRUE,sep="\t")
data$Combo<-as.character(data$Combo)

# construct the model
x<-model.matrix(~Position, data=data)
# estimate the parameters
aitken<-gls(Length~Position, correlation = corCompSymm(form=~1|Combo), 
            data=data)
summary(aitken)
# estimate correlation
rho<-coef(aitken$model$corStruct,unconstrained=FALSE)
cs<-corCompSymm(rho,form = ~1|Combo)
cs<-Initialize(cs, data = data)
R<-corMatrix(cs)
# this can be V<-diag(6)%x%R$f1 in other R versions
V<-diag(6)%x%R$`1`  

# test significance 
r1 <- t.test(Length ~ Position, data = data)
r1

# confidence interval for light seat position
betahat<-coef(aitken)
sig<-sigma(aitken)^2
x_star<-rep(0, 2)
x_star[1]<-1
x_star<-t(t(x_star))
mu_hat<-t(x_star)%*%betahat
lower<-mu_hat-qnorm(0.95)*sqrt(sig*t(x_star)%*%solve(t(x)%*%solve(V)%*%x)%*%x_star)
upper<-mu_hat+qnorm(0.95)*sqrt(sig*t(x_star)%*%solve(t(x)%*%solve(V)%*%x)%*%x_star)
