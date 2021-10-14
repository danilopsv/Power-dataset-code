%%  Simplified Photovoltaic model
%    rev. 0A: 04/09/2019
%    rev. 0: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Descriprion
% 0A: Inicial
% 0: Translation and organization for publication.
% Inputs: GHI, Temperature
% Output: approximated MPPT and updated PV state

function [Pmaxinterpolado, xt1_pv] = pv_sim_0(T, lambda)

%% Axitec PV data
Voc = 37.8;
tensaoinicial = 6*Voc;
tensaofinal = 0;
tamanhovetor = 100;
Isc = 8.71;
T = T + 273.15; % Kelvin

%% Interpolated MPPT function
[~, ~, ~, Pmaxinterpolado] = setpoint_mppt_2(tensaoinicial, tensaofinal, tamanhovetor, Isc, T, Voc, lambda);

%% States update
if lambda <= 0.01 || Pmaxinterpolado < 0
        xt1_pv = 0;        
else
        xt1_pv = round(Pmaxinterpolado,6);
end