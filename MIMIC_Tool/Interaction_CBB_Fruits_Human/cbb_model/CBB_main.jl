##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
#
# Created: June 2022
##############################################################
### CBB_main.jl is the main code for the scolyte model
#------------------------------------------------------------------------------------------------------------------------------------------------------
using CSV
using DataFrames
using Interpolations
include("CBB_Comp.jl")
AR = 0;
AG = 0;
#----------- for stand alone execution 
function CBB(day)

    if day == 1
        for i in eachindex(fruitsCohorts)
            if fruitsCohorts[i].State == true
                global FirstCBB += fruitsCohorts[i].NumberOfOrgans
                push!(scolyteGroup, ScolyteGroup(0, FirstCBB, 0, vie_sco(environment.temperature[1]), 0, 0, 0, 0));
                global Colony  = scolyteGroup[1].population; 
            end
        end
    end 
    # for day in 1:Step_CBB:maxDays     # The step time is 1 day
    # for day in 1:100
    global AR = 0;
    global AG = 0;
    
    # Platform_system_stats_to_CBB(fruitsCohorts, fruitsOfInterest)  # Gets fruitsofInterest 
    
    #--- New Groupe of CBB               
    global scolyteGroup = New_egg(scolyteGroup, day)
    
    #--- Devlopement of the populations
    global scolyteGroup = CBB_developement(scolyteGroup, day)
    
    #--- lifeSpan calculation
    scolyteGroup = CBB_Lifespan(scolyteGroup, day)
    
    #--- Colonisation
    (scolyteGroup, AR, AG) = CBB_colonisation(scolyteGroup, day) 
    
    # Platform_system_stats_to_Plant(fruitsCohorts, AR, AG, day)  # Gets fruitsCohorts
    
    # end
    # return  fruitsCohorts; fruitsOfInterest;
    return AR, AG
end
#-----------
# CBB()
# scolyteGroup


