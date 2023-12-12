/* More comprehensive dataset for price elasticity analysis of Mario's Pizza */
data pizza_sales;
  input Product $ Price QuantitySold;
datalines;
CheesePizza 22.00 750
CheesePizza 23.00 700
CheesePizza 24.15 650
CheesePizza 25.00 600
MealDeal2 14.00 230
MealDeal2 15.00 220
MealDeal2 15.75 210
MealDeal2 16.50 200
PepperoniPizza 24.00 700
PepperoniPizza 25.00 680
PepperoniPizza 26.00 650
VeggiePizza 20.00 300
VeggiePizza 21.00 280
VeggiePizza 22.00 250
MargheritaPizza 19.00 350
MargheritaPizza 20.00 330
MargheritaPizza 21.00 310
SangriaBottle 10.00 150
SangriaBottle 10.50 145
SangriaBottle 11.00 140
;

/* Running PROC REG to estimate price elasticity */
proc reg data=pizza_sales;
  model QuantitySold = Price;
  id Product;
run;

/* Log-Log model for direct elasticity estimation */
data pizza_log;
  set pizza_sales;
  Price_Log = log(Price);
  QuantitySold_Log = log(QuantitySold);
run;

proc reg data=pizza_log;
  model QuantitySold_Log = Price_Log;
  id Product;
run;
