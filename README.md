# 中日美宏观经济指标对比分析

一个交互式仪表板，展示中国、美国、日本三国1960-2024年的宏观经济数据对比分析。

## 🌐 在线访问

**仪表板地址**：https://mako-kawai.github.io/china-usa-japan-economy/

## 📊 数据概览

| 指标 | 数据来源 | 时间跨度 |
|------|----------|----------|
| GDP增长率 | 世界银行 | 1961-2024 |
| 通货膨胀率 | 世界银行 | 1960-2024 |
| 失业率 | 世界银行 | 1991-2024 |

## 🎨 功能特性

- **交互式图表**：鼠标悬停查看详细数据
- **三国家对比**：中国（红色）、美国（蓝色）、日本（橙色）
- **数据分析结论**：基于数据的深度分析
- **局限性说明**：图表的局限性和警示

## 📁 项目文件

| 文件 | 说明 |
|------|------|
| `index.html` | 交互式仪表板 |
| `gdp_growth.csv` | GDP增长率数据 |
| `inflation.csv` | 通货膨胀率数据 |
| `unemployment.csv` | 失业率数据 |
| `generate_dashboard.R` | 生成脚本 |

## 🔧 技术栈

- R 4.5.3
- Plotly.js (CDN)
- 世界银行 Open Data API
- HTML5 + CSS3 + JavaScript

## 📝 数据来源

- [世界银行 Open Data](https://data.worldbank.org/)
- 数据更新日期：2024年

## ⚠️ 免责声明

本项目仅供学习和研究使用。数据来源于公开的官方统计，可能存在统计口径不一致、数据缺失等问题，解读时请注意：
- 各国统计方法存在差异
- 早期数据可信度较低
- 汇率换算可能影响跨期比较

---

*Created with R and Plotly | GitHub: https://github.com/mako-kawai/china-usa-japan-economy*