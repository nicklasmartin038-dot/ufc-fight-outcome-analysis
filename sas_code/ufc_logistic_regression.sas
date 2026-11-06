/*

UFC Analysis Project for coaches

Quinn Ertz, Nick Martin, Dillon Foster

*/



/* Define the location of the cleaned UFC dataset */

/* Update this path to match your SAS environment */

%let data_path = /path/to/ufc-fight-outcome-analysis/data/ufc_fights_cleaned.csv;



/* Import the dataset */

proc import

    datafile = "&data_path"

    out = ufc

    dbms = csv

    replace;

    guessingrows = max;

run;



/*

Verifying variable names and confirming

categorical and numeric variables

*/

proc contents data = ufc;



/*

We are only keeping variables that we are interested in using for our analysis



fighter1_Stance is our categorical explanatory variable, the remaining

variables are our numeric differential variables.



each differential variable was calculated like this:



fighter 1 value - fighter 2 value



How to interpret the resulting variables: 

if the variable is positive = fighter 1 has the higher variable

if the variable is negative = fghter 2 has the higher value,

and obviously if it 0 the fighters have the same value.

*/



data dropped;

set ufc;

rename Significant_Strikes_Landed_Per_M = Sig_Strikes_PM_Diff;

keep fight_outcome fighter1_Stance Reach_Diff Significant_Strikes_landed_Per_M Strike_Accuracy_Diff Strikes_Absorbed_Per_Minute_Diff Striking_Defense_Diff Takedown_Average_Diff Takedown_Accuracy_Diff Takedown_Defence_Diff Submission_Average_Diff Height_Diff Age_Diff;

run;





/* Verify outcome categories before assigning binary values */
proc freq data=ufc;
    tables fight_outcome / missing;
run;

data clean;

set dropped;

if fight_outcome in ("fighter1") then fight_outcome_clean = 1;

else fight_outcome_clean = 0;

drop fight_outcome;

run;



/*

Verifying that the cleaned variables are correct

*/



proc contents data =clean;

run;



proc freq data = clean;

tables fight_outcome_clean;

run;

/*

now inspecting our categorical variable (fighter1_Stance)

*/

proc freq data = clean;

tables fighter1_Stance;

run;





/*

Model specification time!:



Let Yi be the random variable corresponding to whether fighter 1

won fight i.



Yi = 1 if fighter 1 won fight i

Yi = 0 if fighter 2 won fight i



Let pi_i represent the probability that fighter 1 wins fight i.



The numeric explanatory variables are the calculated differential variables



Reach_Diff = difference in reach

Sig_Strikes_PM_Diff = difference in significant strikes landed per minute

Strike_Accuracy_Diff = difference in striking accuracy

Strikes_Absorbed_Per_Minute_Diff = difference in strikes absorbed per minute

Striking_Defense_Diff = difference in striking defense

Takedown_Average_Diff = difference in takedown average 

Takedown_Accuracy_Diff = difference in takedown accuracy 

Takedown_Defence_Diff = difference in takedown defense 

Submission_Average_Diff = difference in submission average 

Height_Diff = difference in height 

Age_Diff = difference in age



fighter1_Stance is a categorical explanatory variable with four levels:

Open stance, orthodox, Southpaw, and Switch. SAS selcted switch as the baseline level.



Random Component:

Yi ~ Bernoulli (pi_i)



Systematic component: 

link function:

n_i = log (pi_i / (1 - pi_i))



Explanation: The link function links the linear predictor (the explanatory variables

and coefficients) to the parameter of interest, pi_i.



In our data, pi_i represents the probability that fighter 1 wins fight i

*/



/*

Why OLR is not appropriate:



Y only takes on values of 0 and 1. That doesn't work with the normal distribution, which is 

continuous and symmetric.



Since Y is Bernoulli, its mean and variance are related. 



OLR uses an identity link function. There is nothing stopping estimated probabilities being greater than 1 

or less than 0.



Why Logistic regression is appropriate: 

fight_outcome_clean only takes on the values 0 and 1. Thus our response variable

has a Bernoulli distribution. Due to this, we will use a Bernoulli random component

with a logit link function(linking the linear predictor to the probability that Fighter 1 wins,

which ensure that the predicted probability remains between 0 and 1), resulting in logistic regression.

*/ 



/*

We will now test for complete separation:



Complete separation can occur in logistic regression

when an explanatory variable perfectly predicts the binary response.



To explain what I will be doing now to my explanatory variables:



For a categorical variable, I will be making a table between X and Y 

looking for empty cells 



For a numeric variable, I will be making scatterplots between X and y and looking

for separation.



After making the model, I will check for unusually large standard errors.



*/



/*

Checking fighter1_Stance for complete separation

*/

proc freq data = clean;

tables fighter1_Stance*fight_outcome_clean;

run;

/*no empty cells for stance, no complete seperation*/



/*

Checking Reach_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Reach_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Sig_Strikes_PM_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Sig_Strikes_PM_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Strike_Accuracy_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Strike_Accuracy_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Strikes_Absorbed_Per_Minute_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Strikes_Absorbed_Per_Minute_Diff

y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Striking_Defense_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Striking_Defense_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Takedown_Average_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Takedown_Average_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Takedown_Accuracy_Diff for complete separation

*/



proc sgplot data = clean;

scatter x = Takedown_Accuracy_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Takedown_Defence_Diff for complete seperation

*/



proc sgplot data = clean;

scatter x = Takedown_Defence_Diff y = fight_outcome_clean;

run;



/*

both Y outcomes observed, no complete seperation

*/



/*

Checking Submission_Average_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Submission_Average_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Checking Hight_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Height_Diff y = fight_outcome_clean;

run;



/*

both Y outcomes observed, no complete separation

*/



/*

checking Age_Diff for complete separation

*/

proc sgplot data = clean;

scatter x = Age_Diff y = fight_outcome_clean;

run;

/*

both Y outcomes observed, no complete separation

*/



/*

Model Fitting

*/

proc logistic data = clean;

class fighter1_Stance / param = reference;

model fight_outcome_clean(event = '1') =
    fighter1_Stance
    Reach_Diff
    Sig_Strikes_PM_Diff
    Strike_Accuracy_Diff
    Strikes_Absorbed_Per_Minute_Diff
    Striking_Defense_Diff
    Takedown_Average_Diff
    Takedown_Accuracy_Diff
    Takedown_Defence_Diff
    Submission_Average_Diff
    Height_Diff
    Age_Diff
    / clparm = both;

output out = diags predicted = pred xbeta = linpred;

run;



/* After confirming with the regression output, the coefficient standard errors 

were also not unusually large.



combined with our pre-analysis tables and scatterplots, there does not appear to be complete 

separation present.



Thus, we will not use Firth.

*/



/*The full linear predictor is specified in our model documentation slide*/



/*

Now, to interpret some significant explanatory variables

*/



/*

We will be interpreting these variables:

fighter1_Stance (southpaw vs switch), Reach_Diff

Sig_Strikes_PM_Diff, Strikes_Absorbed_Per_Minute_Diff, Age_Diff





Southpaw vs Switch

Odds Ratio = 1.472



Interpretation:

Holding all other factors constant, the odds of Fighter 1 winning when

Fighter 1 is a Southpaw are 1.472 times the odds of Fighter 1 winning when

Fighter 1 has a Switch stance.

Meaning, all else equal, the odds of winning are about 47.2% higher for a Southpaw

Fighter 1 than for a Switch Fighter 1.



CI: 95% CI = (1.1411, 1.8963)



CI interpretation: 

Holding all other factors constant, we are 95% confident that the odds

of Fighter 1 winning when Fighter 1 is a Southpaw are between 1.141 and 1.896 times

the odds when Fighter 1 has a Switch stance. That is, the southpaw odds could reasonably 

be 14.1% to 89.6% higher than Switch odds.





Reach Difference

Odds Ratio = 1.029



Interpretation: Holding all other factors constant, the odds of Fighter 1 winning

change by a factor of 1.029 for every one-unit increase in Reach_Diff. meaning, all

else equal, for everyone additional inch of reach advantage Fighter 1 has relative

to Fighter 2, Fighter 1's odds of winning increase by about 2.9%



CI: 95% = CI (1.0075, 1.0504)

CI interpretation:

Holding all other factors constant, we are 95% confident that a one-unit increase

in Fighter 1's reach advantage changes the odds of Fighter 1 winning by a factor between 1.0075 and 1.0504.

Meaning, the odds are estimated to increase by as little as 0.75% or as much as 5.04%





Significant Strikes Per Minute Difference

Odds ratio = 1.335

interpretation:

Holding all other factors constant, the odds of Fighter 1 winning change by a factor of 1.335 for every one-unit increase

in Sig_Strikes_PM_Diff. That is, holding all else equal, for every additional one significant strike per minute advantage Fighter 1 has over Fighter 2,

fighter 1's odds of winning increase by about 33.5%



CI: 95%  = CI (1.2742, 1.4003)

(realized i haven't shown my math of the CI yet, so this is how i have been

doing it for every one)

calculation: (0.2423, 0.3367)

exp(0.2423), exp(0.3367)

= (1.2742, 1.4003)

CI interpretation:

Holding all other factors constant, we are 95% confident that for every additional significant strike per minute advantage 

fighter 1 has over fighter 2 changes the odds of winning by a factor between 1.274 and 1.400, corresponding to an estimated

increase in the odds of winning between about 27.4% and 40%





Strikes Absorbed Per Minute Difference

Odds Ratio = 0.772

interpretation:

Holding all other factors constant, the odds  of fighter 1 winning change by a factor of 0.772 for every one-unit increase in Strikes_Absorbed_Per_Minute_Diff.

Said differntly, Holding All else equal, for every additional stike per minute absorbed by fighter 1 relative to fighter two, fighter 1's odds of winning decrease by about 

22.8%



CI: 95% = CI (0.7345, 0.8102)



CI interpretation:

Holding all other factors constant, we are 95% confident that for every

addition stike per minute fighter 1 absorbs relative to fighter 2 changes 

fighter 1's odds of winning by a factor between 0.735 and 0.810. Said differently,

fighter 1's odds of winning are estimated to decrease from a range fo 19.0% to 26.5%





Age Difference

Odds Ratio = 0.940



Interpreatation: 

Holding all other factors constant, the odds of fighter 1 winning change by a factor of 0.940 for every one-year increase in Age_Diff. Said differently,

for every additional year older fighter 1 is relative to fighter 2, fighter 1's odds of winning decrease by about 6.0%, holding all else

constant.



CI: 95% = CI (0.9298, 0.9498)

CI Interpretation:

Holding all other factors constant, we are 95% confident that every additional year older fighter 1 is relative to fighter 2 changes 

fighter 1's odds of winning by a factor of 0.930 to 0.950. Meaning that corresponds to an estimated decrease in fighter 1's odds

of winning between 5%-7%.



*/



/*

Custom odds ratio calculations



5-unit increase in Reach Difference

calculation shown for the first one for my notes in the future:

exp(5 * 0.0283) = exp(0.1415) = 1.15200

odds ratio = 1.152

interpretation:

holding all other factors constant, a five-unit increase in fighter 1's reach advantage relative to fighter 2 changes fighter 

1's odds of winning by a factor of approximately 1.152. Said differently, for every 5 inches of reach that fighter 1 has over fighter 2,

the odds of fighter 1 winning increase by 15.2%





5-unit increase in Age Difference (fighter 1 is 5 years older)

= exp(5 * -0.0621)

= exp(-0.3105)

=0.73308



interpretation:

Holding all other factors constant, a five-year increase in Age_Diff for fighter 1 relative to fighter two

changes fighter 1's odds of winning by a factor of about 0.733. Said differently,

when fighter 1 is five additional years older relative to fighter 2, fighter 1's odds of winning decrease by about 26.7%, 

holding all else equal.





2-unit increase in significant-strikes-per-minute

= exp(2 * 0.2893)

= exp(0.5786)

=1.78354



Holding all other factors constant, the odds of Fighter 1 winning change by a factor of 1.784 when Fighter 1's 

significant-strikes-per-minute advantage over Fighter 2 increases by 2. Said differently, the odds of fighter 1 winning

when they have 2 significant strikes per minute more than fighter 2 increase by about 78.4%



*/