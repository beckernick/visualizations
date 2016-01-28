#### UNC Chapel Hill Salary Data ####
library(dplyr)
library(ggplot2)
library(gdata)
library(scales)
library(grid)
library(cowplot)
library(lubridate)

unc = read.csv("~/UNC_System_Salary Search and Report2015-09-01.csv")
head(unc)

unc_relevant = select(unc, dept, position, totalsal)

# mean salary by department
salary_by_dept = tapply(unc_relevant$totalsal, unc_relevant$dept, mean)
salary_by_dept = data.frame(School = names(salary_by_dept), Salary = unname(salary_by_dept))


filter(unc_relevant, dept == "Peace War & Defense")

salary_by_dept = arrange(salary_by_dept, desc(Salary))
salary_by_dept$School = factor(salary_by_dept$School,
                levels = salary_by_dept[order(salary_by_dept$Salary, decreasing = FALSE),1])

str(salary_by_dept)

p = ggplot(data = salary_by_dept, aes(x = School, y = Salary, fill = "School")) +
  geom_bar(stat="identity") +
  scale_y_continuous(labels = dollar) +
  theme(legend.position = "blank",
        axis.title.x = element_blank(),
        panel.background = element_rect(fill = "grey"),
        plot.background = element_rect(fill = "grey")) +
  ggtitle("UNC Chapel Hill Average Salary by Department, 2015\n") +
  coord_flip()
p = ggdraw(switch_axis_position(p, axis = 'x', keep = 'x'))
p

# make pdf
pdf("Salary_by_Dept.pdf", width = 10, height = 60)
p
dev.off()




# mean salary by position
head(unc_relevant, 50)
salary_by_position = tapply(unc_relevant$totalsal, unc_relevant$position, mean)
salary_by_position = data.frame(School = names(salary_by_position), Salary = unname(salary_by_position))

salary_by_position = arrange(salary_by_position, desc(Salary))
salary_by_position$School = factor(salary_by_position$School,
                               levels = salary_by_position[order(salary_by_position$Salary, decreasing = FALSE),1])
str(salary_by_position)
head(salary_by_position, 10)









# how has hiring changed over time?
unc_subset = select(unc, dept, hiredate, position, totalsal)
str(unc_subset)
unc_subset = mutate(unc_subset, hiredate = as.Date(as.character(unc_subset$hiredate), format = "%Y%m%d"))
str(unc_subset)

summary(unc_subset)
#sort by date
unc_subset = unc_subset[order(unc_subset$hiredate), ]


p_1 = ggplot(data = unc_subset, aes(x = hiredate, y = totalsal)) +
  geom_point() +
  xlab("Hire Date") +
  ylab("Salary") +
  ggtitle("UNC Chapel Hill Salaries 1957-2014") +
  geom_smooth(method = "loess", color = "red", formula = y ~ x) +
  scale_y_continuous(labels = dollar)
p_1

jpeg("Hiring_Time_Trend.jpeg", width = 1200, height = 800)
p_1
dev.off()



















































































