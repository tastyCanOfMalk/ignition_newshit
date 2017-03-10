# ignition_newshit
### A sightly more reliable ignition program
From launcher.R:
`work.dir` must be the working directory
`save.dir` must be a folder within working directory
`prefix`   must be a folder name containing log files to analyze
 - Naming conventions for folders and log files must be followed
 - Logfile number of replicates must match

### Process 
Running launcher.R will assign above variables and launch the scripts below. After running the scripts the `ggsave()` functions is called for each graph produced and output to `save.dir`

`get_functions.R` 
- loads required packages 
- loads functions for computing key coordinates

`get_coords.R`
 - run functions on logfiles
 - store datapoints in dataframe 

`vars_graph.R`
 - variables for graphs produced

`get_graphs.R`
 - prepare boxplot dataframes
 - save boxplots locally
 - prepare facet dataframes
 - save facets locally
