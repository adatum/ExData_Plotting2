# plot2.R
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
        group_by(year) %>% 
        filter(fips == "24510") %>%
        filter(year %in% c(1999, 2002, 2005, 2008)) %>% 
        summarize(total_emissions = sum(Emissions))

png("plot2.png")

barplot(tot_e$total_emissions, 
        names.arg = tot_e$year,
        col = "darkblue",
        main = expression("Total emissions from " * PM[2.5] * " in Baltimore City, Maryland"),
        xlab = "Year",
        ylab = "Total emissions [ton]"
)

dev.off()

