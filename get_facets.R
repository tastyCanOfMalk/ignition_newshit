# ###   PRIMARY FACET GRAPH      # ###########################################

sample.means <- # all samples mean y-values
  as.data.frame(t(apply(list.all, 1,function(row){
    tapply(row, INDEX=rep(1:samples.unique, c(rep(sample.replicates, samples.unique))), mean)
  })))

colnames(sample.means) <- file.names.stripped2 # homogenize colnames
f.data <- cbind(time, sample.means)            # cbind time
f.data <- (melt(f.data, id="time"))            # melt


# ###   CALCULATED POINTS FACET      # ########################################

colnames(All.points.mean) <- file.names.stripped2  # homogenize colnames
pull.x <- c(1,3,5,7)                # x-coords only
pull.y <- c(2,4,6,8)                # y-coords only
x.1    <- All.points.mean[pull.x,]  
y.1    <- All.points.mean[pull.y,]  
x.y    <- cbind(melt(x.1)[2],       # cbind time
                melt(x.1)[1],       # x-values 
                melt(y.1)[2])       # y-values
colnames(x.y) <- c("time", "variable", "value")


# ###   PRINT FACET      # ########################################

f.graph <-
  ggplot(f.data, aes(x = time, y = value, color = variable)) +
  geom_point(alpha=.1,size=1) +
  geom_point(data=x.y,size=3,shape=1,color="black") +
  theme_gdocs()+
  scale_x_continuous(breaks = seq(0,300,60))+
  theme(legend.position="none")+
  facet_wrap(~variable)
gg.tall <- arrangeGrob(g.table.data,
                       gg.exo,
                       gg.del,
                       gg.dur,
                       fff,
                       layout_matrix = rbind(c(2,5,5),
                                             c(3,5,5),
                                             c(4,1,1)),
                       widths=c(1.4,1,1))

