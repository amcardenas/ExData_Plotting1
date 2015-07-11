# Program Name: plot4.R
# Purpose: Plot 4 subplots in a single plot area in a 2 x 2 structure.  The 4 
#          subplots will be as follows:
#       
#          Row 1, Column 1: A line graph of Global Active Power over time
#          Row 1, Column 2: A line graph of Voltage over time
#          Row 2, Column 1: A line graph of submetering 1 - 3 data over time
#          Row 2, Column 2: A line graph of Global Reactive Power over time
#
#          All data included is from the Electric Power Consumption data set 
#          from the UC Irving Machine Learning Repository as provided by the 
#          Johns Hopkins University Staff for the Exploratory Data Analysis 
#          course from the Data Science Specialization on Coursera.org.
# Source of Data: http://archive.ics.uci.edu/ml/
# Author: Aimee Mostella Cardenas
# Date of Creation: 10-Jul-2015

# Include the necessary libraries.
library(datasets)

# Load the date, time and global active power data columns.
powerdf <- read.table("household_power_consumption.txt", sep = ";", 
                      header = TRUE, colClasses = c("character", "character", 
                      rep("numeric", 3), "NULL", rep("numeric", 3)), 
                      na.strings = "?")

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
# set the range of the y-axis to be the same for all lines in the submetering
# subplot.
all_submetering <- c(powerdf$Sub_metering_1, powerdf$Sub_metering_2, 
                     powerdf$Sub_metering_3)
ymin = min(all_submetering)
ymax = max(all_submetering)


# Open the png device and set the dimensions to 480 pixels by 480 pixels.
png(file = "plot4.png", width = 480, height = 480)

# Set up the plotting area to have 4 subplots in a 2 x 2 structure.
par(mfrow = c(2, 2))

# Create subplot at Row 1, Column 1: Global Active Power over time.
# Replicate the features of the graph shown on the course page.
with(powerdf, plot(powerdf$DateTime, powerdf$Global_active_power, main = NULL,
                   ylab = "Global Active Power (kilowatts)", xlab = "", 
                   type = "n"))
with(powerdf, lines(powerdf$DateTime, powerdf$Global_active_power, type = "l"))


# Create the subplot at Row 1, Column 2: Voltage over time.
# Replicate the features of the graph shown on the course page.
with(powerdf, plot(powerdf$DateTime, powerdf$Voltage, main = NULL,
                   ylab = "Voltage", xlab = "datetime", 
                   type = "n"))
with(powerdf, lines(powerdf$DateTime, powerdf$Voltage, type = "l"))


# Create the subplot at Row 2, Column 1: Submetering 1 - 3 over time.
# Replicate the features of the graph shown on the course page.
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
       legend = col_names[6:8], bty = "n")


# Create the subplot at Row 2, Column 2: Global Reactive Power over time.
# Replicate the features of the graph shown on the course page.
with(powerdf, plot(powerdf$DateTime, powerdf$Global_reactive_power, 
                   ylab = col_names[4], xlab = "datetime", main = NULL,
                   type = "n"))
with(powerdf, lines(powerdf$DateTime, powerdf$Global_reactive_power, 
                    type = "l"))


# Close the png device.
dev.off()
