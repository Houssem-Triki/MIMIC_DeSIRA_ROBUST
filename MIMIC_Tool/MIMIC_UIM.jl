##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
#----------------------------------------------------------------------------------------------------------
ModelsNames = ["Coffee_tree", "CBB"] 
function MIMIC_system_stats(fruitsCohorts, fruitsOfInterest, AR, AG, day, executedModel)
    #--- Fruit management           (cohort managment - Translation : fruitsCohorts ---> fruitsOInterest (Coffee_tree ---> CBB))
    FruitsRH = 0 ;
    FruitsRA = 0 ;             
    FruitsGH = 0 ;
    FruitsGA = 0 ;
    if executedModel == ModelsNames[1]
        for i in eachindex(fruitsCohorts)
            if fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge >= 196
                FruitsRH += fruitsCohorts[i].NumberOfOrgans
            elseif fruitsCohorts[i].State == true && fruitsCohorts[i].ChronologicalAge >= 196
                FruitsRA += fruitsCohorts[i].NumberOfOrgans
            end
            if fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge >= 105 && fruitsCohorts[i].ChronologicalAge < 196
                FruitsGH += fruitsCohorts[i].NumberOfOrgans
            elseif fruitsCohorts[i].State == true && fruitsCohorts[i].ChronologicalAge >= 105 && fruitsCohorts[i].ChronologicalAge < 196
                FruitsGA += fruitsCohorts[i].NumberOfOrgans
            end
            push!(fruitsOfInterest, FruitsOfInterest([FruitsRH, FruitsGH, 0],[FruitsRA, FruitsGA, 0])) ;   
        end
    end
    #--- Fruit management           (cohort managment - Translation : fruitsOInterest ---> fruitsCohorts (CBB ---> Coffee_tree))
    if executedModel == ModelsNames[2]
        while AR > 0 && AG > 0
            for i in eachindex(fruitsCohorts)
                # Red attack
                if AR > 0 
                    if fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge >= 196 && fruitsCohorts[i].NumberOfOrgans <= AR 
                        fruitsCohorts[i].State = true
                        AR -=  fruitsCohorts[i].NumberOfOrgans
                        fruitsCohorts[i].DateOfColonisation = day
                    elseif fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge > 196  && fruitsCohorts[i].NumberOfOrgans > AR
                        fruitsCohorts[i].NumberOfOrgans -= AR
                        push!(fruitsCohorts, FruitsCohorts(AR, fruitsCohorts[i].ChronologicalAge, true, day))
                    end
                end
                # Green Attack
                if AG > 0
                    if fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge >= 105  && fruitsCohorts[i].ChronologicalAge < 196 && fruitsCohorts[i].NumberOfOrgans <= AG
                        fruitsCohorts[i].State = true
                        AG -=  fruitsCohorts[i].NumberOfOrgans
                        fruitsCohorts[i].DateOfColonisation = day
                    elseif fruitsCohorts[i].State == false && fruitsCohorts[i].ChronologicalAge > 105 && fruitsCohorts[i].ChronologicalAge < 196 && fruitsCohorts[i].NumberOfOrgans > AG
                        fruitsCohorts[i].NumberOfOrgans -= AG
                        push!(fruitsCohorts, FruitsCohorts(AG, fruitsCohorts[i].ChronologicalAge, true, day))
                    end
                end
            end
            break
        end
    end
    global fruitsOfInterest
    global fruitsCohorts
    global AR
    global AG
    return fruitsOfInterest, fruitsCohorts, AR, AG
end

#----------------------------------------------------------------------------------------------------------
