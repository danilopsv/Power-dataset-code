%% Statistical indices of weather data
%    rev. 0: 02/26/2020
%    rev. 1: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Description
% 0: Initial
% 1: Translation and organization for publication.

%% Main Variables
% Variable      Description                                         Unit
% maeT          MAE of temperature                                  ºC
% maelambda     MAE of GHI                                          kW/m²
% maevel        MAE of wind speed                                   m/s
% mapeT         MAPE of temperature                                 %
% mapelambda	MAPE of GHI                                         %
% mapevel       MAPE of wind speed                                  %
% q             User-chosen weather data range for simulation       -                                -
% rmse_T        RMSE of temperature                                 -
% rmse_lambda	RMSE of GHI                                         -
% rmse_vel      RMSE of win speed                                   -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [velm, errovel, maevel, mapevel,rmse_vel,Tm,erroT, maeT,mapeT,rmse_T,...
    errolambda,lambdam,maelambda,mapelambda,rmse_lambda]= statistic_climatic_1(q)
%wind speed
velm = mean(q(:,3));
errovel = q(:,3)-q(:,4); %measurement - forecasted
maevel = abs(sum(errovel)/length(errovel));
mapevel = 100*maevel/mean(q(:,3));
rmse_vel=sqrt((1/length(q))*immse(q(:,3),q(:,4)));
%Temperature
Tm = mean(q(:,1));
erroT = q(:,1)-q(:,2); %measurement - forecasted
maeT = abs(sum(erroT)/length(erroT));
mapeT = 100*maeT/mean(q(:,1));
rmse_T=sqrt((1/length(q))*immse(q(:,1),q(:,2)));
% GHI
lambdam = mean(q(:,5));
errolambda = q(:,5)-q(:,6); %measurement - forecasted
maelambda = abs(sum(errolambda)/length(errolambda));
mapelambda = abs(100*maelambda/mean(q(:,5)));
rmse_lambda=sqrt((1/length(q))*immse(q(:,5),q(:,6)));
end