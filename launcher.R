# built in R v3.2.3
# 2017-03

# ## TO DO LIST #########################################################

# modify filename deletion thing, for when 3-digit numbers

# consider addition of measure of time to max temp,
# some ignitions are more gradual than others, would discern
# between very quickly igniting vs slow ignition
# e.g. maxTemp(y) - exoTime(y) = either a low number (fast ignite) or high number (slow ignite)

# the way coordinates are populated into df requires a reformat for plotting

# ## CONTROL VARIABLES ###################################################

work.dir <-       ("C://Users//yue.GLOBAL//Documents//R//ignition_newshit")
save.dir <- paste0("C://Users//yue.GLOBAL//Documents//R//ignition_newshit",
                   "/","/","!Output")
setwd(work.dir)

prefix            <- "2017-02-15,90"  # folder name ######################
exo.threshold     <- 5                # used in exoTime function
import.read.rows  <- 590              # lines to import
import.skip.rows  <- 15               # skip garble

source("get_functions.R")             # load functions
source("get_coords.R")                # calculate coordinates
source("vars_graph.R")
source("get_graphs.R")
grid.newpage()
grid.draw(gg.facet)                   # boxplot/facet/table

setwd(save.dir)  # change work dir to save folder, must be created

# ggsave(paste0(prefix,"-tall",".png"),    # save 'tall' graph
#        gg.tall,
#        width  = 13,
#        height = 10,
#        dpi    = 300)
# ggsave(paste0(prefix,"-wide",".png"),    # save 'wide' graph
#        gg.wide,
#        width  = 10,
#        height = 8,
#        dpi    = 300)
ggsave(paste0(prefix,"-facet",".png"),   # save 'facet' graph
       gg.facet,
       width  = 13,
       height = 10,
       dpi    = 300)

setwd(work.dir)  # revert to previous work dir
