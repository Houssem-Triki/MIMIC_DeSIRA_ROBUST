##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
#
# Created: June 2022
##############################################################
### CBB_dynamics contains all the population dynamics that are used in the CBB model
#------------------------------------------------------------------------------------------------------------------------------------------------------
# Origin of data :  -Temperature-dependent development and survival of immature stages of the coffee berry borer Hypothenemus hampei (Coleoptera: Curculionidae)
#                   -Thermal Tolerance of the Coffee Berry Borer Hypothenemus hampei: Predictions of Climate Change Impact on a Tropical Insect Pest     
#                   -Demography and perturbation analyses of the coffee berry borer Hypothenemus hampei (Coleoptera: Curculionidae): Implications for management
#                   -A review of the biology and control of the coffee berry borer, Hypothenemus hampei (Coleoptera: Scolytidae)
function dev_rate(T_c::Real)::Float64
    ##############################################################
    # dev_rate calculate the developpement of the population for a day,
    # Depending on the daily temperature
    #
    # Inputs:
    #   T_c     :   Daily temperature
    # Output:
    #   z       :   Value of the daily developpement.
    ##############################################################
    if Threads.atomic_xchg!(isfirstcall.dev, false)
        xdata = Float64[20, 23, 25, 27, 30, 33] ;
        ydata = Float64[0.019, 0.032, 0.040, 0.048, 0.042, 0] ;
        global interp_linear_extrap_dev = LinearInterpolation(xdata, ydata, extrapolation_bc=Line()) ;
        # println("initialisation")
    end
    z = round(interp_linear_extrap_dev(T_c), digits = 4)
    if z < 0 || T_c < 15 || T_c > 32
        z = 0
    end
    return (z)
end

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Assumption: egg laying is averaged over the lifetime of a female, it is independent of the age of the female 
# 
# Origin of data : -Temperature-dependent development and survival of immature stages of the coffee berry borer Hypothenemus hampei (Coleoptera: Curculionidae)
#                  -Thermal Tolerance of the Coffee Berry Borer Hypothenemus hampei: Predictions of Climate Change Impact on a Tropical Insect Pest 
#                   -Demography and perturbation analyses of the coffee berry borer Hypothenemus hampei (Coleoptera: Curculionidae): Implications for management
#                   -A review of the biology and control of the coffee berry borer, Hypothenemus hampei (Coleoptera: Scolytidae) 
function egg_lay(T_c::Real)::Float64
    #############################################################
    # egg_lay 
    # Inputs:
    #   T_c     :   Daily temperature
    # Output:
    #   z       :   Value of the daily developpement.
    ##############################################################
    if Threads.atomic_xchg!(isfirstcall.egg, false)
        xdata = Float64[15, 20, 23, 25, 27, 28, 29, 30, 32] ;
        ydata = Float64[0, 2, 2.5, 2.8, 3, 3, 2.5, 2, 0] ;
        global interp_linear_extrap_egg = LinearInterpolation(xdata, ydata, extrapolation_bc=Line()) ;
        # println("initialisation")
    end
    z = round(interp_linear_extrap_egg(T_c), digits = 2)
    if z < 0 || T_c < 15 || T_c > 32
        z = 0
    end
    return (z)
end

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Origin of data : -Abiotic mortality factors of the coffee berry borer (Hypothenemus hampei)
function mortality(T_c::Real, RH_c::Real)::Float64
    ##############################################################
    #                            
    # mortality calculate the death rate for every population category
    #
    # Inputs:
    #   T_c     :   Daily temperature.
    #   RH_c    :   Daily relative humidity.
    # Output:
    #   z       :   Value of the daily death rate.
    ##############################################################
    # if Threads.atomic_xchg!(isfirstcall.death, false)
    xdata = Float64[10, 15, 20, 25, 30, 35, 40, 45, 50, 55] ;
    if RH_c >= 80
        ydata = [0, 0, 2, 5, 10, 15, 25, 25, 25, 25] ;
    else
        if RH_c >= 40
            ydata = [0, 2, 5, 10, 15, 20, 25, 25, 25, 25] ;
        else
            if RH_c < 40
                ydata = [100, 100, 100, 100, 100, 100, 100, 100, 100, 100] ;
            end
        end
    end
    global interp_linear_extrap_mort = LinearInterpolation(xdata, ydata, extrapolation_bc=Line()) ;
    # println("initialisation")
    # end
    if RH_c >= 40
        z = round(interp_linear_extrap_mort(T_c) / 25 , digits = 2);
    else
        z = round(interp_linear_extrap_mort(T_c) / 100 , digits = 2);
    end
    return (z)
end

#------------------------------------------------------------------------------------------------------------------------------------------------------
# Origin of data :   -Influence of seasonal and climatic variables on coffee berry borer (Hypothenemus hampei Ferrari) flight activity in Hawaii
#                   -Temperature-Dependent Development and Emergence Pattern of Hypothenemus hampei (Coleoptera: Curculionidae: Scolytinae) From Coffee Berries
function sortie_t(T_c::Real,RH_c::Real,Rain_c::Bool)::Float64
    ##############################################################
    # sortie_t calculate the chances for every population category to leave the fruits
    # Inputs:
    #   T_c     :   Daily temperature.
    #   RH_c    :   Daily relative humidity.
    #   Rain_c  :   (0 == no raining, 1 == rainning)
    # Output:
    #   z       :   Chances of leaving the fruits.
    ##############################################################
    if Threads.atomic_xchg!(isfirstcall.flight, false)
        xdata = Float64[0, 15, 20, 23, 25, 27, 30, 32, 37, 40] ;
        ydata = Float64[0, 0, 0.06, 0.1, 0.14, 0.145, 0.1, 0, 0, 0] ;
        global interp_linear_extrap_sortie = LinearInterpolation(xdata, ydata, extrapolation_bc=Line()) ;
        # println("initialisation")
    end
    z = round(interp_linear_extrap_sortie(T_c) / 0.145, digits = 2) ;
    if RH_c < 60 && Rain_c == 0
        z = 0 ;
    else
        if RH_c < 40 && Rain_c == 1
            z = 0 ;
        end
    end
    return (z)
end

#------------------------------------------------------------------------------------------------------------------------------------------------------
#   Hypothesis : Since there is no explicit experiment for calculating such
# data, the combinaison of these observations is the best way to estimate
# this variable 
#   Origin of data :   Based on the knowledge aquired from the fellowing
#                   references : 
#                   -Development of an improved laboratory production technique for the coffee berry borer Hypothenemus hampei, using fresh coffee berries
#                   -Temperature-Dependent Development and Emergence Pattern of Hypothenemus hampei (Coleoptera: Curculionidae: Scolytinae) From Coffee Berries
#                   -A review of the biology and control of the coffee berry borer, Hypothenemus hampei (Coleoptera: Scolytidae)
#                   -Bustillo et al. 1998, Damon 2002, Jaramillo et al. 2006, Barrera 2008, Vega 2008, Vega et al. 2009)
function vie_sco(T_c::Real)::Float64
    ##############################################################
    # vie_sco calculate the lifespan for every population category
    #
    # Inputs:
    #   T_c     :   Daily temperature.
    # Output:
    #   z       :   lifespan of population category.
    ##############################################################
    if Threads.atomic_xchg!(isfirstcall.life, false)
        xdata = Float64[10, 15, 19.3, 22, 27, 30] ;
        ydata = Float64[90, 72, 53, 38, 29, 25] ;
        global interp_linear_extrap_vie = LinearInterpolation(xdata, ydata, extrapolation_bc=Line()) ;
        # println("initialisation")
    end
    z = round(interp_linear_extrap_vie(T_c)) ;
    return (z)
end

#------------------------------------------------------------------------------------------------------------------------------------------------------





