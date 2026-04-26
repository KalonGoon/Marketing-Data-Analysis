getwd()


library("gridExtra") 
library("readxl")
library("tidyverse")
library("dplyr")
library("ggplot2")
library("lubridate")
library("rtsplot")
library("xts")
library("writexl")
df <- read_excel("/Users/kalong/Desktop/CODE3/dataset.xlsx")
#I read in the Excel File and assigned it to a dataframe. We have 174,226 rows
df
tidy_names(df)

#Selecting creative name lowercase
creativedf <- select(df, creative_name_low)
#verifying my method
creativedf
  
  #Question 1
#How many versions of creative were run?

#I converted all the creative_names to lower in Excel so it was easier to 
#manipulate data
creativedf %>%
  group_by(creative_name_low) %>%
  summarise( n = n())
count(unique(creativedf))
#Assigning creative_name to creative

#Question 2
#Did the newer version of creative have any effect? If so, how much?
head(creativedf)

ndf <- select(df, creative_name_low, impressions, clicks, conversions)
ndf
#Create a dataframe that only has new creatives
newcre <- ndf %>% filter(grepl('new', creative_name_low))
newcre
#Extract data I want
newcreatives <- select(newcre, creative_name_low, impressions, clicks, conversions)

#Create a dataframe that has 'standard' creatives
stdcre <- ndf %>% filter(!grepl('new', creative_name_low))
#Extract Data I want
stdcreatives <- select(stdcre, creative_name_low, impressions, clicks, conversions)

#Verifying my results
head(newcreatives)
head(stdcreatives)

#Compare clicks between them
par(mfrow=c(2,1))
ggp1 <- ggplot(stdcreatives, aes(x = factor(creative_name_low), y = clicks)) + 
  geom_bar(stat = "summary", fun = "mean")

ggp2<- ggplot(newcreatives, aes(x = factor(creative_name_low), y = clicks)) + 
  geom_bar(stat = "summary", fun = "mean")

summary(newcreatives$clicks)
summary(stdcreatives$clicks)

ggp1
ggp2


grid.arrange(ggp1, ggp2, ncol=2)

###
#Compare impressions between them
par(mfrow=c(2,1))
ggp3 <- ggplot(stdcreatives, aes(x = factor(creative_name_low), y = impressions)) + 
  geom_bar(stat = "summary", fun = "mean")

ggp4<- ggplot(newcreatives, aes(x = factor(creative_name_low), y = impressions)) + 
  geom_bar(stat = "summary", fun = "mean")



summary(newcreatives$impressions)
summary(stdcreatives$impressions)

ggp3
ggp4
grid.arrange(ggp3, ggp4, ncol=2)
###
#Compare conversions between them
par(mfrow=c(2,1))
ggp5 <- ggplot(stdcreatives, aes(x = factor(creative_name_low), y = conversions)) + 
  geom_bar(stat = "summary", fun = "mean")

ggp6<- ggplot(newcreatives, aes(x = factor(creative_name_low), y = conversions)) + 
  geom_bar(stat = "summary", fun = "mean")


summary(newcreatives$conversions)
summary(stdcreatives$conversions)

ggp5
ggp6
grid.arrange(ggp5, ggp6, ncol=2)

#Question 3
#Show the CPA and CVR for each campaign type that was run.
#I defined CPA to be cost per acquisition
#Where CPA is total amount spent / total attributed conversions

q3df <- select(df, campaign_name, creative_name_low, month,
               spend, impressions, clicks, conversions)
head(q3df)

spend <- q3df %>%
  group_by(campaign_name) %>%
  summarise( sumspend = sum(spend))

sumofconv<- q3df %>%
  group_by(campaign_name) %>%
  summarise(sumconversion = sum(conversions))

total <- merge(sumofconv, spend)
head(total)

total$CPA <- (total$sumspend / total$sumconversion)

#Printing and checking whether CPA is printing as a new column for each campaign
tail(total)

#Writing CVA to Excel Sheet
write_xlsx(total,"/Users/kalong/Desktop/CODE3/CVA.xlsx")

#I defined CVR to be the conversion rate
#where the users saw ad and took action as a result
#CVR is (number of conversions/number of impressions ) * 100
q3df
q3df$CVR <- ((q3df$conversions / q3df$impressions) * 100)
head(q3df)

write_xlsx(q3df,"/Users/kalong/Desktop/CODE3/CVR.xlsx")

#Question 4
#Which campaign type was more efficient at driving conversions? By how much?
#To find this, I plotted a graph of conversions relative to campaign type

##In order to sort by campaign type, I had to create different groups
##For example, create a campaign type column 
#Filtered by branding, conversions, fanacquistions

q4df<- select(df, campaign_name, conversions)
head(q4df)
tail(q4df)

campbrand <- q4df %>% filter(grepl('branding', campaign_name))
campconver <- q4df %>% filter(grepl('conversions', campaign_name))
campfana <- q4df %>% filter(grepl('fanacquisition', campaign_name))

campbrand
campconver
campfana

campbrandsum<- campbrand %>%
  summarise(sumbrandconversion = sum(conversions))
campbrandsum

campconversum<- campconver %>%
  summarise(sumconverconver = sum(conversions))
campconversum

campfanasum<- campfana %>%
  summarise(sumcampfanasum = sum(conversions))
campfanasum

#These are the total sum of the conversions, based 
#on the respective types of campaigns run
campfanasum
campconversum
campbrandsum

##Also carried out basic statistics 
summary(campconver)
summary(campfana)
summary(campbrand)
ggp7

qplot(campaign_name, conversions, data=q4df)

##Here we can see that some campaigns have a
#significantly more effective conversion rate than others.
sumofconv<- q4df %>%
  group_by(campaign_name) %>%
  summarise(sumconversion = sum(conversions))

head(sumofconv)

ggp7 <- ggplot(sumofconv, aes(x = factor(campaign_name), y = sumconversion)) + 
  geom_bar(stat = "summary", fun = "mean")

ggp7

#Here we can see that by grouping we 
#can obtain a more significant overall picture using mean
##
ggp7
####

#Question 5
#Are there any time period trends? If so within which metrics and what dimension are they sensitive to?
##Assign months to different time periods
##What metrics/dimensions are time periods sensitive to?
q5df <- select(q3df, month, creative_name_low, spend, impressions, clicks, conversions, CVR)
##Ordering months for q5df

latestdf <- q5df %>%
  arrange(match(month_name, month.name))
head(latestdf)
ggplot(latestdf,aes(x=month_name, y=spend))+geom_line()

monthname <- df$month
monthnamedf <- month.name[monthname]

options(stringsAsFactors = FALSE)
head(q5df)

q5df <-  q5df %>%
  add_column(month_name = monthnamedf)

##I want to verify that month_name prints the respective month_name
#For each month
str(q5df)

#Calculating a time series forecast for month_name & spend
ts1 <- select(q5df, month_name, spend)

ts1months <- group_by(ts1) %>%
  group_by(month_name) %>%
  summarise( total_spend = mean(spend))

##Arranging by month name
ts1montharranged <- ts1months %>%
  arrange(match(month_name, month.name))
str(ts1montharranged)  
#Basic bar plot for mean of spend
barplot(ts1montharranged$total_spend,names.arg=ts1montharranged$month_name,xlab="Month",ylab="Mean Spend",col="blue",
        main="Mean Spend per month chart",border="black")

ts1montharranged

mean(ts1montharranged$total_spend)

#Part 2
#Calculating a time series forecast for month_name & impressions
ts2 <- select(q5df, month_name, impressions)
head(q5df)

ggplot(q5df,aes(x=month_name, y=impressions))+geom_line()

##Calculating for sum 
ts2months <- group_by(ts2) %>%
  group_by(month_name) %>%
  summarise(mean_impressions = mean(impressions))
##Arranging by month name

ts2montharranged <- ts2months %>%
  arrange(match(month_name, month.name))
ts2montharranged

barplot(ts2montharranged$mean_impressions,names.arg=ts2montharranged$month_name,xlab="Month",ylab="Mean Impressions",col="blue",
        main="Mean Impressions per month chart",border="black")

mean(ts2montharranged$mean_impressions)

##Part 3
#Calculating a time series forecast for month_name & clicks
ts3 <- select(q5df, month_name, clicks)
ts3

ggplot(q5df,aes(x=month_name, y=clicks))+geom_line()
##Stays relatively the same

ts3months <- group_by(ts3) %>%
  group_by(month_name) %>%
  summarise( mean_clicks = mean(clicks))

##Arranging by month name
ts3montharranged <- ts3months %>%
  arrange(match(month_name, month.name))

barplot(ts3montharranged$mean_clicks,names.arg=ts3montharranged$month_name
        ,xlab="Month",ylab="Mean Clicks",col="blue",
        main="Mean Clicks per month chart",border="black")

ts3months
mean(ts3montharranged$mean_clicks)

#Part 4
#Calculating a time series forecast for month_name & conversions
ts4 <- select(q5df, month_name, conversions)
ts4
ggplot(q5df,aes(x=month_name, y=conversions))+geom_line()

##Stays relatively the same

##Looking at averages to compare using bar graphs
ts4months <- group_by(ts4) %>%
  group_by(month_name) %>%
  summarise( mean_conversions = mean(conversions))

##Arranging by month name
ts4montharranged <- ts4months %>%
  arrange(match(month_name, month.name))

ts4montharranged

barplot(ts4montharranged$mean_conversions,names.arg=ts4montharranged$month_name,
        xlab="Month",ylab="Mean Conversions",col="blue",
        main="Mean Conversions per month chart",border="black")
mean(ts4montharranged$mean_conversions)

#Part 5
#Calculating a time series forecast for month_name & CVR
ts5 <- select(q5df, month_name, CVR)
ts5


##Rather drastic swings in month to month
ts5months <- group_by(ts5) %>%
  group_by(month_name) %>%
  summarise( mean_CVR = mean(CVR))

##Arranging by month name
ts5montharranged <- ts5months %>%
  arrange(match(month_name, month.name))

ts5montharranged

barplot(ts5montharranged$mean_CVR,names.arg=ts5montharranged$month_name,
        xlab="Month",ylab="Mean CVR",col="blue",
        main="Mean CVR per month chart",border="black")

#Question 6
#How many creative colors were run in February?
q6df <- select(q5df, month_name, creative_name_low)

q6df %>%
  group_by(month_name = "February" = TRUE) %>%
  summarise(q6df)

#Question 7
#If this client asked you what CPA you'd project for next month 
#what would be the most important questions you want to ask prior 
#to providing a response?


