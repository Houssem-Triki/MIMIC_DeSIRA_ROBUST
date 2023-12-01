##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
### MIMIC_Results.jl is the results satup code of the interaction platform

function results(StateVariable, filepath)
    df = DataFrame(StateVariable);
    CSV.write(filepath, df ,delim=';');
    println(" Your results are saved in --> ", filepath)
    # println(StateVariable)
end






# function resul(HarvestHealthy, validationFruits, HarvestColonized, GreenHealthy, GreenColonized)
#     HH = []
#     HC = [] 
#     GH = []
#     GC = []
#     # sumatraFruitshaha = ValidationData()
#     for i in eachindex(HarvestHealthy)
#         push!(HH,[HarvestHealthy[i][2] validationFruits[i,2] HarvestHealthy[i][1]])
#     end
#     for i in eachindex(HarvestColonized)
#         push!(HC,[HarvestColonized[i][2] validationFruits[i,4] HarvestColonized[i][1]])
#     end
#     for i in eachindex(GreenHealthy)
#         push!(GH,[GreenHealthy[i][2] validationFruits[i,3] GreenHealthy[i][1]])
#     end
#     for i in eachindex(GreenColonized)
#         push!(GC,[GreenColonized[i][2] validationFruits[i,5] GreenColonized[i][1]])
#     end
#     HH = reduce(vcat, HH)
#     HC = reduce(vcat, HC)
#     GH = reduce(vcat, GH)
#     GC = reduce(vcat, GC)
    
#     df = DataFrame(Day = HH[:,1], Measured_healthy_fruits = HH[:,2], Simulation_healthy = HH[:,3], Measured_Colonized_fruits = HC[:,2], Simulation_Colonized = HC[:,3], Measured_Healthy_Green = GH[:,2], Simulation_Healthy_Green = GH[:,3], Measured_Colonized_Green = GC[:,2], Simulation_Colonized_Green = GC[:,3])
#     CSV.write("D:/Thèse/Results\\Test_C52.csv", df ,delim=';')
# end


# function CSVtoPlot()
#     resultsdf0 = CSV.read("D:/Thèse/Results\\Test_C52.csv", DataFrame);
#     Resultsdf0 = resultsdf0[1:end,2:end]
#     results = Matrix(Resultsdf0)
#     labels = names(Resultsdf0)
#     labels = reshape(labels, 1, :)
#     aaaa = plot(results, lab = labels)
#     display(plot(aaaa))
# end



