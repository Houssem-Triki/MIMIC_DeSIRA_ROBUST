##############################################################
#   This code is part of the Phd Thesis "Interactions between pest attacks and plant growth
# using a model approach applied to robusta coffee in Uganda. Effects on production"
# and the DeSira project in Uganda.
#
# Main Author: Houssem E.M TRIKI CIRAD-PHIM/AMAP
# Co authors: Marc Jaeger, Fabienne Rebeyre
# Created: June 2022
##############################################################
## MIMIC_Sceduling code, creates the list of executable taskes and manages the listing, order and execution. It is connected to the mediator

Schedul_status_values = ["Not Scheduled", "Ready", "In Queue", "Completed"]
mutable struct Tasks_Desk
    TaskName
    NextStepValue
    lastCall
    TimeOfCall
    Status
end
tasks_desk_list = []

# ---- MIMIC Info
Init_time = 0;

#----------------------------------------------------- Task List (All task history)
function TaskListCreation(active_model, Time_cycle)
    if active_model.LastCycle > Time_cycle
        push!(tasks_desk_list, [length(tasks_desk_list)+1 Tasks_Desk(active_model.NameOfModel, active_model.Stepsize, active_model.CurrentCycle, active_model.CurrentCycle+active_model.Stepsize, Schedul_status_values[1])])
        # Mise à jour des données
    end
    return tasks_desk_list
end

for i in 2:lastindex(name)
    TaskListCreation(eval(Symbol("Model_$(name[i])")), Init_time)
end

#----------------------------------------------------- Ordering List (ReOrder the task by calling order)
function ListOrdering(list) # Priority
    sort!(list, by = x -> x[:][2].TimeOfCall)
    for i in eachindex(list)
        list[i][1] = i
        if list[i][2].Status == Schedul_status_values[1] 
            list[i][2].Status = Schedul_status_values[2]
        end
    end
    return list
end

ListOrdering(tasks_desk_list)

#----------------------------------------------------- Scheduling (Create the scheduled tasks list)
function SchedulingTasks(list)
    ScheduledTasks = []
    for i in eachindex(list)
        if list[i][2].Status == Schedul_status_values[2] || list[i][2].Status == Schedul_status_values[3]
            list[i][2].Status = Schedul_status_values[3]
            push!(ScheduledTasks, [length(ScheduledTasks)+1 list[i][2]])
        end
    end
    return ScheduledTasks
end
# ST is the mediator schedul list
Scheduled_tasks_List = SchedulingTasks(tasks_desk_list)

#----------------------------------------------------- Tasks status

function TasksStatus(ModelName)
    (@eval $(Symbol("Model_$ModelName"))).status = "Executed"
    CompMIMIC_ISS.modelTotranslate = ModelName
    CompMIMIC_ISS.call()
end




#----------------------------------------------------- Task execution
function ArgumentValueExtraction(ModelName)
    if (@eval $(Symbol("Model_$ModelName"))).Arguments !== nothing && (@eval $(Symbol("Model_$ModelName"))).IsFileOrNot == false
        (@eval $(Symbol("Model_$ModelName"))).ArgValue = (eval(Meta.parse((@eval $(Symbol("Model_$ModelName"))).Arguments)))
    elseif (@eval $(Symbol("Model_$ModelName"))).Arguments !== nothing && (@eval $(Symbol("Model_$ModelName"))).IsFileOrNot == true
        (@eval $(Symbol("Model_$ModelName"))).ArgValue = tuple(Directory_Main * (@eval $(Symbol("Model_$ModelName"))).Arguments)
    end
end


function TaskExecution(Time_cycle, Scheduled_tasks_List)
    aa = false
    for i in eachindex(Scheduled_tasks_List)
        if Scheduled_tasks_List[i][2].TimeOfCall <= Time_cycle && Scheduled_tasks_List[i][2].Status == Schedul_status_values[3]
            Scheduled_tasks_List[i][2].Status = Schedul_status_values[4]
            MName = Scheduled_tasks_List[i][2].TaskName
            (@eval $(Symbol("Model_$MName"))).CurrentCycle = Time_cycle
            ArgumentValueExtraction(MName)
            if (@eval $(Symbol("Model_$MName"))).FunctionName !== :nothing 
            (@eval $(Symbol("Model_$MName"))).Outputs = (@eval $(Symbol("Model_$MName"))).call()
            TasksStatus(MName)
            end
            tasks_desk_list = TaskListCreation(eval(Symbol("Model_$MName")), Time_cycle)
            tasks_desk_list = ListOrdering(tasks_desk_list)
            aa = true
        end
        if i == length(Scheduled_tasks_List) && aa ==true
            global tasks_desk_list
            Scheduled_tasks_List = SchedulingTasks(tasks_desk_list)
        end
    end
    return Scheduled_tasks_List
end








