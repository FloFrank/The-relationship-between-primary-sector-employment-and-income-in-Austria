##############################################################################
#                 The relationship between primary sector 
#                 employment and income in Austria
#
#                 Florian Frank 
##############################################################################




# install and load packages

libs <- c("tidyverse","dplyr","tidyr",
          "RPostgres","ggplot2","stringr","ggthemes","sf","spatialreg","spdep","purrr","scales","stargazer","here","rstudioapi")

installed_libs <- libs %in% rownames(installed.packages())
if (any(installed_libs == F)) {
  install.packages(libs[!installed_libs])
}

invisible(lapply(libs, library, character.only = T))

rm(list = ls())
setwd(here::here())


######### Download shapefile of Austria #########
url <- "https://www.statistik.gv.at/gs-open/GEODATA/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=GEODATA:STATISTIK_AUSTRIA_GEM_20260101&outputFormat=SHAPE-ZIP&format_options=CHARSET:UTF-8"
zip_file <- "austria_shapefile.zip"
austria_dir <- "austria"

if (!dir.exists(austria_dir)) {
  message("Loading shapefile...")
  download.file(url, destfile = zip_file, mode = "wb")
  message("Extracting shapefile...")
  unzip(zip_file, exdir = austria_dir)
  unlink(zip_file)  # Delete the zip file after extraction
  message("Done!")

}

######### load and prepare data #########

austria_dir <- file.path(here::here(), "austria")
data <- st_read(austria_dir)
data <- data %>% rename(ID = g_id)
data <- data %>% rename(Name = g_name)

# transform the coordinate reference system to WGS84 and make geometries valid
data <- st_transform(data, crs = "+proj=longlat +ellps=WGS84 +datum=WGS84") 
data <- st_make_valid(data)


income <- read.csv2(file.path(here::here(), "income.csv"), header = T, sep = ";")
sector_1 <- read.csv2(file.path(here::here(), "sector_1.csv"), header = T, sep = ";")
population <- read.csv2(file.path(here::here(), "population.csv"), header = T, sep = ";")
compulsory_education <- read.csv2(file.path(here::here(), "compulsory_education.csv"), header = T, sep = ";")
apprenticeship <- read.csv2(file.path(here::here(), "apprenticeship.csv"), header = T, sep = ";")
secondary_school <- read.csv2(file.path(here::here(), "secondary_school.csv"), header = T, sep = ";")
academic_secondary <- read.csv2(file.path(here::here(), "academic_secondary.csv"), header = T, sep = ";")
higher_vocational_education <- read.csv2(file.path(here::here(), "higher_vocational_education.csv"), header = T, sep = ";")
higher_education <- read.csv2(file.path(here::here(), "higher_education.csv"), header = T, sep = ";")


# merge of all socioeconomic data with the shapefile data
data <- merge(data,income,by="ID")
data <- merge(data,sector_1,by="ID")
data <- merge(data,population,by="ID")
data <- merge(data,compulsory_education,by="ID")
data <- merge(data,apprenticeship,by="ID")
data <- merge(data,secondary_school,by="ID")
data <- merge(data,academic_secondary,by="ID")
data <- merge(data,higher_vocational_education,by="ID")
data <- merge(data,higher_education,by="ID")
data <- na.omit(data) # delete all rows with NA values


# create new variable "university_entrance_qual" which is the sum of academic_secondary and higher_vocational_education
data$university_entrance_qual <- data$academic_secondary + data$higher_vocational_education

# calculate area and population density
data$area <- as.numeric(st_area(data))/10000 
data$population_density <- data$population/data$area 



# create a queen contiguity matrix and a listw object for spatial analysis
queen.nb <- poly2nb(data, queen = TRUE) #create a queen contiguity matrix
queen <- nb2listw(queen.nb, zero.policy = T) #create a listw object for spatial analysis


# create a plot of the queen contiguity matrix
longitude <- map_dbl(data$geometry, ~st_centroid(.x)[[1]]) 
latitude <- map_dbl(data$geometry, ~st_centroid(.x)[[2]]) 
coords <- cbind(longitude, latitude) 
pdf("plot_queen.pdf")
plot(st_geometry(data), border = "#ababab", bg = "#1f1f1f", col = "#1f1f1f")
plot(queen.nb, coords, add = TRUE, col = "red", lwd = 0.05)
dev.off()





######### Creating charts and plots #########

# Create scatter plot – income per Federal State
bland <- read.csv2(file.path(here::here(), "bland.csv"), header = T, sep = ";")
data_boxplot <- merge(data,bland,by="ID")

# Create boxplot of income per Federal State
pdf("plot_Boxplott.pdf") #plotten Boxplott
ggplot(data_boxplot) +
  geom_boxplot(aes(x = BLAND, y = income, fill = "Boxplots")) + 
  labs(x = "Federal State", y = "Gross Earnings") +
  ggtitle("Average annual gross earnings 
            of employees employed throughout the year by federal state") +
  theme_minimal() +
  scale_fill_manual(values = c("lightgray", "gray"), guide = "none")
dev.off() 



# Create choropleth map of income
pdf("plot_income.pdf")
ggplot() +
  geom_sf(data = data, aes(fill = income)) +
  scale_fill_gradientn(
    colours = c("blue", "green", "red"),
    values = scales::rescale(c(25000, 80000), to = c(0, 1)),
    limits = c(25000, 80000)
  ) +
  labs(title = "Average annual gross earnings 
       of employees employed throughout the year") +
  theme_minimal() +
  theme(
    plot.background = element_rect(fill = "#1f1f1f"),
    panel.background = element_rect(fill = "#1f1f1f"),
    text = element_text(color = "#ababab"),
    panel.grid.major = element_line(color = "#1f1f1f"),
    panel.grid.minor = element_line(color = "#1f1f1f"),
    axis.text = element_text(color = "#ababab"),
    axis.title = element_text(color = "#ababab"),
    plot.title = element_text(color = "#ababab")
  )
dev.off()

# Create plot for sector 1 employment
pdf("plot_sector1.pdf")
ggplot() +
  geom_sf(data = data, aes(fill = sector_1)) +
  scale_fill_gradientn(
    colours = c("blue", "green", "red"),
    values = scales::rescale(c(0, 50, 100), to = c(0, 1)),
    limits = c(0, 100)
  ) +
  labs(title = "Proportion of employees in Sector I (Agriculture and Forestry) in %") +
  theme_minimal()+
  theme(
    plot.background = element_rect(fill = "#1f1f1f"),
    panel.background = element_rect(fill = "#1f1f1f"),
    text = element_text(color = "#ababab"),
    panel.grid.major = element_line(color = "#1f1f1f"),
    panel.grid.minor = element_line(color = "#1f1f1f"),
    axis.text = element_text(color = "#ababab"),
    axis.title = element_text(color = "#ababab"),
    plot.title = element_text(color = "#ababab")
  )
dev.off()




######### Models ######### 

# Moran's I 
moran.test(data$income,queen)

pdf("plot_moran.pdf")
moran_qu <- moran.plot(data$income, queen) #the test is significant, indicating spatial autocorrelation
dev.off()

#H0 = no autocorrelation is present
#H1 = autocorrelation is present
#p-value < 2.2e-16 = autocorrelation is present

# global getis-ord g test 
globalG_test <- globalG.test(data$income, queen ,zero.policy=T)  
globalG_test

# geary c-test 
geary_ctest <- geary.test(data$income, listw = queen)
print(geary_ctest)

geary_output <- capture.output(geary_ctest)# create a text output stream
writeLines(geary_output, "geary_result.txt")# save the result


# local getis-ord g test
# the local getis-ord g test identifies spatial clusters
localG_test <- localG(data$income, queen) 
summary(localG_test)

data_gstat <- data
data_gstat$gstat <- as.numeric(localG_test) #add column with values of the local getis ord g 

# plot local getis-ord g test 
pdf("plot_localgetisord.pdf")
ggplot() +
  geom_sf(data = data_gstat, aes(fill = gstat, geometry = geometry)) +
  scale_fill_gradientn(
    colours = c("#2F6AAE", "#7fffd4", "#EF7373", "red"),
    limits = c(-5, 15),
    breaks = c(-5, -2.5, 0, 2.5, 5, 7.5, 10, 12.5, 15)
  ) +
  theme_map() +
  labs(fill = "Local Getis-Ord's G") +
  theme(
    plot.background = element_rect(fill = "#1f1f1f"),
    panel.background = element_rect(fill = "#1f1f1f"),
    text = element_text(color = "#ababab"),
    panel.grid.major = element_line(color = "#1f1f1f"),
    panel.grid.minor = element_line(color = "#1f1f1f"),
    axis.text = element_text(color = "#ababab"),
    axis.title = element_text(color = "#ababab"),
    plot.title = element_text(color = "#ababab"),
    legend.background = element_rect(fill = "#1f1f1f"),
    legend.position = "bottom",
    legend.key.size = unit(1, "cm")
  )
dev.off()

# local getis ord detail view of Vienna and surrounding areas
data_wien_u <- data_gstat[data_gstat$ID >= 30000 & data_gstat$ID <= 33000 | data_gstat$ID >= 90100 & data_gstat$ID <= 92400 | data_gstat$ID >= 10100 & data_gstat$ID <= 10324 | data_gstat$ID >= 10701 & data_gstat$ID <= 10727 , ] #create new table with filter

pdf("plot_localgetisord_wien.pdf")
ggplot() +
  geom_sf(data = data_wien_u, aes(fill = gstat, geometry = geometry)) +
  scale_fill_gradientn(
    colours = c("#2F6AAE", "#7fffd4", "#EF7373", "red"),
    limits = c(-5, 15),
    breaks = c(-5, -2.5, 0, 2.5, 5, 7.5, 10, 12.5, 15)
  ) +
  theme_map() +
  labs(fill = "Local Getis-Ord's G") +
  theme(
    plot.background = element_rect(fill = "#1f1f1f"),
    panel.background = element_rect(fill = "#1f1f1f"),
    text = element_text(color = "#ababab"),
    panel.grid.major = element_line(color = "#1f1f1f"),
    panel.grid.minor = element_line(color = "#1f1f1f"),
    axis.text = element_text(color = "#ababab"),
    axis.title = element_text(color = "#ababab"),
    plot.title = element_text(color = "#ababab"),
    legend.background = element_rect(fill = "#1f1f1f"),
    legend.position = "bottom",
    legend.key.size = unit(1, "cm")
  )
dev.off()

# local getis ord detail view of Vienna
data_wien <- data_gstat[data_gstat$ID >= 90100 & data_gstat$ID <= 92400 , ] #create new table with filter

pdf("plot_localgetisord_wien_stadt.pdf")
ggplot() +
  geom_sf(data = data_wien, aes(fill = gstat, geometry = geometry)) +
  scale_fill_gradientn(
    colours = c("#2F6AAE", "#7fffd4", "#EF7373", "red"),
    limits = c(-5, 15),
    breaks = c(-5, -2.5, 0, 2.5, 5, 7.5, 10, 12.5, 15)
  ) +
  theme_map() +
  labs(fill = "Local Getis-Ord's G") +
  theme(
    plot.background = element_rect(fill = "#1f1f1f"),
    panel.background = element_rect(fill = "#1f1f1f"),
    text = element_text(color = "#ababab"),
    panel.grid.major = element_line(color = "#1f1f1f"),
    panel.grid.minor = element_line(color = "#1f1f1f"),
    axis.text = element_text(color = "#ababab"),
    axis.title = element_text(color = "#ababab"),
    plot.title = element_text(color = "#ababab"),
    legend.background = element_rect(fill = "#1f1f1f"),
    legend.position = "bottom",
    legend.key.size = unit(1, "cm")
  )
dev.off()

# create a ols model with the formula income ~ sector_1 + compulsory_education 
#                   + apprenticeship + academic_secondary + higher_vocational_education + population_density + higher_education

f <- income ~ sector_1 + compulsory_education + apprenticeship + academic_secondary + higher_vocational_education + population_density + higher_education
OLS <- lm(f, data = data)
summary(OLS)

stargazer(OLS, title= "OLS-Model", style= "default",
          decimal.mark= ",", out= "ols.html")



### LM test for spatial dependence
lm.RStests(OLS, queen,zero.policy = T,test=c("LMerr", "LMlag")) 
lm.RStests(OLS, queen,zero.policy = T,test=c("RLMerr", "RLMlag")) 

lmtest_output <- lm.RStests(OLS, queen,zero.policy = T,test=c("LMerr", "LMlag"))
lmtest_output <- capture.output(lmtest_output)# create a text output stream
writeLines(lmtest_output, "lmtest_result.txt")# save the result

lmRtest_output <- lm.RStests(OLS, queen,zero.policy = T,test=c("RLMerr", "RLMlag"))
lmRtest_output <- capture.output(lmRtest_output)#
writeLines(lmRtest_output, "lmRtest_result.txt")





### SAR model
sar <- lagsarlm(f, data=data, queen, zero.policy = T)
summary(sar)

impacts(sar,listw=queen) 
impacts_output <- impacts(sar,listw=queen) 
impacts_output <- capture.output(impacts_output)
writeLines(impacts_output, "impacts_result.txt")


### SEM model
sem <- errorsarlm(f, data=data, queen,zero.policy = T)
summary(sem)



### SDM model
sdm <- lagsarlm(f, data=data,queen, zero.policy = TRUE, type = "mixed")
summary(sdm)



### SLX model
slx <- lmSLX(f, data=data, listw=queen)
summary(slx)
summary(impacts(slx))


# Calculate and compare AIC values
aic_sar <- AIC(sar)
aic_sdm <- AIC(sdm) 
aic_sem <- AIC(sem)
aic_slx <- AIC(slx)

# Create a comparison table
aic_comparison <- data.frame(
  Model = c("SAR", "SDM", "SEM", "SLX"),
  AIC = c(aic_sar, aic_sdm, aic_sem, aic_slx),
  row.names = NULL
)

# Sort by AIC (lower is better)
aic_comparison <- aic_comparison[order(aic_comparison$AIC), ]
print(aic_comparison)

# Identify the best model (lowest AIC)
best_model <- aic_comparison$Model[1]
best_aic <- aic_comparison$AIC[1]
cat("\n\nBest model based on AIC:\n")
cat("Model:", best_model, "\n")
cat("AIC:", best_aic, "\n")
