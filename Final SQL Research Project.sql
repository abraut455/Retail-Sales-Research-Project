create database Retail_Data_Analytics;
drop database Retail_Data_Analytics;
use Retail_Data_Analytics;



-- Features Table
create table Features(Store int, Date Varchar(50), Temperature double, Fuel_Price double,
Markdown1 Varchar(50),Markdown2 Varchar(50),Markdown3 Varchar(50),Markdown4 Varchar(50),Markdown5 Varchar(50),
CPI double ,Unemployment double, IsHoliday binary);
describe features;

-- Sales Table
create table Sales(Store int, Dept int, Date varchar(50), Weekly_Sales double,IsHoliday Binary);
select * from sales;

-- Stores Table
create table stores(Store int, Type text, Size Int);


select count(*)
from sales;


-- Update
set sql_safe_updates = 0;
Alter table features
add  column newdate date;
update features
set newdate = str_to_date(date,"%d-%m-%Y");

update Features
set Markdown1 = null or Markdown2 = null or Markdown3 = null or Markdown4 = null or Markdown5 = null
where Markdown1 = "NA" or Markdown2 = "NA" or Markdown3 = "NA" or Markdown4 = "NA" or Markdown5 = "NA";

-- convert field type into double type for every markdown
ALTER TABLE features
MODIFY COLUMN Markdown5 DOUBLE;

create table c as (SELECT IFNULL(Mtest, 0) AS Mtest , IFNULL(Ptest, 0) AS Ptest 
FROM students);

-- 0 to null
set sql_safe_updates =0;
Alter table features
add column Total_markdown double;
update features
set total_markdown = null
where total_markdown = 0;



-- No. of store 
select count(distinct(store)) from features;

-- total no. of date
-- features
select store, Count(distinct(Newdate)) from features group by store;
-- sales
select Count(distinct(Newdate)) from sales group by store;



-- sales Analysis
-- Yearwise sales
select  year(newdate) "Year", 
round(Avg(Weekly_Sales),2) 
"Year Wise Weekly Sales"
from sales
group by year(newdate);


create index idx_sales_Weekly_Sales 
on sales(Weekly_Sales);

-- Analysis performance of the  sales at the 
-- time of markdowns
select  monthname(s.newdate) "Month", round
(Avg(Weekly_Sales),2) "Month Wise Sales", 
round(avg(total_markdown),2) "Average Markdown"
from sales s inner join  features f on s.store 
= f.store and s.newdate = f.newdate 
group by monthname(s.newdate)
order by 3 desc;



-- Sales holiday wise 
select  if (isholiday = "T", "Holiday", 
"Not_Holiday") "Holiday_or_Not_Holiday",
 round(avg(Weekly_sales),2) Weekly_sales, 
count(distinct(newdate)) 
Number_of_Holidays_or_Not_Holidays
from sales
group by isholiday;



-- Markdowns holiday wise  
select  if (isholiday = "T", "Holiday", "
Not_Holiday") "Holiday_or_Not_Holiday",
 round(avg(Total_Markdown),2) Total_Markdown, 
count(distinct(newdate)) 
Number_of_Holidays_or_Not_Holidays
from features
group by isholiday;


-- Analysis of sales store size wise
select s.Store , round(avg(s.Weekly_sales),2) 
"Weekly Sales", st.size Size_of_Store
from sales s inner join stores st on s.store 
= st.store
group by store,st.size
order by 2 desc;



-- CPI
select  year(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales",round(avg(f.cpi),2) "CPI"
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by year(s.newdate);


-- Fuel price
select  year(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales",
round(avg(f.fuel_price),2) Fuel_price
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by year(s.newdate);



-- Sales highest in terms of markdowns
select store ,round(avg(Total_markdown),2) "markdown" from features
group by store
order by 2 desc;

-- sales lowest in terms of markdowns
select store ,round(avg(Total_markdown),2) "Total_markdown" from features
group by store
order by 2 asc;




drop table MarkdownHolidays; 

select *
from MarkdownHolidays;

create table c as (SELECT IFNULL(Mtest, 0) AS Mtest , IFNULL(Ptest, 0) AS Ptest 
FROM students);

update features
set Total_Markdown = ifnull(Markdown1,0) + ifnull(Markdown2,0) + ifnull(Markdown3,0) + ifnull(Markdown4,0) + ifnull(Markdown5,0)
where Total_Markdown is null;



-- Analysis of markdown store wise
select Store , round(avg(total_markdown),2)
"markdowns"
from features
group by store;

select *
from features;


-- Analysis of sales store size wise
select s.Store , round(avg(s.Weekly_sales),2) "Weekly Sales", st.size Size_of_Store
from sales s inner join stores st on s.store = st.store
group by store,st.size
order by 2 desc;

-- Highest weekly_sales is in store 20
select Store, round(avg(weekly_sales),2) "Weekly Sales"
from sales
group by store
order by 2 desc; 

-- Lowest weekly_sales is in store 5
select Store, round(avg(weekly_sales),2) "Weekly Sales"
from sales
group by store
order by 2 asc; 



-- Holiday wise
select *
from holiday; 

select newdate, count(distinct newdate)
from holiday
group by newdate;

select count(distinct(Newdate))
from sales;

SELECT Newdate, COUNT(DISTINCT Newdate) AS UniqueDatesCount, isholiday
FROM sales
GROUP BY isholiday,Newdate;

create table Holidays_table (SELECT IsHoliday, newdate,if(isholiday = "T","Holiday","Not Holiday") "Number_of_Holiday_or_Not_Holiday"
FROM sales
group by isholiday,newdate,Number_of_Holiday_or_Not_Holiday);

select *
from holidays_table;

SELECT IsHoliday, newdate,if(isholiday = "T","Holiday","Not Holiday") "Holiday_or_Not_Holiday"
FROM sales
group by isholiday,newdate;

select Count(*) "Number_of_Holiday_or_Not_Holiday"
from holidays_table
group by Number_of_Holiday_or_Not_Holiday;

select *
from holidays_table;

select newdate, isholiday
from sales
where newdate = "2012-02-10"
group by isholiday;

select isholiday,round(avg(Weekly_sales),2) "Weekly Sales"
from sales
group by isholiday;

select  year(newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales",count(distinct(newdate))
from sales
where isholiday = "T"
group by year(newdate);




select  year(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales", round(avg(f.temperature),2),
round(avg(f.fuel_price),2),round(avg(f.cpi),2), round(avg(f.unemployment),2),round(avg(total_markdown),2)
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by year(s.newdate);

-- month wise
select monthname(newdate) month,
round(avg(Weekly_sales),2) "Weekly Sales"
from sales
group by monthname(newdate);



--  Markdown Yearly
select round(avg(Total_Markdown),2), 
year(Newdate) "Year"
from features
where Total_Markdown is not null
group by year(Newdate);



-- Why yearwise weekly sales and Volume of Holidays
select  year(newdate) "Year", round(Avg(Weekly_Sales),2)
 "Yearly Sales",count(newdate) "Volume of Holidays"
from sales
where isholiday ="T"
group by year(newdate);



-- Temperature wise affect markdowns and weekly sales
select Temperature, round(avg(total_markdown),2),count(Temperature), Store
from features
group by temperature,  Store
order by round(avg(total_markdown),2) desc;

select  monthname(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales", 
round(avg(f.temperature),2),round(avg(total_markdown),2)
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by monthname(s.newdate);



-- temperature -8 to 102 F
create table Regionwisetemperature as (SELECT distinct(store),  round(Avg(temperature) over(partition by store),2) Average_temperature
FROM  features
order by  Average_temperature desc);

select  Case when  Average_temperature between 70 and 75.44 then "Hot"
 when  Average_temperature between 50 and 69.99 then "Moderate"
else "Cold"
end Status_of_Temperature, count(Store) Number_of_stores
from Regionwisetemperature
group by Status_of_Temperature;



-- CPI
select  f.Unemployment, avg(s.Weekly_sales) over (partition by s.store)
from features f inner join sales s on f.store = s.store and f.newdate and s.newdate and f.isholiday = 
s.isholiday;

-- Fuel Price
select f.store,  round(avg(f.fuel_price),2),round(avg(s.weekly_sales),2)
from features f inner join sales s on f.store = s.store and f.newdate and s.newdate and f.isholiday = 
s.isholiday
group by f.store
order by 3 desc;



-- Why yearwise weekly sales and Volume of Holidays
select  year(newdate) "Year", round(Avg(Weekly_Sales),2) "Yearly Sales",count(newdate) "Volume of Holidays"
from sales
where isholiday ="T"
group by year(newdate);



-- Analysed most of the parameters
select  year(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales", round(avg(f.temperature),2),
round(avg(f.fuel_price),2),round(avg(f.cpi),2), round(avg(f.unemployment),2),round(avg(total_markdown),2)
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by year(s.newdate);


select  year(newdate), round(avg(Total_markdown),2), round(Avg(Temperature),2), round(Avg(Fuel_price),2), round(Avg(cpi),2),
 round(Avg(unemployment),2)
from features
group by year(newdate);



-- CPI and Markdown
select avg(CPI), year(f.newdate), avg(weekly_sales), avg(Total_Markdown)
from features f inner join sales s on f.store = s.store and f.newdate = s.newdate
group by year(f.newdate)
order by year(f.newdate) desc;





create table fuelpriceyearwise as (select  s.store ,round(Avg(Weekly_Sales),2) Year_Wise_Weekly_Sales,
round(avg(f.fuel_price),2) Fuel_price
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by s.store
order by 3 desc);

drop table fuelpriceyearwise;

select *
from fuelpriceyearwise
where Fuel_price <= 3.24 and Year_Wise_Weekly_Sales > 18000;

select *
from fuelpriceyearwise
where Fuel_price >= 3.40 and Year_Wise_Weekly_Sales < 13000;

select  s.store ,round(Avg(Weekly_Sales),2) Year_Wise_Weekly_Sales,
round(avg(f.fuel_price),2) Fuel_price
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by s.store
order by 3 desc;



-- Unemployment
select  year(s.newdate) "Year", round(Avg(Weekly_Sales),2) "Year Wise Weekly Sales",
round(avg(f.Unemployment),2) Unemployment
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by year(s.newdate);



-- Temperature
-- sales
create table salestemperature as (select  monthname(s.newdate) "Year" , round(avg(f.temperature),2) Temperature, round(Avg(Weekly_Sales),2) 
Year_Wise_Weekly_Sales
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by monthname(s.newdate));

drop table salestemperature;

select avg(Year_Wise_Weekly_Sales)from salestemperature
where Temperature > 57;

-- Temperature and markdown
select  monthname (s.newdate) "Year",round(avg(f.temperature),2) Temperature, round(avg(f.total_markdown),2) Average_Markdown
from sales s inner join  features f on s.store = f.store and s.newdate = f.newdate 
group by monthname(s.newdate)
order by 3 desc;



-- store size
select s.Store , round(avg(s.Weekly_sales),2) "Weekly Sales", st.Size
from sales s inner join stores st on s.store = st.store
group by store,st.size
order by 2 desc;

-- stores
select type, count(Store) Number_of_Store from stores group by type;
-- size
select type, round(avg(size),2) Size from stores group by type;

-- Markdowns and size
select  st.store,round(avg(st.size),2) Average_Size
, round(avg(f.Total_Markdown) , 2) Markdown
from features f inner join stores st on st.store = 
f.store inner join sales s on s.store = f.store and 
s.newdate = f.newdate 
where Total_Markdown is not null
group by st.store
order by 2 desc;



-- dept sales
-- Table no. of departments in store store analysis

create table deptsales as (select  store,  count(distinct(dept)) Number_of_Departments, round(avg(weekly_sales)) sales
from sales
group by store
order by sales desc);

select *
from deptsales;

select *
from deptsales;

select  store,  round(avg(weekly_sales)) sales
from sales
group by store
order by 2 desc;
select store, dept from sales;
