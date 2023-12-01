##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
#
# Created: June 2022
##############################################################
### CBB_init.jl initialize the structurs for the data of the model
# 
#   Isfirstcall : Atomics First call, used for initialisation dynamics functions and lock the values 
#   Environment : Climate data (temperature, humidity and rain)
#   ScolyteGroup : Informations on the evry CBB population
#   FruitsOfInterest : Informations on the fruits ( healthy and colonized fruits)  
#   FruitsCohorts : Field data converted to cohorts for the plant growth model
#------------------------------------------------------------------------------------------------------------------------------------------------------
mutable struct Isfirstcall
    dev :: Threads.Atomic{Bool}
    egg :: Threads.Atomic{Bool}
    flight :: Threads.Atomic{Bool}
    life :: Threads.Atomic{Bool}
    death :: Threads.Atomic{Bool}
end
isfirstcall = Isfirstcall(Threads.Atomic{Bool}(true), Threads.Atomic{Bool}(true), Threads.Atomic{Bool}(true), Threads.Atomic{Bool}(true), Threads.Atomic{Bool}(true))

#---------------------------------------------------------------------------
abstract type Scolyte end

mutable struct ScolyteGroup <: Scolyte
    Born::String
    eggday::Int64
    PopulationInFruits::String
    population::Float64
    DevelopementRate::String
    developement::Float64
    Lifeexp::String
    lifeSpan::Float64
    Flying_population::String
    flying_population::Float64
    BailingPopulation::String
    bailingPopulation::Float64
    FlightDate::String
    flight_date::Int64
    DeadPopulation::String
    dead_population::Float64
    function ScolyteGroup(eggday, population, developement, lifeSpan, flying_population, bailingPopulation, flight_date, dead_population)
        Born = "eggday-->"
        PopulationInFruits = "population-->"
        DevelopementRate = "developement-->"
        Lifeexp = "biological age-->"
        Flying_population = "flying_population-->"
        BailingPopulation = "BailingPopulation-->"
        FlightDate = "flying_date-->"
        DeadPopulation = "dead_population-->"
        new(Born, eggday, PopulationInFruits, population, DevelopementRate, developement, Lifeexp, lifeSpan, Flying_population, flying_population,BailingPopulation, bailingPopulation, FlightDate, flight_date, DeadPopulation, dead_population)
    end
end


#---------------------------------------------------------------------------
abstract type TreeFruits end

mutable struct FruitsOfInterest <: TreeFruits
    NumberOfFruitsAvailable::Vector{Int64}
    NumberOfFruitsAttacked::Vector{Int64}
    PercentageHealthyVeryAppealing::Float64 
    PercentageHealthyAppealing::Float64
    PercentageHealthyGround::Float64
    PercentageAttackedVeryAppealing::Float64
    PercentageAttackedAppealing::Float64
    PercentageAttackedGround::Float64
    function FruitsOfInterest(NumberOfFruitsAvailable, NumberOfFruitsAttacked)::Float64
        PercentageHealthyVeryAppealing = round(NumberOfFruitsAvailable[1] *100 / sum(NumberOfFruitsAvailable), digits = 2)
        PercentageHealthyAppealing = round(NumberOfFruitsAvailable[2] *100 / sum(NumberOfFruitsAvailable), digits = 2)
        PercentageHealthyGround = round(NumberOfFruitsAvailable[3] *100 / sum(NumberOfFruitsAvailable), digits = 2)
        if sum(NumberOfFruitsAttacked) == 0
            PercentageAttackedVeryAppealing = 0.0
            PercentageAttackedAppealing = 0.0
            PercentageAttackedGround = 0.0
        else
            PercentageAttackedVeryAppealing = round(NumberOfFruitsAttacked[1] *100 / sum(NumberOfFruitsAttacked), digits = 2)
            PercentageAttackedAppealing = round(NumberOfFruitsAttacked[2] *100 / sum(NumberOfFruitsAttacked), digits = 2)
            PercentageAttackedGround = round(NumberOfFruitsAttacked[3] *100 / sum(NumberOfFruitsAttacked), digits = 2)
        end
        new(NumberOfFruitsAvailable, NumberOfFruitsAttacked, PercentageHealthyVeryAppealing, PercentageHealthyAppealing, PercentageHealthyGround, PercentageAttackedVeryAppealing, PercentageAttackedAppealing, PercentageAttackedGround)
    end
end
scolyteGroup = []
fruitsOfInterest = []
Colony = 0;
FirstCBB = 0;
Colonizer = Array{Float64}(undef, 0, 2)









