## Confirmed
confirmed_world <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Confirmed.csv", 
                            stringsAsFactors = FALSE,
                            check.names =  FALSE)
confirmed_world <- reshape2::melt(confirmed_world, id.vars = c("Province/State", "Country/Region", "Lat", "Long"), variable.name = "Date", value.name = "Confirmed")

## Death
death_world <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Deaths.csv", 
                        stringsAsFactors = FALSE,
                        check.names =  FALSE)
death_world <- reshape2::melt(death_world, id.vars = c("Province/State", "Country/Region", "Lat", "Long"), variable.name = "Date", value.name = "Death")

## Recovered
recovered_world <- read.csv("https://raw.githubusercontent.com/CSSEGISandData/COVID-19/master/csse_covid_19_data/csse_covid_19_time_series/time_series_19-covid-Recovered.csv",
                            stringsAsFactors = FALSE,
                            check.names =  FALSE)
recovered_world <- reshape2::melt(recovered_world, id.vars = c("Province/State", "Country/Region", "Lat", "Long"), variable.name = "Date", value.name = "Recovered")

world_history_data <- dplyr::left_join(confirmed_world, death_world,by = c("Province/State", "Country/Region", "Lat", "Long", "Date"))
world_history_data <- dplyr::left_join(world_history_data, recovered_world, by = c("Province/State", "Country/Region", "Lat", "Long", "Date"))
world_history_data$Date <- as.Date(as.character(world_history_data$Date), format = c("%m/%d/%y"))
colnames(world_history_data) <- make.names(colnames(world_history_data))
latest_date = max(world_history_data$Date)
world_history_data_summary <- world_history_data %>% 
  group_by(Country.Region, Date) %>% 
  filter(Date == latest_date) %>%
  summarise(Confirmed = sum(Confirmed),
            Recovered = sum(Recovered),
            Death = sum(Death)) %>%
  arrange(desc(Confirmed)) %>%
  mutate(RecoveredRate = round(Recovered/Confirmed, 3),
         DeathRate = round(Death/Confirmed, 3))
australia_history_data <- world_history_data %>% filter(Country.Region == "Australia")


####Maps

library(maps) ## careful there are some legacy maps here
world_map <- map_data("world") ## low resolution map
setdiff(world_history_data_summary$Country.Region, world_map$region)

unique(grep("US", world_map$region, value = TRUE))
unique(grep("Korea", world_map$region, value = TRUE))
unique(grep("Taiwan", world_map$region, value = TRUE))
unique(grep("UK", world_map$region, value = TRUE))
unique(grep("China", world_map$region, value = TRUE))
unique(grep("Macedonia", world_map$region, value = TRUE))
unique(grep("Gibraltar", world_map$subregion, value = TRUE))


world_map <- world_map %>% 
  mutate(region = replace(region, 
                          region == "UK",
                          "United Kingdom")) %>% 
  mutate(region = replace(region, 
                          region == "South Korea",
                          "Korea, South")) %>% 
  mutate(region = replace(region, 
                          region == "Taiwan",
                          "Taiwan*")) %>% 
  mutate(region = replace(region, 
                          region == "China",
                          "Mainland China")) %>% 
  mutate(region = replace(region, 
                          subregion == "Hong Kong",
                          "Hong Kong")) %>% 
  mutate(region = replace(region, 
                          subregion == "Macao",
                          "Macau"))  %>% 
  mutate(region = replace(region, 
                          region == "USA",
                          "US")) %>% 
  mutate(region = replace(region, 
                          region == "Macedonia",
                          "North Macedonia")) 

world_map_with_data <- merge(world_map, world_history_data_summary, 
                             by.x = "region", by.y = "Country.Region",
                             all.x = TRUE)
world_map_with_data <- world_map_with_data[order(world_map_with_data$order), ]


### Starting from next part ... I am not sure is needed
breaks <- c(0, 1, 10, 50, 100, 500, 1000, 5000, 10000, 100000)
region_col <- rev(RColorBrewer::brewer.pal(length(breaks) - 1, "Spectral"))
names(region_col) <- levels(cut(0:max(breaks), 
                                breaks = breaks,
                                include.lowest = T, right = F))
world_history_data_all <- world_history_data %>% filter(Date == latest_date)
world_map_with_data$Confirmed[is.na(world_map_with_data$Confirmed)] <- 0
world_map_with_data$Comfirmed_number <- cut(as.numeric(world_map_with_data$Confirmed),
                                            breaks,
                                            include.lowest = T, right = F)

### ggplot

world <- ggplot() +
  borders("world", colour = "gray85", fill = "gray80") +
  theme_map() 

world + 
  geom_point(aes(x = Long, y = Lat, size = Confirmed), 
             data = world_history_data_all, 
             colour = "blue",
             alpha = .5) +  
  scale_color_brewer(palette = "Spectral", direction = -1) + 
  scale_size_continuous(range=c(1,8), breaks = breaks[3:10], trans = "log") +
  labs(title = paste('COVID19'))
