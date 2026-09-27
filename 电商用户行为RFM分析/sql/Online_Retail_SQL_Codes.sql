-- 先创建表
CREATE TABLE retail_transactions (
    Invoice VARCHAR(20),
    StockCode VARCHAR(20),
    Description TEXT,
    Quantity INTEGER,
    InvoiceDate TIMESTAMP,
    Price DECIMAL(10,2),
    CustomerID INTEGER,
    Country VARCHAR(50),
	is_cancel VARCHAR(20),
    TotalAmount DECIMAL(10,2)
);

-- 导入 CSV（注意：路径要用双反斜杠或正斜杠）
COPY retail_transactions(Invoice,StockCode, Description, Quantity, 
                         InvoiceDate, Price, CustomerID,Country,is_cancel,TotalAmount)
FROM 'D:\DataAnalysis\Project1\online+retail+ii/online_retail_cleaned.csv'
DELIMITER ','
CSV HEADER;

--使用COPY命令要注意，创建的表的列的列名和列数量要和.CSV表的列名、列数一样！

-- 计算每个用户的 RFM 指标，RFM:Recency（最近购买时间）、Frequency（购买频率）、Monetary（总金额）。
WITH customer_rfm AS (
    SELECT 
        CustomerID,
        MAX(InvoiceDate) AS recency,
        COUNT(DISTINCT Invoice) AS frequency,
        SUM(TotalAmount) AS monetary,
        -- 计算最近购买距离今天的天数（假设以2011年12月31日为基准）
        DATE_PART('day', '2011-12-31'::TIMESTAMP - MAX(InvoiceDate)::TIMESTAMP) AS recencytonowadays
    FROM retail_transactions
    GROUP BY CustomerID
)
SELECT * FROM customer_rfm
ORDER BY monetary DESC
LIMIT 100;

--月销售趋势，按月统计销售额，可以用DATE_TRUNC函数
SELECT 
    DATE_TRUNC('month', InvoiceDate) AS month,
    COUNT(DISTINCT Invoice) AS order_count,
    SUM(TotalAmount) AS total_sales,
    AVG(TotalAmount) AS avg_order_value
FROM retail_transactions
GROUP BY DATE_TRUNC('month', InvoiceDate)
ORDER BY month;

--TOP10商品（按销售额）
SELECT 
    StockCode,
    Description,
    SUM(Quantity) AS total_quantity_sold,
    SUM(TotalAmount) AS total_revenue
FROM retail_transactions
GROUP BY StockCode, Description
ORDER BY total_revenue DESC
LIMIT 10;

/* 
退货情况分析，如果保留了退货数据，分析每个用户的退货金额占比
SELECT 
    CustomerID,
    SUM(CASE WHEN is_cancel = 'ture' THEN TotalAmount ELSE 0 END) AS return_amount,
    SUM(TotalAmount) AS total_amount,
    ROUND(100.0 * SUM(CASE WHEN is_cancel = 'ture' THEN TotalAmount ELSE 0 END) / NULLIF(SUM(TotalAmount), 0), 2) AS return_rate_pct
FROM retail_transactions
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 0
ORDER BY return_rate_pct DESC;
我已经把退货的记录删除了，所以无法分析退货情况。
*/

-- 统计每个用户的购买次数，再统计每个次数区间有多少用户
WITH user_frequency AS (
    SELECT 
        CustomerID,
        COUNT(DISTINCT Invoice) AS purchase_count
    FROM retail_transactions
    GROUP BY CustomerID
)
SELECT 
    CASE 
        WHEN purchase_count = 1 THEN '1次'
        WHEN purchase_count BETWEEN 2 AND 5 THEN '2-5次'
        WHEN purchase_count BETWEEN 6 AND 10 THEN '6-10次'
        ELSE '10次以上'
    END AS frequency_group,
    COUNT(CustomerID) AS user_count
FROM user_frequency
GROUP BY 
    CASE 
        WHEN purchase_count = 1 THEN '1次'
        WHEN purchase_count BETWEEN 2 AND 5 THEN '2-5次'
        WHEN purchase_count BETWEEN 6 AND 10 THEN '6-10次'
        ELSE '10次以上'
    END
ORDER BY MIN(purchase_count);

-- 创建视图
CREATE VIEW vw_rfm_analysis AS
WITH customer_rfm AS (
    SELECT 
        CustomerID,
        DATE_PART('day', '2011-12-31'::TIMESTAMP - MAX(InvoiceDate)::TIMESTAMP) AS recencytonowadays,
        COUNT(DISTINCT Invoice) AS frequency,
        SUM(TotalAmount) AS monetary
    FROM retail_transactions
    GROUP BY CustomerID
)
SELECT * FROM customer_rfm;

SELECT * FROM vw_rfm_analysis;

-- 之后直接用这个视图
SELECT * FROM vw_rfm_analysis WHERE monetary > 10000;

--验证是否导入成功
-- 1. 查看总行数
SELECT COUNT(*) FROM retail_transactions;

-- 2. 查看前10行
SELECT * FROM retail_transactions LIMIT 10;

-- 3. 查看日期范围
SELECT MIN(InvoiceDate), MAX(InvoiceDate) FROM retail_transactions;

-- 4. 查看有多少个唯一用户
SELECT COUNT(DISTINCT CustomerID) FROM retail_transactions;