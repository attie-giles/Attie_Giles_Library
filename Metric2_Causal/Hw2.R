install.packages("ggplot2","haven","stargazer","dplyr","texreg")  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
library(texreg)


#Question 1: Estimating the probit model by hand
formula_probit <- dfmfd ~ sexhead + agehead + educhead + lnland + vaccess + pcirr + rice + wheat + milk + oil + egg 
probit1 <- glm(formula_probit, data=data,family = binomial(link = "probit"))
summary(probit1)
texre