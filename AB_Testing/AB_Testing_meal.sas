/* Hypothetical A/B Testing for "Meal Deal for 2" */
data meal_deals;
  input Group $ Discounted $ Count;
datalines;
Control Yes 75 
Control No  25  
Test Yes 95  
Test No  5
;
run;

/* Running PROC FREQ to compare the purchase rates between control and test groups */
proc freq data=meal_deals;
  weight Count; /* This counts each purchase occurrence accurately during the analysis */
  tables Group*Discounted / chisq plots=freqplot; /* Requesting a Chi-Square test and a frequency plot */
  title "A/B Testing for 'Meal Deal for 2' at Control and Test Prices";
run;

/* Calculate the revenue for each group */
data revenue;
  set meal_deals;
  if Discounted = 'Yes' then do;
    if Group = 'Control' then Revenue = Count * 15.00;
    else if Group = 'Test' then Revenue = Count * 12.60;
  end;
  else Revenue = 0;
run;

/* Summarize total revenue by group and calculate KPIs */
proc sql;
  select Group, sum(Revenue) as TotalRevenue format=dollar12.2
  from revenue
  group by Group;
  select 'Revenue Change (%)' as KPI, 
         (sum(case when Group = 'Test' then Revenue else 0 end) - 
          sum(case when Group = 'Control' then Revenue else 0 end)) / 
         sum(case when Group = 'Control' then Revenue else 0 end) * 100 as Value
  from revenue
  union
  select 'Purchase Rate Change (%)' as KPI, 
         (sum(case when Group = 'Test' and Discounted = 'Yes' then Count else 0 end) / 
          sum(case when Group = 'Test' then Count else 0 end) - 
          sum(case when Group = 'Control' and Discounted = 'Yes' then Count else 0 end) / 
          sum(case when Group = 'Control' then Count else 0 end)) * 100 as Value
  from meal_deals;
quit;
