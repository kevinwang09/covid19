library(tidyverse)
library(forecast)
library(nCov2019)
library(ggrepel)

all_data = load_nCov2019(lang = 'en', source='github')

theme_set(theme_bw(18) +
            theme(legend.position = "bottom"))