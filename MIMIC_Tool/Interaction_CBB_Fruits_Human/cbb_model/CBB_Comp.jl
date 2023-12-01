#----------- for stand alone execution 
# include("Climate_module.jl")
# include("Plant_Fruit_Dev.jl")
# using .PlantFruit
# include("Platform_SystemStats.jl")    

#-----------
include("CBB_dynamics.jl");
include("CBB_Func_Laws.jl");
include("CBB_init.jl");
include("CBB_attack.jl")
include("./CBB_attack_rest.jl");
# using .Climate_data
#-----------
# FruitInitialisation()
# for i in eachindex(fruitsCohorts)
#     if fruitsCohorts[i].State == true
#         global FirstCBB += fruitsCohorts[i].NumberOfOrgans
#         push!(scolyteGroup, ScolyteGroup(0, FirstCBB, 0, vie_sco(environment.temperature[1]), 0, 0, 0, 0));
#         global Colony  = scolyteGroup[1].population; 
#     end
# end




