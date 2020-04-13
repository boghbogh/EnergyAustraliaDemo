-- Databricks notebook source
create database EADemo;

-- COMMAND ----------

use EADemo;

-- COMMAND ----------

select * from iou;

-- COMMAND ----------

select * from nou;

-- COMMAND ----------

create view AllData_View
as
SELECT * FROM iou
UNION
SELECT * FROM nOU

-- COMMAND ----------

select * from AllData_View