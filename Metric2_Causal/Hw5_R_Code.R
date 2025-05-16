#install.packages("ggplot2","haven","stargazer","dplyr","tidyr")  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
library(tidyr)
library(sandwich)
library(lmtest)

#Problem Set 5

#Load Dataset
nicaragua <- read_dta("Downloads/Coding/R/Metric2_Causal/nicaragua.dta")
nicaragua <- nicaragua %>% 
  filter(!is.na(P) & !is.na(C) & !is.na(area) & !is.na(I) & !is.na(lwage3) & !is.na(S))

View(nicaragua)

#Question 1
#First Stage
first_stage <- lm(S ~ P * C, data = nicaragua)
cluster_se <- vcovCL(first_stage, cluster = nicaragua$area, type = "HC1")

summary(first_stage)
summary_clustered <- coeftest(first_stage, vcov = cluster_se)
se_clustered <- sqrt(diag(cluster_se))

stargazer(first_stage, 
          se=list(se_clustered),
          type="text",
          title = "First-Stage Regression",
          dep.var.labels = "Years of Schooling",
          covariate.labels = c( "Program Region", "Eligibility","Program Region:Eligibility"),
          #omit = c("P", "C"),
          #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)



nicaragua <- nicaragua  %>% 
  mutate(S_hat = fitted(first_stage))

#Question 2
#Reduced Form

reduced_form <-lm(lwage3 ~ P * C, data=nicaragua)
cluster_se2 <- vcovCL(reduced_form, cluster = nicaragua$area, type = "HC1")

summary(reduced_form)
summary_clustered2 <- coeftest(reduced_form, vcov = cluster_se2)
se_clustered2 <- sqrt(diag(cluster_se2))


stargazer(reduced_form, 
          se=list(se_clustered2),
          type="latex",
          title = "Reduced Form Regression",
          dep.var.labels = "Log of Wages",
          covariate.labels = c( "Program Region", "Eligibility","Program Region:Eligibility"),
          #omit = c("P", "C"),
          #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)
  
#Question 3
#Structural Equation
  two_staged <- lm(lwage3 ~ S_hat, data = nicaragua)
  summary(two_staged)
  
  stargazer(two_staged,
            type="latex",
            title = "Structural Equation",
            dep.var.labels = "Log of Wages",
            covariate.labels = c( "Years of Schooling (fitted)"),
            #omit = c("P", "C"),
            #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
            omit.stat = c("f", "ser"), align = TRUE)
  
#Question 4
  #First-Stage redo
  first_stage4 <- lm(S ~ P * C + I, data = nicaragua)
  cluster_se4 <- vcovCL(first_stage4, cluster = nicaragua$area, type = "HC1")
  
  summary(first_stage4)
  summary_clustered4 <- coeftest(first_stage4, vcov = cluster_se4)
  se_clustered4 <- sqrt(diag(cluster_se4))
  
  stargazer(first_stage4, 
            se=list(se_clustered4),
            type="text",
            title = "First-Stage Regression 2",
            dep.var.labels = "Years of Schooling",
            covariate.labels = c( "Program Region", "Eligibility", "Illiteracy","Program Region:Eligibility"),
            #omit = c("P", "C"),
            #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
            omit.stat = c("f", "ser"), align = TRUE)
  
  #Reduced Form redo
  reduced_form4 <-lm(lwage3 ~ P * C + I, data=nicaragua)
  cluster_se24 <- vcovCL(reduced_form4, cluster = nicaragua$area, type = "HC1")
  
  summary(reduced_form4)
  summary_clustered24 <- coeftest(reduced_form4, vcov = cluster_se24)
  se_clustered24 <- sqrt(diag(cluster_se24))
  
  stargazer(reduced_form4, 
            se=list(se_clustered24),
            type="text",
            title = "Reduced Form Regression",
            dep.var.labels = "Log of Wages",
            covariate.labels = c( "Program Region", "Eligibility", "Illiteracy","Program Region:Eligibility"),
            #omit = c("P", "C"),
            #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
            omit.stat = c("f", "ser"), align = TRUE)
  
  #2SLS
  nicaragua <- nicaragua  %>% 
    mutate(S_hat4 = fitted(first_stage4))
  
  two_staged4 <- lm(lwage3 ~ S_hat4 + I, data = nicaragua)
  summary(two_staged4)
  
  stargazer(two_staged4,
            type="text",
            title = "Structural Equation",
            dep.var.labels = "Log of Wages",
            covariate.labels = c( "Years of Schooling (fitted)", "Illiteracy"),
            #omit = c("P", "C"),
            #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
            omit.stat = c("f", "ser"), align = TRUE)
  
  #Results
  stargazer(first_stage4, reduced_form4, two_staged4,
            se=list(se_clustered4, se_clustered24),
            type="latex",
            title = "Regressions with Control Variable",
            dep.var.labels = c("Years of Schooling","Log of Wages", "Log of Wages"),
            covariate.labels = c( "Program Region", "Eligibility", "Years of Schooling (fitted)",
                                   "Parent Illiteracy","Program Region:Eligibility"),
            column.labels = c("First-Stage", "Reduced Form", "2SLS"),
            #omit = c("P", "C"),
            #add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
            omit.stat = c("f", "ser"), align = TRUE)
