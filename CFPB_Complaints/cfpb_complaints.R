library(readr)
library(dplyr)
library(ggplot2)
source("/Users/nickbecker/Documents/R Workspace/538_plot_theme.R")
library(leaflet)
library(maps)
library(rgdal)

# normal mapping
library(rgeos)
library(maptools)
library(gpclib)
library(choroplethr)
library(scales)

complaints = read.csv("/users/nickbecker/downloads/consumer_complaints.csv")
head(complaints)
tail(complaints)

complaints %>% group_by(State) %>%
  summarise(number_complaints = length(Complaint.ID))

# How did people submit complaints?
ggplot(complaints, aes(x = factor(1), fill = factor(Submitted.via))) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  scale_fill_discrete(name  = "Complaint Submission Type")

submission_plot = ggplot(complaints, aes(x = Submitted.via)) +
  geom_bar(fill = "pink") +
  fte_theme() +
  labs(title="Consumer Complaints by Submission Method",
       x="Submission Method",
       y="# of Complaints")
submission_plot

# Were complaint responses quck?

ggplot(complaints, aes(x = factor(1), fill = factor(Timely.response.))) +
  geom_bar(width = 1) +
  coord_polar(theta = "y") +
  scale_fill_discrete(name  = "Timely Response?") +
  theme(axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.text.x = element_blank(),
        axis.text.y = element_blank())


# What states have the most complaints?
complaints_by_state = complaints %>% group_by(State) %>%
  summarise(number_complaints = length(Complaint.ID))

head(complaints_by_state)

# What companies have the most complaints in each state?
company_complaints_by_state = complaints %>% group_by(Company, State) %>%
  summarise(number_complaints = length(Complaint.ID))

head(company_complaints_by_state)

# What companies have the most complaints in each state?
company_complaints_by_state = as.data.frame(company_complaints_by_state) %>%
  arrange(desc(State), desc(number_complaints))
head(company_complaints_by_state)




# Let's find the number of complaints per capita
st_name = read.csv("/users/nickbecker/downloads/states.csv")
head(st_name)

complaints_by_state = left_join(st_name, complaints_by_state, by = c("Abbreviation" = "State"))
head(complaints_by_state)

# bring in state population data
pop_2014 <- read.table("https://www.census.gov/popest/data/national/totals/2014/files/NST_EST2014_ALLDATA.csv",
                            header = TRUE, sep = ",", na.strings="NA", dec=".", strip.white=TRUE)

state_pop_2014 = select(pop_2014, NAME, CENSUS2010POP, POPESTIMATE2014)

head(state_pop_2014)

complaints_by_state = left_join(complaints_by_state, state_pop_2014, by = c("State" = "NAME"))
head(complaints_by_state)

# calculate complaints per capita
complaints_by_state = mutate(complaints_by_state,
                             complaints_per_capita = number_complaints/POPESTIMATE2014,
                             complaints_per_100K = number_complaints/POPESTIMATE2014*100000)
head(complaints_by_state)
str(complaints_by_state)

ggplot(complaints_by_state, aes(x = State, y = complaints_per_100K, fill = State)) +
  geom_bar(stat="identity") + coord_flip()

# Let's order the plot

## Factor Relevel the data by complaint rate
head(complaints_by_state)

complaints_by_state$State <-
  factor(complaints_by_state$State,
         levels=complaints_by_state[order(complaints_by_state$complaints_per_100K),
                        "State"])

head(complaints_by_state)
str(complaints_by_state)

p = ggplot(complaints_by_state, aes(x = State, y = complaints_per_100K, fill = "red")) +
  geom_bar(stat="identity") +
  ylim(0, 500) +
  coord_flip() +
  fte_theme() +
  labs(title="Financial Products/Services Complaints per 100,000 People, \n by State 2011-2015",
       x="State",
       y="# of Complaints")
p

p1 = ggplot(complaints_by_state, aes(x = State, y = complaints_per_100K)) +
  #geom_point(color = "red") +
  geom_bar(stat = "identity", fill = hue_pal()(4)[3]) +
  ylim(0, 500) +
  coord_flip() +
  fte_theme() +
  labs(title="Financial Products/Services Complaints per 100,000 People,\n2011-2015",
       x="State",
       y="Complaints per 100K") +
  theme(axis.text.y = element_text(size = 18),
        axis.text.x = element_text(size = 18),
        axis.title.x = element_text(size = 22),
        axis.title.y = element_text(size = 22),
        plot.title = element_text(size = 25))
p1

png("/users/nickbecker/Documents/Github/beckernick.github.io/images/cfpb_complaints/complaints_chart.png", height = 1000, width = 1250)
p1
dev.off()




# Let's make a map
complaints_by_state_edited = complaints_by_state %>%
  select(State, complaints_per_100K) %>% mutate(State,
                                                State = tolower(State))

colnames(complaints_by_state_edited) = c("region", "value")
head(complaints_by_state_edited, 10)

choro_map = state_choropleth(complaints_by_state_edited,
                 title      = "Financial Products/Services Complaints per 100,000 People \nby State 2011-2015",
                 legend     = "# Complaints",
                 num_colors = 4)





















# Save the plots
jpeg("consumer_complaints_by_state_barchart.jpeg", height = 900, width = 1200)
p
dev.off()

jpeg("consumer_complaints_by_state_pointplot.jpeg", height = 900, width = 1200)
p1
dev.off()

jpeg("complaint_submission_method.jpeg", height = 900, width = 1200)
submission_plot
dev.off()

jpeg("consumer_complaints_by_state_choromap.jpeg", height = 900, width = 1200)
choro_map
dev.off()


















