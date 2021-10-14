%%  Photovoltaic Max Power point
%    rev. 0: 04/09/2018
%    rev. 1: 04/09/2019
%    rev. 2: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Descriprion
% 0: Inicial
% 2: Translation and organization for publication.
% Inputs: Initial voltage, final voltage, length of array, shor circuit
% current, open circuit voltage, temperature and GHI
% Outputs: approximated MPPT

function [Imppt, Pmax, Vmppt, Pmaxinterpolado] = setpoint_mppt_2(tensaoinicial, tensaofinal, tamanhovetor, Isc, T, Voc, lambda)
% Dicionário de Variávies:
% q - carga elementar = 1.60217646e-19 C
% kb - boltzman constant = 1.3806503e-23 J/K
% a (A no artigo)) - Ideality factor = 0.2464
% lambda - Global horizonta irradiance (GHI) = 1000 W/m²
% T - Temperature = 25°C ou 273.15+25 K
% Datasheet AXITEC AC-250P/156-60S 250W
% Voc - Open Circuit Voltage - 37.8 V
% Isc - Short-Circuit Current - 8.71 A
% Iph - Ideal PV current A

% Reference Voltage - Volts
% Ts - Sampling time
% P - PV array power - Whatts

%% INICIALIZAÇÃO
% Parameters
kb = 1.3806503e-23;
q = 1.60217646e-19;
a = 0.2464*1.5;
Iph = lambda*Isc;
Vpv = linspace(tensaoinicial, tensaofinal, tamanhovetor);
%Pre-allocated arrays
Ipv = zeros(length(Vpv),1);
Ppv = zeros(length(Vpv),1);
%% Photovoltaic panel equation

for k =1:length(Vpv)
    p = (Isc/exp(q*a/(kb*T)));
    r = exp((q*a/(kb*T))*(Vpv(k)/(6*Voc)));
    Ipv(k) = Iph - p*(r-1);
    
    % Instant Power
    Ppv(k) = Vpv(k)*Ipv(k);
    
    % Max PV power
    [Pmax,ii] = max(Ppv);
    Vmppt = Vpv(ii);
    Imppt = Pmax/Vmppt;
end

%% Interpolation of PV curve
n = 6;
p = polyfit(Vpv,Ppv',n);
Pmaxinterpolado = p(1).*Vpv(ii).^6+p(2).*Vpv(ii).^5+p(3).*Vpv(ii).^4+p(4).*Vpv(ii).^3+p(5).*Vpv(ii).^2+p(6).*Vpv(ii)+p(7);

end





