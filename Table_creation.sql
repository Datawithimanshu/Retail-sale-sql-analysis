-- ============================================
-- Retail Sales Database Schema
-- Author: Himanshu Rawat
-- Description: Table structure for retail sales analysis
-- ============================================
create database online_retail;
use online_retail;

create table retail_sale(
invoice_no varchar(25),
stock_code varchar(25),
description varchar(255),
quantity int,
invoice_date datetime,
unit_price decimal(10,2),
customer_id int,
country varchar(100)
);
