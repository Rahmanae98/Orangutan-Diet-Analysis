# Orangutan Dietary Analysis: Composition, Diversity, and Visualization using R
This repository presents a complete workflow in R to analyze dietary patterns of wild Sumatran orangutans based on observed feeding behavior. The analysis includes the composition of consumed food types, diversity measures using the Shannon Index, and visual summaries via barplots and pie charts.

## Background
Understanding the feeding ecology of orangutans is crucial for conservation planning and ecological monitoring. This project aims to quantify and visualize:
- The percentage contribution of different food items to orangutan diets
- Dietary diversity among individuals
- Overall food type proportions across all samples

## Analysis Overview
### 1. **Data Preparation**
- Reads dietary data from Excel and CSV files
- Converts categorical variables (individual name, sex, month) to factors
- Reshapes data for visual analysis
### 2. **Barplot of Food Consumption**
- Creates a stacked bar chart of food types by individual
- Visualizes percent contribution per sample
- Custom color palette for enhanced clarity
### 3. **Shannon Diversity Index**
- Calculates Shannon Index using the `vegan` package
- Compares diversity across individuals
- Saves results to Excel and plots them
### 4. **Pie Chart Visualization**
- Visualizes overall diet proportions by food category
- Built using `ggplot2` with `coord_polar`
