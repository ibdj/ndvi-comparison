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
  left_join(merged_data, by = c('targetdate', 'plot_id')) |> 
  filter(NDVI > 0) |> 
  group_by(targetdate, plot_id, image_date) |>
  summarise(ndvi_rapid = mean(NDVI),
            ndvi_senti = mean(ndvi))

summary(ndvi_joined)

write_rds(ndvi_joined, "data/ndvi_joined.rds")




#### checking how many days have gee data #####

days_compared <- ndvi_joined |> 
  group_by(targetdate)  |> 
  summarise(
    first_image_date = first(na.omit(image_date)),
    n_non_na_image_date = sum(!is.na(image_date)),
    n_rows = n(),
    .groups = "drop"
  )
