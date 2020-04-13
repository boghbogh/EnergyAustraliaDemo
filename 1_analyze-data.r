# Databricks notebook source
# MAGIC %sql
# MAGIC create database EADemo;

# COMMAND ----------

# MAGIC %sql
# MAGIC use  EADemo;

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from iou

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from nou

# COMMAND ----------

# MAGIC %sql
# MAGIC create view AllData_View
# MAGIC as
# MAGIC SELECT * FROM iou
# MAGIC UNION
# MAGIC SELECT * FROM nOU

# COMMAND ----------

# MAGIC %sql
# MAGIC select * from AllData_View