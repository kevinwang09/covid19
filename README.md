# nCov app for DATA3888
Example submission by Kevin


# Instructions


The first app is as simple as it gets: visualising the cumulative confirmed cases through time. 


```
library(tidyverse)
library(shiny)
library(nCov2019)
## devtools::install_github("GuangchuangYu/nCov2019")

shiny::runGitHub(
    repo = "covid19", 
    username = "kevinwang09", 
    ref = "master", 
    subdir = "basic")
```


The second app visualise the added cases of countries. You can also examine cross-correlation of a selected country against China.

```
shiny::runGitHub(
    repo = "covid19", 
    username = "kevinwang09", 
    ref = "master")
```

