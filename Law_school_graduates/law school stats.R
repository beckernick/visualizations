#### law school outcomes ####
library(dplyr)
library(ggplot2)
library(plotly)
library(tidyr)
library(stringr)
library(scales)
library(gridExtra)
library(grid)
library(lattice)
library(directlabels)


datasource = "http://employmentsummary.abaquestionnaire.org/"

### create all data in one chart
for (i in 2010:2014) {
  assign(paste0("employment", as.character(i)),
         read.csv(paste0("/~/downloads/EmploymentSummary-",
                         as.character(i+1), ".csv")))
} 

str(employment2014)

# unemployed seeking percent
unemployment2014 = mutate(employment2014, unemployment_rate = UnEmployedSeekingNumber/TotalGraduatesNumber)

unemployment2014 = select(unemployment2014, SchoolName, unemployment_rate)
head(unemployment2014)

## plotting 2014 class unemployment rate
p = ggplot(unemployment2014, aes(x = SchoolName, y = unemployment_rate, fill = SchoolName)) +
  geom_bar(stat="identity") + 
  ylab("Unemployment Rate") +
  xlab("Law School") +
  scale_y_continuous(label = percent) +
  ggtitle("Graduating Class Unemployment Rates by Law School, 2014") +
  theme(axis.text.x = element_blank(), legend.position="none") +
  scale_fill_discrete(name="Law School")
p


# percent school funded
schoolfund2014 = mutate(employment2014, fund_rate = Funded_TotTotalEmployed/TotalGraduatesNumber)
schoolfund2014 = select(schoolfund2014, SchoolName, fund_rate)
head(schoolfund2014)

# plot 
sf = ggplot(schoolfund2014, aes(x = SchoolName, y = fund_rate, fill = SchoolName)) +
  geom_bar(stat="identity") + 
  ylab("School Fund Rate") +
  xlab("Law School") +
  scale_y_continuous(label = percent) +
  ggtitle("Employed by School Rate by Law School, 2014") +
  theme(axis.text.x = element_blank(), legend.position="none") +
  scale_fill_discrete(name="Law School")
sf

grid.arrange(p, sf, ncol=1)
dev.off()



### top 14 law schools
toplawschools = c("YALE UNIVERSITY", "HARVARD UNIVERSITY", "STANFORD UNIVERSITY",
                  "COLUMBIA UNIVERSITY", "CHICAGO, UNIVERSITY OF", "NEW YORK UNIVERSITY",
                  "PENNSYLVANIA, UNIVERSITY OF", "DUKE UNIVERSITY", "CALIFORNIA-BERKELEY, UNIVERSITY OF",
                  "VIRGINIA, UNIVERSITY OF", "MICHIGAN, UNIVERSITY OF", "NORTHWESTERN UNIVERSITY",
                  "CORNELL UNIVERSITY", "GEORGETOWN UNIVERSITY")

top_2010 = filter(employment2010, university %in% toplawschools)
top_2011 = filter(employment2011, SchoolName %in% toplawschools)
top_2012 = filter(employment2012, SchoolName %in% toplawschools)
top_2013 = filter(employment2013, SchoolName %in% toplawschools)
top_2014 = filter(employment2014, SchoolName %in% toplawschools)

# rename variables
top_2010 = rename(top_2010, SchoolName = university)

# unemployed seeking percent
top_2010 = mutate(top_2010, unemployment_rate2010 = Unemployed.Seek/Total.Graduates)
top_2011 = mutate(top_2011, unemployment_rate2011 = UnEmployedSeekingNumber/TotalGraduatesNumber)
top_2012 = mutate(top_2012, unemployment_rate2012 = UnEmployedSeekingNumber/TotalGraduatesNumber)
top_2013 = mutate(top_2013, unemployment_rate2013 = UnEmployedSeekingNumber/TotalGraduatesNumber)
top_2014 = mutate(top_2014, unemployment_rate2014 = UnEmployedSeekingNumber/TotalGraduatesNumber)

top_2010 = select(top_2010, SchoolName, unemployment_rate2010)
top_2011 = select(top_2011, SchoolName, unemployment_rate2011)
top_2012 = select(top_2012, SchoolName, unemployment_rate2012)
top_2013 = select(top_2013, SchoolName, unemployment_rate2013)
top_2014 = select(top_2014, SchoolName, unemployment_rate2014)

top_2014

top14_unemployment_plot = ggplot(top_2014, aes(x = SchoolName, y = unemployment_rate2014, fill = SchoolName)) +
  geom_bar(stat="identity") + 
  ylab("Unemployment Rate") +
  xlab("Law School") +
  ggtitle("Percent of Graduates Unemployed, 2014") +
  scale_y_continuous(label = percent) +
  theme(axis.text.x = element_blank(), legend.position="right",
        axis.text.y = element_text(size = 20)) +
  scale_fill_discrete(name="Law School")

top14_unemployment_plot


merge(top_2010, top_2011, by.x = "SchoolName", by.y = "SchoolName")

data_wide = cbind(top_2010, top_2011$unemployment_rate2011,top_2012$unemployment_rate2012,
      top_2013$unemployment_rate2013,top_2014$unemployment_rate2014)
head(data_wide)
colnames(data_wide) = c("SchoolName", "unemployment_2010", "unemployment_2011",
                   "unemployment_2012", "unemployment_2013", "unemployment_2014")
head(data_wide)

long.data = reshape(data_wide,
        varying = c("unemployment_2010", "unemployment_2011",
                    "unemployment_2012", "unemployment_2013", "unemployment_2014"),
        v.names = "unemployment_rate",
        timevar = "year",
        times = c("2010", "2011", "2012", "2013", "2014"),
        direction = "long")

head(long.data)
data = data.frame(School = long.data$SchoolName, year = long.data$year, rate = long.data$unemployment_rate)

head(data)
data$year = as.integer(data$year) + 2009
data


## Plotting data
standard_plot = ggplot(data = data, aes(x = year, y = rate, color = School, group = School)) +
  geom_line() +
  ylab("Unemployment Rate") +
  xlab("Year") +
  #theme_bw() +
  theme(axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        title = element_text(size = 14, face = "bold")) +
  scale_y_continuous(label = percent) +
  ggtitle("Law School Graduating Class Unemployment Rate, 2010-2014") +
  scale_colour_discrete(name="Law School")

jpeg("Law School Graduating Class Unemployment Rate 2010-2014.jpeg", width = 1200, height = 800)
standard_plot
dev.off()





### Plotting with label next to line
gg = ggplot(data = data, aes(x = year, y = rate, color = School, group = School)) +
  geom_line() +
  ylab("Unemployment Rate") +
  xlab("Year") +
  xlim(2010, 2015) +
  scale_y_continuous(label = percent) +
  ggtitle("Law School Graduating Class Unemployment Rate, 2010-2014") +
  #theme(legend.key=element_blank()) +
  #theme(legend.title = element_blank()) +
  theme(legend.position = "none") +
  
  #geom_text(data = data[data$year == 2014,], aes(label = School),
   #         hjust = -.3, vjust = last_values, size = 3) +
  theme(axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        title = element_text(size = 14, face = "bold"))# +
 # geom_dl(aes(label=School),method="last.points", fontsize = .1)
gg

x = direct.label(gg)
x


jpeg("formatted unemployment 2010-2014.jpeg", width = 1200, height = 800)
x
dev.off()

#### funding rates 
top_2010 = filter(employment2010, university %in% toplawschools)
top_2011 = filter(employment2011, SchoolName %in% toplawschools)
top_2012 = filter(employment2012, SchoolName %in% toplawschools)
top_2013 = filter(employment2013, SchoolName %in% toplawschools)
top_2014 = filter(employment2014, SchoolName %in% toplawschools)

top_2010 = mutate(top_2010, fund_rate2010 = Law.Schl.Funded/Total.Graduates)
top_2011 = mutate(top_2011, fund_rate2011 = Funded.Position/TotalGraduatesNumber)
top_2012 = mutate(top_2012, fund_rate2012 = Funded_TotalEmployed/TotalGraduatesNumber)
top_2013 = mutate(top_2013, fund_rate2013 = Funded_TotTotalEmployed/TotalGraduatesNumber)
top_2014 = mutate(top_2014, fund_rate2014 = Funded_TotTotalEmployed/TotalGraduatesNumber)


top_2010 = select(top_2010, university, fund_rate2010)
top_2011 = select(top_2011, SchoolName, fund_rate2011)
top_2012 = select(top_2012, SchoolName, fund_rate2012)
top_2013 = select(top_2013, SchoolName, fund_rate2013)
top_2014 = select(top_2014, SchoolName, fund_rate2014)


top14_funding_plot = ggplot(top_2014, aes(x = SchoolName, y = fund_rate2014, fill = SchoolName)) +
  geom_bar(stat="identity") + 
  ylab("Funding Rate") +
  xlab("Law School") +
  ggtitle("Percent of Graduates Funded by Law School, 2014") +
  scale_y_continuous(label = percent) +
  theme(axis.text.x = element_blank(), legend.position="right",
        axis.text.y = element_text(size = 20)) +
  scale_fill_discrete(name="Law School")

top14_funding_plot

jpeg("combined_graph.jpeg", width = 1200, height = 800)
grid.arrange(top14_unemployment_plot, top14_funding_plot, ncol=1)
dev.off()




## line plot funding rate
data = cbind(top_2010, top_2011$fund_rate2011,top_2012$fund_rate2012,
             top_2013$fund_rate2013,top_2014$fund_rate2014)
head(data)
colnames(data) = c("SchoolName", "fund_2010", "fund_2011",
                   "fund_2012", "fund_2013", "fund_2014")
head(data)

long.data = reshape(data,
                    varying = c("fund_2010", "fund_2011",
                                "fund_2012", "fund_2013", "fund_2014"),
                    v.names = "fund_rate",
                    timevar = "year",
                    times = c("2010", "2011", "2012", "2013", "2014"),
                    direction = "long")

head(long.data)
data = data.frame(School = long.data$SchoolName, year = long.data$year, rate = long.data$fund_rate)

head(data)


funding_rate_line = ggplot(data = data, aes(x = year, y = rate, color = School, group = School)) +
  geom_line() +
  ylab("Employed by School Rate") +
  xlab("Year") +
  #theme_bw() +
  theme(axis.text.x = element_text(size = 14),
        axis.text.y = element_text(size = 14),
        title = element_text(size = 14, face = "bold")) +
  scale_y_continuous(label = percent) +
  ggtitle("Employed by School Rate, 2010-2014") +
  scale_colour_discrete(name="Law School")

funding_rate_line

jpeg("funding.jpeg", width = 1200, height = 800)
funding_rate_line
dev.off()






















