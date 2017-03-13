
# ###   IMPORT      # #######################################################

prefix.path <- paste(getwd(), prefix, sep = "/")
file.names  <- dir(prefix.path)
all.files   <- paste(prefix.path, file.names, sep = "/")
df.all      <- as.data.frame(lapply(all.files, 
                                    function(x) read.csv(x, 
                                                         sep   = '\t', 
                                                         skip  = import.skip.rows,
                                                         nrows = import.read.rows)))
file.names.stripped  <- str_sub(file.names, -9, -5)         # simplify names eg A-1
file.names.stripped2 <- unique(str_sub(file.names, -9, -7)) # simplify colnames eg A
sample.replicates    <- length(file.names.stripped) / 
                               length(file.names.stripped2) # calc replicates
samples.all          <- length(file.names)                  # total samples including replicates
samples.unique       <- length(file.names) /            
                               sample.replicates            # total unique samples

list.all <- vector("list", samples.all) # preallocate list

for(i in 1:samples.all){                       # pull every 4th column from csv
  if(i==1){
    list.all <- cbind(df.all[[4*i]])           # create first col
  }
  else{
    list.all <- cbind(list.all, df.all[[4*i]]) # add remaining cols
  }}

colnames(list.all) <- file.names.stripped            # name columns
total.seconds <- length(df.all[,1]) / 2              # calculate seconds
time          <- seq.int(0, total.seconds - .5, 0.5) # match to df length
list.all      <- list.all * 1000                     # convert from 1/1000 F

# ###   CALCULATIONS   # ####################################################
# create coordinate list of all samples
# total of 4 coordinates + baseline temperature per sample

A <- vector("list",3) # create empty lists
B <- vector("list",2)
C <- vector("list",2)
D <- vector("list",2)
E <- vector("list",1)
F <- vector("list",1)
G <- vector("list",1)

for(i in 1:samples.all){
  A[[i]] <- dropTime   (list.all[,i]) # (x1, y1, baseline)
  B[[i]] <- exoTime    (list.all[,i]) # (x2, y2)
  C[[i]] <- maxTemp    (list.all[,i]) # (x3, y3, delta)
  D[[i]] <- exoDuration(list.all[,i]) # (x4, y4)
  E[[i]] <- B[[i]][[1]] - A[[i]][[1]] # (timeToEXo)   exoTime-dropTime
  F[[i]] <- D[[i]][[1]] - B[[i]][[1]] # (exoDuration) exoDur-exoTime
  # G[[i]] <- getAUC     (list.all[,i]) # calc AUC
}

AA <- data.frame(matrix(unlist(A),nrow=3))
BB <- data.frame(matrix(unlist(B),nrow=2))
CC <- data.frame(matrix(unlist(C),nrow=3))
DD <- data.frame(matrix(unlist(D),nrow=2))
EE <- data.frame(matrix(unlist(E),nrow=1))
FF <- data.frame(matrix(unlist(F),nrow=1))
# GG <- data.frame(matrix(unlist(G),nrow=1))

All.points <- rbind(AA[1:2,],BB,CC[1:2,],DD,AA[3,],EE,CC[3,],FF)
                    # ,GG)

colnames(All.points) <- file.names.stripped 
rownames(All.points) <-  c("dropTime.x",   #a 1
                           "dropTime.y",   #a 2
                           "exoTime.x",    #b 3
                           "exoTime.y",    #b 4
                           "maxTemp.x",    #c 5
                           "maxTemp.y",    #c 6
                           "exo.dur.x",    #d 7
                           "exo.dur.y",    #d 8
                           "baseline.avg", #a 9
                           "time.to.exo",  #e 10
                           "delta.temp",   #c 11
                           "exo.duration"  #f 12
                           # "auc"           #g 13
)

All.points.mean <- as.data.frame(                # mean of unique column groups
  t(apply(All.points, 1, function(row){
    tapply(row, INDEX=rep(1:samples.unique,
                          c(rep(sample.replicates, samples.unique))), mean)
  })))

All.points.stdev <- as.data.frame(               # sd of unique column groups
  t(apply(All.points, 1, function(row){
    tapply(row, INDEX=rep(1:samples.unique,
                          c(rep(sample.replicates, samples.unique))), sd)
  })))

All.points.data <- as.data.frame(rbind(All.points.mean[10,], All.points.stdev[10,],
                                       All.points.mean[11,], All.points.stdev[11,], 
                                       All.points.mean[12,], All.points.stdev[12,]
                                       # All.points.mean[13,], All.points.stdev[13,] #AUC not used
                                       ))

colnames(All.points.data) <- file.names.stripped2
rownames(All.points.data) <- c("time to exo  (avg)",
                               " time to exo  (sd)",
                               "delta temp   (avg)",
                               " delta temp   (sd)",
                               "exo duration (avg)",
                               " exo duration (sd)"
                               # 
                               # "auc (avg)",          # AUC not used
                               # "auc (sd)"            # AUC not used
                               )

All.points.data <- round(All.points.data,0)