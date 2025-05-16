#install.packages("ggplot2","haven","stargazer","dplyr","tidyr")  # Install if needed
library(ggplot2)
library(haven)
library(stargazer)
library(dplyr)
library(tidyr)

#Question 2a:
#Defining new variables 
# Load Data
replic_malaria_us <- read_dta("Downloads/Coding/R/Metric2_Causal/replic_malaria_us.dta")
View(replic_malaria_us)

data <- replic_malaria_us

#Specifying the percentile variables
upper_perc <- quantile(data$malmort1890, 0.90, na.rm = TRUE)
lower_perc <- quantile(data$malmort1890, 0.10, na.rm = TRUE)
#Here we are setting a boundary for what is considered a high vs low area for malaria infection 
#from the malaria mortality stats in 1890

#Defining the new variables
data <- data %>% 
  mutate(
    young = if_else(exp_mal == 1, 1, 0),
    old = if_else(exp_mal == 0, 1, 0),
    high_malaria_area = if_else(malmort1890 >= upper_perc, 1, 0),
    low_malaria_area = if_else(malmort1890 <= lower_perc, 1, 0)
  )
#Using those distinctions and knowledge of cohorts that would have been exposed to this program
#since birth we can classify them as such

#Defining sei_diff
data_filtered <- data %>% 
  filter(
    (high_malaria_area == 1 | low_malaria_area == 1) &
  (young == 1 | old == 1)
  )
data_labeled <- data_filtered %>%
  mutate(
    malaria_area = case_when(
      high_malaria_area == 1 ~ "high",
      low_malaria_area == 1 ~ "low"
    ),
    age_group = case_when(
      young == 1 ~ "young",
      old == 1 ~ "old"
    )
  )
sei_summary <- data_labeled %>% 
  group_by(year, age_group, malaria_area) %>%
  summarise(
    mean_sei = mean(sei, na.rm = TRUE),
    .groups = "drop"
  )
sei_diff_data <- sei_summary %>%
  pivot_wider(names_from = malaria_area, values_from = mean_sei) %>%
  mutate(sei_diff = high - low)

#Plotting results
ggplot(sei_diff_data, aes(x = year, y = sei_diff)) +
  geom_point() + 
  facet_wrap(~ age_group)+
  labs(
    title = "                                                Difference in SEI (High-Low Malaria Areas)",
    x = "Census Year ",
    y = "SEI Difference"
  )+
  theme_minimal()
  
#######################################################################################
#Question 2b
# Mean log SEI by malaria area and age group
sei_table <- data_labeled %>%
  group_by(malaria_area, age_group) %>%
  summarise(mean_log_sei = mean(sei, na.rm = TRUE)) %>%
  pivot_wider(names_from = malaria_area, values_from = mean_log_sei)

print(sei_table)
stargazer(sei_table,
          summary=FALSE,
          title = "2x2 Diff-in-Diff Tables of Mean log Duncan SEI",
          rownames = FALSE,
          label = "sei_diff_in_diff_table",
          digits = 3,
          out = "sei_dd_table.tex"
          )

#Mean Occupational Income score by Malaria area and age group
occ_table <- data_labeled %>%
  group_by(malaria_area, age_group) %>%
  summarise(mean_log_occ = mean(occscore, na.rm = TRUE)) %>%
  pivot_wider(names_from = malaria_area, values_from = mean_log_occ)

print(occ_table)
stargazer(occ_table,
          summary=FALSE,
          title = "2x2 Diff-in-Diff Tables of Occupational Income Score",
          rownames = FALSE,
          label = "occ_diff_in_diff_table",
          digits = 3,
          out = "occ_dd_table.tex"
          )
#######################################################################################
#Question 2C
regression1 <- lm(sei ~ young + high_malaria_area + young*high_malaria_area, data = data_labeled)
summary(regression1)

stargazer(regression1, type = "text",
          title = "Diff-in-Diff Regression of Mean log Duncan SEI",
          summary = FALSE,
          dep.var.labels = "Log SEI Index",
          covariate.labels = c("Young","High Malaria Area", "Young:High Malaria Area")
          )

regression2 <- lm(occscore ~ young + high_malaria_area + young*high_malaria_area, data = data_labeled)
summary(regression2)

stargazer(regression2, type = "text",
          title = "Diff-in-Diff Regression of Occupational Income Score",
          summary=FALSE,
          dep.var.labels = "Log Occupational Score",
          covariate.labels = c("Young","High Malaria Area", "Young:High Malaria Area")
          )
#######################################################################################
#Question 2e
#Defining sei_diff for the young and old comparison
data2 <- replic_malaria_us %>% 
  mutate(
    young = if_else(yob >= 1920 & yob < 1940, 1, 0),
    old = if_else(yob <= 1899 & yob > 1860, 1, 0),
    high_malaria_area = if_else(malmort1890 >= upper_perc, 1, 0),
    low_malaria_area = if_else(malmort1890 <= lower_perc, 1, 0)
  )

#Defining sei_diff
data_filtered2 <- data2 %>% 
  filter(
    (high_malaria_area == 1 | low_malaria_area == 1) &
      (young == 1 | old == 1)
  )
data_labeled2 <- data_filtered2 %>%
  mutate(
    malaria_area = case_when(
      high_malaria_area == 1 ~ "high",
      low_malaria_area == 1 ~ "low"
    ),
    age_group = case_when(
      young == 1 ~ "young",
      old == 1 ~ "old"
    )
  )

# Mean log SEI by malaria area and age group
sei_table2 <- data_labeled2 %>%
  group_by(malaria_area, age_group) %>%
  summarise(mean_log_sei = mean(sei, na.rm = TRUE)) %>%
  pivot_wider(names_from = malaria_area, values_from = mean_log_sei)

print(sei_table2)
stargazer(sei_table,
         summary=FALSE,
           title = "2x2 Diff-in-Diff Tables of Mean log Duncan SEI",
           rownames = FALSE,
           label = "sei_diff_in_diff_table",
         digits = 3,
           out = "sei_dd_table.tex"
           )

regression3 <- lm(sei ~ young + high_malaria_area + young*high_malaria_area, data = data_labeled2)
summary(regression3)
stargazer(regression3, type = "latex",
          title = "Diff-in-Diff Regression of Mean log Duncan SEI",
          summary = FALSE,
          dep.var.labels = "Log SEI Index",
          covariate.labels = c("Young","High Malaria Area", "Young:High Malaria Area")
          )

#Defining sei_diff for the very young and very old comparison
data3 <- replic_malaria_us %>% 
  mutate(
    very_young = if_else(yob >= 1940, 1, 0),
    very_old = if_else(yob <= 1860, 1, 0),
    high_malaria_area = if_else(malmort1890 >= upper_perc, 1, 0),
    low_malaria_area = if_else(malmort1890 <= lower_perc, 1, 0)
  )

#Defining sei_diff
data_filtered3 <- data3 %>% 
  filter(
    (high_malaria_area == 1 | low_malaria_area == 1) &
      (very_young == 1 | very_old == 1)
  )
data_labeled3 <- data_filtered3 %>%
  mutate(
    malaria_area = case_when(
      high_malaria_area == 1 ~ "high",
      low_malaria_area == 1 ~ "low"
    ),
    age_group = case_when(
      very_young == 1 ~ "very young",
      very_old == 1 ~ "very old"
    )
  )

# Mean log SEI by malaria area and age group
sei_table3 <- data_labeled3 %>%
  group_by(malaria_area, age_group) %>%
  summarise(mean_log_sei = mean(sei, na.rm = TRUE)) %>%
  pivot_wider(names_from = malaria_area, values_from = mean_log_sei)

print(sei_table3)
stargazer(sei_table3,
          summary=FALSE,
          title = "2x2 Diff-in-Diff Tables of Mean log Duncan SEI",
          rownames = FALSE,
          label = "sei_diff_in_diff_table3",
          digits = 3,
          out = "sei_dd_table3.tex")
#######################################################################################
#Question 3c
#part 1
replic_malaria_us$aob_controls <- rowSums(
  replic_malaria_us[, c("hookworm", "lebergott99", "south")] *
    replic_malaria_us$exp_mal,
  na.rm = TRUE
)
  
q3_regression <- lm(occscore ~ malmort1890 * exp_mal + yob + bplg + year 
                     + aob_controls, data = replic_malaria_us)
summary(q3_regression)

stargazer(
  q3_regression,
  type = "latex",
  title = "Base regression",
  summary = FALSE,
  dep.var.labels = "Log Occupational Income Score",
  covariate.labels = c("Baseline"),
  omit = c("yob", "bplg", "year", "aob_controls", "malmort1890", "exp_mal"),
  keep = c("malmort1890:exp_mal")
)

#part 2
replic_malaria_us$post1920 <- if_else(replic_malaria_us$yob < 1920, 0, replic_malaria_us$yob)

q3_regression2 <- lm(occscore ~ malmort1890 * exp_mal + yob + bplg + year 
                    + aob_controls + post1920*bplg , data = replic_malaria_us, na.rm = TRUE)
summary(q3_regression2)

stargazer(
  q3_regression2,
  type = "latex",
  title = "Post 1920",
  summary = FALSE,
  dep.var.labels = "Log Occupational Income Score",
  covariate.labels = c("Post-1920 break in birthplace time trend"),
  omit = c("yob", "bplg", "year", "aob_controls", "malmort1890", "exp_mal","post1920","south"),
  keep = c("malmort1890:exp_mal")
)

#part3
q3_regression3 <- lm(occscore ~ malmort1890 * exp_mal + yob + bplg + year 
                    + aob_controls +bplg*year, data = replic_malaria_us)
summary(q3_regression3)

stargazer(
  q3_regression3,
  type = "latex",
  title = "Base regression",
  summary = FALSE,
  dep.var.labels = "Log Occupational Income Score",
  covariate.labels = c("Allow for birthplace x time effects"),
  omit = c("yob", "bplg", "year", "aob_controls", "malmort1890", "exp_mal"),
  keep = c("malmort1890:exp_mal")
)

#part 4
part4data <- replic_malaria_us %>%
  filter(year > 1930)

q3_regression4 <- lm(occscore ~ malmort1890 * exp_mal + yob + bplg + year 
                    + aob_controls, data = part4data)
summary(q3_regression4)

stargazer(
  q3_regression4,
  type = "latex",
  title = "Base regression",
  summary = FALSE,
  dep.var.labels = "Log Occupational Income Score",
  covariate.labels = c("Drop early census years (<1930)"),
  omit = c("yob", "bplg", "year", "aob_controls", "malmort1890", "exp_mal"),
  keep = c("malmort1890:exp_mal")
)

#part 5
q3_regression5 <- lm(occscore ~ malmort1890 * exp_mal + yob + bplg + year 
                    + aob_controls +yob*south*year, data = replic_malaria_us)
summary(q3_regression5)

stargazer(
  q3_regression5,
  type = "latex",
  title = "Base regression",
  summary = FALSE,
  dep.var.labels = "Log Occupational Income Score",
  covariate.labels = c("Add region x year x YOB effects"),
  omit = c("yob", "bplg", "year", "aob_controls", "malmort1890", "exp_mal"),
  keep = c("malmort1890:exp_mal")
)



