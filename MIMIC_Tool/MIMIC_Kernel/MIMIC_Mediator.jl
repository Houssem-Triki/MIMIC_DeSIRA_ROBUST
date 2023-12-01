##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
## The models and components structure are created and initialised in MIMIC_mediatore

#------------------------------------------------------------------------------------
#-------------------------------------Mediator---------------------------------------
#------------------------------------------------------------------------------------
# Declaring the mediator structure
abstract type MediatorMother end
abstract type ComposMother end
mutable struct Mediator <: MediatorMother
    component::Vector
    Myschedule:: Vector
    Notify::Any
    Addcomponent::Any
    RemoveComponent::Any
    MyScheduling::Any
    function Mediator()
        self = new()
        self.component = Vector{ComposMother}(undef,1)
        self.Notify= function (sender,message::String)
            println(message)
        end            
        self.Addcomponent= function (self::Mediator, component::ComposMother)
            push!(self.component, component)
        end
        self.RemoveComponent = function ()
            println("Uwu")
        end
        return self
    end
end

#------------------------------------------------------------------------------------
#------------------------------------- Models ---------------------------------------
#------------------------------------------------------------------------------------
# Model's costructor
# IMPORTANT : Rajouter: {Status  = ["Not Started", "In Progress", "Done"]} // Change step size to 
mutable struct ModelConstructor <: ComposMother
    MyMediator::MediatorMother
    add_mediator::Function
    notifyC::Function
    NameOfModel::String
    Stepsize::Float64
    state_variables::Vector
    CurrentCycle::Float64
    LastCycle::Float64
    FunctionName::Symbol
    Arguments::Any
    ArgValue::Any
    Outputs::Any
    IsFileOrNot::Any
    call::Function
    status::String
    PathFile::Any
    Performance::Bool
    function ModelConstructor()
        self = new()
        self.MyMediator = Mediator()
        self.add_mediator = function (self::ModelConstructor,mediator::MediatorMother)
            self.MyMediator = mediator
        end
        self.notifyC = function (self::ModelConstructor,msg::String)
            self.MyMediator.Notify(self,msg)
        end
        self.call = function ()
            FuncName = self.FunctionName
            global FuncArg = self.ArgValue
            if self.Performance == true
                if FuncArg === nothing
                    @timeit to "$(self.NameOfModel)" (@eval $FuncName())
                else
                    @timeit to "$(self.NameOfModel)" (@eval $FuncName(FuncArg...))
                end
            else
                if FuncArg === nothing
                    @eval $FuncName()
                else
                    @eval $FuncName(FuncArg...)
                end
            end
        end
        return self
    end
end

#------------------------------------------------------------------------------------
#-------------------------------------Kernel Components------------------------------
#------------------------------------------------------------------------------------
#----  Interaction System States Server (ISS) 
mutable struct MIMIC_ISS <: ComposMother
    MyMediator::MediatorMother
    add_mediator::Function
    notifyC::Function
    NameOfComponent::String
    Arguments::Any
    ArgValue::Any
    Outputs::Any
    IsFileOrNot::Any
    FunctionName::Symbol
    call::Function
    modelTotranslate::String
    PathFile::Any
    Performance::Bool
    function MIMIC_ISS()
        self = new()
        self.MyMediator = Mediator()
        self.add_mediator = function (self::MIMIC_ISS,mediator::MediatorMother)
            self.MyMediator = mediator
        end
        self.notifyC = function (self::MIMIC_ISS,msg::String)
            self.MyMediator.Notify(self,msg)
        end
        self.call = function ()
            FuncName = self.FunctionName
            global modelname = self.modelTotranslate
            updateUIM()
            global FuncArg = self.ArgValue
            if self.Performance == true
                if FuncArg === nothing
                    @timeit to "ISS" (@eval $FuncName())
                else
                    @timeit to "ISS" (@eval $FuncName(FuncArg..., modelname))
                end
            else
                if FuncArg === nothing
                    @eval $FuncName()
                else
                    @eval $FuncName(FuncArg..., modelname)
                end
            end
        end
        return self
    end
end

#---- Interaction State & Data Recorder (ISDR) 
mutable struct MIMIC_ISDR <: ComposMother
    MyMediator::MediatorMother
    add_mediator::Function
    notifyC::Function
    NameOfComponent::String
    Arguments::Any
    ArgValue::Any
    Outputs::Any
    call::Function
    PersonalCall::Function
    PathFile::Any
    Performance::Bool
    function MIMIC_ISDR()
        self = new()
        self.MyMediator = Mediator()
        self.add_mediator = function (self::MIMIC_ISDR,mediator::MediatorMother)
            self.MyMediator = mediator
        end
        self.notifyC = function (self::MIMIC_ISDR,msg::String)
            self.MyMediator.Notify(self,msg)
        end
        self.call = function ()
            updateISDR()
            global FuncArg = self.ArgValue
            global FuncArg2 = self.PathFile
            global FuncArg3 = self.Arguments
            if self.Performance == true
                @timeit to "ISDR" results(FuncArg, FuncArg2, FuncArg3)
            else
                results(FuncArg, FuncArg2, FuncArg3)
            end
        end
        self.PersonalCall = function (Path)
            updateISDR()
            dt = now();
            dt = Dates.format(dt, "yyyy_mm_dd__HH_MM_SS") ;
            global FuncArg = self.ArgValue;
            global FuncArg2 = Path * "\\Result_" * dt * ".CSV";
            if self.Performance == true
                @timeit to "ISDR" results(FuncArg, FuncArg2)
            else
                results(FuncArg, FuncArg2)
            end
        end
        return self
    end
end

#---- Cycle Synchronizer (CS)  
mutable struct MIMIC_CS <: ComposMother
    MyMediator::MediatorMother
    add_mediator::Function
    notifyC::Function
    Myschedule:: Vector
    MyScheduling::Function
    NameOfComponent::String
    Arguments::Any
    ArgValue::Any
    Outputs::Any
    call::Function
    PathFile::Any
    Performance::Bool
    function MIMIC_CS()
        self = new()
        self.MyMediator = Mediator()
        self.add_mediator = function (self::MIMIC_CS,mediator::MediatorMother)
            self.MyMediator = mediator
        end
        self.notifyC = function (self::MIMIC_CS,msg::String)
            self.MyMediator.Notify(self,msg)
        end
        self.MyScheduling = function(Simulation_Time, Scheduled_tasks_List)
            if self.Performance == true
                @timeit to "CS" TaskExecution(Simulation_Time, Scheduled_tasks_List)
            else
                TaskExecution(Simulation_Time, Scheduled_tasks_List)
            end
        end
        return self
    end
end

#---- 
mutable struct MIMICParameters <: ComposMother
    MyMediator::MediatorMother
    add_mediator::Function
    notifyC::Function
    function MIMICParameters()
        self = new()
        self.MyMediator = Mediator()
        self.add_mediator = function (self::MIMICParameters,mediator::MediatorMother)
            self.MyMediator = mediator
        end
        self.notifyC = function (self::MIMICParameters,msg::String)
            self.MyMediator.Notify(self,msg)
        end
        return self
    end
end

#------------------------------------------------------------------------------------
#-----------------------------------inttialisation I --------------------------------
#------------------------------------------------------------------------------------
# Initialisation of the components handled by the mediator
mediator = Mediator()
CompMIMIC_ISS = MIMIC_ISS()
CompMIMIC_ISDR = MIMIC_ISDR()
CompMIMIC_CS = MIMIC_CS()
CompMIMICParameters = MIMICParameters()

#------------------------------------------
# Adding the components and linking them to the mediator
mediator.Addcomponent(mediator, CompMIMIC_ISS)
mediator.Addcomponent(mediator, CompMIMIC_ISDR)
mediator.Addcomponent(mediator, CompMIMIC_CS)
mediator.Addcomponent(mediator, CompMIMICParameters)

#------------------------------------------
# Linking the components to the mediator
CompMIMIC_ISS.add_mediator(CompMIMIC_ISS, mediator)
CompMIMIC_ISDR.add_mediator(CompMIMIC_ISDR, mediator)
CompMIMIC_CS.add_mediator(CompMIMIC_CS, mediator)
CompMIMICParameters.add_mediator(CompMIMICParameters, mediator)

#------------------------------------------------------------------------------------
#-----------------------------------inttialisation II--------------------------------
#------------------------------------------------------------------------------------
for i in 1:NumberOfModels
    @eval $(Symbol("Model_$(name[i])")) = ModelConstructor()                                                    
    mediator.Addcomponent(mediator, (@eval $(Symbol("Model_$(name[i])"))))                                      
    if isdefined(Main, Symbol(eval("Model_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).NameOfModel = name[i]
    end
    if isdefined(Main, Symbol(eval("Model_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).add_mediator((@eval $(Symbol("Model_$(name[i])"))), mediator)         
    end
    if isdefined(Main, Symbol(eval("StepT_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).Stepsize = eval(Symbol("StepT_$(name[i])")) 
        (@eval $(Symbol("Model_$(name[i])"))).CurrentCycle = 0
        (@eval $(Symbol("Model_$(name[i])"))).LastCycle = eval(Symbol("EndT_$(name[i])"))
    end  
    if isdefined(Main, Symbol(eval("StateVariable_$(name[i])")))   
        (@eval $(Symbol("Model_$(name[i])"))).state_variables = eval(Symbol("StateVariable_$(name[i])")) 
    end
    if isdefined(Main, Symbol(eval("outputs_$(name[i])")))   
        (@eval $(Symbol("Model_$(name[i])"))).Outputs = eval(Symbol("outputs_$(name[i])")) 
    end
    if isdefined(Main, Symbol(eval("callSynthax_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).FunctionName = Symbol(eval(Symbol("callSynthax_$(name[i])")))          
    end
    if isdefined(Main, Symbol(eval("arguments_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).Arguments = (eval(Symbol("arguments_$(name[i])")))         
        (@eval $(Symbol("Model_$(name[i])"))).IsFileOrNot = (eval(Symbol("isFile_$(name[i])"))) 
    end
    if isdefined(Main, Symbol(eval("file_$(name[i])")))
        (@eval $(Symbol("Model_$(name[i])"))).PathFile = Directory_Main * (eval(Symbol("file_$(name[i])")))
        if @eval $(Symbol("Model_$(name[i])")).NameOfModel != name[1]
            include(@eval $(Symbol("Model_$(name[i])")).PathFile)
        end
    end
    # Components Initialisation
    if isdefined(Main, Symbol(eval("perfs_$(name[i])")))
        @eval $(Symbol("Model_$(name[i])")).Performance = @eval $(Symbol("perfs_$(name[i])"))
    end
end

Symbol(UIMparsing[1].CallSynthax)


CompMIMIC_ISS.Performance = @eval $(Symbol("perfs_$(name[1])"))
CompMIMIC_ISDR.Performance = @eval $(Symbol("perfs_$(name[1])"))
CompMIMIC_CS.Performance = @eval $(Symbol("perfs_$(name[1])"))

#---- UIM Initialisation
function updateUIM()
    if CompMIMIC_ISS.Arguments !== nothing && CompMIMIC_ISS.IsFileOrNot == false
        CompMIMIC_ISS.ArgValue = (eval(Meta.parse(CompMIMIC_ISS.Arguments)))
    elseif CompMIMIC_ISS.Arguments !== nothing && CompMIMIC_ISS.IsFileOrNot == true
        CompMIMIC_ISS.ArgValue = tuple(CompMIMIC_ISS.Arguments)
    end
end

if UIMparsing[1].CallSynthax !== nothing
    CompMIMIC_ISS.NameOfComponent = "Interaction System States Server"
    CompMIMIC_ISS.Arguments = UIMparsing[1].Arguments
    CompMIMIC_ISS.FunctionName = Symbol(UIMparsing[1].CallSynthax)
    CompMIMIC_ISS.IsFileOrNot = UIMparsing[1].IsFile
    CompMIMIC_ISS.PathFile = UIMparsing[1].PathToFile
    updateUIM()
    include(CompMIMIC_ISS.PathFile)
end


# ---- ISDR Initialisation
function updateISDR()
    if CompMIMIC_ISDR.Arguments !== nothing 
        CompMIMIC_ISDR.ArgValue = []
        for i in eachindex(CompMIMIC_ISDR.Arguments)
            push!(CompMIMIC_ISDR.ArgValue, eval(Symbol(CompMIMIC_ISDR.Arguments[i])))
        end
    elseif CompMIMIC_ISDR.Arguments !== nothing 
        CompMIMIC_ISDR.ArgValue = tuple(CompMIMIC_ISDR.Arguments)
    end
end

dt = now();
dt = Dates.format(dt, "yyyy_mm_dd__HH_MM_SS") 
Resultfile = "\\Result_" * dt * ".CSV"
CompMIMIC_ISDR.NameOfComponent = "Interaction State & Data Recorder"
CompMIMIC_ISDR.Arguments = eval(Symbol("StateVariable_$(name[1])")) 
CompMIMIC_ISDR.PathFile = Directory_Results * Resultfile



