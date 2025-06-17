#### packages to process data ####
library(readxl)
library(tidyverse)
library(ggplot2)

#### import of ndvi plot measurements ####

Biobasis_Nuuk_PhenologyPlots_NDVI <- read_excel("~/Library/CloudStorage/OneDrive-GrønlandsNaturinstitut/General - BioBasis/03_GEM_Database/Datafiler excel/Biobasis_Nuuk_PhenologyPlots_NDVI.xlsx")

write_rds(Biobasis_Nuuk_PhenologyPlots_NDVI, "data/biobasis_ndvi.rds")

biobasis_ndvi <- read_rds("data/biobasis_ndvi.rds") |> 
  mutate(plot_id = paste0(Species,Plot)) |> 
  rename(targetdate = Date)
   
names(biobasis_ndvi)                                                            
View(biobasis_ndvi)

#### import the gee ndvi data ####

# Set your folder path
folder_path <- "~/Library/CloudStorage/OneDrive-Aarhusuniversitet/MappingPlants/r_generel/ndvi-comparison/ndvi-comparison/data"

# List all CSV files
files <- list.files(path = folder_path, pattern = "\\.csv$", full.names = TRUE)

# Read and merge all CSVs
merged_data <- files |> 
  lapply(read_csv) |> 
  bind_rows() |> 
  mutate(plot_id = ident)

#### joining the data ####
ndvi_joined <- biobasis_ndvi |> 
  left_join(merged_data, by = c('targetdate', 'plot_id'))

ggplot(ndvi_joined, aes(x = NDVI, y = ndvi))+
  geom_point()+
  coord_cartesian(xlim = c(0, 1), ylim = c(0, 1))+
  geom_smooth(method = lm)

