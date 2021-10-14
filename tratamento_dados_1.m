%%  Treatment of measured and forecasted data
%    rev. 0:  01/27/2020
%    rev. 1:  10/04/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo

% Description
% 0: Initial
% 1: Translation and organization for publication. 

%% Maind Variables
% Variable      Description                                         Unit
% handle_data	Submatrix of round data. Its a T_GHI_WS_dataset
% raw_data      Untreated data obtained by weather dataset
% raw_time      Serial date, UTC hour and local hour
% round_data	Raw data processed
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [handle_data, round_data, raw_time] = tratamento_dados_1(site)

%% Open weather dataset
while site ~= 1 && site~=2
site = input('Error, Please enter location again: ');
end
% Choose open the raw data of Natal or Santa Vitoria
if site ==1
load raw_data_Natal.mat
else
load raw_data_Santa_Vitoria.mat
end
% Data Description  in each column 
% Col	Description
% 1     Local Hour	
% 2     Temperature (ºC)	Inst,
% 3             Max,
% 4             Min,
% 5             WRF
% 6     Humidity (%)	Inst,
% 7             Max,
% 8             Min,
% 9     Dew point (ºC)	Inst,
% 10            Max,
% 11            Min,
% 12	Pressure (hPa)	Inst,
% 13            Max,
% 14            Min,
% 15	Wind speed (m/s)	,
% 16            Dir, (º)
% 17            Wind speed (WRF)
% 18            DIR (WRF)
% 19            Max Wind speed,
% 20            GHI	(kJ/m2)
% 21            GHI (W/m2)
% 22            GHI WRF (W/m2)
% 23            Chuva	(mm)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters
Tmax = 40;
Tmin = 0;
vmax = 25;
horamax = 18;
horamin = 6;

%% Purge wrong values above established limits 
for ii = 1: length(raw_data)
    %Temperature
    if raw_data(ii,2) < Tmin && raw_data(ii,2) > Tmax
        raw_data(ii,2) = mean(raw_data(:,2) );
    end
    % Wind speed
    if raw_data(ii,15) > vmax
        raw_data(ii,15) = max(raw_data(:,15) );
    end
    
    %% Purge wrong GHI data
    %All negative data equal a zero
    % There will be no solar radiation between 6 pm and 6 am.
    if raw_data(ii,1) < horamin || raw_data(ii,1) > horamax || raw_data(ii,21) < 0
        raw_data(ii,21) = 0;
    end    
    % Adjust wrong data at 6 am
    % Adjusts the relative error of 50%
    if raw_data(ii,1) == horamin && raw_data(ii,21) >3*raw_data(ii,22)
       raw_data(ii,21) = 1.5*raw_data(ii,22);
    end
    % Adjust wrong data at 6 pm
    % Adjusts the relative error of 50%
    if raw_data(ii,1) == horamax && raw_data(ii,21) > 3*raw_data(ii,22)        
        raw_data(ii,21) = 1.5*raw_data(ii,22);
    end    
end

%% Replacing NaN values with average values of the nearest numbers

indicedata=(1:size(raw_data,1))';
% Fills NaN values using a interpolation function
% Problem: the two last lines did not update and have some NaN values
data1=bsxfun(@(x,y) interp1(y(~isnan(x)),x(~isnan(x)),y),raw_data,indicedata);
% Solution: after interpolation,  insert below the last line, a auxiliary
% line without NaN values
data1 = [data1; data1(24,:)];
% Update indicedata
indicedata=(1:size(data1,1))';
% Rerun the interpolation function
data2=bsxfun(@(x,y) interp1(y(~isnan(x)),x(~isnan(x)),y),data1,indicedata);
% Delete the auxiliary line and it's done
data2(end,:)=[];

%% Rounds
round_data = [data2(:,1) round(data2(:,2:end),1)];

%% GHI unit convesrion; W/m² --> kW/m²
round_data(:,21:22) = round_data(:,21:22)/1000;

%% Final Array
    % Handle data colunms
    %Col 1: Measurement Temperature ºC
    %Col 2: Forecasted Temperature ºC
    %Col 3: Measurement wind speed m/s
    %Col 4: Forecasted wind speed m/s
    %Col 5: Measurement GHI in kW/m²
    %Col 6: Forecasted GHI in kW/m²
handle_data = [round_data(:,2) round_data(:,5) round_data(:,15) round_data(:,17) round_data(:,21) round_data(:,22)];
end

