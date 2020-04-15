-- Databricks notebook source
-- MAGIC %sql
-- MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  FROM AllData_View GROUP BY state ORDER BY state

-- COMMAND ----------

-- MAGIC %sql
-- MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  FROM AllData_View GROUP BY state ORDER BY AVG(res_rate)

-- COMMAND ----------

-- MAGIC %md
-- MAGIC <h3> Data for two states are skwing our analysis. Let's exclude those slide.  </h3> 

-- COMMAND ----------

-- MAGIC %sql
-- MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  
-- MAGIC                            FROM AllData_View  
-- MAGIC                            WHERE NOT state IN ("AK", "HI") 
-- MAGIC                            GROUP BY state 
-- MAGIC                            ORDER BY state

-- COMMAND ----------

-- MAGIC %md
-- MAGIC <h2> Owner ship per State </h2>

-- COMMAND ----------

SELECT state, ownership, utility_name, 
                         AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate 
                         FROM AllData_View 
                         GROUP BY state, ownership, utility_name  
                         ORDER BY AVG(res_rate)                     

-- COMMAND ----------

-- MAGIC %md
-- MAGIC <h2>Highest Residential Rates by Utility</h2>

-- COMMAND ----------

SELECT utility_name, state, AVG(res_rate) res_rate 
                    FROM AllData_View 
                    GROUP BY utility_name, state 
                    ORDER BY res_rate DESC 
                    LIMIT 20

-- COMMAND ----------

-- MAGIC %md
-- MAGIC <h3> States with the Most Utilities </h3>

-- COMMAND ----------

SELECT state, COUNT(DISTINCT utility_name) as utilities 
                FROM AllData_View 
                GROUP BY state 
                ORDER BY utilities DESC 
                LIMIT 10

-- COMMAND ----------

