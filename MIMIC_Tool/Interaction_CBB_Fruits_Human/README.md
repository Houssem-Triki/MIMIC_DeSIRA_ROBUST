# The CBB Pest Model
In this project, we set up a dynamic model of the coffee berry borer (CBB). The model fellows the evolution of a CBB population, on an initial infected coffee berries.
In addition of the pest model, we introduced a reduced growth coffee tree model. It focuses mainly on fruits development.

The two models are linked by a platforme, that provides for the transfert of informations. And the updating the data within the two models.
We plan on adding on a human action model to intreduce a control aspect to the whole.

## Fonctional Model Hypotheses:
- The operating space of the model is relative to the location of the fruits introduced in the implementation. Ex: if we incorporate the number of fruits present on eight branches of the same tree: we say that the operating space of the model is the eight branches
- The model divides the fruits into three distinct categories: 
   - Red fruits: fruits that are ripe and from the moment they turn red.
   - Green fruit: well-developed green fruit, this category includes light green fruit as well as fruit that turns yellow.
   - Ground fruits: all fruits that may belong to the other two categories, but which have fallen to the ground.
- The monitoring of populations is based on the grouping of different individuals within groups of populations having the same day of birth.
- The cohorts of the model are constructed by crossing the groups of individuals and the categories of fruit attacked by these individuals.

| Population group / Fruits category | Hatched the 1_st day | Hatched the 2_nd day | ... | Hatched the n_th day |
| :---: | :---: | :---: | :---: | :---: |
| ***Very Appealing fruits***   | Cohort (1, VAp) | Cohort (2, VAp) | ... | Cohort (n, VAp) |
| ***Appealing fruits***        | Cohort (1, Ap) | Cohort (2, Ap) | ... | Cohort (n, Ap) |
| ***Fruits on the grounds***   | Cohort (1, G) | Cohort (2, G) | ... | Cohort (n, G) |


- Each of the above categories of fruit has an attraction factor that influences whether a bark beetle chooses to colonise a fruit in the operating space or not.   
- Male bark beetles are not considered in the calculation and monitoring of populations (as they represent only one-tenth of the individuals in a colony).
- The population dynamics are subject to temperature. Relative humidity and rainfall are introduced as control parameters and tolerance values.  (To be detailed?) 
- The calculated mortality at fruit emergence is the result of predation as well as the environmental tolerance of the beetle without a food source.
- We only consider the populations that are the offspring of the original individuals, i.e. we do not consider bark beetles that come from other trees or other branches (we restrict ourselves to our operating space.). 
- The model operates over a temperature range of [15,35] °C.

# The coffee fruit cohort model
In Sumatra region of Indonesia, Arabica coffee trees produce coffee berries throughout the year. With the presence of rainfall throughout the year and an average daytime temperature between 22°C and 30°C, the equatorial climate provides the necessary conditions for the trees to flower. A simple plant growth model is created as a reduced model to simulate fruiting only, based on the observed numbers of berries harvested. We designed a cohort fruit model inspired from the GreenLab cohort assumption: fruits with the same parameters (chronological age, physiological age, sink power) are merged into the same cohort. An automaton is created that build fruit cohorts based on the field harvest. Then, the model estimates the age of the fruits according to the harvest frequencies and the climatic data.

# Human Harvest model
Human intervention is represented here as a simple harvest model. This model simulates harvesting at dates that correspond to observed data, which is useful for validation by comparing simulated data to actual data. 

