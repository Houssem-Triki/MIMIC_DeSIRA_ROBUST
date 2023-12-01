##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
# Plant fruit model
using DataFrames
using CSV

mutable struct FruitsCohorts
    NumberOfOrgans::Int32
    ChronologicalAge::Float64
    State::Bool
    DateOfColonisation::Any
end
mutable struct Isfirstinitialisation
    fruitinit :: Threads.Atomic{Bool}
end
isfirstinitialisation = Isfirstinitialisation(Threads.Atomic{Bool}(true))
fruitsCohorts = []
sumatraFruits = []


#-----------------------------------------------------------------------------------------------------------------------------------------------
function FruitInitialisation(Tree_File)
    
    # Field data
    SumatraFruits = CSV.read(Tree_File, DataFrame);
    #Fruits
    StudiedFruits = SumatraFruits[1:end,:]
    sumatraFruits = Matrix(StudiedFruits)
    # println(sumatraFruits)
    if Threads.atomic_xchg!(isfirstinitialisation.fruitinit, false)
        fruitsCohorts = FruitsCohortcreation(sumatraFruits)
    end
    # if AgingInit == 
    #     # println("heyyyy")
    fruitsCohorts = CohortsAging()
    # end
    # global AgingInit += 1
    global fruitsCohorts
    return fruitsCohorts, sumatraFruits
end

#-----------------------------------------------------------------------------------------------------------------------------------------------
function FruitsCohortcreation(sumatraFruits)
    #########################################################################################
    # FruitsCohortcreation Creat the fruit's cohorts for the reduced plant growth model 
    #
    # Inputs:
    #   sumatraFruits     :   Field data from Sumatra, Indonesia.
    # Output:
    #   fruitsCohorts     :   Fruit's Cohorts
    #########################################################################################
    # Add first attackd green
    for i in 1:size(sumatraFruits)[1]
        if sumatraFruits[i,5] != 0 && sumatraFruits[i,8] == 1  # attackd green
            push!(fruitsCohorts, FruitsCohorts(sumatraFruits[i,5], sumatraFruits[i,6]-15, true, 0))
        end
        if sumatraFruits[i,7] != 0 && sumatraFruits[i,8] == 0 
            push!(fruitsCohorts, FruitsCohorts(sumatraFruits[i,7], sumatraFruits[i,6], false, missing))
        end       
        if sumatraFruits[i,7] != 0 && sumatraFruits[i,8] == 1
            if sumatraFruits[i,4] != 0 
                push!(fruitsCohorts, FruitsCohorts(sumatraFruits[i,4], sumatraFruits[i,6], true, 0))
            end
            if sumatraFruits[i,2] != 0 
                push!(fruitsCohorts, FruitsCohorts(sumatraFruits[i,2], sumatraFruits[i,6], false, missing))
            end
        end
    end
    return fruitsCohorts
end

#-----------------------------------------------------------------------------------------------------------------------------------------------
function CohortsAging()
    for i in eachindex(fruitsCohorts)
        fruitsCohorts[i].ChronologicalAge += 1
    end
    return fruitsCohorts
end

#-----------------------------------------------------------------------------------------------------------------------------------------------
function ValidationData(Tree_File)
    # Field data
    SumatraFruits = CSV.read(Tree_File, DataFrame);
    #Fruits
    StudiedFruits = SumatraFruits[1:end,:]
    sumatraFruits = Matrix(StudiedFruits)
    return sumatraFruits
end