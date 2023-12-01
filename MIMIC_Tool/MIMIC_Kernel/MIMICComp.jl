##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
# In this file, all the components are initialised + every pâckage can be added here for an execution
using Plots
using Dates
using TimerOutputs
# using Plots
# gr(size = (750, 565))
# theme(:default)
Directory_UC = Directory_Main * "/MIMIC_UC.yml";
Directory_Results = Directory_Main * "\\MIMIC_Results"
if isdir(Directory_Results) == false 
    mkdir(Directory_Results)
end
Directory_Kernel = @__DIR__ ;
include(Directory_Kernel * "/MIMIC_data_selection.jl");
include(Directory_Kernel * "/MIMIC_Mediator.jl");
include(Directory_Kernel * "/MIMIC_Scheduling.jl");
include(Directory_Kernel * "/MIMIC_ISDR.jl");
# (fruitsCohorts, sumatraFruits) = Model_Coffee_tree.call

println("  ")
println("Initialisation completed")
printstyled("============================"; color = :cyan)
println("  ")





