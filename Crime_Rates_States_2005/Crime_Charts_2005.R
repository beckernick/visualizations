# Bubble and Text Charts of Crime Data #
#           Nick Becker                #


library(ggplot2)

crime <- read.csv("http://datasets.flowingdata.com/crimeRatesByState2005.tsv", header = TRUE,
                  sep = "\t")
head(crime)

p <- ggplot(crime, aes(x = murder, y = burglary, size = population, label = state, color = state)) + 
  geom_point() +
  #theme_bw() +
  geom_text(size = 4, hjust = -0.25, vjust = 1.0) +
  scale_size_area(max_size = 15) +
  theme(legend.position="none") +
  ggtitle("Burglary Rate vs. Murder Rate by State 2005 \n") +
  ylab("Burglaries per 1,000 population") + 
  xlab("Murders per 1,000 population") +
  theme(plot.title = element_text(size = 25),
        axis.title = element_text(size = 25),
        axis.text = element_text(size = 20))

p

jpeg("~/R Workspace/burglaries_murders_by_states2005.jpeg",
     width = 1800, height = 1200)
p
dev.off()


p_1 <- ggplot(crime, aes(x = murder, y = burglary, size = population, label = state, color = state)) + 
  #theme_bw() +
  geom_text(size = 6, hjust = -0.25, vjust = 1.0,
            position = position_jitter(w = 0.1, h = 0.1)) +
  theme(legend.position="none") +
  ggtitle("Burglary Rate vs. Murder Rate by State 2005 \n") +
  ylab("Burglaries per 1,000 population") + 
  xlab("Murders per 1,000 population") +
  xlim(0, 10.5) +
  theme(plot.title = element_text(size = 25),
        axis.title = element_text(size = 25),
        axis.text = element_text(size = 20))

p_1

jpeg("~/R Workspace/burglaries_murders_by_states2005_text.jpeg",
     width = 1800, height = 1200)
p_1
dev.off()
