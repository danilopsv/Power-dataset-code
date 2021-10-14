%% Gera os valores estatisticos das potencias renovaveis
%    rev. 0: 02/26/2020
%    rev. 1: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Description
% 0: Inicial
% 1: Translation and organization for publication.

%% Main Variables
% Variable      Description                                         Unit
% mae_Peol      MAE of wind power                                   W
% mae_Ppv       MAE of PV power                                     W
% mape_Peol     MAPE of wind power                                  %
% mape_Ppv      MAPE of PV power                                    %
% rmse_Peol     RMSE of wind power                                  -
% rmse_Ppv      RMSE of PV power                                    -
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Peolm,erroPeol,mae_Peol,mape_Peol,rmse_Peol,Ppvm,Ppvm_util,...
    erroPpv,mae_Ppv,mape_Ppv,rmse_Ppv]= statistic_RESpower_1(Yfpv,Y_pv,Yfeol,Y_eol)
% Gera os valores estatisticos dos dados climaticos
N=1;
erroPeol = 1000*Yfeol(1:length(Yfeol)-N+1)-Y_eol;
%mae_Peol = mae(erroPeol);
mae_Peol = sum(erroPeol)/length(erroPeol);
Peolm = mean(Y_eol);
mape_Peol = 100*mae_Peol/Peolm;
%rmse_Peol = sqrt(immse(1000*Yfeol(1:length(Yfeol)-N+1),Y_eol));
rmse_Peol=sqrt((1/length(Y_eol))*immse(1000*Yfeol(1:length(Yfeol)-N+1),Y_eol));
% Potencia fotovoltaica
% calculo da media util PV (descartar noite)
Y_pv_parcial = Y_pv;
indices = find(Y_pv<=0);
Y_pv_parcial(indices) = [];

Ppvm_util=mean(Y_pv_parcial);
erroPpv = abs(1000*Yfpv(1:length(Yfpv)-N+1)-Y_pv);
%mae_Ppv = mae(erroPpv);
mae_Ppv = sum(erroPpv)/length(erroPpv);
Ppvm = mean(Y_pv);
mape_Ppv = 100*mae_Ppv/mean(Y_pv);
%rmse_Ppv = sqrt(immse(1000*Yfpv(1:length(Yfpv)-N+1),Y_pv));
rmse_Ppv=sqrt((1/length(Y_pv))*immse(1000*Yfpv(1:length(Yfpv)-N+1),Y_pv));
end