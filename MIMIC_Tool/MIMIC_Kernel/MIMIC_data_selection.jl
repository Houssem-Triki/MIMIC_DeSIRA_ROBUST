##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
### Data parsing managment code
# Getting the data from the Input file
using YAML
using OrderedCollections
data = YAML.load_file(Directory_UC, dicttype=OrderedDict{String,Any})

#-------------------------------------------------------------------------------------------------------------------------------------
# Structures that holds the parsed data
mutable struct StepTimeModel
    NameOfModel::String
    StepOffSet::Any
    StepTime::Any
    EndSimulation::Any
end
stepTimeModel= []

mutable struct VariablesModels
    NameOfModel::String
    StateVariables::Any
    Inputs::Any
    DataFile::Any
    Outputs::Any
end
variablesModels = []


mutable struct FunctionModels
    NameOfModel::String
    CallSynthax::Any     
    Arguments::Any
    IsFile::Any
end
functionModels = []

mutable struct PathModels
    NameOfModel::String
    PathToFile::Any
end
pathModels = []
mutable struct PerformancesModels
    NameOfModel::String
    performances::Bool
end

performancesModels = []

mutable struct UIMParsing
    Name::String
    CallSynthax::Any    
    Arguments::Any
    IsFile::Any
    PathToFile::Any
end
UIMparsing = []
#-------------------------------------------------------------------------------------------------------------------------------------
#------ Counting active models and creating variables for models ------
Firstkey = [] # First key of the input.yml groups
name = [] # the name given to models
ActingModels = [] # the name of outside (to MIMIC) models
for (key,value) in data
    if data["$key"]["Is_model_active"] == true
        @eval $(Symbol("$key")) = nothing
        if get(data["$key"], "Name", "NoValue") !== nothing
            push!(name, data["$key"]["Name"])
        elseif get(data["$key"], "Name", "NoValue") === nothing
            push!(name, "$key")
        end
        push!(Firstkey, "$key") 
    end
    name
end
NumberOfModels = length(Firstkey)
ActingModels = name[2:end]

#----- Extracting time, variables, function call and file path data from each model
for i in eachindex(Firstkey)
    if getkey(data[Firstkey[i]], "Nature_of_Step", false ) == "Nature_of_Step"
        @eval $(Symbol("times_$(name[i])")) = copy(data[Firstkey[$i]]["Nature_of_Step"])
        push!(stepTimeModel, StepTimeModel(name[i], (@eval $(Symbol("times_$(name[i])"))["Step_offset"]), (@eval $(Symbol("times_$(name[i])"))["Unit_step_size"]), (@eval $(Symbol("times_$(name[i])"))["End_Simulation"])))
    end
    if getkey(data[Firstkey[i]], "Variables", false ) == "Variables"
        @eval $(Symbol("variables_$(name[i])")) = copy(data[Firstkey[$i]]["Variables"])
        push!(variablesModels, VariablesModels(name[i], (@eval $(Symbol("variables_$(name[i])"))["State_variables"]), (@eval $(Symbol("variables_$(name[i])"))["Inputs"]), (@eval $(Symbol("variables_$(name[i])"))["Myrefdir"]),(@eval $(Symbol("variables_$(name[i])"))["Outputs"])))
    end
    if getkey(data[Firstkey[i]], "Function", false ) == "Function" && data[Firstkey[i]]["Function"]["Call"] !== nothing
        @eval $(Symbol("functions_$(name[i])")) = copy(data[Firstkey[$i]]["Function"])
        push!(functionModels, FunctionModels(name[i], (@eval $(Symbol("functions_$(name[i])"))["Call"]), (@eval $(Symbol("functions_$(name[i])"))["Arguments"]), (@eval $(Symbol("functions_$(name[i])"))["File"])))
    else
        push!(functionModels, FunctionModels(name[i], nothing, nothing, nothing))
    end
    if getkey(data[Firstkey[i]], "PathToFile", false ) == "PathToFile"
        if typeof(data[Firstkey[i]]["PathToFile"]) == String
            @eval $(Symbol("paths_$(name[i])")) = data[Firstkey[$i]]["PathToFile"]
            push!(pathModels, PathModels(name[i], (@eval $(Symbol("paths_$(name[i])")))))
        else
            @eval $(Symbol("paths_$(name[i])")) = copy(data[Firstkey[$i]]["PathToFile"])   # NE COPIE PAS LES "STRING" !!!!!!
            push!(pathModels, PathModels(name[i], (@eval $(Symbol("paths_$(name[i])")))))
        end
    end
    if getkey(data[Firstkey[i]], "Perfs", false) == "Perfs"
        @eval $(Symbol("Perfs_$(name[i])")) = data[Firstkey[$i]]["Perfs"]
        push!(performancesModels, PerformancesModels(name[i], (@eval $(Symbol("Perfs_$(name[i])")))))
    else
        push!(performancesModels, PerformancesModels(name[i], (false)))
    end
end

#------------------------------------------------------------------------------------
#----------------------------------Initialisation------------------------------------
#------------------------------------------------------------------------------------
#-- Times parameters
Init_time = stepTimeModel[1].StepOffSet
End_time = stepTimeModel[1].EndSimulation
Step_time = stepTimeModel[1].StepTime
Simulation_Time = Init_time
NatureOfTime = @eval $(Symbol("times_$(name[1])"))["Nature"]
Symbol("$NatureOfTime")
@eval $(Symbol("$NatureOfTime")) = Init_time
@eval $(Symbol("$NatureOfTime")) 

#----- Collecting and filling the structures with data from the active models 
index_s = 1
index_v = 1
index_f = 1
index_p = 1
index_c = 1
for i in eachindex(name)
    global index_s
    global index_v
    global index_f
    global index_p
    global index_c
    if name[i] == stepTimeModel[(index_s)].NameOfModel
        @eval $(Symbol("StepT_$(name[i])")) = stepTimeModel[index_s].StepTime
        @eval $(Symbol("EndT_$(name[i])")) = stepTimeModel[index_s].EndSimulation
        index_s += 1 
    end
    if name[i] == variablesModels[index_v].NameOfModel
        @eval $(Symbol("StateVariable_$(name[i])")) = variablesModels[index_v].StateVariables
        @eval $(Symbol("datafile_$(name[i])")) = variablesModels[index_v].DataFile
        @eval $(Symbol("inputs_$(name[i])")) = variablesModels[index_v].Inputs
        @eval $(Symbol("outputs_$(name[i])")) = variablesModels[index_v].Outputs
        index_v += 1 
    end
    if name[i] == functionModels[index_f].NameOfModel
        @eval $(Symbol("callSynthax_$(name[i])")) = functionModels[index_f].CallSynthax
        @eval $(Symbol("arguments_$(name[i])")) = functionModels[index_f].Arguments
        @eval $(Symbol("isFile_$(name[i])")) = functionModels[index_f].IsFile
        index_f += 1
    end
    if name[i] == pathModels[index_p].NameOfModel
        @eval $(Symbol("file_$(name[i])")) = pathModels[index_p].PathToFile
        index_p += 1
    end
    if name[i] == performancesModels[index_c].NameOfModel
        @eval $(Symbol("perfs_$(name[i])")) = performancesModels[index_c].performances
        index_c += 1
    end
end

#----- UIM parsing
if getkey(data[Firstkey[1]]["Interaction_Data"], "Function", false ) == "Function" && data[Firstkey[1]]["Interaction_Data"]["Function"]["Call"] !== nothing
    @eval $(Symbol("functions_UIM")) = copy(data[Firstkey[$1]]["Interaction_Data"]["Function"])
    push!(UIMparsing, UIMParsing("UIMCode", (@eval $(Symbol("functions_UIM"))["Call"]), (@eval $(Symbol("functions_UIM"))["Arguments"]), (@eval $(Symbol("functions_UIM"))["File"]), Directory_Main * data[Firstkey[1]]["Interaction_Data"]["Myrefdir"]))
else
    push!(UIMparsing, UIMParsing("UIMCode", nothing, nothing, nothing, nothing))
end






