#install.packages("ggplot2","haven","stargazer","dplyr","texreg","MatchIt","MASS","maxLik","Matching")  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
library(texreg)
library(MatchIt)
library(MASS)
library(maxLik)
library(Matching)

#Question 1a: Estimating the probit model by hand

#By Hand Probit
# Define my matrix X from the data
X <- as.matrix(data[,c("sexhead", "agehead", "educhead", "lnland", "vaccess", 
                       "pcirr", "rice", "wheat", "milk", "oil", "egg")])

# Standardize predictors (excluding intercept)
X <- scale(X)

# Add intercept column
X <- cbind(1, X)

# Define the negative log-likelihood function for Probit Model
probit_logLik <- function(params) {
  beta <- params
  linear_pred <- X %*% beta  # Compute Xβ
  
  # Compute predicted probabilities using the probit function (Φ(Xβ))
  p <- pnorm(linear_pred)
  
  # Avoid log(0) issues
  p <- pmax(p, 1e-6)  # Ensure p is never exactly 0
  p <- pmin(p, 1 - 1e-6)  # Ensure p is never exactly 1
  
  # Compute log-likelihood
  log_likelihood <- sum(data$dfmfd * log(p) + (1 - data$dfmfd) * log(1 - p))
  
  return(log_likelihood)  # maxLik maximizes by default
}


# Use GLM estimates as starting values for optimization
probit1 <- glm(dfmfd ~ sexhead + agehead + educhead + lnland + vaccess + 
                 pcirr + rice + wheat + milk + oil + egg, 
               data = data, family = binomial(link = "probit"))

init_params <- coef(probit1)  # Use GLM estimates as initial values

# Perform MLE optimization
mle_result <-  maxLik(logLik = probit_logLik, start = init_params)

# Extract estimated beta coefficients from MLE
beta_hat <- coef(mle_result) # Extract coefficients

# Compute predicted probabilities
predicted_prob <- pnorm(X %*% beta_hat) 

# Check the range of predicted probabilities
summary(predicted_prob)

manual_mle_results <-  cbind(Manual_Probit = beta_hat, Probit = coef(probit1))

stargazer(manual_mle_results, 
          summary = FALSE, 
          type = "latex",  # Use "latex" for LaTeX output
          title = "Comparison of Probit Estimates: Manual MLE vs GLM",
          digits = 4, 
          rownames = FALSE)
#Estimating logit model by hand
logit1 <- glm(formula_probit_logit, data=data,family = binomial(link = "logit"))
summary(logit1)

stargazer(probit1, logit1, type="latex", 
          title = "Probit/Logit Model of Female Participation in Microfinance")

#Question 1b Kernel density plot of predicted probabilities 
data$predicted_prob <- predicted_prob #Uses the probit results to get predicted probability
head(data[, c("dfmfd","predicted_prob")])

#Treated
treated_data <- data %>% filter (dfmfd ==1)

# Plot density for treated units only
ggplot(treated_data, aes(x = predicted_prob, fill = as.factor(dfmfd))) +
  geom_density(alpha = 0.5, color = "black") +
  labs(title = "Kernel Density Plot of Predicted Probabilities (Treated Only)",
       x = "Predicted Probability", y = "Density", fill = "Treatment Status") +
  scale_fill_manual(values = c("red"), labels = c("Treated")) +  # Only red for treated
  theme_minimal()

#Untreated
untreated_data <- data %>% filter (dfmfd ==0)

# Plot density for untreated units only
ggplot(untreated_data, aes(x = predicted_prob, fill = as.factor(dfmfd))) +
  geom_density(alpha = 0.5, color = "black") +
  labs(title = "Kernel Density Plot of Predicted Probabilities (Untreated Only)",
       x = "Predicted Probability", y = "Density", fill = "Treatment Status") +
  scale_fill_manual(values = c("blue"), labels = c("Untreated")) +  # Only red for treated
  theme_minimal()

#Treated and Untreated
ggplot(data, aes(x = predicted_prob, fill = as.factor(dfmfd))) +
  geom_density(alpha = 0.5) +
  labs(title = "Kernel Density Plot of Predicted Probabilities",
       x = "Predicted Probability", y = "Density", fill = "Treatment Status") +
  scale_fill_manual(values = c("blue", "red"), labels = c("Untreated", "Treated")) +
  theme_minimal()

#Question 3 Simple Linear Regression
regression1 <- lm(lexptot ~ dfmfd , data=data)
regression2 <- lm(lexptot ~ dfmfd + predicted_prob , data=data)
summary(regression1)
summary(regression2)

stargazer(regression1, regression2, type = "latex",
          title = "Simple Linear Regression")
#Question 5 
psm_model1 <- matchit(dfmfd ~ sexhead + agehead + educhead + lnland + vaccess + pcirr + rice + wheat + milk + oil + egg,
                      data = data, method = "nearest", estimand = "ATT", distance="logit",replace = TRUE)
matched_data <- match.data(psm_model1)
table(matched_data$dfmfd)

psm_regression <- lm(lexptot ~ dfmfd + distance, data = matched_data)
summary(psm_regression)

stargazer(psm_regression, type="text",
          title = "Propensity Score Regression",
          omit = c("distance"), align = TRUE)

#Question 6
#nonbiased
match_results <- Match(Y = data$lexptot, 
                       Tr = data$dfmfd,
                       X = cbind(data$educhead, data$lnland),
                       estimand = "ATT",
                       M=1)
summary(match_results)

match_table <- data.frame(
  Estimate = match_results$est,
  Std_Error = match_results$se,
  t_Value = match_results$est / match_results$se,
  p_Value = 2 * (1 - pnorm(abs(match_results$est / match_results$se)))
  )

print(match_table)

stargazer(match_table, type = "latex",
          title = "ATT of Nearest-Neighbor Matching",
          summary = FALSE,
          covariate.labels = c("dfmfd"),
          digits = 4)
#biased
match_results2 <- Match(Y = data$lexptot, 
                       Tr = data$dfmfd,
                       X = cbind(data$educhead, data$lnland),
                       estimand = "ATT",
                       M=1,
                       BiasAdjust = TRUE)


summary(match_results2)

match_table2 <- data.frame(
  Estimate = match_results2$est,
  Std_Error = match_results2$se,
  t_Value = match_results2$est / match_results2$se,
  p_Value = 2 * (1 - pnorm(abs(match_results2$est / match_results2$se)))
)

stargazer(match_table2, type = "latex",
          title = "ATT of Nearest-Neighbor Matching with Bias Adjustment",
          summary = FALSE,
          covariate.labels = c("dfmfd"),
          digits = 4)