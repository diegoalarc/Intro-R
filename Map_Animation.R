# Map animation in R

library(dplyr)        # data wrangling
library(cartogram)    # for the cartogram
library(ggplot2)      # to realize the plots
library(broom)        # from geospatial format to data frame
library(tweenr)       # to create transition dataframe between 2 states
library(gganimate)    # To realize the animation
library(maptools)     # world boundaries coordinates
library(viridis)      # for a nice color palette
library(mapproj)

# Get the shape file of Asia
data(wrld_simpl)
asia=wrld_simpl[wrld_simpl$REGION==142,]

# A basic representation
plot(asia)

# construct a cartogram using the population in 2005
asia_cartogram <- cartogram_cont(asia, "POP2005", itermax=7)

# A basic representation
plot(asia_cartogram)

# Transform these 2 objects in dataframe, plotable with ggplot2
asia_cartogram_df <- tidy(asia_cartogram) %>% left_join(. , asia_cartogram@data, by=c("id"="ISO3")) 
asia_df <- tidy(asia) %>% left_join(. , asia@data, by=c("id"="ISO3")) 

# And using the advices of chart #331 we can custom it to get a better result:
ggplot() +
  geom_polygon(data = asia_df, aes(fill = POP2005/1000000, x = long, y = lat, group = group) , size=0, alpha=0.9) +
  theme_void() +
  scale_fill_viridis(name="Population (M)", breaks=c(1,100,250,500,1000,1250), guide = guide_legend( keyheight = unit(3, units = "mm"), keywidth=unit(1, units = "mm"), label.position = "bottom", title.position = 'top', nrow=1)) +
  labs( title = "Asia", subtitle="Population per country in 2005" ) +
  ylim(-55,55) +
  theme(
    text = element_text(color = "#22211d"), 
    plot.background = element_rect(fill = "#f5f5f4", color = NA), 
    panel.background = element_rect(fill = "#f5f5f4", color = NA), 
    legend.background = element_rect(fill = "#f5f5f4", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 13, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    legend.position = c(0.3, 0.4)
  ) +
  coord_map()

# Give an id to every single point that compose the boundaries
asia_cartogram_df$id <- seq(1,nrow(asia_cartogram_df))
asia_df$id <- seq(1,nrow(asia_df))

# Bind both map info in a data frame. 3 states: map --> cartogram --> map
data <- rbind(asia_df, asia_cartogram_df, asia_df)

# Set transformation type + time
data$ease <- "cubic-in-out"
data$time <- rep(c(1:3), each=nrow(asia_df))

# Calculate the transition between these 2 objects?
dt <- tween_elements(data, time='time', group='id', ease='ease', nframes = 30)

# check a few frame
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==0) %>% arrange(order), 
               aes(fill = POP2005, x = long, y = lat, group = group), size=0, alpha=0.9
  )
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==5) %>% arrange(order), 
               aes(fill = POP2005, x = long, y = lat, group = group) , size=0, alpha=0.9
  )
ggplot() + 
  geom_polygon(data = dt %>% filter(.frame==10) %>% arrange(order), 
               aes(fill = POP2005, x = long, y = lat, group = group) , size=0, alpha=0.9
  )

# Plot
p <- ggplot() + 
  geom_polygon(data = dt  %>% arrange(order) , aes(fill = POP2005/1000000, x = long, y = lat, group = group) , size=0, alpha=0.9) +
  theme_void() +
  
  scale_fill_viridis(
    name="Population (M)", breaks=c(1,100,250,500,1000,1250), 
    guide = guide_legend( 
      keyheight = unit(3, units = "mm"), keywidth=unit(1, units = "mm"), 
      label.position = "bottom", title.position = 'top', nrow=1)
  ) +
  labs( title = "Asia", subtitle="Population per country in 2005" ) +
  ylim(-55,55) +
  
  theme(
    text = element_text(color = "#22211d"), 
    plot.background = element_rect(fill = "#f5f5f4", color = NA), 
    panel.background = element_rect(fill = "#f5f5f4", color = NA), 
    legend.background = element_rect(fill = "#f5f5f4", color = NA),
    plot.title = element_text(size= 22, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    plot.subtitle = element_text(size= 13, hjust=0.5, color = "#4e4d47", margin = margin(b = -0.1, t = 0.4, l = 2, unit = "cm")),
    legend.position = c(0.3,0.4)
  ) +
  coord_map()

p + transition_states(dt$time, transition_length = 5, state_length = 2)  # doesnt work 

gganimate(p, "Animated_Asia.gif",  title_frame = F)
