# plot5.R
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

# identify motor vehicle-related SCCs in the EI.Sector column of SCC
vehicleSCC <- droplevels(SCC$SCC[grep("Vehicle", SCC$EI.Sector)])

tot_e <- NEI %>%
        group_by(year) %>%
        filter(fips == "24510") %>% # Baltimore City, Maryland
        filter(SCC %in% vehicleSCC) %>%
        filter(year >= 1999 & year <= 2008) %>% # unnecessary
        summarize(total_emissions = sum(Emissions))

png("plot5.png")

barplot(tot_e$total_emissions, 
        names.arg = tot_e$year,
        col = "darkblue",
        main = expression("Total " * PM[2.5] * " emissions from motor vehicles in Baltimore City, Maryland"),
        xlab = "Year",
        ylab = "Total emissions [ton]"
)

dev.off()