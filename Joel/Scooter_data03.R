library(cluster)
library(igraph)
library(dplyr)
#library(devtools)
library(arulesViz)
library(shiny)
library(geojsonio)
library(ggplot2)
library(leaflet)
library(rmarkdown)
library(lubridate)
library(ggmap)
library(mapsapi)
library(revgeo)



setwd("C:/xampp/htdocs/RStudio/")
df <- read.csv("VEoRide_DataFormat_3.csv")
df1 <- na.omit(df)



data1 <- df   # Replicate data for Example 1
data1$Date <- as.Date(data1$Date, format='%m/%d/%Y')
data1$weekday <- weekdays(data1$Date)                 # Convert dates to weekdays

#Find distance of rides Lat/lon
R= 3961
dlon = data1$end_lon - data1$start_lon #dlon = lon2 - lon1
dlat = data1$end_lat - data1$start_lat #dlat = lat2 - lat1
a = (sin(dlat/2))^2 + cos(data1$start_lat) * cos(data1$end_lat) * (sin(dlon/2))^2 #a = (sin(dlat/2))^2 + cos(lat1) * cos(lat2) * (sin(dlon/2))^2
c = 2 * atan2( sqrt(a), sqrt(1-a) )
d = R * c #(where R=3961 miles is the radius of the Earth)
data1$distance <- d

#Time in Hour/Min/Sec
data1$Hours_Min_Sec <- hms(data1$Time)

#DateTime format
data1$dateTime <- as.POSIXct(paste(data1$Date, data1$Time), format="%Y-%m-%d %H:%M:%S")

#remove duplicates
data2 <- unique(data1, incomparables = FALSE)
data2$hour <- hour(hms(data2$Hours_Min_Sec))

data3 <- filter(data2, distance >50 &hour>8)

co <- revgeo(longitude = data3$start_lon, latitude = data3$start_lat, provider = 'photon', output = 'frame');
cn <- revgeo(longitude = data3$end_lon, latitude = data3$end_lat, provider = 'photon', output = 'frame');
data3$Start_Zip <- co$zip
data3$End_Zip <- cn$zip

#Plotting
p3 <- ggplot(data3,
             aes(x = Start_Zip,
                 y = distance)) + 
  theme(legend.position="top",
        axis.text=element_text(size = 6))
(p4 <- p3 + geom_point(aes(color = weekday),
                       alpha = 0.5,
                       size = 1.5,
                       position = position_jitter(width = 0.25, height = 0)))
p5 <- ggplot(data3,
             aes(x = End_Zip,
                 y = distance)) + 
  theme(legend.position="top",
        axis.text=element_text(size = 6))
(p6 <- p5 + geom_point(aes(color = weekday),
                       alpha = 0.5,
                       size = 1.5,
                       position = position_jitter(width = 0.25, height = 0)))

View(data3) 

