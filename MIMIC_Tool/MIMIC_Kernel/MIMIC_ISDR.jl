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






function results(StateVariable, filepath, SVnames)
    df = DataFrame(StateVariable, SVnames)
    CSV.write(filepath, df ,delim=';');
    println(" Your results are saved in --> ", filepath)    
end


# function ISDR_Management(outputs)
#     # Space = Vector{Any}(undef, length(argumentsName))
#     # for i in eachindex(argumentsName)
#     #     hcat(FOutputs, argumentsName)

#     #     hcat(FOutputs, Space)

#     # push!(FOutputs, argumentsName)
# end

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


function CSVtoPlot(Validation)
    resultsdf0 = CSV.read(CompMIMIC_ISDR.PathFile, DataFrame)
    XR = resultsdf0[1:end,2:end]
    XR1 = XR[1:end,1] + XR[1:end,2]
    XR2 = XR[1:end,2]
    YR = resultsdf0[1:end,1]
    XR3 = Validation[1:end,4]
    labels = names(resultsdf0[1:end,2:end])
    labels = reshape(labels, 1, :)
    plot(YR, XR1, label = "Total Fruits\n", seriestype = :bar, color = :lightgrey);
    plot!(YR, XR2, lw = 3, label = "Colonized Simulated\n", color = :blue)
    last(Model_Coffee_tree.Arguments)
    treename = first(last(Model_Coffee_tree.Arguments, 7), 3)
    title!("\nTotal and colonized fruits on tree $treename")
    xlabel!("$NatureOfTime\n")
    ylabel!("\nNumber of fruits")
    display(plot!(YR, XR3, lw = 3, seriestype = :scatter, color = :red, label = "Colonized Measured"))
end

first(last(Model_Coffee_tree.Arguments, 7), 3)



