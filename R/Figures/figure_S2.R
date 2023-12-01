# Decadal shifts 
# load libraries and data ####
library(here)
library(tidyverse)
library(gmRi)

all_strata <- read_rds(here("Processed Data", "all_strata_t_test.rds")) %>%
  mutate(comname = stringr::str_to_sentence(comname)) 

decadal_map <- all_strata %>%
  filter(comname %in% c("Acadian redfish","Summer flounder", "American lobster" )) %>%
  filter(variable %in% c("avg_lat", "avg_lon")) %>%
  select(comname, variable, data) %>%
  unnest(data) %>%
  mutate(Decade = 10*est_year %/% 10) %>%
  pivot_wider(names_from = "variable", values_from = "measurement")

# Map ####
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(ggrepel)

world <- ne_states(returnclass = "sf")
cols <- c("#7D7C7C", "#22444B", "#0E6686", "#028ABD", "#02D2FF")

decadal_map <- ggplot(data = world)+
  geom_sf()+
  coord_sf(xlim=c(-76, -66), ylim=c(37.5,45)) +
  geom_point(data = decadal_map, aes(x=avg_lon, y= avg_lat, color = as.factor(Decade)), size = 1) +
  scale_color_manual(values = cols)+
  facet_wrap(~factor(comname, levels = c("Acadian redfish", "Summer flounder", "American lobster")), nrow = 1) +
  scale_y_continuous(breaks = c(36,40,44)) + scale_x_continuous(breaks = c(-78,-72,-66)) +
  theme_gmri(legend.title = element_text(face = "bold", size = 8),
             legend.text = element_text(size = 6), 
             axis.title = element_blank(),
             axis.text = element_text(size = 8), 
             strip.text = element_text(size = 8),
             strip.background = element_rect(fill = "#00608A"), 
             panel.border = element_rect(fill = NA, linetype = 1, linewidth = 0.2, color = "lightgray")) +
  guides(color = guide_legend(title = "Decade", size = 2, override.aes = list(size = 3)))

ggsave(here("Figures", "Figure_S2.pdf"), decadal_map, width = 170, height = 79, units = "mm")
