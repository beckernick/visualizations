suppressMessages(library(ggplot2))
suppressMessages(library(dplyr))
suppressMessages(library(leaflet))
suppressMessages(library(maps))

farmers = read.csv("/users/nickbecker/downloads/farmers_market_data.csv",
                   stringsAsFactors = FALSE)


farmers_relevant = select(farmers, FMID, MarketName, State, long = x, lat = y) %>%
  filter(!(State %in% c("Puerto Rico", "", "Virgin Islands", "Alaska", "Hawaii")),
         !is.na(long))


# visualize 100 random farmers markets
#set.seed(12)
farmers_sample = farmers_relevant[sample(nrow(farmers_relevant), 100),]

random_markets_map = leaflet(data = farmers_sample) %>% 
  addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(MarketName))


# visualize all farmers markets on the map
all_markets_map = leaflet(data = farmers_relevant) %>% 
  addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(MarketName))


# let's visualize DC farmers markets
dc_farmers = filter(farmers_relevant, State == "District of Columbia")

# Custom icon 
greenLeafIcon <- makeIcon(
  iconUrl = "http://leafletjs.com/docs/images/leaf-green.png",
  iconWidth = 38, iconHeight = 95,
  iconAnchorX = 22, iconAnchorY = 94,

  shadowUrl = "http://leafletjs.com/docs/images/leaf-shadow.png",
  shadowWidth = 50, shadowHeight = 64,
  shadowAnchorX = 4, shadowAnchorY = 62
)


dc_farmers_map = leaflet(data = dc_farmers) %>%
  addTiles() %>%
  addMarkers(~long, ~lat, popup = ~as.character(MarketName),
             icon = greenLeafIcon)






























































