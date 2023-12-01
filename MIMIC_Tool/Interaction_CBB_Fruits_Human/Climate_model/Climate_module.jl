##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: April 2022
#
##############################################################
### Climate model
# Creating a module called Climate_data and exporting the environment variable.
#------------------------------------------------------------------------------------------------------------------------------------------------------

# module Climate_data
using DataFrames
using CSV
#---------------------------------------------------------------------------
Directory_Climate = @__DIR__

abstract type Climate end

mutable struct Environment <: Climate
    temperature::Vector{Float64}
    relative_humidity::Vector{Float64}
    rain::Vector{Bool}
    thermal_time::Vector{Float64}
end


# Climate
# Environment data ( to be included in the interface)
Tmean = CSV.read(Directory_Climate * "/Climat_data/Tmean.csv", DataFrame);
Hmean = CSV.read(Directory_Climate * "/Climat_data/Hmean.csv", DataFrame);
Rain = CSV.read(Directory_Climate * "/Climat_data/Rain.csv", DataFrame);

tmean = Tmean[!, 1];
hmean = Hmean[!, 1];
rain = isone.(Rain[!, 1]);
environment = Environment(tmean, hmean, rain, []);



# end