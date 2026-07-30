SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo=read.csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo.csv")





SGK25_NEC_SES_AFS <- combined_data_all_final  %>%
  filter(str_detect(sample_name, "^SGK25-NEC"),
         species_code %in% c("SES", "AFS") 
  )
write.csv(SGK25_NEC_SES_AFS, "SGK25_NEC_SES_AFS.csv")


SGK25_NEC <- combined_data_all_final  %>%
  filter(str_detect(sample_name, "^SGK25-NEC"),
  )
write.csv(SGK25_NEC, "SGK25_NEC.csv")

###



install.packages("ggplot2")
install.packages("sf")
Yes
library(ggplot2)
library(sf)  
library(dplyr)
library(stringr)
library(leaflet)

gps_data <- SGK25_NEC_SES_AFS


# Initialize the leaflet map centered on SG
map <- leaflet() %>%
  setView(lng = -36.7, lat = -54.3, zoom = 7)   %>%
  addTiles() # Adds standard OpenStreetMap background automatically

# Add gps coordinates
# (Using suppressWarnings to handle the HTML line breaks (<br>) safely)

map <- map %>%
  addMarkers(
    data = gps_data, 
    lng = ~Longitude, 
    lat = ~Latitude, 
    label = ~paste( `sample_name`),
    popup = ~paste("<b>sample name:</b>")
  )


# Display the map in your RStudio Viewer pane
map

# if want permanent labels 

labelOptions = labelOptions(
  noHide = TRUE,          # Permanent display
  direction = "top",      # Positions text box above the marker pin
  textsize = "12px",      # Clean text size
  style = list(
    "font-weight" = "bold", 
    "box-shadow" = "3px 3px rgba(0,0,0,0.15)" # Subtle shadow drop
  ))

#colony labels
map <- map %>%
  addLabelOnlyMarkers(
    data = gps_data[!duplicated(gps_data$Colony), ], # Trims out all duplicate rows
    lng = ~Longitude, 
    lat = ~Latitude, 
    label = ~Colony,                                 # Displays the colony name
    labelOptions = labelOptions(
      noHide = TRUE, 
      textOnly = TRUE,                               # Clean text, no ugly boxes
      style = list("color" = "black", "font-weight" = "bold", "font-size" = "12px")
    )
  )

library(readr)
SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo <- read_csv("~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_more.csv")







# trying with ggplot

# 1. Load your required libraries
library(dplyr)
library(stringr)
library(ggplot2)
library(sf)
install.packages("ggrepel")
library(ggrepel) # Crucial for clean, non-overlapping labels
install.packages("ggspatial")
library("ggspatial")

# i added all extra columns i needed with age and colony and delted water


SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo <- read.csv(
  "~/Library/CloudStorage/Box-Box/Isla - HPAI seals/SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo.csv", 
  fileEncoding = "latin1"  # This forces R to safely read the special characters
)


# 3. Convert your data frame to a geographic 'sf' object 
# (Assuming WGS84 CRS coordinate system, which is standard EPSG:4326)
geo_data <- st_as_sf(SGK_25_NEC_SES_and_SFS_Lab_Log_ISY_moreinfo, coords = c("Longitude", "Latitude"), crs = 4326)













library(dplyr)
library(stringr)
library(ggplot2)
library(sf)
library(ggrepel)

# --- NEW DATA PREPARATION STEPS ---

# 1. Clean the Sample ID numbers and create styling categories
geo_data_cleaned <- geo_data %>%
  # Extract just the digits from the end of "SGK-NEC-051" -> "051"
  mutate(sample_number = str_extract(Sample.ID, "\\d+$")) %>%
  # Determine PCR status color group (checks for NA or empty cells)
  mutate(pcr_status = if_else(is.na(PCR.Date) | PCR.Date == "", "Negative", "Positive"))

# 2. dont think i need- Extract unique colonies for labeling (using the cleaned dataset)
colony_data <- geo_data_cleaned %>% 
  distinct(Colony, .keep_all = TRUE)

# --- 5. BUILD THE STATIC GGPLOT MAP ---
static_map <- ggplot() +
  # Draw map background
  borders("world", regions = "South Georgia", fill = "antiquewhite", color = "darkgray") +
  
  # Add sample location points with unique Shapes (Species) and Colors (PCR Status)
  geom_sf(
    data = geo_data_cleaned, 
    aes(shape = Species, color = pcr_status), 
    size = 4,      # Increased size slightly so shapes are easy to distinguish
    alpha = 0.9
  ) +
  
  # Manual controls for Shapes (16 = Solid Circle, 17 = Solid Triangle)
  scale_shape_manual(
    name = "Species",
    values = c("AFS" = 17, "SES" = 16)
  ) +
  
  # Manual controls for Colors (Green for tested, Red for NA)
  scale_color_manual(
    name = "pcr status",
    values = c("Positive" = "forestgreen", "Negative" = "firebrick")
  ) +
  
  # Add individual sample NUMBER labels (e.g., "051" instead of the long text)
  geom_text_repel(
    data = geo_data_cleaned,
    aes(label = sample_number, geometry = geometry),
    stat = "sf_coordinates",
    size = 3.5,
    fontface = "bold",
    box.padding = 0.5,
    max.overlaps = Inf
  ) +
  
  # Add prominent Colony labels
  geom_label_repel(
    data = colony_data,
    aes(label = Colony, geometry = geometry),
    stat = "sf_coordinates",
    size = 4,
    fontface = "bold",
    color = "darkblue",
    fill = "white",
    alpha = 0.85,
    box.padding = 1
  ) +
  
  # Crop the map view to your specific region
  coord_sf(xlim = c(-38.5, -35.5), ylim = c(-55.0, -53.5), expand = FALSE) +
  
  # Apply theme settings
  theme_minimal() +
  labs(
    title = "SGK25 NEC Sample Locations",
    subtitle = "South Georgia HPAI Seal Monitoring",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme(
    panel.background = element_rect(fill = "aliceblue"), 
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right" # Places your clean Species & PCR legends on the right
  )

# 6. Display your map in RStudio
print(static_map)

# 7. Save your map perfectly as a high-resolution file
ggsave("SGK25_static_map.png", plot = static_map, width = 10, height = 8, dpi = 300)







# round 2

geo_data_cleaned <- geo_data_cleaned %>% 
  arrange(pcr_status) 

# --- 5. BUILD THE STATIC GGPLOT MAP ---
static_map <- ggplot() +
  # Draw map background
  borders("world", regions = "South Georgia", fill = "antiquewhite", color = "darkgray") +
  
  # Add sample location points with unique Shapes (Species) and Colors (PCR Status)
  geom_sf(
    data = geo_data_cleaned, 
    aes(shape = Species, color = pcr_status), 
    size = 4,      # Increased size slightly so shapes are easy to distinguish
    alpha = 0.4
  ) +
  
  # Manual controls for Shapes (16 = Solid Circle, 17 = Solid Triangle)
  scale_shape_manual(
    name = "Species",
    values = c("AFS" = 17, "SES" = 16)
  ) +
  
  # Manual controls for Colors (Green for tested, Red for NA)
  scale_color_manual(
    name = "pcr status",
    values = c("Positive" = "forestgreen", "Negative" = "firebrick")
  ) +
  
  
  # UPDATED: Only add labels for samples that have a sequencing start date
  geom_text_repel(
    data = geo_data_cleaned %>% 
      filter(!is.na(Sequencing.Start.Date) & Sequencing.Start.Date != ""),
    aes(label = sample_number, geometry = geometry),
    stat = "sf_coordinates",
    size = 3.5,
    fontface = "bold",
    box.padding = 0.5,
    max.overlaps = Inf # Keeps R from hiding labels due to spacing issues
  ) +
  
  
  
  # Add prominent Colony labels
  geom_label_repel(
    data = colony_data,
    aes(label = Colony, geometry = geometry),
    stat = "sf_coordinates",
    size = 4,
    fontface = "bold",
    color = "darkblue",
    fill = "white",
    alpha = 0.85,
    box.padding = 1
  ) +
  
  # Crop the map view to your specific region
  coord_sf(xlim = c(-38.5, -35.5), ylim = c(-55.0, -53.5), expand = FALSE) +
  
  # Apply theme settings
  theme_minimal() +
  labs(
    title = "SGK25 NEC Sample Locations",
    subtitle = "South Georgia HPAI Seal Monitoring",
    x = "Longitude",
    y = "Latitude"
  ) +
  theme(
    panel.background = element_rect(fill = "aliceblue"), 
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "right" # Places your clean Species & PCR legends on the right
  )

print(static_map)

