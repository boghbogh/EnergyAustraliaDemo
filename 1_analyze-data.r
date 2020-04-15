# Databricks notebook source
library(SparkR)
library(plotly)
library(ggplot2)
library(reshape2)
library(dplyr)
library(agricolae)
library(cluster)
sparkR.session()
sparkDF <- SparkR::sql('SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  
                          FROM AllData_View 
                          GROUP BY state 
                          ORDER BY state')
state.avg.rates<- as.data.frame(sparkDF)
str(state.avg.rates)

# Define what is displayed when hovering over the states in the choropleth graph.

state.avg.rates$hover <- with(state.avg.rates, paste(state, '<br>', 'Commercial Rate', round(comm_rate, 3), 
                                                     '<br>', 'Industrial Rate', round(ind_rate, 3),
                                                     '<br>', 'Residential Rate', round(res_rate, 3)))

# Set the state borders to white
state.border <- list(color = toRGB('white'))

# Define how the choropleth graph will be displayed
geo <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = TRUE,
  lakecolor = toRGB('white')
)

# Build the graph and plot.
p <- plot_ly(state.avg.rates, z = round(state.avg.rates$res_rate,3), text = state.avg.rates$hover, locations = state.avg.rates$state, type = 'choropleth',
             locationmode = 'USA-states', colors = 'Blues', marker = list(line = state.border)) %>%
  layout(title = 'Average Electricity Rates by State', geo = geo)
p

state.avg.rates$state <- as.factor(state.avg.rates$state)
rownames(state.avg.rates) <- state.avg.rates$state
clust <- kmeans(state.avg.rates[,2:4], 6)
clusplot(state.avg.rates[,2:4], clust$cluster, color=TRUE, shade=TRUE, labels=2, lines=0, main = "Cluster Plot of States' Electricity Rates")


state.avg.rates2_spark <- SparkR::sql('SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  
                           FROM AllData_View  
                           WHERE NOT state IN ("AK", "HI") 
                           GROUP BY state 
                           ORDER BY state')
state.avg.rates2<- as.data.frame(state.avg.rates2_spark)

p <- plot_ly(state.avg.rates2, z = round(state.avg.rates2$res_rate, 3), text = paste('Residential Rate:', round(state.avg.rates2$res_rate, 3)), locations = state.avg.rates2$state, type = 'choropleth',
             locationmode = 'USA-states', colors = 'Blues', marker = list(line = state.border)) %>%
  layout(title = 'Average Residential Electricity Rates by State', geo = geo)
p

state.avg.rates2$state <- as.factor(state.avg.rates2$state)
rownames(state.avg.rates2) <- state.avg.rates2$state
clust2 <- kmeans(state.avg.rates2[,2:4], 6)
clusplot(state.avg.rates2[,2:4], clust2$cluster, color=TRUE, shade=TRUE, labels=2, lines=0)


distinctOwner<-SparkR::sql('SELECT DISTINCT ownership FROM AllData_View')
distinctOwner<-as.data.frame(distinctOwner)
distinctOwner

ownership.rate <- SparkR::sql('SELECT state, ownership, utility_name, 
                         AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate 
                         FROM AllData_View 
                         GROUP BY state, ownership, utility_name  
                         ORDER BY state')
ownership.rate<-as.data.frame(ownership.rate)

ownership.melted <- melt(ownership.rate, id.vars = 'ownership', 
                         measure.vars = c('res_rate', 'comm_rate', 'ind_rate'), variable.name = 'rate')

ownership.rates2 <- dcast(ownership.melted, formula = ownership ~ rate, fun.aggregate = mean)
ownership.rates2 <- ownership.rates2[order(-ownership.rates2$res_rate),]

p <- plot_ly(ownership.rates2, x=ownership.rates2$ownership, y=round(ownership.rates2$res_rate,3), type='bar') %>%
  layout(title = 'Average Residential Electricity Rates by Utility Ownership', yaxis = list(title = 'Electricity Rate'))

p

ownership.res <- filter(ownership.melted, rate == 'res_rate') # First filter all rate types except for Residential
kruskal(ownership.res$value, ownership.res$ownership, console = TRUE)

utilities <- SparkR::sql('SELECT utility_name, state, AVG(res_rate) res_rate 
                    FROM AllData_View 
                    GROUP BY utility_name, state 
                    ORDER BY res_rate DESC 
                    LIMIT 20')
utilities <- as.data.frame(utilities)

p <- plot_ly(utilities, x=utilities$utility_name, y=round(utilities$res_rate,3), type='bar', split = utilities$state) %>%
  layout(title = 'Highest Residential Rates by Utility', yaxis = list(title = 'Electricity Rate'))

p


owned <- SparkR::sql('SELECT state, COUNT(DISTINCT utility_name) as utilities 
                FROM AllData_View 
                GROUP BY state 
                ORDER BY utilities DESC 
                LIMIT 10')
owned <- as.data.frame(owned)
p <- plot_ly(owned, x=owned$state, y=owned$utilities, type='bar') %>%
  layout(title = 'States with the Most Utilities', yaxis = list(title = 'Count of Utilities'))
p