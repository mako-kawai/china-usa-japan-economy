# 设置用户库路径
lib <- Sys.getenv('R_LIBS_USER')
if(lib == '') lib <- normalizePath('~/R/library', winslash='/')
.libPaths(lib)

library(plotly)
library(htmlwidgets)

# 读取数据
gdp_data <- read.csv("c:/Users/w1837/vs_git/R/gdp_growth.csv", stringsAsFactors = FALSE)
gdp_data[gdp_data == ''] <- NA
gdp_data[] <- lapply(gdp_data, function(x) as.numeric(ifelse(x == '', NA, x)))

inf_data <- read.csv("c:/Users/w1837/vs_git/R/inflation.csv", stringsAsFactors = FALSE)
inf_data[inf_data == ''] <- NA
inf_data[] <- lapply(inf_data, function(x) as.numeric(ifelse(x == '', NA, x)))

unemp_data <- read.csv("c:/Users/w1837/vs_git/R/unemployment.csv", stringsAsFactors = FALSE)
unemp_data[unemp_data == ''] <- NA
unemp_data[] <- lapply(unemp_data, function(x) as.numeric(ifelse(x == '', NA, x)))

# 生成JSON数据
gdp_json <- gdp_data[, c("年份", "中国", "美国", "日本")]
inf_json <- inf_data[, c("年份", "中国", "美国", "日本")]
unemp_json <- unemp_data[, c("年份", "中国", "美国", "日本")]

# 创建HTML页面
html <- '<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>中日美宏观经济指标对比分析</title>
  <script src="https://cdn.plot.ly/plotly-2.27.0.min.js"></script>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif; background: #F5F7FA; min-height: 100vh; padding: 20px; }
    .header { text-align: center; padding: 25px; background: linear-gradient(135deg, #1A1A2E, #16213E); color: white; border-radius: 12px; margin-bottom: 25px; max-width: 1800px; margin-left: auto; margin-right: auto; }
    .header h1 { font-size: 28px; margin-bottom: 8px; }
    .header p { font-size: 14px; color: #B0B0B0; }
    .chart-section { background: white; border-radius: 12px; padding: 25px; margin-bottom: 25px; max-width: 1800px; margin-left: auto; margin-right: auto; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .chart-title { font-size: 18px; font-weight: 600; color: #2C3E50; margin-bottom: 15px; padding-bottom: 10px; border-bottom: 2px solid #3498DB; }
    .legend-bar { display: flex; justify-content: center; gap: 30px; margin-top: 15px; }
    .legend-item { display: flex; align-items: center; gap: 8px; font-size: 14px; color: #333; }
    .legend-dot { width: 16px; height: 4px; border-radius: 2px; }
    .china { background: #E74C3C; }
    .usa { background: #3498DB; }
    .japan { background: #F39C12; }
    .analysis-section { background: white; border-radius: 12px; padding: 30px; max-width: 1800px; margin-left: auto; margin-right: auto; box-shadow: 0 2px 12px rgba(0,0,0,0.08); }
    .analysis-title { font-size: 24px; font-weight: 600; color: #1A1A2E; text-align: center; margin-bottom: 25px; padding-bottom: 15px; border-bottom: 3px solid #3498DB; }
    .analysis-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 20px; margin-bottom: 25px; }
    .analysis-card { background: #F8F9FA; border-radius: 10px; padding: 20px; border-left: 4px solid #3498DB; }
    .analysis-card h3 { font-size: 16px; color: #2C3E50; margin-bottom: 12px; padding-bottom: 8px; border-bottom: 1px solid #E0E0E0; }
    .analysis-card ul { list-style: none; padding: 0; margin: 0; }
    .analysis-card li { font-size: 13px; color: #555; line-height: 1.7; padding: 4px 0; }
    .analysis-card li:before { content: "•"; color: #3498DB; font-weight: bold; margin-right: 8px; }
    .highlight-card { background: #FFF9E6; border-left-color: #F39C12; }
    .summary-card { background: linear-gradient(135deg, #667eea, #764ba2); border-radius: 10px; padding: 25px; color: white; }
    .summary-card h3 { font-size: 18px; margin-bottom: 12px; }
    .summary-card p { font-size: 14px; line-height: 1.8; }
    .summary-card b { color: #FFD700; }
  </style>
</head>
<body>
  <div class="header">
    <h1>中日美宏观经济指标对比分析</h1>
    <p>数据来源：世界银行 (1960-2024) | 交互图表 - 鼠标悬停查看详细数据</p>
  </div>

  <div class="chart-section">
    <div class="chart-title">GDP增长率折线图 (1961-2024)</div>
    <div id="gdp-chart"></div>
    <div class="legend-bar">
      <div class="legend-item"><span class="legend-dot china"></span>中国</div>
      <div class="legend-item"><span class="legend-dot usa"></span>美国</div>
      <div class="legend-item"><span class="legend-dot japan"></span>日本</div>
    </div>
  </div>

  <div class="chart-section">
    <div class="chart-title">通货膨胀率面积图 (1960-2024)</div>
    <div id="inflation-chart"></div>
    <div class="legend-bar">
      <div class="legend-item"><span class="legend-dot china"></span>中国</div>
      <div class="legend-item"><span class="legend-dot usa"></span>美国</div>
      <div class="legend-item"><span class="legend-dot japan"></span>日本</div>
    </div>
  </div>

  <div class="chart-section">
    <div class="chart-title">失业率折线图 (1991-2024)</div>
    <div id="unemployment-chart"></div>
    <div class="legend-bar">
      <div class="legend-item"><span class="legend-dot china"></span>中国</div>
      <div class="legend-item"><span class="legend-dot usa"></span>美国</div>
      <div class="legend-item"><span class="legend-dot japan"></span>日本</div>
    </div>
  </div>

  <div class="analysis-section">
    <h2 class="analysis-title">数据分析结论</h2>

    <div class="analysis-grid">
      <div class="analysis-card">
        <h3>GDP增长率</h3>
        <ul>
          <li><b>中国</b>：平均增长率最高(7.92%)，但波动最大(-27.27%至19.3%)</li>
          <li><b>美国</b>：平均3.02%，增长相对稳定，2009年金融危机跌幅最大(-2.58%)</li>
          <li><b>日本</b>：平均3.32%，2010年后增速明显放缓，2020年跌幅最大(-4.17%)</li>
          <li><b>结论</b>：中国经济增速领先，但稳定性较差；发达国家增长平稳</li>
        </ul>
      </div>

      <div class="analysis-card">
        <h3>通货膨胀率</h3>
        <ul>
          <li><b>中国</b>：平均4.53%，1994年峰值达24.26%(高通胀时期)，近年回落至1%左右</li>
          <li><b>美国</b>：平均3.76%，1980年峰值13.55%(滞胀期)，2022年再次升至8%</li>
          <li><b>日本</b>：平均2.93%，长期维持低通胀，2020-2024年出现通缩迹象</li>
          <li><b>结论</b>：日本面临通缩风险；中美通胀波动较大；美国2022年通胀严重</li>
        </ul>
      </div>

      <div class="analysis-card">
        <h3>失业率</h3>
        <ul>
          <li><b>中国</b>：平均4.07%，失业率相对稳定，波动在2.37%-5%之间</li>
          <li><b>美国</b>：平均5.72%，2010年金融危机后最高达9.63%，2023年最低3.64%</li>
          <li><b>日本</b>：平均3.65%，长期维持低失业率，2020年疫情冲击最小(2.81%)</li>
          <li><b>结论</b>：日本失业率最低且最稳定；美国受经济周期影响最大</li>
        </ul>
      </div>

      <div class="analysis-card highlight-card">
        <h3>2020年疫情冲击对比</h3>
        <ul>
          <li><b>GDP冲击</b>：中国(+2.34%) > 美国(-2.16%) > 日本(-4.17%)</li>
          <li><b>失业率</b>：中国(5.0%) &lt; 日本(2.81%) &lt; 美国(8.05%)</li>
          <li><b>结论</b>：中国GDP正增长但失业率上升；美国GDP降幅大、失业率飙升最严重；日本GDP降幅最大但失业率控制最好</li>
        </ul>
      </div>
    </div>

    <div class="summary-card">
      <h3>总体结论</h3>
      <p>从1961-2024年的数据分析来看，<b>中国</b>以平均7.92%的GDP增长率领先全球，但经济波动较大，通胀控制面临挑战；<b>美国</b>经济最为成熟，通胀率和失业率波动与经济周期高度相关；<b>日本</b>长期面临通缩压力，经济增长乏力，但就业市场最为稳定。三国在全球经济中各具特色：中国增长快但不稳定，美国成熟稳健，日本稳定但增长停滞。</p>
    </div>
  </div>

<script>
'

# GDP数据
gdp_js <- paste0('var gdpData = ', jsonlite::toJSON(gdp_json), ';')
inf_js <- paste0('var infData = ', jsonlite::toJSON(inf_json), ';')
unemp_js <- paste0('var unempData = ', jsonlite::toJSON(unemp_json), ';')

# JS代码
js <- '
function createTrace(data, yCol, color, fillColor) {
  return {
    x: data.map(function(d) { return d.年份; }),
    y: data.map(function(d) { return d[yCol]; }),
    type: "scatter",
    mode: "lines",
    name: yCol === "中国" ? "中国" : (yCol === "美国" ? "美国" : "日本"),
    line: { color: color, width: 2.5 },
    fill: fillColor ? "tozeroy" : undefined,
    fillcolor: fillColor,
    hoverinfo: "text",
    text: data.map(function(d) {
      return "年份: " + d.年份 + "<br>中国: " + d.中国 + "%<br>美国: " + d.美国 + "%<br>日本: " + d.日本 + "%";
    })
  };
}

var gdpTraces = [
  createTrace(gdpData, "中国", "#E74C3C"),
  createTrace(gdpData, "美国", "#3498DB"),
  createTrace(gdpData, "日本", "#F39C12")
];

var infTraces = [
  createTrace(infData, "中国", "#E74C3C", "rgba(231,76,60,0.3)"),
  createTrace(infData, "美国", "#3498DB", "rgba(52,152,219,0.3)"),
  createTrace(infData, "日本", "#F39C12", "rgba(243,156,18,0.3)")
];

var unempTraces = [
  createTrace(unempData, "中国", "#E74C3C"),
  createTrace(unempData, "美国", "#3498DB"),
  createTrace(unempData, "日本", "#F39C12")
];

var layout = {
  xaxis: { title: "", gridcolor: "#E8E8E8", showgrid: true, tickfont: { size: 12 } },
  yaxis: { title: "", gridcolor: "#E8E8E8", showgrid: true, zeroline: true, zerolinecolor: "#CCC", tickfont: { size: 12 } },
  paper_bgcolor: "#FFFFFF",
  plot_bgcolor: "#FAFAFA",
  margin: { l: 70, r: 40, t: 30, b: 50 },
  height: 400
};

Plotly.newPlot("gdp-chart", gdpTraces, { ...layout, xaxis: { ...layout.xaxis, range: [1960, 2025] }, yaxis: { ...layout.yaxis, title: "GDP增长率 (%)" } }, { responsive: true });
Plotly.newPlot("inflation-chart", infTraces, { ...layout, xaxis: { ...layout.xaxis, range: [1960, 2025] }, yaxis: { ...layout.yaxis, title: "通胀率 (%)" } }, { responsive: true });
Plotly.newPlot("unemployment-chart", unempTraces, { ...layout, xaxis: { ...layout.xaxis, range: [1990, 2025] }, yaxis: { ...layout.yaxis, title: "失业率 (%)" } }, { responsive: true });
</script>

</body>
</html>
'

# 组合
full_html <- paste0(html, gdp_js, '\n', inf_js, '\n', unemp_js, '\n', js)

# 保存
writeLines(full_html, "c:/Users/w1837/vs_git/R/china_usa_japan_economy.html", useBytes = FALSE)
cat("仪表板已生成: china_usa_japan_economy.html\n")