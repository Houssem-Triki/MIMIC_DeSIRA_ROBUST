# MIMIC v 0.9 [^1]

Mediation Interface for Model Inner Coupling

## What is it?
MIMIC is a coupling tool that let you connect models through their inputs and outputs.
The fundamental assumption of the coupling is that each model operates and evaluates its own internal states in a finite amount of time, from one internal step to the next. MIMIC supervises the interaction through its own states and information, which are evaluated based on the information collected from the connected models.

 
  
## Software and Dependencies of MIMIC
In order to use this tool, you need to download Julia REPL v 1.8.5 at least. [Julia download link](https://julialang.org/downloads/).

Once installed, launch Julia. You need first to install the dependencies. 
Type `using Pkg` command in Julia REPL to installing the packages.


You can installing all the MIMIC requested packages typing :

`Pkg.add(["YAML", "Plots", "OrderedCollections", "TimerOutputs", "CSV", "DataFrames", "Interpolations"])`

In case of failure, retry package per package using the following command lines to install MIMIC's dependencies:
- YAML (write `Pkg.add("YAML")` in Julia's REPL)
- Plots (`Pkg.add("Plots")`)
- OrderedCollections (`Pkg.add("OrderedCollections")`)
- TimerOutputs (`Pkg.add("TimerOutputs")`)
- CSV (`Pkg.add("CSV")`)
- DataFrames (`Pkg.add("DataFrames")`)
- Interpolations (`Pkg.add("Interpolations")`)


## Installing MIMIC.jl
[Download](https://github.com/Houssem-Triki/MIMIC/archive/refs/heads/main.zip) the Project and unzip it in your working folder.

In Julia's REPL, change the working directory with the command `cd("D:/MyWorkingFolder/MIMIC-main/MIMIC_Tool")` to your working folder. 
(*Warning*: the command cd needs to be writen in the same synthax as the example, without special characters or spaces).

Run then the command `include("MIMIC.jl")` in order to load MIMIC's code in Julia.

## Running the example
Issued from soumission to Plant Phenomics, this example concerns CBB attacks on coffea berries. The Tree C22 data is illustrated here.
Launch the initialisation with the command `MIMICinit()`. 
Launch the simulation by typing `MIMICmain(Scheduled_tasks_List)`.

At the end of the simulation, besides the graph, the full results are available in a CSV file, located in the MIMIC-main/MIMIC_Tool/MIMIC_Results directory under the name  "Results_yyyy_mm_dd__HH_MM_SS.CSV".


## Creating your own interaction 
Interactions in MIMIC are generated from the users’ instructions, covering the following two aspects: 
1) the interaction code itself written by the user and so called UIM (User interaction Model) 
2) the control of the simulation so called UC (User simulation control). 

This mean that you can edit the two files "MIMIC_UIM.jl" for the interaction code and "MIMIC_UC.yml" for your models codes. 
You can use a simple text editor or download a code editor like VScode, with the Julia addon [following this tutorial](https://code.visualstudio.com/docs/languages/julia) .

Once you defined your models and the interaction codes in MIMIC_UC and MIMIC_UIM, proceed as explicited on the example: 

Initialise first your application with `MIMICinit()`.
You can check for the scheduled tasks to be executed by putting the following command: `Scheduled_tasks_List` . 
Then launch the simulation with `MIMICmain(Scheduled_tasks_List)`

## Reference
To com, submitted to Plant Phenomics, currently under review

[^1]: *Readme.ml v0.9 2023/04/21*
[^2]: *References Abstract for PMA2022
[^3]: *References Presentation for PMA2022
