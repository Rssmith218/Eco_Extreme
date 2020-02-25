---
  title: "Spatial-temporal analysis: Proportions + Count plots"
author: "Rachel Smith & Brandon Sansom"
date: "Update on 12/04/2019"
output: github_document
---
  
  ```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE, echo = F, message = F, error = F, warning = F)
```

### Exploratory plots of space/time variables: 

```{r prepare}
###install packages:
library(tidyverse)
library(readxl)
library(magrittr)
library(stringr)
library(lubridate)
library(here)
library(ggplot2)
library(tigerstats)
library(dplyr)
# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  numPlots = length(plots)
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  if (numPlots==1) {
    print(plots[[1]])
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}
EEdata <- read_excel("CleanedExtremeEventsData_8Nov2019.xlsx", sheet = 1)
###convert all spatial/temporal variables to factors
EEdata$Sampling_Duration_After <- factor(EEdata$Sampling_Duration_After)
EEdata$Sampling_Duration_Before <- factor(EEdata$Sampling_Duration_Before)
EEdata$Sampling_Duration_During <- factor(EEdata$Sampling_Duration_During)
EEdata$SamplingUnit_SpatialExtent <- factor(EEdata$SamplingUnit_SpatialExtent)
EEdata$Study_SpatialExtent <- factor(EEdata$Study_SpatialExtent)
EEdata$ProximateEvent_SpatialExtent <- factor(EEdata$ProximateEvent_SpatialExtent)
EEdata$ProximateEvent_Duration <- factor(EEdata$ProximateEvent_Duration)

###reduce EEdata to only unique accession numbers
EEunique <- {EEdata %>%
    distinct(UniqueAccession, .keep_all = T)
}
```


#### Combined Count plots:
```{r}
spatial.data<-EEunique %>% 
  select(Study_SpatialExtent,SamplingUnit_SpatialExtent, ProximateEvent_SpatialExtent)
temporal.data<-EEunique %>% 
  select(Sampling_Duration_Before, Sampling_Duration_During, Sampling_Duration_After, ProximateEvent_Duration)
####get all data into the same format for sampling duration:
sample.after.c<-EEunique %>%
  group_by(Sampling_Duration_After) %>%
  tally()
sample.during.c<-EEunique %>%
  group_by(Sampling_Duration_During) %>%
  tally()
sample.before.c<-EEunique %>%
  group_by(Sampling_Duration_Before) %>%
  tally()
event.duration.c<-EEunique %>%
  group_by(ProximateEvent_Duration) %>%
  tally()
##Sample duration:        
sample.after.c<-plyr::rename(sample.after.c,c('Sampling_Duration_After'='Time.Scale'))
sample.after.c$Sample.Scale <- "Sample.Duration.After"
sample.during.c<-plyr::rename(sample.during.c,c('Sampling_Duration_During'='Time.Scale'))
sample.during.c$Sample.Scale <- "Sample.Duration.During"
sample.before.c<-plyr::rename(sample.before.c,c('Sampling_Duration_Before'='Time.Scale'))
sample.before.c$Sample.Scale <- "Sample.Duration.Before"
event.duration.c<-plyr::rename(event.duration.c,c('ProximateEvent_Duration'='Time.Scale'))
event.duration.c$Sample.Scale <- "Proximate.Event.Duration"
###combine data
time.data<-rbind(sample.after.c, sample.during.c, sample.before.c,event.duration.c  )
##change factor order
time.data$Time.Scale <- factor(time.data$Time.Scale, levels = c("none", "single sample", "hours", "days", "weeks", "months", "years"))
time.data$Sample.Scale <- factor(time.data$Sample.Scale, levels = c("Proximate.Event.Duration", "Sample.Duration.Before", "Sample.Duration.During", "Sample.Duration.After"))
###ggplot
time.plot<- ggplot(time.data, aes(x= Time.Scale, y =n , fill = Sample.Scale)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  theme(legend.justification = c(0,1),
        legend.position = c(0,1))
time.plot
##Sample spatial scale:   
sample.spatial.c<-EEunique %>%
  group_by(SamplingUnit_SpatialExtent) %>%
  tally()
event.spatial.c<-EEunique %>%
  group_by(ProximateEvent_SpatialExtent) %>%
  tally()
study.spatial.c<-EEunique %>%
  group_by(Study_SpatialExtent) %>%
  tally()

sample.spatial.c<-plyr::rename(sample.spatial.c,c('SamplingUnit_SpatialExtent'='Spatial.Scale'))
sample.spatial.c$Sample.Scale <- "Sample.Unit.Extent"
event.spatial.c<-plyr::rename(event.spatial.c,c('ProximateEvent_SpatialExtent'='Spatial.Scale'))
event.spatial.c$Sample.Scale <- "Proximate.Event.Extent"
study.spatial.c<-plyr::rename(study.spatial.c,c('Study_SpatialExtent'='Spatial.Scale'))
study.spatial.c$Sample.Scale <- "Study.Extent"

# ##THE NA VALUES IN EVENT.SPATIAL CAUSE ISSUES FOR SORTING FACTORS TO GRAPH - FOR NOW I HAVE REPLACED WITH MISSING DATA
# event.spatial.c$Spatial.Scale <- as.character(event.spatial.c$Spatial.Scale)
# event.spatial.c$Spatial.Scale[is.na(event.spatial.c$Spatial.Scale)] <- "Missing Data"
# event.spatial.c$Spatial.Scale <- as.factor(event.spatial.c$Spatial.Scale)

##combine data
spatial.data<-rbind(study.spatial.c, event.spatial.c, sample.spatial.c)
##change factor order
spatial.data$Spatial.Scale <- factor(spatial.data$Spatial.Scale, levels = c("undefined", "<1 sq m", "1-10 sq m", "10-100 sq m", "100-1000 sq m", ">1000 sq m", "Regional/Continental"))
####ggplot
spatial.plot<- ggplot(spatial.data, aes(x= Spatial.Scale, y =n , fill = Sample.Scale)) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) + 
  geom_col(position = position_dodge2(width = 0.9, preserve = "single")) +
  theme(legend.justification = c(0,1),
        legend.position = c(0,1))
spatial.plot

##combined plot
{r sampling duration,  fig.width = 12, fig.height = 12}
multiplot(time.plot, spatial.plot, cols = 2)

```