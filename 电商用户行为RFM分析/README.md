# 电商用户RFM分层与留存分析



## 项目背景



基于英国某电商平台 2010-2011 年的真实交易数据，对用户进行 RFM 分层和留存分析，识别高价值用户与流失风险用户，为精细化运营提供数据支持。



## 数据说明



- 来源：UCI Machine Learning Repository - Online Retail II

- 时间范围：2010年12月 - 2011年12月

- 数据量：约100万条交易记录

- 字段：Invoice（订单号）、StockCode（商品编码）、Description（商品描述）、Quantity（数量）、InvoiceDate（日期）、Price（单价）、Customer ID（用户ID）、Country（国家）



## 分析目标



1. 用 RFM 模型对用户分层，识别高价值用户

2. 分析各分层用户的销售额贡献

3. 用群组留存分析（Cohort Analysis）分析用户留存率

4. 给出运营策略建议



## 分析方法



- 工具：Python（pandas、matplotlib、seaborn）、PostgreSQL、Power BI

- RFM模型：按 Recency、Frequency、Monetary 打分（1-5分）

- 用户分层：高价值用户、重点保持、重点挽留、流失边缘、一般价值

- 留存分析：按首次购买月份分组，计算后续每月留存率



## 核心发现



### 用户分层



- 高价值用户：976 人，占比 22.3%，贡献销售额 70.5%

- 重点保持：970 人，占比 22.2%，贡献销售额 13.0%

- 重点挽留：293 人，占比 6.7%，贡献销售额 5.6%

- 流失边缘：1058 人，占比 24.2%，贡献销售额 4.0%

- 一般价值：1075 人，占比 24.6%，贡献销售额 6.8%



### 留存分析



- 第 1 个月平均留存率：100.0%（首次购买月，所有用户都算在内）

- 第 2 个月平均留存率：24.1%

- 用户流失最快发生在第 1 个月到第 2 个月之间



## 优化建议



1. 高价值用户：专属维护，提升复购频次

2. 重点保持：定期互动，保持活跃度

3. 重点挽留：个性化推荐，优惠券刺激

4. 流失边缘：召回活动，唤醒沉睡用户

5. 一般价值：提升客单价，引导升级


## 文件结构



```

电商用户行为RFM分析/

├── data/

│   ├── raw/                    # 原始Excel数据

│   └── cleaned/                # 清洗后数据、RFM结果

├── notebooks/

│   ├── Data\_Acquisition\_Preprocessing.ipynb   # 数据获取与清洗

│   └── Data\_Analysis.ipynb                    # RFM与留存分析

├── sql/

│   └── Online\_Retail\_SQL\_Codes.sql            # PostgreSQL查询代码

├── powerbi/

│   └── 电商用户分析仪表板.pbix                # Power BI仪表板源文件

├── output/

│   ├── charts/                 # 可视化图表

│   ├── 曹梦涵\_电商用户RFM分层与留存分析\_portfolio.pdf

│   └── 电商用户分析仪表板.pdf

└── README.md

```


## 如何运行



1. 安装依赖：



```

pip install pandas numpy matplotlib seaborn openpyxl

```



2. 按顺序运行 `notebooks/` 里的文件：
   - `Data\_Acquisition\_Preprocessing.ipynb`（数据获取与清洗）

&#x20;  - `Data\_Analysis.ipynb`（RFM与留存分析）



3. Power BI 仪表板：打开 `powerbi/电商用户分析仪表板.pbix`



## 分析报告



完整报告见 `output/曹梦涵\_电商用户RFM分层与留存分析\_portfolio.pdf`



## 作者



曹梦涵

