/* Setting up the dataset for A/B testing on the impact of a 20% price increase on the 18" Large Cheese Pizza */
data pizza_sales;
  input Group $ Purchased $ Count;
datalines;
Regular Yes 220 
Regular No  30  
Increased Yes 217  
Increased No  33
;
run;

/* Running PROC FREQ to compare the purchase rates between regular and increased price groups */
proc freq data=pizza_sales;
  weight Count; /* This counts each purchase occurrence accurately during the analysis */
  tables Group*Purchased / chisq plots=freqplot; /* Requesting a Chi-Square test and a frequency plot */
  title "A/B Testing for 18'' Large Cheese Pizza at Regular and Increased Prices";
run;
/* The frequency plot will help visualize the difference in purchase rates */

/* Calculate the revenue for each group */
data revenue;
  set pizza_sales;
  if Purchased = 'Yes' then
    do;
      if Group = 'Regular' then do;
        Revenue = Count * 24.15;
      end;
      else if Group = 'Increase' then do;
        Revenue = Count * 27.60;
      end;
    end;
  else Revenue = 0;

run;

/* Summarize total revenue by group */
proc sql;
  select Group, sum(Revenue) as TotalRevenue format=dollar12.2
  from revenue
  group by Group;
quit;

/* Calculate KPIs */
proc sql;
  select 'Revenue Change (%)' as KPI, 
         (sum(case when Group = 'Increase' then Revenue else 0 end) - 
          sum(case when Group = 'Regular' then Revenue else 0 end)) / 
         sum(case when Group = 'Regular' then Revenue else 0 end) * 100 as Value
  from revenue
union
  select 'Purchase Rate Change (%)' as KPI, 
         (sum(case when Group = 'Increase' and Purchased = 'Yes' then Count else 0 end) / 
          sum(case when Group = 'Increase' then Count else 0 end) - 
          sum(case when Group = 'Regular' and Purchased = 'Yes' then Count else 0 end) / 
          sum(case when Group = 'Regular' then Count else 0 end)) * 100 as Value
  from pizza_sales;
quit;


