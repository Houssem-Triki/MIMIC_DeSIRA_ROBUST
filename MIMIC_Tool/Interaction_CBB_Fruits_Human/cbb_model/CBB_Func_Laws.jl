##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
#
# Created: June 2022
##############################################################
# this file regroupe all the functioning laws of the CBB

#------------------------------------------------------------------------------------------------------------------------------------------------------
#--- New Groupe of CBB
function New_egg(scolyteGroup, day)
    newScolyteGroup = ScolyteGroup(day, ceil(egg_lay(environment.temperature[day]) * Colony) , 0, vie_sco(environment.temperature[day]) + day, 0, 0, 0, 0)
    push!(scolyteGroup, newScolyteGroup)
    return scolyteGroup
end               

#------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Devlopement of the populations
function CBB_developement(scolyteGroup, day)
    for i in eachindex(scolyteGroup)
        if scolyteGroup[i].population > 0 && (scolyteGroup[i].developement != 1 || scolyteGroup[i].developement != NaN) 
            scolyteGroup[i].developement += dev_rate(environment.temperature[day])
            if scolyteGroup[i].developement >= 1
                scolyteGroup[i].developement = 1
            end
        end
    end
    return scolyteGroup
end
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#--- lifeSpan calculation
function CBB_Lifespan(scolyteGroup, day)
    for i in 1:length(scolyteGroup)-1
        NewLifespan = vie_sco(environment.temperature[day]) + scolyteGroup[i].eggday
        scolyteGroup[i].lifeSpan += round(  ( (NewLifespan - scolyteGroup[i].lifeSpan) / 10) )        
        if scolyteGroup[i].population == 0 && scolyteGroup[i].flying_population == 0 && scolyteGroup[i].dead_population > 0
            scolyteGroup[i].Lifeexp = "death date -->"
        end
        #--- Death of the populations
        if  scolyteGroup[i].lifeSpan <= day && (scolyteGroup[i].population != 0 || scolyteGroup[i].flying_population != 0 )
            scolyteGroup[i].dead_population += scolyteGroup[i].population + scolyteGroup[i].flying_population
            scolyteGroup[i].population = 0
            scolyteGroup[i].developement = NaN
            global Colony -= scolyteGroup[i].dead_population
            if Colony < 0
                Colony = 0
            end
            scolyteGroup[i].flying_population = 0 
        end
    end 
    return scolyteGroup
end
#-------------------------------------------------------------------------------------------------------------------------------------------------------
#--- Colonisation
function CBB_colonisation(scolyteGroup, day)
    for i in eachindex(scolyteGroup)
        #--- Estimation of the populations that leaves the fruits to colonize 
        if scolyteGroup[i].developement >= 1 
            flight = sortie_t(environment.temperature[day],environment.relative_humidity[day],environment.rain[day])
            if flight != 0
                scolyteGroup[i].flying_population +=  round((flight * scolyteGroup[i].population), digits = 3)
                scolyteGroup[i].population -=  round((flight * scolyteGroup[i].population), digits = 3)
                #--- Updating the informations on populations
                if scolyteGroup[i].population <= 0.1 && scolyteGroup[i].flying_population >= 1
                    scolyteGroup[i].flight_date = day 
                    scolyteGroup[i].population = 0
                    scolyteGroup[i].dead_population = round(scolyteGroup[i].flying_population * (mortality(environment.temperature[day],environment.relative_humidity[day])), digits = 2)
                    scolyteGroup[i].flying_population -=  scolyteGroup[i].dead_population
                    scolyteGroup[i].flying_population = round(scolyteGroup[i].flying_population)
                    scolyteGroup[i].developement = NaN ; 
                    #-------------------------------------------------------------------------------------------------------------------------------------------------------
                    #--- Colonisation management
                    # println(fruitsOfInterest)
                    if sum(fruitsOfInterest[end].NumberOfFruitsAvailable) > 0
                        flying_pop = scolyteGroup[i].flying_population
                        Fruits = fruitsOfInterest[end].NumberOfFruitsAvailable
                        nfruitsOfInterest = fruitsOfInterest[end] 
                        resultOfAttack = AttackOnFruits(flying_pop, nfruitsOfInterest, Fruits)
                        scolyteGroup[i].bailingPopulation = resultOfAttack[3]
                        global Colonizer = vcat(Colonizer, [sum(resultOfAttack[2]) scolyteGroup[i].eggday])
                        global Colony += sum(resultOfAttack[2])
                        # push!(FPop, scolyteGroup[i].flying_population)
                        global AR += resultOfAttack[2][1]
                        global AG += resultOfAttack[2][2]
                        # push!(fruitsOfInterest, FruitsOfInterest(resultOfAttack[1] , resultOfAttack[2]))
                    end
                end
            end
        end
    end
    return [scolyteGroup, AR, AG]
end
















