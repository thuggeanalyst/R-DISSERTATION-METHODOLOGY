library(readr)
library(ggplot2)
library(dplyr)
library(corrplot)
library(stargazer)
DATA <- read_csv("AUTOMOTIVE DATA.csv")
str(DATA)
DATA = as.data.frame(DATA)
class(DATA)
# Sample 10,000 observations

sampled_data <- DATA %>% 
  sample_n(10000, replace = FALSE)

# Filter the 'year' column to include only years from 2000 to 2024
filtered_data <- subset(DATA, year >= 2000 & year <= 2024)

filtered_data$transmission = as.factor(filtered_data$transmission)
filtered_data$fuelType = as.factor(filtered_data$fuelType)
filtered_data$Manufacturer = as.factor(filtered_data$Manufacturer)
filtered_data$model = as.factor(filtered_data$model)
min(filtered_data$year)
max(filtered_data$year)
str(filtered_data)

#Check missing values 
na_count1 <-sapply(filtered_data, function(y) sum(length(which(is.na(y)))))
na_count1 <- data.frame(na_count1)
na_count1

##Resuls
summary(filtered_data)



# Step 1: Filter numeric columns
numeric <- filtered_data[, sapply(filtered_data, is.numeric)]
numeric_columns = numeric[, -1]
summary_statistics = summary(numeric_columns)
summary_statistics



# Calculate the correlation matrix
correlation_matrix <- cor(numeric_columns)
correlation_matrix
stargazer(correlation_matrix, type = "text")

corrplot(correlation_matrix, method = "circle")
corrplot(correlation_matrix, method = "circle", 
         main = "Correlation Matrix", addCoef.col = "black")

#create scatterplot of price, grouped by fuel type
ggplot(data = filtered_data, aes(x = fuelType, y = price)) + 
  geom_boxplot(fill = "steelblue") +
  ggtitle("Boxplot of Price by Fuel Type") +
  theme(plot.title = element_text(hjust = 0.5))

#create scatterplot of price, grouped by Transmission
ggplot(data = filtered_data, aes(x = transmission, y = price)) + 
  geom_boxplot(fill = "lightblue") +
  ggtitle("Boxplot of Price by Transimission") +
  theme(plot.title = element_text(hjust = 0.5))


#HYPOTHESIS TEST 

anova_T <- aov(price ~ transmission, data = filtered_data)

# Print the ANOVA summary
summary(anova_T)

# TurkeyHSD Test
THSD_T = TukeyHSD(anova_T)
THSD_T

anova_F <- aov(price ~ fuelType, data = filtered_data)

# Print the ANOVA summary
summary(anova_F)

# TurkeyHSD Test
THSD_F = TukeyHSD(anova_F)
THSD_F

anova_M <- aov(price ~ Manufacturer, data = filtered_data)

# Print the ANOVA summary
summary(anova_M)

# TurkeyHSD Test
THSD_M = TukeyHSD(anova_M)
THSD_M
# 
# anova_mo <- aov(price ~ model, data = filtered_data)
# 
# # Print the ANOVA summary
# summary(anova_mo)
# 
# # TurkeyHSD Test
# THSD_mo = TukeyHSD(anova_mo)
# THSD_mo

# normality check for the data variables
attach(filtered_data)
Q1 <- quantile(filtered_data$price, .25)
Q3 <- quantile(filtered_data$price, .75)
IQR <- IQR(filtered_data$price)

filtered_data_no_outliers = subset(filtered_data,
                                   filtered_data$price> (Q1 - 1.5*IQR) & filtered_data$price< (Q3 + 1.5*IQR))
boxplot(filtered_data_no_outliers$price)

ggplot(filtered_data_no_outliers, aes(price)) +
  geom_histogram(aes(y = ..density..), fill='lightgray', col='black') +
  stat_function(fun = dnorm, args = list(mean=mean(price), sd=sd(price))) +
  ggtitle("Distribution of Car Prices") +
  theme(plot.title = element_text(hjust = 0.5))

Q1 <- quantile(filtered_data$mpg, .25)
Q3 <- quantile(filtered_data$mpg, .75)
IQR <- IQR(filtered_data$mpg)
mpg_no_outliers = subset(filtered_data, filtered_data$mpg> (Q1 - 1.5*IQR) & filtered_data$mpg< (Q3 + 1.5*IQR))
boxplot(filtered_data_no_outliers$mpg)


ggplot(mpg_no_outliers, aes(mpg)) +
  geom_histogram(aes(y = ..density..), fill = 'lightgreen', col = 'black') +
  stat_function(fun = dnorm, args = list(mean = mean(mpg_no_outliers$mpg), sd = sd(mpg_no_outliers$mpg))) +
  ggtitle("Distribution of MPG") +
  theme(plot.title = element_text(hjust = 0.5))




# Min-max normalize the mpg variable
mpg_mm <- scale(mpg_no_outliers$mpg,
                              center = min(mpg_no_outliers$mpg), 
                              scale = max(mpg_no_outliers$mpg) - min(mpg_no_outliers$mpg))



Q1 <- quantile(filtered_data$tax, .25)
Q3 <- quantile(filtered_data$tax, .75)
IQR <- IQR(filtered_data$tax)

filtered_data_no_outliers = subset(filtered_data, filtered_data$tax> (Q1 - 1.5*IQR) & filtered_data$tax< (Q3 + 1.5*IQR))

boxplot(filtered_data_no_outliers$tax)


ggplot(filtered_data_no_outliers, aes(tax)) +
  geom_histogram(aes(y = ..density..), fill = 'lightyellow', col = 'black') +
  stat_function(fun = dnorm, args = list(mean = mean(filtered_data_no_outliers$tax), sd = sd(filtered_data_no_outliers$tax))) +
  ggtitle("Distribution of TAX with no ouliers") +
  theme(plot.title = element_text(hjust = 0.5))




Q1 <- quantile(filtered_data$engineSize, .25)
Q3 <- quantile(filtered_data$engineSize, .75)
IQR <- IQR(filtered_data$engineSize)

filtered_data_no_outliers = subset(filtered_data, filtered_data$engineSize> (Q1 - 1.5*IQR) & filtered_data$engineSize< (Q3 + 1.5*IQR))

boxplot(filtered_data$engineSize)


ggplot(filtered_data_no_outliers, aes(engineSize)) +
  geom_histogram(aes(y = ..density..), fill = 'lightyellow', col = 'black') +
  stat_function(fun = dnorm, args = list(mean = mean(filtered_data_no_outliers$tax), sd = sd(filtered_data_no_outliers$tax))) +
  ggtitle("Distribution of engine size with no ouliers") +
  theme(plot.title = element_text(hjust = 0.5))








# scatter plot of mpg and price
correlation_value <- cor(filtered_data$mpg, filtered_data$price)
ggplot(filtered_data, aes(x = mpg, y = price, color = Manufacturer)) +
  geom_point() +
  ggtitle(paste("Scatterplot of Miles Per Gallon vs. Price by Manufacturer (Correlation =", round(correlation_value, 2), ")")) +
  theme(plot.title = element_text(hjust = 0.5))

# scatter plot of mileage and price

correlation_value <- cor(filtered_data$mileage, filtered_data$price)

# Scatter plot of mileage and price
ggplot(filtered_data, aes(x = mileage, y = price, color = Manufacturer)) +
  geom_point() +
  ggtitle(paste("Scatterplot of Mileage vs. Price by Manufacturer (Correlation =", round(correlation_value, 2), ")")) +
  theme(plot.title = element_text(hjust = 0.5))


correlation_value <- cor(filtered_data$tax, filtered_data$price)

# Scatter plot of mileage and price
ggplot(filtered_data, aes(x = tax, y = price, color = Manufacturer)) +
  geom_point() +
  ggtitle(paste("Scatterplot of tax vs. Price by Manufacturer (Correlation =", round(correlation_value, 2), ")")) +
  theme(plot.title = element_text(hjust = 0.5))



correlation_value <- cor(filtered_data$engineSize, filtered_data$price)

# Scatter plot of mileage and price
ggplot(filtered_data, aes(x = engineSize, y = price, color = Manufacturer)) +
  geom_point() +
  ggtitle(paste("Scatterplot of engine size vs. Price by Manufacturer (Correlation =", round(correlation_value, 2), ")")) +
  theme(plot.title = element_text(hjust = 0.5))

#linear regression model
filtered_data$model = as.factor(filtered_data$model)
filtered_data$model = as.numeric(filtered_data$model)

filtered_data$transmission = as.factor(filtered_data$transmission)
filtered_data$transmission = as.numeric(filtered_data$transmission)

filtered_data$fuelType = as.factor(filtered_data$fuelType)
filtered_data$fuelType = as.numeric(filtered_data$fuelType)

filtered_data$Manufacturer = as.factor(filtered_data$Manufacturer)
filtered_data$Manufacturer = as.numeric(filtered_data$Manufacturer)

# price as the dependent variable
linear_regression1 <- lm(price ~ mpg + engineSize+tax+mileage+year+model+
                           transmission+fuelType+Manufacturer, data = filtered_data)
# Summarize the model
summary(linear_regression1)
stargazer(linear_regression1, type = "text")

# mpg as the dependet variable
linear_regression2 <- lm(mpg ~ price+engineSize+tax+mileage+year+model+
                           transmission+fuelType+Manufacturer, data = filtered_data)
# Summarize the model
summary(linear_regression2)
stargazer(linear_regression2, type = "text")

# Creating logarithmic data
filtered_data$model = log10(filtered_data$model)
filtered_data$transmission = log10(filtered_data$transmission)
filtered_data$mileage = log10(filtered_data$mileage)
filtered_data$mpg = log10(filtered_data$mpg)
filtered_data$tax = log10(filtered_data$tax)
filtered_data$fuelType = log10(filtered_data$fuelType)
filtered_data$Manufacturer = log10(filtered_data$Manufacturer)
filtered_data$engineSize = log10(filtered_data$engineSize)

sampled_data <- filtered_data%>%
  rename(ln_price = price)%>%
  rename(ln_transimission = transmission)%>%
  rename(ln_model = model)%>%
  rename(ln_tax = tax)%>%
  rename(ln_manufacturer = Manufacturer)%>%
  rename(ln_mpg = mpg)%>%
  rename(ln_engineSize = engineSize)%>%
  rename(ln_mileage = mileage)%>%
  rename(ln_fuelType = fuelType)

# Logarithmic mode
sampled_data$ln_tax[is.na(sampled_data$ln_tax) | sampled_data$ln_tax==Inf & sampled_data$ln_tax==-Inf ] = NA

# Replace -Inf values with NA in the ln_tax column
sampled_data$ln_tax[sampled_data$ln_tax == -Inf] <- NA
sampled_data$ln_engineSize[sampled_data$ln_engineSize == -Inf] <- NA

Log_model <- lm(ln_price ~ ln_mpg + ln_engineSize+ln_mileage+ln_model+
                  ln_transimission+ln_fuelType+ln_manufacturer,
                data =sampled_data)
# Summarize the model
summary(Log_model)
stargazer(Log_model, type = "text")





