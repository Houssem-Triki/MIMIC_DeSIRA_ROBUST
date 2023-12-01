# MIMIC_UC
The UC defines the information about the simulation's operation and the model definition that are going to interact. This information is in the form of a YAML file. The UC is used to parse the model metadata and create the variables that will be used during the interaction execution process. The model priority is set by the model rank, which is the order in which the model is described in the MIMIC_UC.yml file.


# MIMIC_UIM

Users write code in the Julia language that describes how the models interact with each other by using the state variables. But you don't have to use Julia to encode the UIM: i) the interaction code can also be a "external" model, which is part of the Model layer but has a higher level of complexity and worse performance because it needs to be wrapped in a pseudo-model. ii) If the interaction works with a low coupling level only on the existing models' direct inputs and outputs, this is called a "shared coupling." The user doesn't have to give any UIM. The simulation starts right from the initial schedule and runs based on the input and output definitions for implicit cycles that were given for the pseudo-model generation. 

# Using code written in another coding language
In order to use a code written in other than Julia, you need to write a Julia code that contains the adequate package to run it. Julia support C, R, Matlab and python languages. 
