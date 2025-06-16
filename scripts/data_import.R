#### import of ndvi plot measurements ####

Biobasis_Nuuk_PhenologyPlots_NDVI <- read_excel("~/Library/CloudStorage/OneDrive-GrønlandsNaturinstitut/General - BioBasis/03_GEM_Database/Datafiler excel/Biobasis_Nuuk_PhenologyPlots_NDVI.xlsx")

write_rds(Biobasis_Nuuk_PhenologyPlots_NDVI, "biobasis_ndvi.rds")
                                                               
View(Biobasis_Nuuk_PhenologyPlots_NDVI)