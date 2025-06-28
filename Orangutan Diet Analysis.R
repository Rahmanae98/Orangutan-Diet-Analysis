# Author: [Arif Rahman]
# orangutan diet analysis in R

# =======================
# Load Required Libraries
# =======================

library(readxl)
library(ggplot2)
library(dplyr)
library(tidyr)
library(vegan)
library(readr)
library(openxlsx)
library(plotly)

# =======================
# 1. Bar Plot: Food Type per Individual
# =======================

diet_data <- read_excel("your_path/.xlsx")

diet_data <- diet_data %>%
  mutate(
    Sample_ID = as.factor(Sample_ID),
    Sex = as.factor(Sex),
    Month = as.factor(Month)
  ) %>%
  mutate(across(-c(Sample_ID, Sex, Month), ~ as.numeric(.), .names = "{.col}"))

diet_long <- diet_data %>%
  pivot_longer(
    cols = -c(Sample_ID, Sex, Month),
    names_to = "Food_Type",
    values_to = "Percentage"
  ) %>%
  filter(!is.na(Percentage) & Percentage > 0)

food_order <- diet_long %>%
  group_by(Food_Type) %>%
  summarise(Total_Percentage = sum(Percentage, na.rm = TRUE)) %>%
  arrange(desc(Total_Percentage)) %>%
  pull(Food_Type)

diet_long$Food_Type <- factor(diet_long$Food_Type, levels = food_order)

color_palette_nature <- c(
  "#2D6A4F", "#1B4332", "#3B6F27", "#A7C957", "#F0A500",
  "#D9BF77", "#3A7CA5", "#1D3557", "#457B9D", "#A8DADC",
  "#9A3D3D", "#E63946", "#F1FAEE", "#F4A261", "#2A9D8F",
  "#7A4E6C", "#B1A7A6", "#C1D3D7", "#264653", "#98C4D3"
)
color_palette <- rep(color_palette_nature, length.out = length(unique(diet_long$Food_Type)))

plot_diet <- ggplot(diet_long, aes(x = Sample_ID, y = Percentage, fill = Food_Type)) +
  geom_col() +
  labs(
    title = "Overall Diet Composition per Orangutan",
    x = "Individual",
    y = "Diet Percentage (%)",
    fill = "Food Type"
  ) +
  theme_bw() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, vjust = 1),
    legend.position = "right",
    legend.text = element_text(size = 6)
  ) +
  scale_fill_manual(values = color_palette) +
  guides(fill = guide_legend(ncol = 2))

print(plot_diet)

ggsave("diet_barplot.png", plot = plot_diet, width = 10, height = 7.5, dpi = 500)

# =======================
# 2. Shannon Diversity Index
# =======================

shannon_data <- read_csv("your_path/.csv", show_col_types = FALSE)
row.names(shannon_data) <- shannon_data$Sampel_ID
shannon_matrix <- shannon_data[, -1]

shannon_matrix[] <- lapply(shannon_matrix, function(x) as.numeric(gsub(",", ".", x)))

shannon_index <- diversity(shannon_matrix, index = "shannon")
shannon_df <- data.frame(Sampel_ID = row.names(shannon_matrix), Shannon_Index = shannon_index)

write.xlsx(shannon_df, "Shannon_Index_Feeding_Orangutan.xlsx")

plot_shannon <- ggplot(shannon_df, aes(x = reorder(Sampel_ID, Shannon_Index), y = Shannon_Index)) +
  geom_bar(stat = "identity", fill = "forestgreen") +
  coord_flip() +
  labs(title = "Shannon Index per Orangutan Individual", x = "", y = "") +
  theme_minimal()

print(plot_shannon)

ggsave("shannon_index.png", plot = plot_shannon, width = 10, height = 10, dpi = 800)

# ---------------------------
# 3. Pie Chart: Food Type Proportion
# ---------------------------

pie_data <- read_excel("your_path/.xlsx", sheet = "Sheet1")

custom_colors <- c("#17becf", "#1B4332", "#3B6F27", "#A7C957", "#F0A50d", "#8c564b", "#D9BF77", "#bcbd22")

pie_chart <- ggplot(pie_data, aes(x = "", y = `Percent(%)`, fill = `Feed Type`)) +
  geom_col(width = 1) +
  coord_polar(theta = "y") +
  theme_void() +
  labs(title = "") +
  theme(legend.title = element_blank()) +
  scale_fill_manual(values = custom_colors)

print(pie_chart)

ggsave("diet_pie_chart.png", plot = pie_chart, dpi = 300, width = 8, height = 6)
