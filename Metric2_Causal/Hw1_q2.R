#Import the dataset 
#install.packages("ggplot2","haven","stargazer","dplyr")  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
# Load Data
data <- read_dta("Downloads/Coding/R/Metric2_Causal/hh_98.dta")

# Create New Variables in the DataFrame
data$lexptot <- log(data$exptot)  
data$lnland <- log(data$hhland / 100)

# Create the unique village identifier
data <- data %>%
  mutate(vill = thanaid * 10 + villid)  # Equivalent to "gen vill=thanaid*10+villid"

# Generate village-level max indicators
data <- data %>%
  group_by(vill) %>%
  mutate(progvillm = max(dmmfd, na.rm = TRUE),  # Equivalent to "egen progvillm=max(dmmfd), by(vill)"
         progvillf = max(dfmfd, na.rm = TRUE))  # Equivalent to "egen progvillf=max(dfmfd), by(vill)"

# Ungroup to return to household-level data
data <- ungroup(data)


# ✅ Histogram + Kernel Density for Expenditures (Level)
ggplot(data, aes(x = exptot)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 500, fill = "red", alpha = 0.5) +
  geom_density(color = "blue", lwd = 1) +  # Density plot
  ggtitle("Histogram with Kernel Density for Expenditures (Level)") +
  xlab("Expenditures") + ylab("Density") +
  xlim(min(data$exptot, na.rm = TRUE), max(20000)) +  # Fix xlim
  ylim(0, NA) +  # Auto-scale y-axis
  theme_minimal()

# ✅ Histogram + Kernel Density for Log Expenditures
ggplot(data, aes(x = lexptot)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.2, fill = "red", alpha = 0.5) +  # Adjusted binwidth
  geom_density(color = "blue", lwd = 1) +  # Density plot
  ggtitle("Histogram with Kernel Density for Expenditures (Log)") +
  xlab("Log Expenditures") + ylab("Density") +
  xlim(min(data$lexptot, na.rm = TRUE), max(data$lexptot, na.rm = TRUE)) +  # Fix xlim
  ylim(0, NA) +  # Auto-scale y-axis
  theme_minimal()

# ✅ Histogram + Kernel Density for Landhol ings(Level)
ggplot(data, aes(x = hhland / 100)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = .5, fill = "red", alpha = 0.5) +
  geom_density(color = "blue", lwd = 1) +  # Density plot
  ggtitle("Histogram with Kernel Density for Landholdings (Level)") +
  xlab("Landholdings") + ylab("Density") +
  xlim(min(0), max(10)) +  # Fix xlim
  ylim(0, .5) +  # Auto-scale y-axis
  theme_minimal()

# ✅ Histogram + Kernel Density for Log  Landholdings
ggplot(data, aes(x = lnland)) +
  geom_histogram(aes(y = after_stat(density)), binwidth = 0.5, fill = "red", alpha = 0.5) +  # Adjusted binwidth
  geom_density(color = "blue", lwd = 1) +  # Density plot
  ggtitle("Histogram with Kernel Density for Landholdings (Log)") +
  xlab("Log Landholdings") + ylab("Density") +
  xlim(min(data$lnland, na.rm = TRUE), max(data$lnland, na.rm = TRUE)) +  # Fix xlim
  ylim(0, NA) +  # Auto-scale y-axis
  theme_minimal()

# ✅ Scatter Plot  of expenditure against landholdings (Level)
ggplot(data,aes(x=hhland / 100,y=exptot))+
  geom_point() + #add points
  ggtitle("Scatterplot of Expenditure against Landholdings (Level)")+
  xlab("Landholdings")+ylab("Expenditure")+
  theme_minimal()

# ✅ Scatter Plot  of expenditure against landholdings (Level)
ggplot(data,aes(x=lnland,y=lexptot))+
  geom_point() + #add points
  ggtitle("Scatterplot of Expenditure against Landholdings (Log)")+
  xlab("Log Landholdings")+ylab("Log Expenditure")+
  theme_minimal()

# Convert sexhead to a factor for grouping
data$sexhead <- factor(data$sexhead, labels = c("Male", "Female"))

# Kernel Density Plot for Expenditure
ggplot(data, aes(x = exptot, fill = sexhead)) + 
  geom_density(alpha = 0.5) +  # Transparent overlapping densities
  ggtitle("Kernel Density of Expenditure by Household Head Gender") +
  xlab("Total Expenditure") + ylab("Density") +
  xlim(min(0), max(15000)) +  # Fix xlim
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

# Kernel Density Plot for Landholdings
ggplot(data, aes(x = hhland, fill = sexhead)) + 
  geom_density(alpha = 0.5) +  
  ggtitle("Kernel Density of Landholdings by Household Head Gender") +
  xlab("Landholdings") + ylab("Density") +
  xlim(min(0), max(100)) +  # Fix xlim
  scale_fill_manual(values = c("blue", "red")) +
  theme_minimal()

#OLS regression of lexptot with and without female program
model1 <- lm(lexptot ~ progvillf, data=data)
summary(model1)
stargazer(model1, type="latex",
          title= "OLS Regression of Female Finance Program on Log Expenditures",
          dep.var.labels = c("Log Expenditure"),
          covariate.labels = c("Female Microfinance Program"),
          add.lines = list(c("Controls", " No")),
          omit.stat = c("f", "ser"), align = TRUE)

#OLS regression of lexptot with and without female program and other covariates
model2 <- lm(lexptot ~ progvillf + sexhead + agehead + 
               educhead + lnland + vaccess + pcirr + rice +
               wheat + milk + oil + egg, data=data)
summary(model2)
stargazer(model2, type="latex",
          title = "OLS Regression of Female Finance Program on Log Expenditures with Controls",
          dep.var.labels = "Log Expenditure",
          covariate.labels = c("Female Microfinance Program"),
          omit = c("sexhead", "agehead", "educhead", "lnland", "vaccess", 
                   "pcirr", "rice", "wheat", "milk", "oil", "egg"),
          add.lines = list(c("Controls", " Yes")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)

#OLS regression of lexptot with and without household participation
model3 <- lm(lexptot ~ dfmfd, data=data)
summary(model3)
stargazer(model3, type="latex",
          title= "OLS Regression of Households that Participated on Log Expenditures",
          dep.var.labels = c("Log Expenditure"),
          covariate.labels = c("Household with Female Participant"),
          add.lines = list(c("Controls", "No")),
          omit.stat = c("f", "ser"), align = TRUE)

#OLS regression of lexptot with and without female program and other covariates
model4 <- lm(lexptot ~ dfmfd + sexhead + agehead + 
               educhead + lnland + vaccess + pcirr + rice +
               wheat + milk + oil + egg, data=data)
summary(model4)
stargazer(model4, type="latex",
          title = "OLS Regression of Households that Participated on Log Expenditures with Controls",
          dep.var.labels = "Log Expenditure",
          covariate.labels = c("Household with Female Participant"),
          omit = c("sexhead", "agehead", "educhead", "lnland", "vaccess", 
                   "pcirr", "rice", "wheat", "milk", "oil", "egg"),
          add.lines = list(c("Controls", "Yes")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)

#OLS regression of lexptot with and without household participation and existence of female microfinance program
model5 <- lm(lexptot ~ progvillf + dfmfd + progvillf*dfmfd, data = data)
summary(model5)
stargazer(model5, type="latex",
          title= "OLS Regression of Female Finance Program, Households that Participated, and Interaction on Log Expenditures",
          dep.var.labels = "Log Expenditure",
          covariate.labels = c("Female Microfinance Program", "Household with Female Participant",
          "Female Microfinance Program x Household with Female Participant"),
          add.lines = list(c("Controls", "No")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)

#OLS regression of lexptot with and without household participation and existence of female microfinance program with controls
model6 <- lm(lexptot ~ progvillf + dfmfd + progvillf*dfmfd + sexhead + agehead + 
               educhead + lnland + vaccess + pcirr + rice +
               wheat + milk + oil + egg, data = data)
summary(model5)
stargazer(model6, type="latex",
          title= "OLS Regression of Female Finance Program, Households that Participated, and Interaction on Log Expenditures with Controls",
          dep.var.labels = "Log Expenditure",
          covariate.labels = c("Female Microfinance Program", "Household with Female Participant",
                               "Female Microfinance Program x Household with Female Participant"),
          omit = c("sexhead", "agehead", "educhead", "lnland", "vaccess", 
                   "pcirr", "rice", "wheat", "milk", "oil", "egg"),
          add.lines = list(c("Controls", "Yes")),  # Adds a row indicating controls were included
          omit.stat = c("f", "ser"), align = TRUE)










