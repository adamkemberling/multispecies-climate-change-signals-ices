## Time series for each species and variable ####
library(here)
library(tidyverse)
library(gmRi)
library(grid)
library(gridExtra)

#  Read in data #### 
all_strata <- read_rds(here("Processed Data", "all_strata_t_test.rds"))

all_strata <- all_strata %>%
  unnest(data) %>% 
  unnest(t.test) %>%
  mutate(comname = stringr::str_to_sentence(comname)) %>%
  select(comname, variable, est_year, group, measurement, estimate1970to2009, estimate2010to2019) %>%
  group_by(comname, variable) %>%
  nest()

# Plots ####
plots <- all_strata %>%
  filter(!variable == "avg_depth") %>% # removing to plot later with reversed y-axis
  mutate(plot = map2(data, comname, function(df, comname){
    plot <- ggplot(data = df) +
      geom_line(aes(x=est_year, y=measurement), color = "#E9E9E9", linewidth = 0.45)+
      geom_point(aes(x = est_year, y = measurement), size=0.2)+
      geom_segment(aes(x = 1970, xend = 2009, y = estimate1970to2009, yend = estimate1970to2009), linewidth = 0.7, color = "#00608A") +
      geom_segment(aes(x = 2010, xend = 2019, y = estimate2010to2019, yend = estimate2010to2019), linewidth = 0.7, color = "#EA4F12") +
      ggtitle(comname) +
      theme_gmri(axis.title   = element_blank(),
                 plot.title   = element_text(size = 8),
                 axis.text    = element_text(size = 6),
                 panel.grid   = element_line(linewidth  = 0.2),
                 axis.line.x  = element_line(linewidth  = 0.1),
                 axis.ticks.x = element_line(linewidth  = 0.1),
                 plot.margin  = margin(t = 8, b = 4, r = 8, l = 4))
    return(plot)})) %>%
  group_by(variable) %>%
  nest()

bt    <- plots[[2]][[1]][[3]]
sst   <- plots[[2]][[2]][[3]]
lat   <- plots[[2]][[3]][[3]]
lon   <- plots[[2]][[4]][[3]]

# bt multipanel
species_bt <- marrangeGrob(bt, layout_matrix = matrix(1:20,  nrow = 5, ncol=4, byrow=TRUE), top = NULL, left = textGrob(
  expression(bold("Bottom Temperature (\u00B0C)")), rot = 90, gp = gpar(col = "black", fontsize = 8)))
ggsave(here("Figures", "Figure_S7_BotTemp.pdf"), species_bt, height = 225, width = 170, units ="mm", dpi = 500)

# sst multipanel 
species_sst <- marrangeGrob(sst, layout_matrix = matrix(1:20, nrow = 5, ncol = 4, byrow = TRUE), top = NULL, left = textGrob(
  expression(bold("Surface Temperature (\u00B0C)")), rot = 90, gp = gpar(col = "black", fontsize = 8)))
ggsave(here("Figures", "Figure_S6_SurfTemp.pdf"), species_sst, height = 225, width = 170, units = "mm")

# lat multipanel 
species_lat <- marrangeGrob(lat, layout_matrix = matrix(1:20, nrow = 5, ncol = 4, byrow = TRUE), top = NULL, left = textGrob(
  expression(bold("Latitude (\u00B0N)")), rot = 90, gp = gpar(col = "black", fontsize = 8)))
ggsave(here("Figures", "Figure_S3_Latitude.pdf"), species_lat, height = 225, width = 170, units = "mm")

#lon multipanel
species_lon <-  marrangeGrob(lon, layout_matrix = matrix(1:20, nrow = 5, ncol = 4, byrow = TRUE), top = NULL, left = textGrob(
  expression(bold("Longitude (\u00B0W)")), rot = 90, gp = gpar(col = "black", fontsize = 8)))
ggsave(here("Figures", "Figure_S4_Longitude.pdf"), species_lon, height = 225, width = 170, units = "mm")

# Depth ####
depth <- all_strata %>%
  filter(variable == "avg_depth") %>% 
  mutate(plot = map2(data, comname, function(df, comname){
    plot <- ggplot(data = df) +
      geom_line(aes(x=est_year, y=measurement), color = "#E9E9E9", linewidth = 0.45)+
      geom_point(aes(x = est_year, y = measurement), size=0.2)+
      geom_segment(aes(x = 1970, xend = 2009, y = estimate1970to2009, yend = estimate1970to2009), linewidth = 0.7, color = "#00608A") +
      geom_segment(aes(x = 2010, xend = 2019, y = estimate2010to2019, yend = estimate2010to2019), linewidth = 0.7, color = "#EA4F12") +
      scale_y_reverse() + # reverses y-axis to show increasing depth
      ggtitle(comname) +
      theme_gmri(axis.title   = element_blank(),
                 plot.title   = element_text(size = 8),
                 axis.text    = element_text(size = 6),
                 panel.grid   = element_line(linewidth  = 0.2),
                 axis.line.x  = element_line(linewidth  = 0.1),
                 axis.ticks.x = element_line(linewidth  = 0.1),
                 plot.margin  = margin(t = 8, b = 4, r = 8, l = 4))
    return(plot)})) %>%
  group_by(variable) %>%
  nest()

depth <- depth[[2]][[1]][[3]]

# depth multipanel
species_depth <- marrangeGrob(depth, layout_matrix = matrix(1:20, nrow = 5, ncol = 4, byrow = TRUE), top = NULL, left = textGrob(
  expression(bold("Depth (m)")), rot = 90, gp = gpar(col = "black", fontsize = 8)))
ggsave(here("Figures", "Figure_S5_Depth.pdf"), species_depth, height =225, width = 170, units = "mm")

# Clear environment ####
rm(list=ls())
