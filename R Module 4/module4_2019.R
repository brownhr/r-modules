library(GISTools)
#install.packages("rgdal")
library(rgdal)
setwd("C:/Users/kovachmm/Downloads")
NC=readOGR(file.choose())
NC=rgdal::writeOGR(file.choose())

summary(NC)
typeof(NC$MNEM2000) #check type of
NC$MNEM2000 = as.numeric(as.character(NC$MNEM2000)) 


#first create a relative frequency histogram (also called a density plot)
#I've specified a particular technique for defining the breaks
#To learn more about this break method, review help(hist)
hist(NC$MNEM2000, prob=T, col='red', breaks='fd')

#Now I'll add the smoothed frequency polygon curve to the
histogram
lines(density(NC$MNEM2000), lwd=4, lty='dashed', col='black')
#Next I'll add the mean and median as vertical lines using

abline()

abline(v=mean(NC$MNEM2000), lwd=4, lty='dotted', col='blue')
abline(v=median(NC$MNEM2000), lwd=3, lty='twodash',
       col='green')

#Last, I'll add a legend to keep track of all these lines.
legend(x='topright', c('Density plot', 'Mean', 'Median'),
       col=c('black', 'blue', 'green'), lwd=c(4, 4, 3), lty=c('dashed',
                                                              'dotted', 'twodash'))

#histogram 1 
hist(NC$MNEM2000, prob=T, col='thistle2', border = "indianred4", breaks='fd', main="Manufacturing Jobs in 2000", xlab = "Manufacturing jobs", xlim =c(0,50000))
#density plot
lines(density(NC$MNEM2000), lwd=4, lty= 1, col="black") 
#adding lines: mean, median
abline(v=mean(NC$MNEM2000), lwd=4, lty= 2, col="navyblue")
abline(v=median(NC$MNEM2000), lwd=4, lty= 2, col="limegreen")
#legend
legend(x='topright', c('Density plot', 'Mean', 'Median'), col=c('black', 'navyblue', 'limegreen'), lwd=c(4, 4, 3), lty=c(1, 2, 2))

#histogram 2
NC$MNEM1990 = as.numeric(as.character(NC$MNEM1990)) 
hist(NC$MNEM1990, prob=T, col='thistle2', border = "indianred4", breaks='fd', main="Manufacturing Jobs in 2000", xlab = "Manufacturing jobs", xlim =c(0,50000))
#density plot
lines(density(NC$MNEM1990), lwd=4, lty= 1, col="black") 
#adding lines: mean, median
abline(v=mean(NC$MNEM1990), lwd=4, lty= 2, col="navyblue")
abline(v=median(NC$MNEM1990), lwd=4, lty= 2, col="limegreen")
#legend
legend(x='topright', c('Density plot', 'Mean', 'Median'), col=c('black', 'navyblue', 'limegreen'), lwd=c(4, 4, 3), lty=c(1, 2, 2))



NC$TOTJOB2000 = as.numeric(as.character(NC$TOTJOB2000)) 
#histogram 3
hist(NC$TOTJOB2000, prob=T, col='thistle2', border = "indianred4", breaks='fd', main="Total Jobs in 2000", xlab = "Total jobs")
#density plot
lines(density(NC$TOTJOB2000), lwd=4, lty= 1, col="black") 
#adding lines: mean, median
abline(v=mean(NC$TOTJOB2000), lwd=4, lty= 2, col="navyblue")
abline(v=median(NC$TOTJOB2000), lwd=4, lty= 2, col="limegreen")
#legend
legend(x='topright', c('Density plot', 'Mean', 'Median'), col=c('black', 'navyblue', 'limegreen'), lwd=c(4, 4, 3), lty=c(1, 2, 2))

#histogram 3 
hist(NC$MNEM1990, prob=T, col='thistle2', border = "indianred4", breaks='fd', main="Manufacturing Jobs in 1990", xlab = "Manufacturing jobs", xlim =c(0,50000))
#density plot
lines(density(NC$MNEM1990), lwd=4, lty= 1, col="black") 
#adding lines: mean, median
abline(v=mean(NC$MNEM1990), lwd=4, lty= 2, col="navyblue")
abline(v=median(NC$MNEM1990), lwd=4, lty= 2, col="limegreen")
#legend
legend(x='topright', c('Density plot', 'Mean', 'Median'), col=c('black', 'navyblue', 'limegreen'), lwd=c(4, 4, 3), lty=c(1, 2, 2))

#histogram 4 
hist(NC$TOTJO1990, prob=T, col='thistle2', border = "indianred4", breaks='fd', main="Total Jobs in 1990", xlab = "Total jobs")
#density plot
lines(density(NC$TOTJO1990), lwd=4, lty= 1, col="black") 
#adding lines: mean, median
abline(v=mean(NC$TOTJO1990), lwd=4, lty= 2, col="navyblue")
abline(v=median(NC$TOTJO1990), lwd=4, lty= 2, col="limegreen")
#legend
legend(x='topright', c('Density plot', 'Mean', 'Median'), col=c('black', 'navyblue', 'limegreen'), lwd=c(4, 4, 3), lty=c(1, 2, 2))


#LQ CALCULATION
# 1.Statewide Ratio of manufacturing jobs to total jobs by summing each variable
jobrate.2000=sum(NC$MNEM2000)/sum(NC$TOTJOB2000)
jobrate.2000
#[1] 0.1144246
#if manufacturing jobs are evenly distributed across the 92 Counties
#manufacturing should comprise roughly 11% of all jobs in a given county

#we can now calculate the LQ for each county
#but we need to add a new field to the attribute table to hold the results
#we'll create the field and populate it with the calculated LQ Values

NC$LQ2000=(NC$MNEM2000/NC$TOTJOB2000)/jobrate.2000
summary(NC$LQ2000)
#now I can map the LQ measures for each county 
shades=shading(c(0.5, 1, 1.5), cols=brewer.pal(4, 'Blues'))
choropleth(NC,NC$LQ2000,shades, main= "Ratio of Manufacturing Jobs in NC during 2000")
choro.legend(-84, 34.9, sh=shades, title='LQ Manufacturing (2000)', cex = 0.75, y.intersp=0.8)
#this will save the shapefile to the working directory specified earlier 
#I'm going to call mine new file 'test_RMOD4'

td <-file.path(tempdir(), "rgdal_examples");dir.create(td)
rgdal::writeOGR(NC ,td, "test_RMOD4", driver = "ESRI Shapefile", overwrite_layer=TRUE)

#LQ 1990
jobrate.1990=sum(NC$MNEM1990)/sum(NC$TOTJO1990)
jobrate.1990
NC$LQ1990=(NC$MNEM1990/NC$TOTJO1990)/jobrate.1990
summary(NC$LQ1990)
#now I can map the LQ measures for each county 
shades=shading(c(0.5, 1, 1.5), cols=brewer.pal(4, 'Blues'))
choropleth(NC,NC$LQ1990,shades, main= "Ratio of Manufacturing Jobs in NC during 1990")
choro.legend(-84, 34.9, sh=shades, title='LQ Manufacturing (1990)', cex = 0.75, y.intersp=0.8)
#this will save the shapefile to the working directory specified earlier 
#I'm going to call mine new file 'test_RMOD4'
