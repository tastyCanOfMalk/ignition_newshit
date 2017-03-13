
# ###   LOAD PACKAGES      # ##############################################

if (require("packrat") == FALSE) install.packages("packrat")
require("packrat")

if (require("ggplot2")   == FALSE) install.packages("ggplot2")
if (require("ggthemes" ) == FALSE) install.packages("ggthemes")
if (require("gtable")    == FALSE) install.packages("gtable")
if (require("stringr")   == FALSE) install.packages("stringr")
if (require("reshape2")  == FALSE) install.packages("reshape2")
if (require("gridExtra") == FALSE) install.packages("gridExtra")
require("ggplot2")     # ggplot
require("ggthemes")    # gdocs theme
require("gtable")      # tableGrobs
require("stringr")     # remove date from filenames
require("reshape2")    # melt stuff
require("gridExtra")   # grid.arrange
# if (require("MESS")   == FALSE) install.packages("MESS")
# require("MESS")      # AUC only


# ###   DEFINE FUNCTIONS      # ##############################################

dropTime <- function(x){
  # Computes drop time  coordinates & average baseline temperature
  #   Based on a negative decrease in slope value
  #
  # Args:
  #   x: numeric vector whose droptime & baseline is to be calculated
  #
  # Returns: 
  #   list of values: drop time(x1), drop temp(y1), baseline(y-value)
  for (i in 1:length(x)){
    if (abs(x[i] - x[i + 1] > 5)){
      drop.time <- time[i]
      drop.temp <- x[i]
      baseline <- mean(x[1:i])
      A <- list(drop.time, drop.temp, baseline)
      return(A)
      break #stop loop when drop time found
    }}}

exoTime <- function(x){
  # Computes exotherm coordinates
  #   Based on a positive increase in slope, "exo.threshold",
  #     may need adjustment based on speed of exotherm reaction
  #     (slower reaction needs a lower threshold value)
  #     (too low might cause false positives near dropTime)
  #     && conditional keeps exoTime result near calculated 
  #       baseline to avoid false positives near dropTime[1]
  #   
  # Args:
  #   x: numeric vector whose exotherm time is to be calculated
  #
  # Returns: 
  #   list of values: exotherm time(x2), exotherm temp(y2)
  for (i in dropTime(x)[[1]]:length(x)){
    if (x[i+1] - x[i] > exo.threshold && x[i+15] > dropTime(x)[[3]]){
      # value must be within 15-seconds from baseline.temp
      exo.time <- time[i]
      exo.temp <- x[i]
      A <- list(exo.time, exo.temp)
      return(A)
    }
  }
  B <- list(0,0)
  return(B)
  # POTENTIALLY MODIFY
  # else take first temperature to cross baseline
  # else take first lowest derivative value
  # OR, find time when derivative crosses zero and continues over baseline without
  #  once again reaching zero
}

maxTemp <- function(x){
  # Computes maximum temperature coordinates from values between
  #   dropTime and end of dataset
  #
  # Args:
  #   x: numeric vector whose max temperature is to be calculated
  #
  # Returns: 
  #   list of values: maxTemp time(x3), maxTemp temp(y3), delta.temp
  # max(list.all[as.numeric(dropTime(list.all[,20])[1]):import.read.rows,20])
  # 
  # from <- as.numeric(dropTime(x)[[1]])
  # to <- import.read.rows
  max.temp <- max(x[as.numeric(dropTime(x)[[1]]*3):import.read.rows])
  max.time <- match(max.temp,x)/2
  delta.temp <- max.temp - dropTime(x)[[3]]
  A <- list(max.time, max.temp, delta.temp)
  return(A)    
}

exoDuration <- function(x){
  # Computes exotherm end duration coordinates
  #     create new list bracketing maxTemp(x) and length(x)
  #     find coords of smallest abs(new.x)
  #
  # Args:
  #   x: numeric vector whose exotherm duration is to be calculated
  #
  # Returns: 
  #   list of values: exo duration(x4), exo duration temp temp(y4)
  new.start <- maxTemp(x)[[1]]*2
  baseline  <- dropTime(x)[[3]]
  new.list  <- x[new.start:import.read.rows]
  abs.match <- match(min(abs(new.list-baseline)), abs(new.list-baseline))
  A <- list((abs.match + new.start)/2,new.list[abs.match])
  return(A)
}

# AUC NOT USED
# getAUC <- function(x){
#   # Compute AUC between exoTime()[1] and exoDuration[1]
#   #     
#   # Args:
#   #   x: temp vs time list data
#   #
#   # Returns:
#   #   list of auc values for each sample
#   area <- 
#     auc(time, x, 
#         from = as.numeric(exoTime(x)[1]),
#         to = as.numeric(exoDuration(x)[1]))
#   return(area)
# }