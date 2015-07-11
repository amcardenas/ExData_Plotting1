# Program Name: plot3.R
# Purpose: Plot a line graph of submeter data from submeters 1 - 3 over time 
#          using the Electric Power Consumption data set from the UC Irving 
#          Machine Learning Repository as provided by the Johns Hopkins  
#          University Staff for the Exploratory Data Analysis course from the 
#          Data Science Specialization on Coursera.org.
# Source of Data: http://archive.ics.uci.edu/ml/
# Author: Aimee Mostella Cardenas
# Date of Creation: 10-Jul-2015

# Include the necessary libraries.
library(datasets)

# Load the date, time and all 3 submetering data columns.
powerdf <- read.table("household_power_consumption.txt", sep = ";", 
                      header = TRUE, colClasses = c("character", "character", 
                      rep("NULL", 4), rep("numeric", 3)), na.strings = "?")

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

# Calculate the min and max values of all 3 submetering columns so that we can
# set the range of the y-axis to be the same for all lines in the graph.
all_submetering <- c(powerdf$Sub_metering_1, powerdf$Sub_metering_2, 
                     powerdf$Sub_metering_3)
ymin = min(all_submetering)
ymax = max(all_submetering)

# Plot each of the submetering columns vs. time directly to a png with 
# dimensions of 480 pixels x 480 pixels.  Replicate the other features of the
# graph shown on the course page as well.
png(file = "plot3.png", width = 480, height = 480)
with(powerdf, plot(powerdf$DateTime, powerdf$Sub_metering_1, main = NULL,
                   ylab = "Energy sub metering", xlab = "", 
                   ylim = range(ymin:ymax), type = "n"))
with(powerdf, lines(powerdf$DateTime, powerdf$Sub_metering_1, type = "l", 
                    ylim = range(ymin:ymax), xlab = ""))
with(powerdf, lines(powerdf$DateTime, powerdf$Sub_metering_2, type = "l", 
                    ylim = range(ymin:ymax), xlab = "", col = "red"))
with(powerdf, lines(powerdf$DateTime, powerdf$Sub_metering_3, type = "l", 
                    ylim = range(ymin:ymax), xlab = "", col = "blue"))

# Add a legend.
col_names <- names(powerdf)
legend("topright", pch = "_", col = c("black", "red", "blue"), 
       legend = col_names[3:5])

# Close the png device.
dev.off()
