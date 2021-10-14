%%  Simulation of photovoltaic and wind power data 
%    
%    rev. 0A: 04/15/2020
%    rev. 0: 10/04/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Descriprion
% 0A: Initial.
% 0:  Translation and organization for publication. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Tutorial to simulate and save the RES power data
% This algorithm consists of a power simulator for photovoltaic panels and  
% a wind turbine. This simulator was developed using mathematical models 
% based on the research article “Management of an island and grid-connected 
% microgrid using hybrid economic model predictive control 
% with weather data”, https://doi.org/10.1016/j.apenergy.2020.115581

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Requirements:
% Matlab 2016a or later
% Hysdel version 2.0.6 installed
% download hysdel, link: http://people.ee.ethz.ch/~cohysys/hysdel/download.html

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUTS: raw_data_Natal.mat and raw_data_Santa_Vitoria.mat

% OUTPUTS: Statistical results of weather and power data and the
% MAT file of the power data array (Section 3.2.5 of the Data in Brief 
% (DIB) manuscript). 
% This variable contains
    %Col 1: Measurement Wind power (W)
    %Col 2: Forecasted Wind power (W)
    %Col 3: Measurement photovoltaic panels (PV) power (W)
    %Col 4: Forecasted PV power (W)
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Step 1 - Unzip the file into a selected folder (suggestion name: Power Code)
% Recommended path:
% 'C:\Users\User\Documents\MATLAB\hysdel-2.0.6-MINGW32_NT-5.1-i686\Power Code
% Step 2 - Copy the path of the folder of step 1
%
% Step 3 - Open the Matlab
%
% Step 4 - Paste the folder's path to the toolbar of current folder
% 
% Step 5 - Above the current folder Matlab environmet, click on the icon 
%           "Up one Level"
% Step 6 - Click on the code's folder with the right mouse button and  
%          select "add to path" and "selected folders and subfolders"
% Step 6 - In the current folder Matlab environmet, open the code's folder 
%          and open the file PowerRES_0.m
% Step 7 - Run the PowerRES_0.m and insert the input values
%          see algorithm test suggestions below
% Step 8 - Save the power dataset. Default name: Natal_power_dataset.mat
%          Suggestion: If the chosen location is Santa Vitoria, rename the 
%          file as Santa_vitoria_power_dataset.mat
%
% Optional - If you desire to save the power_data to .dat format, 
%            do this script after step 8
%  save ('folder's path\filename.dat','power_data','-ASCII', '-tabs')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ALGORITHM TESTS SUGGESTIONS
% RAPID TEST:
% Enter the initial simulation time (hours): 
% 1
% Enter the final simulation time (hours): 
% 48
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1
%
% Enter the initial simulation time (hours): 
% 1
% Enter the final simulation time (hours): 
% 48
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 2
% 
% LONG TEST:
% a)
% Enter the initial simulation time (hours): 
% 1
% Enter the final simulation time (hours): 
% 9092
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1
%
% Enter the initial simulation time (hours): 
% 1
% Enter the final simulation time (hours): 
% 8180
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 2
%
% b)
% Enter the initial simulation time (hours): 
% 3000
% Enter the final simulation time (hours): 
% 5000
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1
%
% Enter the initial simulation time (hours): 
% 4000
% Enter the final simulation time (hours): 
% 6000
% Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: 1

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Main Variables
% Variable      Description                                         Unit
% Ieo           Wind current                                        A
% Ipv           PV current                                          A
% Peolm         Average of wind power                               W
% Ppvm          Average of PV power                                 W
% T             Temperature                                         ºC
% Tm            Average of temperature                              ºC
% Ts            Sampling time                                       h
% Y_eol         Measurement Wind power                              W
% Y_pv          Measurement PV power                                W
% Yfeol         Forecasted Wind power                               kW
% Yfpv          Forecasted PV power                                 kW
% erroPeol      Difference between measured wind power 
%               and forecasted wind power                           W
% erroPpv       Difference between measured PV power 
%               and forecasted PV power                             W
% erroT         Difference between measured temperature  
%               and forecasted temperature                          ºC
% errolambda	Difference between measured GHI and forecasted GHI	kW/m²
% errovel       Difference between measured wind speed 
%               and forecasted wind speed                           m/s
% lambda        Global horizontal irradiance                        kW/m²
% lambdam       Average GHI                                         kW/m²
% maeT          MAE of temperature                                  ºC
% mae_Peol      MAE of wind power                                   W
% mae_Ppv       MAE of PV power                                     W
% maelambda     MAE of GHI                                          kW/m²
% maevel        MAE of wind speed                                   m/s
% mapeT         MAPE of temperature                                 %
% mape_Peol     MAPE of wind power                                  %
% mape_Ppv      MAPE of PV power                                    %
% mapelambda	MAPE of GHI                                         %
% mapevel       MAPE of wind speed                                  %
% power_data	Array of forecasted and measurement power           W
% q             User-chosen weather data range for simulation       -
% rmse_Peol     RMSE of wind power                                  -
% rmse_Ppv      RMSE of PV power                                    -
% rmse_T        RMSE of temperature                                 -
% rmse_lambda	RMSE of GHI                                         -
% rmse_vel      RMSE of win speed                                   -
% round_data	Full weather data rounded obtained through the 
%               weather dataset                                     -
% tensao        PV Voltage                                          V
% vel           wind speed                                          m/s
% velf          forecasted wind speed                               m/s
% velm          Average of wind speed                               m/s
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Clear Matlab
close all
clear
clc

%% Improving performance
warning('off','all');

%% Global variables
global   Ts
tensao = 220;

%% Dataset initialization
[S_eol, qf, q, Pgf, Pg, vel, velf, xt_eol, xt_pv, X_eol, D_eol,Y_eol, Ieo, X_pv,Y_pv,...
    u_pv, Ipv, round_data] = RESinit_7();

%% Simulation time
Ts = 1;
iss = 0; % Error flag of wind system

%% Current and power arrays
Yres = zeros(length(qf),1);
Ires = zeros(length(qf),1);
Yfres = [];
Ifres = zeros(length(qf),1);

%% Simulation loop
for ii = 1:Ts:length(q)
    
    % Wind system simulation
    q_eol = [Pg vel];
    % improving perfomance: minimize the mldsim runs
    if ii-1 > 0
        flageo1 = prod(logical(q_eol(ii-1,:) == q_eol(ii,:)));
        flageo2 = prod(logical(X_eol(ii-1,:) == X_eol(ii,:)));
    end
    
    if ii-1 ==0
        u_eol = [Pg(ii) vel(ii)];
        [xt1_eol, dt_eol, zt_eol, yt_eol, fl_eol, eps_eol] = mldsim( S_eol, xt_eol', u_eol);
        xt_eol = round(xt1_eol,6);
        D_eol(ii,:) = dt_eol';
        X_eol(ii+1,:) = round(xt1_eol,6);
        Y_eol(ii) = yt_eol; %Wind power (W)
        Ieo(ii) = round(Y_eol(ii)/tensao,2); %Current (A)
        
    elseif flageo1 && flageo2
        D_eol(ii,:) = dt_eol';
        X_eol(ii+1,:) = xt1_eol;
        Y_eol(ii) = yt_eol;
        Ieo(ii) = round(Y_eol(ii)/tensao,2);         
    else
        u_eol = [Pg(ii) vel(ii)];
        [xt1_eol, dt_eol, zt_eol, yt_eol, fl_eol, eps_eol] = mldsim( S_eol, xt_eol', u_eol);
        
        if ~isequal(fl_eol,1)
            fprintf('Error wind model flag num. %d, instant %d\n',fl_eol, ii)
            iss = iss+1;
            disp(iss)
        end
        xt_eol = round(xt1_eol,6);
        D_eol(ii,:) = dt_eol';
        X_eol(ii+1,:) = round(xt1_eol,6);
        Y_eol(ii) = yt_eol; 
        Ieo(ii) = round(Y_eol(ii)/tensao,2);
    end
    
    %PV System simulation
    T = q(ii,1); %Degrees Celsius
    lambda = q(ii,5);
    [Pmaxinterpolado, xt1_pv] = pv_sim_0(T, lambda);
    
    xt_pv = round(xt1_pv,6);
    X_pv(ii+1) = round(xt1_pv,6);
    Y_pv(ii) = X_pv(ii);
    %% Storage the wind + PV power
    Yres(ii) = round((X_pv(ii+1) + X_eol(ii,1))/1000,6); 
    Ires(ii) = Yres(ii)*1000/tensao;
    
    %% Forecast arrays
    % Rolling condition:
    % In the 1st iteration, the arrays are created. 
    % In the next, the rolling arrays. 
    if  isempty(Yfres)==true
        
        [Yfpv, Yfeol, Yfres, Ifres, xt_eolf, xt_pvf, kk] =  RESforecast_4(xt_pv, xt_eol,ii,qf,Pgf...
            ,velf,Y_pv,Y_eol,tensao,S_eol);
        
        Yfres_old = Yfres;
        Ifres_old = Ifres;
        xt_pv_old = xt_pvf;
        xt_eol_old = xt_eolf;
        kk_old = kk;
        Yfres1 = Yfres;
        Ifres1 = Ifres;
    else
        
        % Forecast arrays rolling
        [Yt1f_pv1,Yt1f_eol1, Yfres1, Ifres1, xt_pvf1,xt_eolf1,kk1]...
            =  Disturb_forecast_update_4(xt_pv_old, xt_eol_old, Yfres_old, Ifres_old,...
            kk_old, ii, qf,Pgf,velf,S_eol,Yres,Ires);
        
        Yfres_old = Yfres1;
        Ifres_old = Ifres1;
        xt_pv_old = xt_pvf1;
        xt_eol_old = xt_eolf1;
        kk_old = kk1;
        Yfpv = [Yfpv; Yt1f_pv1];
        Yfeol = [Yfeol; Yt1f_eol1];
    end
end

%% Statistic results
% Weather data
[velm, errovel, maevel, mapevel,rmse_vel,Tm,erroT, maeT,mapeT,rmse_T,...
    errolambda,lambdam,maelambda,mapelambda,rmse_lambda]= statistic_climatic_1(q);

% Renewable power
[Peolm,erroPeol,mae_Peol,mape_Peol,rmse_Peol,Ppvm,Ppvm_util,erroPpv,...
    mae_Ppv,mape_Ppv,rmse_Ppv]= statistic_RESpower_1(Yfpv,Y_pv,Yfeol,Y_eol);

%% Display the statistic results
fprintf('\nThe average GHI is %4.3f kW/m2. \n', lambdam)
fprintf('The average wind speed is %4.2f m/s.\n', velm)
fprintf('The average temperature is %4.2f °C. \n', Tm) 
fprintf('The MAE of GHI is %4.3f kW/m2. \n', maelambda)
fprintf('The MAE of wind speed is %4.2f m/s. \n', maevel)
fprintf('The MAE of temperature is %4.2f °C. \n', maeT)
fprintf('The MAPE of GHI is %4.2f %% . \n', mapelambda)
fprintf('The MAPE of wind speed is %4.2f %% . \n', mapevel)
fprintf('The MAPE of temperature is %4.2f %% . \n', mapeT) 
fprintf('The RSME of GHI is %4.3f . \n', rmse_lambda)
fprintf('The RSME of wind speed is %4.2f . \n', rmse_vel)
fprintf('The RSME of temperature is %4.2f . \n', rmse_T)
fprintf('The average of PV power is %4.1f W. \n', Ppvm)
fprintf('The average of Wind power is %4.1f W. \n', Peolm)
fprintf('The MAE of PV power is %4.1f W. \n', mae_Ppv)
fprintf('The MAE of Wind power is %4.1f W. \n', mae_Peol)
fprintf('The MAPE of PV power is %4.1f %%. \n', mape_Ppv)
fprintf('The MAPE of Wind power is %4.1f %%. \n', mape_Peol)
fprintf('The RSME of PV power is %4.1f . \n', rmse_Ppv)
fprintf('The RSME of Wind power is %4.1f . \n', rmse_Peol)

%% Save datasets
% Power data array - Section 3.2.5 of the DIB manuscript
    %Col 1: Measurement Wind power (W)
    %Col 2: Forecasted Wind power (W)
    %Col 3: Measurement PV power (W)
    %Col 4: Forecasted PV power (W)
power_data=[Y_eol Yfeol.*1000 Y_pv Yfpv.*1000];

% Open dialog box for saving the power dataset 
% Suggestion: If the local is Santa_vitoria, 
% rename the file as Santa_vitoria_dataset.mat
uisave({'power_data'},'Natal_power_dataset')