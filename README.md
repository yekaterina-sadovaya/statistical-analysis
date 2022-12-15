# Statistical data analisys

This repository provides solutions to different statistical problems. Each folder corresponds to the topic and includes the dataset with the corresponding model code to describe it. A description of the data and models can be found below.

## 01 Linear Models for Data with Correlation

A linear model specifies a linear relationship between a dependent variable and n independent variables. 
The dataset used in this exersize is taken from H. Randle, H. Edwards, L. Button (2010). 
"The Effect of Rider Position on the Stride and Step Lengt of the Horse at Canter (Abstract)," 
Journal of Veterinary Behavior, Vol. 5, pp. 219-220. 

The example demonstrates how to parametrise the unknown parameter β of the model y = Xβ + ε (where ε follows normal distribution) 
and compute statistical parametrs such as, e.g. maximum likelihood estimate.

## 02 Linear Mixed Effects Models

Mixed effect models contain both fixed effects and random effects. They are particularly useful in the repeated measurements case for the same dataset or if the data is clustered.
There are 4 different datasets analyzed under this category.

Children.R contains models for 2 datasets, i.e.,
1. The task analyses the children height of two genders and in different age. More details about the data can be found in the paper:
   Tuddenham, R. D., and Snyder, M. M. (1954) "Physical growth of California boys and girls from birth to age 18", University of California Publications in Child Development, 1, 183-364.

2. The second dataset is related to tree moistorizing of 4 different tree species with 5 branches/species, 3 sample locations/branch, two transpiration
   conditions. Branch Locations: 1=Central, 2=Distal, 3=Proximal. Species: 1=Loblolly Pine, 2=Shortleaf Pine, 3=Yellow Poplar, 4=Red Gum.
   Transpiration Types: 1=Rapid (Hot, dry, sunny day), 2=Slow (Cool, moist, cloudy day). The goal is to describe the moisture Content (% of Dry wt times 10) using these variables using the linear mixed effects models.

Wages.R also contains models for 2 datasets:
1. The dataset wages from the brolgar library.
2. Gambling symptom Assessment. In this study, the main object is to consider whether the theatment has a significant effect on having symptoms. On top of that, the levels of adherence measures
how well a person complies with the given instructions during the trial.