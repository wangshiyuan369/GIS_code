> library(sf)
Linking to GEOS 3.12.1, GDAL 3.8.4, PROJ 9.3.1; sf_use_s2() is TRUE
> library(dplyr)

载入程序包：‘dplyr’

The following objects are masked from ‘package:stats’:
  
  filter, lag

The following objects are masked from ‘package:base’:
  
  intersect, setdiff, setequal, union

> library(readr)
> library(ggplot2)
> 
  > setwd("D:/005GIS/week4/practice")
> gender_data <- read_csv("Composite_indices_complete_time_series (1).csv")
错误: 'Composite_indices_complete_time_series (1).csv' does not exist in current working directory ('D:/005GIS/week4/practice').
> gender_data <- read_csv("HDR23-24_Composite_indices_complete_time_series.csv")
Rows: 206 Columns: 1076                                                                        
── Column specification ───────────────────────────────────────────────────────────────────────
Delimiter: ","
chr    (4): iso3, country, hdicode, region
dbl (1072): hdi_rank_2022, hdi_1990, hdi_1991, hdi_1992, hdi_1993, hdi_1994, hdi_1995, hdi_...

ℹ Use `spec()` to retrieve the full column specification for this data.
ℹ Specify the column types or set `show_col_types = FALSE` to quiet this message.
> world_data <- st_read("World_Countries_(Generalized)_9029012925078512962.geojson")
Reading layer `World_Countries_(Generalized)_9029012925078512962' from data source 
  `D:\005GIS\week4\practice\World_Countries_(Generalized)_9029012925078512962.geojson' 
using driver `GeoJSON'
Simple feature collection with 251 features and 5 fields
Geometry type: MULTIPOLYGON
Dimension:     XY
Bounding box:  xmin: -180 ymin: -89 xmax: 180 ymax: 83.6236
Geodetic CRS:  WGS 84
> gii_data <- gender_data %>%
+     select(COUNTRY = country, gii_2010, gii_2019) %>%
+     mutate(GII_Diff = gii_2019 - gii_2010)
> 
> merged_data <- world_data %>%
+     left_join(gii_data, by = "COUNTRY")
> 
> ggplot(data = merged_data) +
+     geom_sf(aes(fill = GII_Diff)) +
+     scale_fill_gradient2(low = "blue", mid = "white", high = "red", 
+                          midpoint = 0,
+                          name = "GII Difference\n(2019-2010)") +
+     theme_minimal() +
+     ggtitle("Change in Gender Inequality Index (2010-2019)")
> 
> write.csv(merged_data, "merged_data.csv")
> 
> ggsave("plot.png", plot = last_plot(), width = 10, height = 8, dpi = 300)
> 