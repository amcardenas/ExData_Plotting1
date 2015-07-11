# Program Name: plot1.R
# Purpose: Plot a histogram of global active power using the Electric Power
#          Consumption data set from the UC Irving Machine Learning Repository
#          as provided by the Johns Hopkins University Staff for the 
#          Exploratory Data Analysis course from the Data Science 
#          Specialization on Coursera.org.
# Source of Data: http://archive.ics.uci.edu/ml/
# Author: Aimee Mostella Cardenas
# Date of Creation: 10-Jul-2015

# Include the necessary libraries.
library(datasets)

# Load the date, time and global active power data columns.
powerdf <- read.table("household_power_consumption.txt", sep = ";", 
                      header = TRUE, colClasses = c("character", "character", 
                      "numeric", rep("NULL", 6)), na.strings = "?")

# Clean the data.
powerdf <- powerdf[complete.cases(powerdf), ]

# Change the class of the date column from character to Date.
powerdf[, 1] <- as.Date(powerdf[, 1], "%d/%m/%Y")

# Extract only the data collected on 2007-02-01 (February 1, 2007)
# and 2007-02-02 (February 2, 2007).
powerdf <- subset(powerdf, Date == "2007-02-01" | Date == "2007-02-02")

# Plot a histogram of global active power to the screen.  Replicate the 
# features of the graph shown on the course page.
with(powerdf, hist(powerdf$Global_active_power, col = "red",
                   main = "Global Active Power",
                   xlab = "Global Active Power (kilowatts)"))

# Copy the graph from the screen to a png file.  The graph should have 
# dimensions of 480 pixels x 480 pixels in this png.
dev.copy(png, file = "plot1.png", width = 480, height = 480)
dev.off()