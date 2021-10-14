# Power-dataset-code
This algorithm consists of a power simulator for photovoltaic panels and  a wind turbine. This simulator was developed using mathematical models based on the research article “Management of an island and grid-connected microgrid using hybrid economic model predictive control  with weather data”, https://doi.org/10.1016/j.apenergy.2020.115581
# Tutorial to simulate and save the RES power data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Requirements:
Matlab 2016a or later

Hysdel version 2.0.6 installed

Download hysdel, link: http://people.ee.ethz.ch/~cohysys/hysdel/download.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUTS: Natal_T_GHI_WS_dataset.mat and Santa_Vitoria_T_GHI_WS_dataset.mat

% OUTPUTS: Statistical results of weather and power data and the

% MAT file of the power data array (Section 3.2.5 of the Data in Brief (DIB) manuscript). 
This variable contains

    %Col 1: Measurement Wind power (W)
    
    %Col 2: Forecasted Wind power (W)
    
    %Col 3: Measurement photovoltaic panels (PV) power (W)
    
    %Col 4: Forecasted PV power (W)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Step 1 - Unzip the file into a selected folder (suggestion name: Power Code)

% Recommended path: 'C:\Users\User\Documents\MATLAB\hysdel-2.0.6-MINGW32_NT-5.1-i686\Power Code

% Step 2 - Copy the path of the folder of step 1

% Step 3 - Open the Matlab

% Step 4 - Paste the folder's path to the toolbar of current folder

% Step 5 - Above the current folder Matlab environmet, click on the icon "Up one Level"
          
% Step 6 - Click on the code's folder with the right mouse button and select "add to path" and "selected folders and subfolders"
        
% Step 6 - In the current folder Matlab environmet, open the code's folder and open the file PowerRES_0.m
          
% Step 7 - Run the PowerRES_0.m and insert the input values see algorithm test suggestions below
          
% Step 8 - Save the power dataset. Default name: Natal_power_dataset.mat

%          Suggestion: If the chosen location is Santa Vitoria, rename the file as Santa_vitoria_power_dataset.mat

% Optional - If you desire to save the power_data to .dat format, do this script after step 8
            
%  save ('folder's path\filename.dat','power_data','-ASCII', '-tabs')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

# ALGORITHM TESTS SUGGESTIONS
RAPID TEST:

Enter the initial simulation time (hours): 
1

Enter the final simulation time (hours): 
48

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1

Enter the initial simulation time (hours): 
1

Enter the final simulation time (hours): 
48

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 2

LONG TEST:

a)

Enter the initial simulation time (hours): 
1

Enter the final simulation time (hours): 
9092

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1

Enter the initial simulation time (hours): 
1

Enter the final simulation time (hours): 
8180

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 2

b)

Enter the initial simulation time (hours): 
3000

Enter the final simulation time (hours): 
5000

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1

Enter the initial simulation time (hours): 
4000

Enter the final simulation time (hours): 
6000

Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
