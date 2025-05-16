#install.packages("ggplot2","haven","stargazer","dplyr","tidyr","rdrobust","rddensity","knitr)  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
library(tidyr)
library(rdrobust)
library(rddensity)
library(knitr)

#Import Dataset
adkw <- read_dta("Downloads/Coding/R/Metric2_Causal/adkw.dta")

#####################################################################################

#RD Robust Regression
rd_result <- rdrobust(
  y = adkw$death1year ,
  x = adkw$dbirwt ,
  c = 1500 ,
  h = 85 ,
  p=1,
  kernel = "triangular"
)

summary(rd_result)
summary(adkw$dbirwt)
summary(adkw$death1year)

mean_y_above <-adkw %>% filter(dbirwt >= 1500) %>% summarize(
  n = n(),
  nonmissing = sum(!is.na(death1year)),
  mean_y = mean(death1year, na.rm = TRUE)) %>%
  pull(mean_y)

#Building dummy variable for stargazer
adkw <- adkw %>%
  mutate(
    dummy1 = if_else(death1year>= 0, 1, 0),
    dummy2 = if_else(death1year>= 0, 1, 0)
  )

rd_lm <- lm(death1year ~ 0 + dummy1 + dummy2, data = adkw)

est <- -1*(rd_result$Estimate[1]) #coefficient
se <- rd_result$se[1] #std error
p <- rd_result$pv[1] #p-value
####################################################################################
#OLS regression 1
adkw <- adkw %>%
  mutate(
    VLBW = if_else(dbirwt < 1500, 1, 0), #very birth rate
    HBW = if_else(dbirwt >= 1500, 1, 0), #very birth rate
    distance = sqrt((dbirwt - 1500)^2) / 100, #distance measure
    grco = sqrt((dbirwt - 1500)^2) / 100
  )
ols_regression <- lm(death1year ~ VLBW + distance + VLBW:distance, data = adkw)
summary(ols_regression)

ols_regression2 <- lm(death1year ~ HBW + grco + HBW:grco, data = adkw)
summary(ols_regression2)

ols_se <- summary(ols_regression)$coefficients[, "Std. Error"]
ols_se2 <- summary(ols_regression2)$coefficients[, "Std. Error"]

ols_pvalues <- summary(ols_regression)$coefficients[, "Pr(>|t|)"]
ols_pvalues2 <- summary(ols_regression2)$coefficients[, "Pr(>|t|)"]


VLBW_coef <- ols_regression$coefficients[2]
VLBW_se <- ols_se[2]
VLBW_p <- ols_pvalues[2]

HBWinteraction <- ols_regression$coefficients[3]
HBWinteraction_se <- ols_se[3]
HBWinteraction_p <- ols_pvalues[3]


VLBWinteraction <- -1*ols_regression2$coefficients[3]
VLBW_interaction_se <- ols_se2[3]
VLBW_interaction_p <- ols_pvalues2[3]

#Building Dummy Variable for Stargazer
adkw <- adkw %>%
  mutate(
    dummy4 = if_else(death1year>= -1, 0, 0),
    dummy5 = if_else(death1year>= -1, 0, 0),
    dummy6 = if_else(death1year>= -1, 0, 0)
  )

ols_lm <- lm(death1year ~  1 + dummy4 + dummy5 + dummy6, data = adkw)
ols_lm$coefficients <- c(VLBW_coef, VLBWinteraction, HBWinteraction)
####################################################################################
#Combining them both
est_combined <- c(est, VLBW_coef)
s_combind <- c(se, VLBW_se, HBWinteraction_se)
p_combined <- c(p, VLBW_p, VLBW_interaction_p, HBWinteraction_p)
####################################################################################
#Stargazer RD
stargazer::stargazer(
          rd_lm,
          type = "text",
          title = "Infant Mortality at Very-Low-Birth-Weight Status",
          coef = list(c(est, mean_y_above)),
          se   = list(c(se, NA)),
          p    = list(c(p, NA)),
          summary = FALSE,
          dep.var.labels = c("One-year Mortality"),
          column.labels = c("Local linear model"),
          covariate.labels = c("Birth weight < 1,500g",
                               "Mean of dependent variable above cutoff"),
          omit.stat = c("f", "rsq", "adj.rsq", "ser"))

#Stargazer RD
stargazer::stargazer(
          ols_lm,
          type = "text",
          title = "Infant Mortality at Very-Low-Birth-Weight Status",
          se   = list(c(VLBW_se, VLBW_interaction_se, HBWinteraction_se)),
          p    = list(c(VLBW_p, VLBW_interaction_p, HBWinteraction_p)),
          summary = FALSE,
          dep.var.labels = c("One-year Mortality"),
          column.labels = c("OLS"),
          covariate.labels = c("Birth weight < 1,500g", 
                               "Birth weight < 1,500g x grams from cutoff (100s)",
                               "Birth weight > 1,500g x grams from cutoff (100s)"),
          omit.stat = c("f", "rsq", "adj.rsq", "ser"))

#Note to Nino Stargazer does not work very well when I have to input values but the values are generated from here
#Stargazer Together
stargazer::stargazer(rd_lm, ols_lm,
  type = "latex",
  title = "Infant Mortality at Very-Low-Birth-Weight Status",
  coef = list(c(est_combined, VLBWinteraction, HBWinteraction , mean_y_above)),
  se   = list(c(s_combind, NA)),
  p    = list(c(p_combined, NA)),
  summary = FALSE,
  dep.var.labels = c("One-year Mortality"),
  column.labels = c("Local linear model", "OLS"),
  covariate.labels = c("Birth weight < 1,500g",
                       "Mean of dependent variable above cutoff"),
  omit.stat = c("f", "rsq", "adj.rsq", "ser"))

#######################################################################################
#Bullet Point 1 histogram plot

ggplot(adkw, aes(x = dbirwt)) +
  geom_histogram( binwidth = 1, fill = "black", alpha = 0.5)+
  ggtitle("Histogram of Birthweights (grams)") +
  xlab("Birth Weight (g)") +
  ylab("Frequency") +
  xlim(min(adkw$dbirwt, na.rm = TRUE), max(adkw$dbirwt, na.rm = TRUE)) +
  ylim(0, NA) +
  theme_minimal()
#######################################################################################
#Bullet Point 2 RD Graph for 1-year Mortality

binned <- adkw %>%
  mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=28.35), include.lowest  = TRUE)) %>%
  group_by(bin) %>%
  summarise(
    mean_bw = mean(dbirwt, na.rm = TRUE), 
    mean_mortality = mean(death1year, na.rm =TRUE)
  )

ggplot(binned, aes(x = mean_bw, y = mean_mortality)) +
  geom_point() +
  theme_minimal() +
  ylim(0.04, 0.08) +
  geom_vline(xintercept = 1500, linetype = "solid") +
  labs(x = "Birth Weight (g)", y = "Mortality Rate")

binned2 <- adkw %>%
  mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=1), include.lowest = TRUE)) %>%
  group_by(bin) %>%
  summarise(
    mean_bw = mean(dbirwt, na.rm = TRUE), 
    mean_mortality = mean(death1year, na.rm =TRUE)
  )

ggplot(binned2, aes(x = mean_bw, y = mean_mortality)) +
  geom_point() +
  theme_minimal() +
  ylim(0.04, 0.08) +
  geom_vline(xintercept = 1500, linetype = "solid") +
  labs(x = "Birth Weight (g)", y = "Mortality Rate")

binned3 <- adkw %>%
  mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=5), include.lowest = TRUE)) %>%
  group_by(bin) %>%
  summarise(
    mean_bw = mean(dbirwt, na.rm = TRUE), 
    mean_mortality = mean(death1year, na.rm =TRUE)
  )

ggplot(binned3, aes(x = mean_bw, y = mean_mortality)) +
  geom_point() +
  theme_minimal() +
  ylim(0.04, 0.08) +
  geom_vline(xintercept = 1500, linetype = "solid") +
  labs(x = "Birth Weight (g)", y = "Mortality Rate")

binned4 <- adkw %>%
  mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=10), include.lowest = TRUE)) %>%
  group_by(bin) %>%
  summarise(
    mean_bw = mean(dbirwt, na.rm = TRUE), 
    mean_mortality = mean(death1year, na.rm =TRUE)
  )

ggplot(binned4, aes(x = mean_bw, y = mean_mortality)) +
  geom_point() +
  theme_minimal() +
  ylim(0.04, 0.08) +
  geom_vline(xintercept = 1500, linetype = "solid") +
  labs(x = "Birth Weight (g)", y = "Mortality Rate")

binned5 <- adkw %>%
  mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=20), include.lowest = TRUE)) %>%
  group_by(bin) %>%
  summarise(
    mean_bw = mean(dbirwt, na.rm = TRUE), 
    mean_mortality = mean(death1year, na.rm =TRUE)
  )

ggplot(binned5, aes(x = mean_bw, y = mean_mortality)) +
  geom_point() +
  theme_minimal() +
  ylim(0.04, 0.08) +
  geom_vline(xintercept = 1500, linetype = "solid") +
  labs(x = "Birth Weight (g)", y = "Mortality Rate")

#######################################################################################
#Work in Progress

cutoff_bp4 <- 1500
bw <- c(85, 50, 25, 10, 5)

adkw_sub_bp4 <- adkw %>%
  filter(dbirwt >= (cutoff_bp4 - bw), dbirwt <= (cutoff_bp4 + bw)) %>%
  mutate(group = ifelse(dbirwt < cutoff_bp4, "Below", "Above"))

summary_table_bp4 <- adkw_sub_bp4 %>%
  group_by(group) %>%
  summarize(
    mean_mortality = mean(death1year, na.rm = TRUE),
    sd_mortality = sd(death1year, na.rm = TRUE),
    n = sum(!is.na(death1year)),
    .groups = "drop"
  ) %>%
  pivot_wider(names_from = group, values_from = c(mean_mortality, sd_mortality, n)) %>%
  mutate(
    diff = mean_mortality_Above - mean_mortality_Below,
    se_diff = sqrt((sd_mortality_Above^2 / n_Above)+ (sd_mortality_Below^2 / n_Below))
  )

stargazer_bp4 <- data.frame(
  Variable = "Death within 1 Year",
  Bandwidth = bw,
  Mean_Below = summary_table_bp4$mean_mortality_Below,
  Mean_Above = summary_table_bp4$mean_mortality_Above,
  Difference = summary_table_bp4$diff,
  SE = summary_table_bp4$se_diff
)



stargazer(stargazer_bp4, type = "text", summary = FALSE,
          title = "Table 1: Summary Statistics and the Cutoff",
          rownames = FALSE
           )


cutoff <- 1500
bandwidths <- c(85, 50, 25, 10, 5)
bin_sizes <- c(5, 10, 20)

# Function to compute table for one combo of bandwidth and bin size
compute_binned_summary <- function(bw, bin_size) {
  adkw_sub <- adkw %>%
    filter(dbirwt >= (cutoff - bw), dbirwt <= (cutoff + bw)) %>%
    mutate(
      bin = cut(dbirwt, breaks = seq(cutoff - bw, cutoff + bw, by = bin_size), include.lowest = TRUE),
      group = ifelse(dbirwt < cutoff, "Below", "Above")
    )
  
  summary <- adkw_sub %>%
    group_by(group) %>%
    summarise(
      mean_mortality = mean(death1year, na.rm = TRUE),
      sd_mortality = sd(death1year, na.rm = TRUE),
      n = sum(!is.na(death1year)),
      .groups = "drop"
    ) %>%
    pivot_wider(names_from = group, values_from = c(mean_mortality, sd_mortality, n)) %>%
    mutate(
      Bandwidth = bw,
      BinSize = bin_size,
      Variable = "1-Year Mortality",
      Difference = mean_mortality_Above - mean_mortality_Below,
      SE = sqrt((sd_mortality_Above^2 / n_Above) + (sd_mortality_Below^2 / n_Below))
    ) %>%
    select(Variable, Bandwidth, BinSize, mean_mortality_Below, mean_mortality_Above, Difference, SE)
  
  return(summary)
}
param_grid <- expand.grid(bw = bandwidths, bin_size = bin_sizes)

results_list <- Map(compute_binned_summary, param_grid$bw, param_grid$bin_size)
results_df <- bind_rows(results_list)

colnames(results_df) <- c("Variable", "Bandwidth", "Bin Size", "Mean Below", "Mean Above", "Difference", "SE")

results_rounded <- results_df %>%
  mutate(across(where(is.numeric), ~ round(.x, 3)))

library(stargazer)

stargazer(results_rounded,
          type = "latex",
          summary = FALSE,
          title = "Table: RD Summary Statistics by Bandwidth and Bin Size",
          rownames = FALSE)


#######################################################################################
#Bullet Point 3 RD Graphs

#Linear
rdplot(
  y = adkw$death1year,
  x = adkw$dbirwt,
  c = 1500, 
  x.label = "Birth Weight (g)",
  y.label = "Mortality Rate",
  title = "                Linear Polynomial Specifcation ",
  binselect = "es",
  p=1
)

#quadratic
rdplot(
  y = adkw$death1year,
  x = adkw$dbirwt,
  c = 1500, 
  x.label = "Birth Weight (g)",
  y.label = "Mortality Rate",
  title = "                Quadratic Polynomial Specifcation ",
  binselect = "es",
  p=2
)

#cubic
rdplot(
  y = adkw$death1year,
  x = adkw$dbirwt,
  c = 1500, 
  x.label = "Birth Weight (g)",
  y.label = "Mortality Rate",
  title = "                Cubic Polynomial Specifcation ",
  binselect = "es",
  p=3
)

#4th order
rdplot(
  y = adkw$death1year,
  x = adkw$dbirwt,
  c = 1500, 
  x.label = "Birth Weight (g)",
  y.label = "Mortality Rate",
  title = "                Fourth-Order Polynomial Specifcation ",
  binselect = "es",
  p=4
)

#5th order
rdplot(
  y = adkw$death1year,
  x = adkw$dbirwt,
  c = 1500, 
  x.label = "Birth Weight (g)",
  y.label = "Mortality Rate",
  title = "                Fifth-Order Polynomial Specifcation ",
  binselect = "es",
  p=5
)

#opt fitting order
left_data <- subset(adkw, dbirwt < 1500)
lm_left <- lm(death1year ~ poly(dbirwt, 2), data = left_data, na.action = na.omit)

right_data <- subset(adkw, dbirwt >= 1500)
lm_right <- lm(death1year ~ poly(dbirwt, 5), data = right_data, na.action = na.omit)

x_left <- seq(min(left_data$dbirwt, na.rm = TRUE), 1500, length.out = 100)
x_right <- seq(1500,max(right_data$dbirwt, na.rm = TRUE), length.out = 100)

pred_left <- predict(lm_left, newdata = data.frame(dbirwt = x_left))
pred_right <- predict(lm_right, newdata = data.frame(dbirwt = x_right))

fit_df <- data.frame(
  dbirwt = c(x_left, x_right),
  fit = c(pred_left, pred_right),
  side = rep(c("Left","Right"),each = 100)
)

ggplot(adkw, aes(x = dbirwt, y = death1year)) + 
  geom_point(alpha = 0.3, color = "gray50", size = 1.5)+
  geom_point(data = binned, aes(x = mean_bw, y = mean_mortality),
             color = "black", size = 2.5, shape = 21, fill = "black", stroke = 1) + 
  geom_line(data = fit_df, aes(x = dbirwt, y = fit, color = side),linewidth = 1) +
  geom_vline(xintercept = 1500, linetype = "solid", color = "black")+
  xlim(min(adkw$dbirwt, na.rm = TRUE), max(adkw$dbirwt, na.rm = TRUE)) +
  ylim(0, .1) +
  labs(
    title = "RD Plot with Custom Polynomial Specification",
    x = "Birth Weight (g)",
    y = "Mortality Rate"
  )+
  scale_color_manual(values = c("Left"= "blue", "Right"="red"))+
  theme_minimal() +
  theme(legend.position = "none")

################################################################################
#Bullet Point 4 Work in progress

cutoff <- 1500
bandwidths <- c(85, 50, 25, 10, 5)
orders <- c(0, 1, 2, 3, 4)

# Create grid of combinations
param_grid <- expand.grid(p = orders, h = bandwidths)

# Function to run rdrobust and return string-formatted cell
get_est_se <- function(p, h) {
  tryCatch({
    fit <- rdrobust(y = adkw$death1year, x = adkw$dbirwt, c = cutoff, h = h, p = p)
    est <- round(fit$coef[1], 3)
    se <- round(fit$se[1], 3)
    sprintf("%.3f (%.3f)", est, se)
  }, error = function(e) {
    "NA"
  })
}

# Run it
param_grid$cell <- mapply(get_est_se, param_grid$p, param_grid$h)

# Pivot to table style
table2 <- param_grid %>%
  select(p, h, cell) %>%
  pivot_wider(names_from = h, values_from = cell) %>%
  rename(`Polynomial Order` = p)

print(table2)



table2_bp4 <- table2 %>%
  mutate(across(where(is.numeric), ~.x * -1))

colnames(table2_bp4) <- c("Polynomial Order", "h = 85", "h = 50", "h = 25", "h = 10", "h = 5")

stargazer(table2_bp4,
          type = "latex",
          summary = FALSE,
          title = "Table 2: RD Estimates by Bandwidth and Polynomial Order",
          rownames = FALSE)


cutoff <- 1500
bandwidths <- c(85,80, 75, 70, 65, 60, 55, 50, 45, 40, 35, 30,25, 15, 10, 5)

# Run rdrobust and collect results
rd_sensitivity <- lapply(bandwidths, function(h) {
  tryCatch({
    fit <- rdrobust(y = adkw$death1year, x = adkw$dbirwt, c = cutoff, h = h)
    data.frame(
      Bandwidth = h,
      Estimate = fit$coef[1],
      SE = fit$se[1]
    )
  }, error = function(e) {
    message("Failed for h = ", h)
    data.frame(Bandwidth = h, Estimate = NA, SE = NA)
  })
})

# Combine
rd_plot_data <- do.call(rbind, rd_sensitivity)

rd_plot_data <- rd_plot_data %>%
  mutate(
    Estimate = Estimate * -1,
    CI_lower = (Estimate - 1.96 * SE),
    CI_upper = (Estimate + 1.96 * SE)
  )


ggplot(rd_plot_data, aes(x = Bandwidth, y = Estimate)) +
  geom_point(size = 2, color = "steelblue") +
  geom_errorbar(aes(ymin = CI_lower, ymax = CI_upper), width = 5, color = "black") +
  geom_hline(yintercept = -.012, linetype = "dashed", color="red") +
  labs(
    title = "Sensitivity of RD Estimate to Bandwidth Choice",
    x = "Bandwidth (h)",
    y = "Estimated Treatment Effect"
  ) +
  theme_minimal()

################################################################################
  #Bullet Point 5 
  
  #Histogram fir births
  ggplot(adkw, aes(x = gestat)) +
    geom_histogram( binwidth = 1, fill = "black", alpha = 0.5)+
    ggtitle("Histogram of Gestational Age (weeks)") +
    xlab("Gestational Age (weeks)") +
    ylab("Frequency") +
    xlim(min(adkw$gestat, na.rm = TRUE), max(adkw$gestat, na.rm = TRUE)) +
    ylim(0, NA) +
    theme_minimal()
  
  binned_gest <- adkw %>%
    mutate(bin = cut(adkw$dbirwt, breaks = seq(1350, 1650, by=28), include.lowest  = TRUE)) %>%
    group_by(bin) %>%
    summarise(
      mean_bw = mean(dbirwt, na.rm = TRUE), 
      mean_gest = mean(gestat, na.rm =TRUE)
    )
  
  ggplot(binned_gest, aes(x = mean_bw, y = mean_gest)) +
    geom_point() +
    theme_minimal() +
    ylim(31, 33) +
    geom_vline(xintercept = 1500, linetype = "solid") +
    labs(x = "Birth Weight (g)", y = "Gestational Age")
  
  
  #RD for Gest Table
  rd_result_gest <- rdrobust(
    y = adkw$gestat ,
    x = adkw$dbirwt ,
    c = 1500 ,
    h = 85 ,
    p=1,
    kernel = "triangular"
  )
  
  summary(rd_result_gest)
  summary(adkw$dbirwt)
  summary(adkw$gestat)
  
  mean_y_above_gest <-adkw %>% filter(dbirwt >= 1500) %>% summarize(
    n = n(),
    nonmissing = sum(!is.na(gestat)),
    mean_y_gest = mean(gestat, na.rm = TRUE)) %>%
    pull(mean_y_gest)
  
  #Building dummy variable for stargazer
  adkw <- adkw %>%
    mutate(
      dummy1 = if_else(gestat>= 0, 1, 0),
      dummy2 = if_else(gestat>= 0, 1, 0)
    )
  
  rd_lm_gest <- lm(gestat ~ 0 + dummy1 + dummy2, data = adkw)
  
  est_gest <- -1*(rd_result_gest$Estimate[1]) #coefficient
  se_gest <- rd_result_gest$se[1] #std error
  p_gest <- rd_result_gest$pv[1] #p-value
  
  stargazer::stargazer(
    rd_lm_gest,
    type = "text",
    title = "Gestational Age at Very-Low-Birth-Weight Status",
    coef = list(c(est_gest, mean_y_above_gest)),
    se   = list(c(se_gest, NA)),
    p    = list(c(p_gest, NA)),
    summary = FALSE,
    dep.var.labels = c("Gestatinal Age"),
    column.labels = c("Local linear model"),
    covariate.labels = c("Birth weight < 1,500g",
                         "Mean of dependent variable above cutoff"),
    omit.stat = c("f", "rsq", "adj.rsq", "ser"))
  
  ##############################################################################
  #Bullet Point 6
  
  ols_regression_gest <- lm(death1year ~ VLBW + distance + VLBW:distance + gestat, data = adkw)
  summary(ols_regression_gest)
  
  ols_regression2_gest <- lm(death1year ~ HBW + grco + HBW:grco + gestat, data = adkw)
  summary(ols_regression2_gest)
  
  ols_se_gest <- summary(ols_regression_gest)$coefficients[, "Std. Error"]
  ols_se2_gest <- summary(ols_regression2_gest)$coefficients[, "Std. Error"]
  
  ols_pvalues_gest <- summary(ols_regression_gest)$coefficients[, "Pr(>|t|)"]
  ols_pvalues2_gest <- summary(ols_regression2_gest)$coefficients[, "Pr(>|t|)"]
  
  
  VLBW_coef_gest <- ols_regression_gest$coefficients[2]
  VLBW_se_gest <- ols_se_gest[2]
  VLBW_p_gest <- ols_pvalues_gest[2]
  
  HBWinteraction_gest <- ols_regression_gest$coefficients[3]
  HBWinteraction_se_gest <- ols_se_gest[3]
  HBWinteraction_p_gest <- ols_pvalues_gest[3]
  
  
  VLBWinteraction_gest <- -1*ols_regression2_gest$coefficients[3]
  VLBW_interaction_se_gest <- ols_se2_gest[3]
  VLBW_interaction_p_gest <- ols_pvalues2_gest[3]
  
  #Building Dummy Variable for Stargazer
  adkw <- adkw %>%
    mutate(
      dummy4_gest = if_else(gestat>= -1, 0, 0),
      dummy5_gest = if_else(gestat>= -1, 0, 0),
      dummy6_gest = if_else(gestat>= -1, 0, 0),
      dummy7_gest = if_else(gestat>= -1, 0, 0)
    )
  
  ols_lm_gest <- lm(gestat ~  1 + dummy4_gest + dummy5_gest + dummy6_gest + dummy7_gest, data = adkw)
  ols_lm_gest$coefficients <- c(VLBW_coef_gest, VLBWinteraction_gest, HBWinteraction_gest)
  
  #Stargazer RD
  stargazer::stargazer(
    ols_lm_gest,
    type = "latex",
    title = "Infant Mortality at Very-Low-Birth-Weight Status with Controls",
    se   = list(c(VLBW_se_gest, VLBW_interaction_se_gest, HBWinteraction_se_gest)),
    p    = list(c(VLBW_p_gest, VLBW_interaction_p_gest, HBWinteraction_p_gest)),
    summary = FALSE,
    dep.var.labels = c("One-year Mortality"),
    column.labels = c("OLS"),
    covariate.labels = c("Birth weight < 1,500g", 
                         "Birth weight < 1,500g x grams from cutoff (100s)",
                         "Birth weight > 1,500g x grams from cutoff (100s)"),
    add.lines = list(c("Controls", " Yes")),
    omit.stat = c("f", "rsq", "adj.rsq", "ser"))
  
  
  #Note to Nino: Stargazer still does not like when I enter in the values this way so I am putting them in manually
  
  
  
  
  
  
  
  
  
  