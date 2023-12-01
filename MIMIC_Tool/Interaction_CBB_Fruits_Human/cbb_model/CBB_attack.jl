##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
#
# Created: April 2022
#
##############################################################
### fruit_attack is used to distrubute the colonising population categories on the fruit categories. 
# And calculating the healthy fruits and attacked ones. 
#   flying_pop     :   Attacking population.
#   availableFruits  :   Number of healthy fruits.
#   newfruitsOfInterest : Actual fruits data (healthy and attacked)
# Output:
#   pn       :   Number of attacked fruits after this attack iteration
#   availableFruits :   Number of remainnig healthy fruits after this attack iteration
#   attackedFruits  :   Number of attacked fruits after this attack iteration
#   sum(attackedFruits) - flying_pop : Bailing CBB population
#
#------------------------------------------------------------------------------------------------------------------------------------------------------
function AttackOnFruits(flying_pop, newfruitsOfInterest, availableFruits)    
    HealthyVeryAppealing =round(Int64, newfruitsOfInterest.PercentageHealthyVeryAppealing * sum(availableFruits) / 100)
    HealthyAppealing = round(Int64, newfruitsOfInterest.PercentageHealthyAppealing * sum(availableFruits) / 100)
    HealthyGround = round(Int64, newfruitsOfInterest.PercentageHealthyGround * sum(availableFruits) / 100)
    # Categories of fruit's attraction 
    # 0.6 0.25 0.05 for C22
    # 0.7 0.35 0.05 for C52
    # 0.01 0.15
    AttractivityVeryAppealing   = 0.85 * (newfruitsOfInterest.PercentageHealthyVeryAppealing > 0)
    AttractivityAppealing       = 0.3 * (newfruitsOfInterest.PercentageHealthyAppealing > 0)
    AttractivityGround          = 0 * (newfruitsOfInterest.PercentageHealthyGround > 0)
    AttractivityFruits          = [AttractivityVeryAppealing, AttractivityAppealing, AttractivityGround]
    
    Ratio = round(flying_pop / sum(availableFruits), digits = 4)
    AttractivityFruits = round.(AttractivityFruits .* Ratio, digits = 4)
    # Limitations
    for i in eachindex(AttractivityFruits)
        if AttractivityFruits[i] < 0
            AttractivityFruits[i] = 0
        elseif AttractivityFruits[i] > 1
            AttractivityFruits[i] = 1
        end
    end
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Creation of attractivness
    x = 0:0.01:100
    if AttractivityFruits[1] != 0 && (AttractivityFruits[2] != 0 || AttractivityFruits[3] != 0)
        mean = 0
        sd = 15
        nOrder = 2
    elseif AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
        mean = 0
        sd = 30
        nOrder = 20
    else
        mean = 0
        sd = 0.1
        nOrder = 20
    end     
    y = - ((1/(sd*sqrt(2*π))) * exp.(-(1/2)*((x.-mean)/sd).^nOrder))
    y = (y.-minimum(y))/(maximum(y)-minimum(y))
    
    y_index1 = findall(x->x==newfruitsOfInterest.PercentageHealthyVeryAppealing , x)
    y_index1 = y_index1[1]
    y_index2 = findall(x->x==newfruitsOfInterest.PercentageHealthyAppealing , x)
    y_index2 = y_index2[1]
    y_index3 = findall(x->x==newfruitsOfInterest.PercentageHealthyGround, x)
    y_index3 = y_index3[1]
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Weight of attraction of every category
    if AttractivityFruits[1] != 0 && (AttractivityFruits[2] != 0 || AttractivityFruits[3] != 0)
        AttractivityFruits[1] *= y[ y_index1];
        AttractivityFruits[2] *= y[ y_index2];
        AttractivityFruits[3] *= y[ y_index3] ;
        if AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
            AttractivityFruits[2] /=  2;
            AttractivityFruits[3] /=  2;
        end
    elseif AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
        AttractivityFruits[2] *= y[ y_index2] ;
        AttractivityFruits[3] *= y[ y_index3] ;
    end
    AttractivityFruits = round.(AttractivityFruits, digits = 4)
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Calculation of the colonized fruits
    attackedFruits = round.(AttractivityFruits .* sum(availableFruits) )
    # Cheking if any colonizer is left without a fruit to attack
    DoubleAttack = zeros(Int64,3,1)
    if attackedFruits[1] > HealthyVeryAppealing
        DoubleAttack[1] = attackedFruits[1] - HealthyVeryAppealing
        attackedFruits[1] -= DoubleAttack[1]
    elseif attackedFruits[2] > HealthyAppealing
        DoubleAttack[2] = attackedFruits[2] - HealthyAppealing
        attackedFruits[2] -= DoubleAttack[2]
    elseif attackedFruits[3] > HealthyGround
        DoubleAttack[3] = attackedFruits[3] - HealthyVeryAppealing
        attackedFruits[3] -= DoubleAttack[3]
    end
    
    TotalAttacks = attackedFruits
    if TotalAttacks != 0
        availableFruits -= TotalAttacks
    end
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Redistrubution of colonizer
    if (DoubleAttack[1] > 0 || DoubleAttack[3] > 0 || DoubleAttack[3] > 0 )
        while (attackedFruits[1] > 0 || attackedFruits[3] > 0 || attackedFruits[3] > 0 )
            # println("availableFruits", availableFruits)
            ReAttack = AttackOnFruitsLeft(availableFruits)
            attackedFruits  = ReAttack[:,1]
            # println(attackedFruits," 3")
            availableFruits = ReAttack[:,2]
            # println(TotalAttacks," 2")
            TotalAttacks += attackedFruits
        end
    end
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    #Output
    Bailing =   flying_pop - sum(attackedFruits)
    if Bailing < 0
        Bailing = 0
    end
    z = [availableFruits, attackedFruits, Bailing]
    return(z)
end
