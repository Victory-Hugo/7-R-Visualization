# 代码一
# 加载R包，没有安装请先安装  install.packages("包名") 
library(venn)         #韦恩图（venn 包，适用样本数 2-7）
library(VennDiagram) 

# 读取数据文件
venn_dat <- read.delim('/mnt/d/幽门螺旋杆菌/Script/分析结果/2-变异统计/output/venn_counts.csv',sep = ',') # 每一列是一个集合,可以是一列数字，也可以是一列字符
venn_list <- list(venn_dat[,1], venn_dat[,2],venn_dat[,3])   # 制作韦恩图搜所需要的列表文件
names(venn_list) <- colnames(venn_dat[1:3])    # 把列名赋值给列表的key值
venn_list = purrr::map(venn_list,na.omit)      # 删除列表中每个向量中的NA

#作图
# 直接用 ilabels = "counts" 自动显示每个区域的计数
venn(
  x       = venn_list,
  zcolor  = 'style',       # 预设配色
  opacity = 0.3,           # 透明度
  box     = FALSE,         # 不要外框
  ilabels = "counts",      # ★ 自动统计并显示数字 ★
  ilcs    = 1.0,           # 数字大小，可根据需要调整
  sncs    = 1.0,            # 集合名称大小
  plotsize = 15
)
#?venn
# 更多参数 ?venn查看

# 查看交集详情,并导出结果
inter <- get.venn.partitions(venn_list)
for (i in 1:nrow(inter)) inter[i,'values'] <- paste(inter[[i,'..values..']], collapse = '|')
inter <- subset(inter, select = -..values.. )
inter <- subset(inter, select = -..set.. )
write.table(inter, "result.csv", row.names = FALSE, sep = ',', quote = FALSE)

# 代码二
