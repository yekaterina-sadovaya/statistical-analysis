# Statistical data analisys

This repository provides solutions to different statistical problems. Each folder corresponds to the topic and includes the dataset with the corresponding model code to describe it. A description of the data and models can be found below.

## 01 Linear Models for Data with Correlation

A linear model specifies a linear relationship between a dependent variable and n independent variables. 
The dataset used in this exersize is taken from 
**H. Randle, H. Edwards, L. Button (2010). "The Effect of Rider Position on the Stride and Step Lengt of the Horse at Canter," Journal of Veterinary Behavior, Vol. 5, pp. 219-220**.

The example demonstrates how to parametrise the unknown parameter β of the model y = Xβ + ε (where ε follows normal distribution) 
and compute statistical parametrs such as, e.g. maximum likelihood estimate.

## 02 Linear Mixed Effects Models

Mixed effect models contain both fixed effects and random effects. They are particularly useful in the repeated measurements case for the same dataset or if the data is clustered.
There are 4 different datasets analyzed under this category.

Children.R contains models for 2 datasets, i.e.,
1. The task analyses the children height of two genders and in different age. More details about the data can be found in the paper:
   **Tuddenham, R. D., and Snyder, M. M. (1954) "Physical growth of California boys and girls from birth to age 18", University of California Publications in Child Development, 1, 183-364.**

2. The second dataset is related to tree moistorizing of 4 different tree species with 5 branches/species, 3 sample locations/branch, two transpiration
   conditions. Branch Locations: 1=Central, 2=Distal, 3=Proximal. Species: 1=Loblolly Pine, 2=Shortleaf Pine, 3=Yellow Poplar, 4=Red Gum.
   Transpiration Types: 1=Rapid (Hot, dry, sunny day), 2=Slow (Cool, moist, cloudy day). The goal is to describe the moisture Content (% of Dry wt times 10) using these variables using the linear mixed effects models.

Wages.R also contains models for 2 datasets:
1. The dataset wages from the brolgar library.
2. Gambling symptom Assessment. In this study, the main object is to consider whether the theatment has a significant effect on having symptoms. On top of that, the levels of adherence measures
how well a person complies with the given instructions during the trial.

## 03 Generalized Linear Mixed Effects Models (GLMM) 

GLMM is an extension of the generalized linear model. The main difference is that the predictor accounts for both fixed and random effects, e.g., y = Xβ + ZU.

The first dataset related to patients having AIDS. The second dataset analyses the effect of hunger on locomotory behaviour of a locust.

The last set tries to describe the appetite of children in Kenya accounting for such factors as the presence of treatment, gender, and the number of doctors visits. 
**Neumann, C. G., Bwibo, N. O., Murphy, S. P., Sigman, M., Whaley, S., Allen, L. H., Guthrie, D., Weiss, R. E. Demment, M. W. (2003). Animal source foods improve dietary quality, micronutrient status, growth and cognitive function in Kenyan school children: Background, study design and baseline findings. Journal of Nutrition, 11.**


## 04 Multi-Variative Models

The multi-variative models represent models of multiple variables to forecast possible outcomes. The model can be described by Y = XB + E, where B and E consists of multiple variables, e.g., yi1 = β01 + β11 xi1 + αj1 + εi1, yi2 = β02 + β12 xi1 + αj2 + εi2, etc.

The data is taken from **Smith, H., Gnanadesikan, R., & Hughes, J. B. (1962). Multivariate analysis of variance (MANOVA). Biometrics, 18, 2241** and represents characteristics of the
urine of young men. The men are categorized into four groups based on their degree of obesity.

## 05 Functional Data Models

Funtional data is multi-variative. In functional data analysis, data consist of at least a pair of discrete observations of time T and the response for each sampling unit.
It can be written similarly to the multi-variative model, e.g., y_it = y_i(t) + ε_it. But the main difference is that y_i(t) is a smooth function (curve).

The solutions semonstrate how to describe the data using a growth curve model. The first dataset corresponds to an experiment in which a treatment for depression is studied.
Two groups of patients (1: control / 2: treatment) have been followed at four different times
(0: pre-test, 1: one month post-test, 3: 3 months follow-up and 6: 6 months follow-up).
The dependent variable is a depression score.

The second dataset is from a study of weight gain **Box, G.E.P. (1950). Problems in the analysis of growth and wear curves. Biometrics, 6, 362-389**, where investigators randomly assigned 30 rats
to three treatment groups: treatment 1 was a control (no additive); treatments 2 and 3
consisted of two different additives (thiouracil and thyroxin respectively) to
the rats drinking water.Weight was measured at baseline (week 0) and at weeks 1, 2, 3, and 4.
