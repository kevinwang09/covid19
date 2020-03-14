# nCov app for DATA3888
Example submission by Kevin


# Instructions

To run the app:

```
library(tidyverse)
library(shiny)
library(nCov2019)
## devtools::install_github("GuangchuangYu/nCov2019")

shiny::runGitHub(
    repo = "covid19", 
    username = "kevinwang09", 
    ref = "master")
```