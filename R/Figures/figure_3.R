# Map and table of statistically significant movement
# load libraries and data
library(here)
library(tidyverse)
library(gmRi)

all_strata <- read_rds(here("Processed Data", "all_strata_t_test.rds")) %>%
  mutate(comname = stringr::str_to_sentence(comname)) 

# Significant Movers Map ####
significant_movers <- all_strata %>%
  filter(variable %in% c("avg_lat", "avg_lon")) %>%
  unnest(t.test) %>%
  filter(different == "TRUE") %>%
  select(!data & !method)

significant_movers <- significant_movers %>% 
  filter(variable == "avg_lat") %>% 
  mutate(direction = ifelse(estimate2010to2019 > estimate1970to2009, "North", "South")) %>%
  full_join(significant_movers %>% 
              filter(variable == "avg_lon") %>%
              mutate(direction = ifelse(estimate2010to2019 < estimate1970to2009, "West", "East"))) %>%
  filter(!comname %in% c("Atlantic cod", "Atlantic hagfish", "Atlantic herring","Fourspot flounder", "Gulf stream flounder", "Haddock", "Jonah crab", "Longhorn sculpin", 
                         "Northern shortfin squid", "Pollock", "Red hake", "Spotted hake", "Thorny skate", "Winter flounder", "Winter skate", "Witch flounder", 
                         "Yellowtail flounder")) %>% arrange(comname)

movers_plot <- significant_movers %>% 
  ungroup(comname, variable, estimate1970to2009, estimate2010to2019, p.value, different, direction) %>%
  select(comname, variable, estimate1970to2009, estimate2010to2019) %>%
  pivot_longer(cols = 3:4, names_to = "group", values_to = "means") %>%
  pivot_wider(names_from = "variable", values_from = "means") %>%
  drop_na() # plotting species that change both lat and long

plot_names <- movers_plot %>%
  filter(group == "estimate1970to2009") %>%
  rowid_to_column()

# Map ####
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)
library(ggrepel)

world <- ne_states(returnclass = "sf")

movement <- 
  ggplot(data=world)+
  geom_sf()+
  coord_sf(xlim=c(-74.5, -67.5), ylim=c(37.5, 43))+
  geom_point(data=movers_plot, aes(x=avg_lon, y=avg_lat, fill = group), pch = 21, size = 12)+
  geom_line(data=movers_plot, aes(x=avg_lon, y=avg_lat, group = comname), alpha = 0.5, color="#535353", linewidth = 1.5)+
  scale_fill_manual(name = "Years", labels = c("2010-2019", "1970-2009"), values=c("#EA4f12", "#00608A"))+
  theme_gmri(legend.text = element_text(size = 35),
             legend.title = element_text(size = 40, face = "bold"),
             axis.line = element_blank(),
             axis.title = element_text(size = 40, face = "bold"),
             axis.text  = element_text(size = 35),
             plot.title = element_text(size = 35), 
             panel.border = element_rect(fill = NA, linetype = 1, linewidth = 1, color = "lightgray"))+
  ylab("Latitude")+
  xlab("Longitude")+
  guides(fill = guide_legend(reverse=TRUE)) +
  geom_text(data = plot_names, aes(x=avg_lon, y=avg_lat, label= rowid), fontface = "bold", color = "white", size = 6) + # command out to remove labels
  scale_y_continuous(breaks = c(38,40,42)) + scale_x_continuous(breaks = c(-74,-71,-68))

ggsave(here("Figures", "Movement_Map.png"), movement, height = 18, width = 27, units = "in", bg = "white") # This is combined with the legend in an external program

# Map Legend ####
library(gt)
legend <- plot_names %>%
  select(rowid, comname) %>%
  gt(groupname_col = NULL) %>%
  tab_style(
    style = cell_text(weight = "bold"),
    locations = cells_body(columns = rowid)) %>%
  tab_style(
    style = cell_text(size = "x-large"),
    locations = cells_body(columns = everything(), rows = everything())) %>% 
  tab_style(
    style = cell_text(size = "xx-large"),
    locations = cells_column_labels(columns = everything()))%>%
  cols_label(comname = md("**Species**"),
             rowid = "") 

gtsave(legend, here("Figures", "Movement_Legend.png")) # Legend and map combined in external program with manual numbering

# Clear environment ####
rm(list=ls())
