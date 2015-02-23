# plot3.R
# Exploratory Data Analysis: Course Project 2
# Author: adatum
#
# Assumes the data files in working directory:
#       summarySCC_PM25.rds
#       Source_Classification_Code.rds
#
# Otherwise, downloads and unzips them from URL:
# https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip
#

library(dplyr)
library(ggplot2)

dataURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
fileNEI <- "summarySCC_PM25.rds"
fileSCC <- "Source_Classification_Code.rds"

# if data files do not exist, download and unzip them
if(!file.exists(fileNEI) & !file.exists(fileSCC)){
        download.file(url = dataURL, destfile = "data.zip", method = "curl")
        unzip("data.zip")
}

# save time by loading data objects only if they do not already exist
if(!exists("NEI") & !exists("SCC")){
        NEI <- readRDS(fileNEI)
        SCC <- readRDS(fileSCC)
}

tot_e <- NEI %>% 
        group_by(year, type) %>% 
        filter(fips == "24510") %>%
        filter(year %in% c(1999, 2002, 2005, 2008)) %>% 
        summarize(total_emissions = sum(Emissions))

png("plot3.png")

qplot(year, total_emissions, data = tot_e, 
      shape = type, 
      geom = c("point", "line"),
      main = expression("Total " * PM[2.5] * " emissions in Baltimore City by source type"),
      xlab = "Year",
      ylab = "Total emissions [ton]"
      ) + 
        theme_bw(base_family = "Times", base_size = 12) +
        theme(legend.position = c(.85,.85),
              legend.background = element_rect(fill="transparent")) +
        scale_shape_discrete(name="Source type")

dev.off()
