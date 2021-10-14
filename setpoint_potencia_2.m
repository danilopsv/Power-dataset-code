
function [Pg, vel] = setpoint_potencia_2(q)
% Creates an interpolation function to calculate the power setpoint 
% for the wind system model 

%  Revision:
%      Data       Programador          Description
%      ====       ===========          ====================================
%    03/20/2018   Danilo Silva            Initial
%    04/10/2018   Danilo Silva         Incluso de valores do algoritmo de 
%                                      leitura dos pixels da curva GERAR246
%    10/04/2021                        Translation and organization for publication. 

%% Variables list
% v: wind speed in m/s of Gerar246 wind turbine
% Pout: Output power of Gerar246 wind turbine
% n: interpolating polynomial degree
% p: interpolating polynomial coefficients
% q: input data
% vel: measurement/forecasted wind speed m/s
% Pg: Power Setpoint W

%% Gerar 246 turbine power curve
d = load('dados_eolicos.mat');
v = d.vel;
Pout = d.pot;
%% Interpolation function
n = 4;
p = polyfit(v,Pout,n);

%% wind speed dataset
vel = q;

%% Interpolation wind power
Pg = p(1).*vel.^4+p(2).*vel.^3+p(3).*vel.^2+p(4).*vel+p(5);

%% Non-negative values
for ii =1:length(Pg)
    if Pg(ii) < 0
        Pg(ii) = 0;
    end
end
end
