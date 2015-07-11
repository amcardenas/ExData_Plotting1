# Program Name: plot2.R
# Purpose: Plot a line graph of global active power over time using 
#          Electric Power Consumption data set from the UC Irving Machine 
#          Learning Repository as provided by the Johns Hopkins University  
#          Staff for the Exploratory Data Analysis course from the Data Science 
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

# Concatenate the date and time columns and put the new value into a new column
# called DateTime and reformat it as a date with time.
powerdf$DateTime <- paste(powerdf$Date, powerdf$Time)
powerdf$DateTime <- strptime(powerdf$DateTime, "%Y-%m-%d %H:%M:%S")

# Plot global active power vs. time to the screen.  Replicate the 
# features of the graph shown on the course page.
with(powerdf, plot(powerdf$DateTime, powerdf$Global_active_power, main = NULL,
                   ylab = "Global Active Power (kilowatts)", xlab = "", 
                   type = "n"))
with(powerdf, lines(powerdf$DateTime, powerdf$Global_active_power, type = "l"))

# Copy the graph from the screen to a png file.  The graph should have 
# dimensions of 480 pixels x 480 pixels in this png.
dev.copy(png, file = "plot2.png", width = 480, height = 480)
dev.off()
