
# ###   PREPARE BOXPLOT DATAFRAMES  # ########################################

p.title   <- str_sub(file.names[1], ,10)  # pull date from filename, table title
g.names   <- str_sub(file.names,-9,-7)    # row names

g.exo.dat           <- t(All.points[10,]) # time to exo x-data
rownames(g.exo.dat) <- g.names            # assign row names  
g.exo.dat           <- melt(g.exo.dat)    # melt

g.del.dat           <- t(All.points[11,]) # delta temp x-data
rownames(g.del.dat) <- g.names            # assign row names  
g.del.dat           <- melt(g.del.dat)    # melt

g.dur.dat           <- t(All.points[12,]) # duration x-data
rownames(g.dur.dat) <- g.names            # assign row names  
g.dur.dat           <- melt(g.dur.dat)    # melt

# ###   MAKE BARPLOTS  # ##########################################

gg.exo <- 
  ggplot(g.exo.dat, aes(x = Var1, y = value, fill = Var1)) + 
  geom_boxplot(outlier.color = vars.graph[[1]], 
               shape         = vars.graph[[2]], 
               outlier.size  = vars.graph[[3]]) +
  stat_summary(fun.y = mean, 
               shape = vars.graph[[4]], 
               color = vars.graph[[5]], 
               geom  = vars.graph[[6]], 
               size  = vars.graph[[7]]) +
  geom_point(size = 1,
             color = "red") +
  ggtitle("Time to exotherm") +
  xlab("") +
  ylab("time (s)") +
  theme_gdocs() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position="none")

gg.del <- 
  ggplot(g.del.dat, aes(x = Var1, y = value, fill = Var1)) + 
  geom_boxplot(outlier.color = vars.graph[[1]], 
               shape         = vars.graph[[2]], 
               outlier.size  = vars.graph[[3]]) +
  stat_summary(fun.y = mean, 
               shape = vars.graph[[4]], 
               color = vars.graph[[5]], 
               geom  = vars.graph[[6]], 
               size  = vars.graph[[7]]) +
  geom_point(size = 1,
             color = "red") +
  ggtitle("Delta temp") +
  xlab("") +
  ylab("temperature (C)") +
  theme_gdocs() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position="none")


gg.dur <- 
  ggplot(g.dur.dat, aes(x = Var1, y = value, fill = Var1)) + 
  geom_boxplot(outlier.color = vars.graph[[1]], 
               shape         = vars.graph[[2]], 
               outlier.size  = vars.graph[[3]]) +
  stat_summary(fun.y = mean, 
               shape = vars.graph[[4]], 
               color = vars.graph[[5]], 
               geom  = vars.graph[[6]], 
               size  = vars.graph[[7]]) +
  geom_point(size = 1,
             color = "red") +
  ggtitle("Exo duration") +
  xlab("") +
  ylab("time(s)") +
  theme_gdocs() +
  theme(axis.text.x = element_text(angle = 90, hjust = 1),
        legend.position="none")

# AUC NOT IN USE
# g.auc.dat           <- t(All.points[13,]) # auc x-data
# rownames(g.auc.dat) <- g.names            # assign row names  
# g.auc.dat           <- melt(g.auc.dat)    # melt
# 
# gg.auc <- 
# ggplot(g.auc.dat, aes(x=Var1, y=value, fill=Var1)) + 
#   geom_boxplot(outlier.color="cyan", shape=4, outlier.size=3) +
#   stat_summary(fun.y=mean, shape=2, color="cyan", geom="point", size=3) +
#   geom_point(size=1,color="red") +
#   ggtitle(p.title) +
#   xlab("") +
#   ylab("AUC") +
#   theme(legend.position="none")

ss           <- tableGrob(All.points.data, 
                          theme = ttheme_minimal())  # convert themed df to grob
title        <- textGrob(p.title, 
                         gp = gpar(fontsize = 12))   # save date as title
padding      <- unit(5,"mm")                         # bottom title padding
g.table.data <- gtable_add_rows(ss, 
                                heights = grobHeight(title) + padding,
                                pos = 0)
g.table.data <- gtable_add_grob(g.table.data, title, 1, 1, 1, ncol(g.table.data))
# grid.newpage()
# grid.draw(g.table.data)     # print table

gg.tall <- arrangeGrob(g.table.data,
                       gg.exo,
                       gg.del,
                       gg.dur,
                       layout_matrix = rbind(c(2,1,1),
                                             c(3,1,1),
                                             c(4,1,1)),
                       widths=c(1.5,1,1))

gg.wide <- arrangeGrob(g.table.data, 
                       gg.exo, 
                       gg.del, 
                       gg.dur,
                       layout_matrix = rbind(c(1,1,1), 
                                             c(2,3,4)),
                       heights=c(1,2))


# ###   PREPARE FACET DATAFRAMES  # ##########################################

sample.means <- # all samples mean y-values
  as.data.frame(t(apply(list.all, 1,function(row){
    tapply(row, INDEX=rep(1:samples.unique, c(rep(sample.replicates, samples.unique))), mean)
  })))

colnames(sample.means) <- file.names.stripped2 # homogenize colnames
f.data <- cbind(time, sample.means)            # cbind time
f.data <- (melt(f.data, id="time"))            # melt


# ###   MAKE FACETS      # ########################################

colnames(All.points.mean) <- file.names.stripped2  # homogenize colnames
pull.x <- c(1,3,5,7)                # x-coords only
pull.y <- c(2,4,6,8)                # y-coords only
x.1    <- All.points.mean[pull.x,]  
y.1    <- All.points.mean[pull.y,]  
x.y    <- cbind(melt(x.1)[2],       # cbind time
                melt(x.1)[1],       # x-values 
                melt(y.1)[2])       # y-values
colnames(x.y) <- c("time", "variable", "value")

f.graph <-
  ggplot(f.data, aes(x = time, y = value, color = variable)) +
  geom_point(alpha=.1,size=1) +
  geom_point(data=x.y,size=3,shape=1,color="black") +
  theme_gdocs()+
  scale_x_continuous(breaks = seq(0,300,60))+
  theme(legend.position="none")+
  facet_wrap(~variable)

gg.facet <- arrangeGrob(g.table.data,
                       gg.exo,
                       gg.del,
                       gg.dur,
                       f.graph,
                       layout_matrix = rbind(c(2,5,5),
                                             c(3,5,5),
                                             c(4,1,1)),
                       widths=c(1.4,1,1))