# plot6.R
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

# identify motor vehicle-related SCCs in the EI.Sector column of SCC
vehicleSCC <- droplevels(SCC$SCC[grep("Vehicle", SCC$EI.Sector)])

tot_e <- NEI %>%
        group_by(year, fips) %>%
        filter(fips == "24510" | fips == "06037") %>% # Baltimore City or Los Angeles
        filter(SCC %in% vehicleSCC) %>%
        filter(year >= 1999 & year <= 2008) %>% # unnecessary
        summarize(total_emissions = sum(Emissions)) %>%
        mutate(city = plyr::mapvalues(fips, c("24510", "06037"), c("Baltimore City", "Los Angeles")))

png("plot6.png")

qplot(year, total_emissions, data = tot_e, 
      shape = city, 
      geom = c("point", "line"),
      main = expression(PM[2.5] * " emissions from motor vehicles in Baltimore City and Los Angeles"),
      xlab = "Year",
      ylab = "Total emissions [ton]"
) + 
        theme_bw(base_family = "Times", base_size = 12) +
        theme(legend.position = c(.85,.5),
              legend.background = element_rect(fill="transparent"))

dev.off()