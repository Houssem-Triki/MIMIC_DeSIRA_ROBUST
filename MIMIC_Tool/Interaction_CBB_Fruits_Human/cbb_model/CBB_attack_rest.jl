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
### fruit_attack_rest simulate the attacks of the remaining fruits after the first attack iteration 
# And calculating the healthy fruits and attacked ones. 
# Input:
#   FruitsLeft  :   Number of remainnig healthy fruits 
# Output:
#   Attacks     :   Number of attacked fruits after this attack iteration
#   FruitsLeft  :   Updated Number of remainnig healthy fruits after this attack iteration
#------------------------------------------------------------------------------------------------------------------------------------------------------
function AttackOnFruitsLeft(FruitsLeft) 
    
    Attacks = [0, 0, 0]
    HealthyVeryAppealing = FruitsLeft[1]
    HealthyAppealing     = FruitsLeft[2]
    HealthyGround        = FruitsLeft[3]
    
    PercentageHealthyVeryAppealing  =   round(HealthyVeryAppealing * 100 / sum(FruitsLeft), digits = 2)
    PercentageHealthyAppealing      =   round(HealthyAppealing * 100 / sum(FruitsLeft), digits = 2)
    PercentageHealthyGround         =   round(HealthyGround * 100 / sum(FruitsLeft), digits = 2)
    
    AttractivityVeryAppealing   = 1.0 * (PercentageHealthyVeryAppealing > 0) 
    AttractivityAppealing       = 1.0 * (PercentageHealthyAppealing > 0) 
    AttractivityGround          = 1.0 * (PercentageHealthyGround > 0) 
    AttractivityFruits          = [AttractivityVeryAppealing, AttractivityAppealing, AttractivityGround]
    
    
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Creation of attractivness
    if AttractivityFruits[1] > 0 || AttractivityFruits[2] > 0 || AttractivityFruits[3] > 0
        x = 0:0.01:100
        if AttractivityFruits[1] != 0 && (AttractivityFruits[2] != 0 || AttractivityFruits[3] != 0)
            mean = 0
            sd = 15
            nOrder = 2
        elseif AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
            mean = 0
            sd = 40
            nOrder = 20
        else
            mean = 0
            sd = 0.1
            nOrder = 20
        end     
        
        y = - ((1/(sd*sqrt(2*π))) * exp.(-(1/2)*((x.-mean)/sd).^nOrder))
        y = (y.-minimum(y))/(maximum(y)-minimum(y))
        y_index1 = findall(x->x==PercentageHealthyVeryAppealing, x)
        # println(PercentageHealthyVeryAppealing)
        y_index1 = y_index1[1]
        y_index2 = findall(x->x==PercentageHealthyAppealing, x)
        y_index2 = y_index2[1]
        y_index3 = findall(x->x==PercentageHealthyGround, x)
        y_index3 = y_index3[1]
        
        #------------------------------------------------------------------------------------------------------------------------------------------------------
        # Weight of attraction of every category
        if AttractivityFruits[1] != 0 && (AttractivityFruits[2] != 0 || AttractivityFruits[3] != 0)
            AttractivityFruits[1] *= round(y[ y_index1], digits = 2)
            AttractivityFruits[2] *= y[ y_index2]
            AttractivityFruits[3] *= y[ y_index3] 
            if AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
                AttractivityFruits[2] /=  2;
                AttractivityFruits[3] /=  2;
            end
        elseif AttractivityFruits[2]!= 0 && AttractivityFruits[3]!= 0
            AttractivityFruits[2] *= y[ y_index2] ;
            AttractivityFruits[3] *= y[ y_index3] ;
        end
        # Calculation of the colonized fruits
        Attacks = round.(AttractivityFruits .* FruitsLeft )
        
        #------------------------------------------------------------------------------------------------------------------------------------------------------
        # Cheking if any colonizer is left without a fruit to attack
        DoubleAttack = zeros(Int64,3,1)
        if Attacks[1] > HealthyVeryAppealing
            DoubleAttack[1] = Attacks[1] - HealthyVeryAppealing
            Attacks[1] -= DoubleAttack[1]
        elseif Attacks[2] > HealthyAppealing
            DoubleAttack[2] = Attacks[2] - HealthyAppealing
            Attacks[2] -= DoubleAttack[2]
        elseif Attacks[3] > HealthyGround
            DoubleAttack[3] = Attacks[3] - HealthyVeryAppealing
            Attacks[3] -= DoubleAttack[3]
        end
    end
    
    #------------------------------------------------------------------------------------------------------------------------------------------------------
    # Output
    FruitsLeft -= Attacks
    z = [Attacks FruitsLeft] 
    return(z)
end