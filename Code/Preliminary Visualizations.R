###################################################################################################
#                              Preliminary Visualizations
#         Drought, Dust Storms, and Health and Agricultural Impacts in South Africa
#                                   Laura Caron
#                                 December 23, 2021
##################################################################################################

library(tidyverse)
library(sf)
library(terra)
library(rgdal)

#########################
# Cleaning and Merging Data Sources
# Note: Zonal statistics pre-calculated in QGIS for speed
# Final visualization in QGIS for speed
#########################
parcels <- st_read("Raw Data/Parcels/SA_parcels_fixed.shp")

croplands <- st_read("QGIS Analysis/Zonal statistics/Mean Croplands.shp") %>% dplyr::select(OBJECTID, X_Croplands)
ndvi_2015 <- st_read("QGIS Analysis/Zonal statistics/Mean NDVI 2015.shp") %>% dplyr::select(OBJECTID, X_NDVI2015m)
ndvi_2016 <- st_read("QGIS Analysis/Zonal statistics/Mean NDVI 2016.shp") %>% dplyr::select(OBJECTID, X_NDVI2016m)
spi_2016_04 <- st_read("QGIS Analysis/Zonal statistics/Mean SPI 2016_04.shp") %>% dplyr::select(OBJECTID, X_SPI2016_0)
spi_2015_04 <- st_read("QGIS Analysis/Zonal statistics/Mean SPI 2015_04.shp") %>% dplyr::select(OBJECTID, X_SPI2015_0)
spi_2015_10 <- st_read("QGIS Analysis/Zonal statistics/Mean SPI 2015_10.shp") %>% dplyr::select(OBJECTID, X_SPI2015_1)
spi_2014_10 <- st_read("QGIS Analysis/Zonal statistics/Mean SPI 2014_10.shp") %>% dplyr::select(OBJECTID, X_SPI2014_1)
aerosol <- st_read("QGIS Analysis/Zonal statistics/Mean Aerosol 2016.shp") %>% dplyr::select(OBJECTID, X_Aero2016m)


parcels <- left_join(parcels, st_drop_geometry(aerosol)) %>%
           left_join(st_drop_geometry(croplands)) %>% 
           left_join(st_drop_geometry(ndvi_2015)) %>%
           left_join(st_drop_geometry(ndvi_2016)) %>%
           left_join(st_drop_geometry(spi_2016_04)) %>% 
           left_join(st_drop_geometry(spi_2014_10)) %>%
           left_join(st_drop_geometry(spi_2015_04)) %>%
           left_join(st_drop_geometry(spi_2015_10)) 

parcels <- rename(parcels, SPI2016_0=X_SPI2016_0, SPI2015_0=X_SPI2015_0, SPI2014_1=X_SPI2014_1, SPI2015_1=X_SPI2015_1)
parcels <- rename(parcels, OBJECT =OBJECTID)


parcels <- parcels %>% mutate(farm=(X_Croplands > 0))
parcels.sp <-  as(parcels, 'Spatial')
#write_sf(parcels, "QGIS Analysis/Zonal statistics/merged.gpkg")
writeOGR(parcels.sp, "QGIS Analysis/Zonal statistics/merged.gpkg", driver="GPKG", layer="merged")