---
  title: "Spatial-temporal analysis: Proportions + Count plots"
author: "Rachel Smith & Brandon Sansom"
date: "Update on 12/04/2019"
output: github_document
---


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
library(data.table)

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

EEdata <- read_excel(here::here("/data/CleanedExtremeEventsData_8Nov2019.xlsx"), sheet = 1)

###convert all spatial/temporal variables to factors
EEdata$Sampling_Duration_After <- factor(EEdata$Sampling_Duration_After)
EEdata$Sampling_Duration_Before <- factor(EEdata$Sampling_Duration_Before)
EEdata$Sampling_Duration_During <- factor(EEdata$Sampling_Duration_During)
EEdata$SamplingUnit_SpatialExtent <- factor(EEdata$SamplingUnit_SpatialExtent)
EEdata$Study_SpatialExtent <- factor(EEdata$Study_SpatialExtent)
EEdata$ProximateEvent_SpatialExtent <- factor(EEdata$ProximateEvent_SpatialExtent)
EEdata$ProximateEvent_Duration <- factor(EEdata$ProximateEvent_Duration)

###look at factor levels:
#unique(EEdata$Sampling_Duration_After) ##years, months, none, weeks, single sample, days
#unique(EEdata$Sampling_Duration_Before)##years, months, none, weeks, single sample, days
#unique(EEdata$Sampling_Duration_During) #years, months, none, weeks, single sample, days, hours
#unique(EEdata$SamplingUnit_SpatialExtent)##<1 sqm, >1000 sq m, 1-10 sq m, 10-100 sq m, 100-1000 sq m, Regional/Continent, undefined
#unique(EEdata$Study_SpatialExtent)#<1 sqm, >1000 sq m, 1-10 sq m, 10-100 sq m, 100-1000 sq m, Regional/Continent, undefined
#unique(EEdata$ProximateEvent_Duration)###days, hours, months, weeks, years; this is missing single sample and none
#unique(EEdata$ProximateEvent_SpatialExtent)###<1 sqm, >1000 sqm, 10-100 sqm, 100-1000 sqm, Regional/Continent; this one is missing 1-10 sqm

###reduce EEdata to only unique accession numbers
EEunique <- {EEdata %>%
    distinct(UniqueAccession, .keep_all = T)
}


#### Contingency tables:

#Study Spatial Extent vs. Event Spatial Extent:
 
#Here, rows are Study Spatial Extent and columns are Event Spatial extent.

###https://www.datacamp.com/community/tutorials/contingency-tables-r
####here the rows are Study Spatial extent and and columns are Event Spatial extent
###We can also turn these into proportions/do a chi square test
spatial<- xtabs(~ Study_SpatialExtent + ProximateEvent_SpatialExtent, data = EEunique)
spatial
spatial_prop<-prop.table(spatial)
spatial_prop
#spatial1<-table(EEdata$Study_SpatialExtent, EEdata$ProximateEvent_SpatialExtent)
#spatial2<-prop.table(table(EEdata$Study_SpatialExtent, EEdata$ProximateEvent_SpatialExtent))
#rowPerc(spatial1)
write.csv(spatial_prop, "spatial_extent_study.csv")
###rows and columns are not independent
#chisq.test(EEdata$Study_SpatialExtent, EEdata$ProximateEvent_SpatialExtent)
```

*Sampling Unit Spatial Extent vs. Event Spatial Extent:*
  
  Here, rows are Sampling Unit Spatial Extent and columns are Event Spatial extent.

```{r sample}
sample<- xtabs(~ SamplingUnit_SpatialExtent + ProximateEvent_SpatialExtent, data = EEunique)
sample
sample_prop <- prop.table(sample)
sample_prop
write.csv(sample_prop, "spatial_extent_sample.csv")
#table(EEunique$SamplingUnit_SpatialExtent, EEunique$ProximateEvent_SpatialExtent)
###rows and columns are not independent
#chisq.test(EEunique$SamplingUnit_SpatialExtent, EEunique$ProximateEvent_SpatialExtent)
```

*Sampling Duration Before vs. Event Duration:*
  
  Here, rows are Sampling Duration Before and columns are Event Duration extent.

```{r before}
before1<- xtabs(~ Sampling_Duration_Before + ProximateEvent_Duration, data = EEunique)
before1
before_prop<- prop.table(before1)
write.csv(before_prop, "duration_before.csv")
#before<- table(EEunique$Sampling_Duration_Before, EEunique$ProximateEvent_Duration)
#before
###rows and columns are not independent
#chisq.test(EEunique$Sampling_Duration_Before, EEunique$ProximateEvent_Duration)
```


*Sampling Duration During vs. Event Duration:*
  
  Here, rows are Sampling Duration During and columns are Event Duration extent.

```{r during}
during1<- xtabs(~ Sampling_Duration_During + ProximateEvent_Duration, data = EEunique)
during1
during_prop<- prop.table(during1)
write.csv(during_prop, "duration_during.csv")
#during<- table(EEunique$Sampling_Duration_During, EEunique$ProximateEvent_Duration)
#during
###rows and columns are not independent
#chisq.test(EEunique$Sampling_Duration_During, EEunique$ProximateEvent_Duration)
```


*Sampling Duration After vs. Event Duration:*
  
  Here, rows are Sampling Duration After and columns are Event Duration extent.

```{r after}
after1<- xtabs(~ Sampling_Duration_After + ProximateEvent_Duration, data = EEunique)
after1
after_prop<- prop.table(after1)
write.csv(after_prop, "duration_after.csv")
#after<-table(EEunique$Sampling_Duration_After, EEunique$ProximateEvent_Duration)
#after
###rows and columns are not independent
#chisq.test(EEunique$Sampling_Duration_After, EEunique$ProximateEvent_Duration)
```




#### Heat Maps: 
*Study Spatial Extent vs. Event Spatial Extent - as a proportion:*

```{r spatial prop,  fig.width = 12, fig.height = 12}
##convert xtabs to data.frame, add in missing categories, convert back to xtabs, covert xtabs to dataframe for heat maps##
spatial_1 <- as.data.frame.matrix(spatial_prop, make.names = TRUE)
spatial_1 <- setDT(spatial_1, keep.rownames = TRUE)[]
spatial_1$`undefined` <- 0
spatial_1$`1-10 sq m` <- 0
spatial_2 <- as.xtabs(spatial_1)

spatial_df1 <- as.data.frame(spatial_2)
colnames(spatial_df1) <- c("Study_SpatialExtent", "ProximateEvent_SpatialExtent", "Freq")
spatial_df1$Study_SpatialExtent = factor(spatial_df1$Study_SpatialExtent,levels(spatial_df1$Study_SpatialExtent)[c(7,1,3:5,2,6)])
spatial_df1$ProximateEvent_SpatialExtent = factor(spatial_df1$ProximateEvent_SpatialExtent,levels(spatial_df1$ProximateEvent_SpatialExtent)[c(6,1,7,3,4,2,5)])

levels(spatial_df1$Study_SpatialExtent) <- c("Undefined", "<1 sq m", "1-10 sq m", "10-100 sq m", "100-1000 sq m", ">1000 sq m", "Regional/Continental")
levels(spatial_df1$ProximateEvent_SpatialExtent) <- c("Undefined", "<1 sq m", "1-10 sq m", "10-100 sq m", "100-1000 sq m", ">1000 sq m", "Regional/Continental")


spatial_plot <- ggplot(spatial_df1, aes(Study_SpatialExtent, ProximateEvent_SpatialExtent)) +
  geom_tile(aes(fill = Freq), colour = "black") +
  scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Study Spatial Extent") +
  ylab("Event Spatial Extent")
```

*Sampling Unit Spatial Extent vs. Event Spatial Extent - as a proportion:*
  
```{r sample prop,  fig.width = 12, fig.height = 12}
##convert xtabs to data.frame, add in missing categories, convert back to xtabs, covert xtabs to dataframe for heat maps##
sample_1 <- as.data.frame.matrix(sample_prop, make.names = TRUE)
sample_1 <- setDT(sample_1, keep.rownames = TRUE)[]
sample_1$`undefined` <- 0
sample_1$`1-10 sq m` <- 0
sample_2 <- as.xtabs(sample_1)

sample_df1 <- as.data.frame(sample_2)
colnames(sample_df1) <- c("SamplingUnit_SpatialExtent", "ProximateEvent_SpatialExtent", "Freq")
sample_df1$SamplingUnit_SpatialExtent = factor(sample_df1$SamplingUnit_SpatialExtent,levels(sample_df1$SamplingUnit_SpatialExtent)[c(7,1,3:5,2,6)])
sample_df1$ProximateEvent_SpatialExtent = factor(sample_df1$ProximateEvent_SpatialExtent,levels(sample_df1$ProximateEvent_SpatialExtent)[c(6,1,7,3,4,2,5)])

levels(sample_df1$SamplingUnit_SpatialExtent) <- c("Undefined", "<1 sq m", "1-10 sq m", "10-100 sq m", "100-1000 sq m", ">1000 sq m", "Regional/Continental")
levels(sample_df1$ProximateEvent_SpatialExtent) <- c("Undefined", "<1 sq m", "1-10 sq m", "10-100 sq m", "100-1000 sq m", ">1000 sq m", "Regional/Continental")


sample_plot <- ggplot(sample_df1, aes(SamplingUnit_SpatialExtent, ProximateEvent_SpatialExtent)) +
  geom_tile(aes(fill = Freq), colour = "black") +
  scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Sampling Unit Spatial Extent") +
  ylab("Event Spatial Extent")
```

```{r spatial sampling,  fig.width = 12, fig.height = 12}
multiplot(spatial_plot, sample_plot, cols = 2)
```  
  
*Sampling Duration Before vs. Event Duration - as a proportion:*
  
```{r before prop,  fig.width = 12, fig.height = 12}
##convert xtabs to data.frame, add in missing categories, convert back to xtabs, covert xtabs to dataframe for heat maps##
before_1 <- as.data.frame.matrix(before_prop, make.names = TRUE)
before_1 <- setDT(before_1, keep.rownames = TRUE)[]
before_1$`none` <- 0
before_1$`single sample` <- 0

before_1_hours <- data.frame("hours", 0,0,0,0,0,0,0)
names(before_1_hours) <- c("rn", "days", "hours", "months", "weeks", "years", "none", "single sample")
before_2 <- rbind(before_1, before_1_hours)

before_3 <- as.xtabs(before_2)

before_df1 <- as.data.frame(before_3)
colnames(before_df1) <- c("Sampling_Duration_Before", "ProximateEvent_Duration", "Freq")
before_df1$Sampling_Duration_Before = factor(before_df1$Sampling_Duration_Before,levels(before_df1$Sampling_Duration_Before)[c(3,4,7,1,5,2,6)])
before_df1$ProximateEvent_Duration = factor(before_df1$ProximateEvent_Duration,levels(before_df1$ProximateEvent_Duration)[c(6,7,2,1,4,3,5)])

levels(before_df1$Sampling_Duration_Before) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")
levels(before_df1$ProximateEvent_Duration) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")

before_plot <- ggplot(before_df1, aes(Sampling_Duration_Before, ProximateEvent_Duration)) +
  geom_tile(aes(fill = Freq), colour = "black") +
  scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Sampling Duration Before Event") +
  ylab("Event Duration")
```  
  
*Sampling Duration During vs. Event Duration - as a proportion:*  
  
```{r during prop,  fig.width = 12, fig.height = 12}
##convert xtabs to data.frame, add in missing categories, convert back to xtabs, covert xtabs to dataframe for heat maps##
during_1 <- as.data.frame.matrix(during_prop, make.names = TRUE)
during_1 <- setDT(during_1, keep.rownames = TRUE)[]
during_1$`none` <- 0
during_1$`single sample` <- 0

during_2 <- as.xtabs(during_1)

during_df1 <- as.data.frame(during_2)
colnames(during_df1) <- c("Sampling_Duration_During", "ProximateEvent_Duration", "Freq")
during_df1$Sampling_Duration_During = factor(during_df1$Sampling_Duration_During,levels(during_df1$Sampling_Duration_During)[c(4,5,2,1,6,3,7)])
during_df1$ProximateEvent_Duration = factor(during_df1$ProximateEvent_Duration,levels(during_df1$ProximateEvent_Duration)[c(6,7,2,1,4,3,5)])

levels(during_df1$Sampling_Duration_During) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")
levels(during_df1$ProximateEvent_Duration) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")


during_plot <- ggplot(during_df1, aes(Sampling_Duration_During, ProximateEvent_Duration)) +
  geom_tile(aes(fill = Freq), colour = "black") +
  scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Sampling Duration During Event") +
  ylab("Event Duration")
``` 
  
*Sampling Duration After vs. Event Duration - as a proportion:*
  
```{r after prop,  fig.width = 12, fig.height = 12}
##convert xtabs to data.frame, add in missing categories, convert back to xtabs, covert xtabs to dataframe for heat maps##
after_1 <- as.data.frame.matrix(after_prop, make.names = TRUE)
after_1 <- setDT(after_1, keep.rownames = TRUE)[]
after_1$`none` <- 0
after_1$`single sample` <- 0

after_1_hours <- data.frame("hours", 0,0,0,0,0,0,0)
names(after_1_hours) <- c("rn", "days", "hours", "months", "weeks", "years", "none", "single sample")
after_2 <- rbind(after_1, after_1_hours)

after_3 <- as.xtabs(after_2)

after_df1 <- as.data.frame(after_3)
colnames(after_df1) <- c("Sampling_Duration_After", "ProximateEvent_Duration", "Freq")
after_df1$Sampling_Duration_After = factor(after_df1$Sampling_Duration_After,levels(after_df1$Sampling_Duration_After)[c(3,4,7,1,5,2,6)])
after_df1$ProximateEvent_Duration = factor(after_df1$ProximateEvent_Duration,levels(after_df1$ProximateEvent_Duration)[c(6,7,2,1,4,3,5)])

levels(after_df1$Sampling_Duration_After) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")
levels(after_df1$ProximateEvent_Duration) <- c("None", "Single Sample", "Hours", "Days", "Weeks", "Months", "Years")


after_plot <- ggplot(after_df1, aes(Sampling_Duration_After, ProximateEvent_Duration)) +
  geom_tile(aes(fill = Freq), colour = "black") +
  scale_fill_gradient(low = "white", high = "steelblue") + theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  xlab("Sampling Duration After Event") +
  ylab("Event Duration")
``` 

```{r sampling duration,  fig.width = 12, fig.height = 12}
multiplot(before_plot, during_plot, after_plot, cols = 3)
```  
