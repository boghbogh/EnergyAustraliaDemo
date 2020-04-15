# Databricks notebook source
# MAGIC %fs ls /

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  FROM AllData_View GROUP BY state ORDER BY state

# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  FROM AllData_View GROUP BY state ORDER BY state

# COMMAND ----------



# COMMAND ----------

# MAGIC %sql
# MAGIC SELECT state, AVG(comm_rate) as comm_rate, AVG(ind_rate) as ind_rate, AVG(res_rate) as res_rate  
# MAGIC                            FROM AllData_View  
# MAGIC                            WHERE NOT state IN ("AK", "HI") 
# MAGIC                            GROUP BY state 
# MAGIC                            ORDER BY state

# COMMAND ----------

