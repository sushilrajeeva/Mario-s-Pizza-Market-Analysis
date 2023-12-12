/* Reading the actual revenue data for Mario's Pizza from CSV */
proc import datafile='/home/u63671694/Mario Pizza/marios_pizza_revenues.csv' 
    out=work.marios_monthly_revenue
    dbms=csv 
    replace;
    getnames=yes;
run;

/* Check the imported data */
proc print data=work.marios_monthly_revenue;
run;

/* Visualize historical data */
proc sgplot data=work.marios_monthly_revenue;
    series x='Year-Month'n y=Revenue / markers;
    xaxis label='Year-Month';
    yaxis label='Revenue';
    title 'Historical Monthly Revenue Data';
run;


/* Time Series Forecasting with ARIMA */
proc arima data=work.marios_monthly_revenue;
    identify var=Revenue;
    estimate p=1 q=1;
    forecast lead=12 id=date interval=month out=forecast; /* Forecasting 1 year ahead */
run;

/* Visualizing the forecasted data */
proc sgplot data=forecast;
    series x=date y=Revenue / markers lineattrs=(pattern=solid color=blue);
    series x=date y=fore / markers lineattrs=(pattern=dashed color=red);
    xaxis label='Year-Month'; /* Change the label to 'Year-Month' for consistency */
    yaxis label='Revenue';
    title 'ARIMA Forecasted Monthly Revenue Data';
run;
