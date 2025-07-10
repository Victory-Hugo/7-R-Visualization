library(ggtree)
library(treeio)
library(ape)
library(tidyverse)
library(ggtreeExtra)
library(ggnewscale)
library(ggsci)
# 设置工作目录
setwd("/mnt/d/幽门螺旋杆菌/Script/分析结果/5-ggtree")
# 加载系统发生树文件(WGS)
WGS_tree <- read.tree("./data/WGS.aln.snp-sites.rooted.tree")



##* 分支着色
# 文件路径可按需修改
group_file <- "./conf/group.txt"
color_file <- "./conf/color.txt"

# 读取分组信息
group_df <- read.table(group_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE, col.names = c("label", "group"))
group_list <- split(group_df$label, group_df$group) # 将分组信息转换为列表

# 读取颜色信息
color_df <- read.table(color_file, header = FALSE, sep = "\t", stringsAsFactors = FALSE, comment.char = '', col.names = c("group", "color"))
group_colors <- setNames(color_df$color, color_df$group) # 将颜色信息转换为命名向量

# 读取树并分组
tree_grouped <- groupOTU(WGS_tree, group_list)

# 绘制系统发育树
p0 <- ggtree(tree_grouped, aes(color = group), layout = 'fan',open.angle = 5, lwd = 0.15) +
  scale_color_manual(values = group_colors)

##* 使用ggtreeExtra美化
# 首先读取meta信息文件
meta_file <- "./conf/HP数据收集2.xlsx"
df_META <- readxl::read_excel(meta_file, sheet = 'HP数据收集')

p0 +  
new_scale_fill() +
    geom_fruit(
    data = filter(df_META,Species != 'H. pylori'),
    geom = geom_point,
    mapping = aes(y = ID ,color =group, shape = Species),
    position = "identity" #!重要参数，保证了位置恰好在树的分支末端
    ) +  
new_scale_fill() +
    geom_fruit(
    data = filter(df_META,Ecotype != 'Ubiquitous'),
    geom = geom_point,
    mapping = aes(y = ID ,color =group, shape = Ecotype),
    position = "identity" #!重要参数，保证了位置恰好在树的分支末端
    ) +  
new_scale_fill() +
    geom_fruit(
    data = filter(df_META),
    geom = geom_tile,
    mapping = aes(y = ID ,fill = Continent),
    width = 0.01,
    offset = -0.02
    ) + scale_fill_brewer(palette = "Set3") +  # Nature期刊配色 
new_scale_fill() +
    geom_fruit(
    data = filter(df_META),
    geom = geom_tile,
    mapping = aes(y = ID ,fill =Elevation),
    width = 0.01,
    offset = 0.03
    )+ scale_fill_gradient(low = "#FAC1C8", high = "#740808") +
new_scale_fill() +
    geom_fruit(
    data = filter(df_META),
    geom = geom_tile,
    mapping = aes(y = ID ,fill =Latitude),
    width = 0.01,
    offset = 0.03
    )+  scale_fill_gradient(low = "#B3F0E7", high = "#083F38") +
new_scale_fill() +
    geom_fruit(
    data = filter(df_META),
    geom = geom_tile,
    mapping = aes(y = ID ,fill =Longitude),
    width = 0.01,
    offset = 0.03
    ) + scale_fill_gradient(low = "#C5E1F7", high = "#041734") -> p2
ggsave(p2,filename = './output/WGS.aln.snp-sites.rooted.tree.fan.pdf')
