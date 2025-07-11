library(ggplot2)
library(ggrepel)
library(reshape2)
library(plyr)
library(zoo)
library(grid)
library(gridExtra)
library(reshape2)
library("ggsci")
library("ggplot2")
library("gridExtra")

#######E:/1Projects/5Mogolian/3f3/1outgroupf3/400pops
setwd("C:/Users/victo/Desktop") # 这里替换成Fst矩阵
mydata<-read.table("C:/Users/victo/Desktop/10K数据集.csv",header=TRUE,sep=",", row.names = 1)
library(ggplot2)
mds=cmdscale(mydata,k=4,eig=T)
write.csv(mds$points,file="mdsFst_SNP_genotypes_Global.csv") # 这里替换为输出文件
