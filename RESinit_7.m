%%  Dataset initialization
% Setup the simulation time, initial conditions and array creations and
% wind and PV power initialization
%    rev. 0: 04/06/2018
%    rev. 1: 04/09/2019
%    rev. 2: 04/16/2019
%    rev. 3: 09/16/2019
%    rev. 4: 11/01/2019
%    rev. 5: 01/16/2020
%    rev. 6: 15/16/2020
%    rev. 7: 10/04/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Descriprion
% 0: Initial
% 7: Translation and organization for publication.

%% Main Variables
% Variable      Description                                         Unit
% T             Temperature                                         ºC
% Ts            Sampling time                                       h
% Y_eol         Measurement Wind power                              W
% Y_pv          Measurement PV power                                W
% Yfeol         Forecasted Wind power                               kW
% Yfpv          Forecasted PV power                                 kW
% lambda        Global horizontal irradiance                        kW/m²
% S_eol         MLD model of wind turbine	
% ll            Initial hour input by user	
% nn            Final hour input by user
% q             User-chosen weather data range for simulation       -
% raw_time      Serial date, UTC hour and local hour
% round_data	Full weather data rounded obtained through the 
%               weather dataset                                     -
% tensao        PV Voltage                                          V
% vel           wind speed                                          m/s
% velf          forecasted wind speed                               m/s
% Final_Date	Final date chosen by user	
% Final_hour	UTC Hour of the final date	
% Init_Date     Initial date chosen by user	
% Init_hour     UTC Hour of the initial date	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [S_eol, qf, q, Pgf, Pg, vel, velf, xt_eol, xt_pv, X_eol, D_eol,Y_eol, Ieo, X_pv,Y_pv,...
    u_pv, Ipv, round_data] = RESinit_7()
%% GENERATE THE  WIND SYSTEM MLD MODEL
eolico_4
S_eol=S;
N=1;
%% Input the simulation time
ll = input('Enter the initial simulation time (hours): \n'); %(1, 145, 289,...day*144+1)
nn = input('Enter the final simulation time (hours): \n');
while nn <= ll+N || nn > 9093-N % Length of Weather dataset of Natal
    nn = input('Error, Value must be greater than initial value and \n less than 9093 hours. Please Retype:  ');
end
site = input('Enter the location number: 1 - Natal; 2 - Santa Vitoria do Palmar: \n');

% INMEP handle data
% Handle data colunms
%Col 1: Measurement Temperature ºC
%Col 2: Forecasted Temperature ºC
%Col 3: Measurement wind speed m/s
%Col 4: Forecasted wind speed m/s
%Col 5: Measurement GHI in kW/m²
%Col 6: Forecasted GHI in kW/m²
[handle_data, round_data, raw_time] = tratamento_dados_1(site);
% If the local is Santa Vitoria do Palmar, update the length os array
% The number of lines of Natal weather dataset is bigger than
% Santa Vitoria do Palmar weather dataset.
if nn > length(round_data)
    nn=length(round_data);
end
% diplay the date and hour
Init_Date = datestr(raw_time(ll,1));
Final_Date = datestr(raw_time(nn,1));
Init_hour= raw_time(ll,2);
Final_hour= raw_time(nn,2);
smallSubstring = '0120';

if ~isempty(strfind(Init_Date, smallSubstring))
    Init_Date=strrep(Init_Date, smallSubstring, '2020');
else
    Init_Date=strrep(Init_Date, '0121', '2021');
end

if ~isempty(strfind(Final_Date, smallSubstring))
    Final_Date=strrep(Final_Date, smallSubstring, '2020');
else
    Final_Date=strrep(Final_Date, '0121', '2021');
end
fprintf('\nInitial date: %s at %2.0f hours UTC. \n', Init_Date, Init_hour)
fprintf('Final date: %s at %2.0f hours UTC.\n', Final_Date, Final_hour)

% Round GHI
q = [round(handle_data(ll:nn+N,1:4),1) round(handle_data(ll:nn+N,5:end),3)];
qf = q;
% Others functions of the code use the forecast colunms as 1, 3, and 5.
qf(:,1) = qf(:,2); % Forecasted Temperature
qf(:,3) = qf(:,4); % Forecasted wind speed
qf(:,5) = qf(:,6); % Forecasted GHI

%% Initian Conditions
xt_pv = 0;%Initial state of PV system
xt_eol = [0;1;0;0;0];%Initial state of wind system

%% Wind data
vel=q(:,3);% measurement wind speed
velf=qf(:,3); % forecasted wind speed

%Wind speed height conversion
opt = 1; % European equation. Otherwise american equation.
[velt, velft]=altura_torre_1(opt,vel,velf);

%Input wind power
Pg=setpoint_potencia_2(velt); %Measure value
Pgf=setpoint_potencia_2(velft); %Forecasted value

%% Array initialization
%Wind system
X_eol=zeros(length(vel),length(xt_eol));
X_eol(1,:) = xt_eol';
D_eol = false(length(vel),9);
Y_eol = zeros(length(vel),1);
Ieo = zeros(length(vel),1);

%PV system
X_pv=zeros(length(q),1);
X_pv(1,:) = xt_pv;
Y_pv = zeros(length(q),1);
u_pv = zeros(length(q),1);
Ipv = zeros(length(q),1);
end