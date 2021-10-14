%%  Rooling forecast array
% Discard the first instant and add the new forecast instant at the end of
% the array
%    rev. 0: 04/03/2019
%    rev. 1: 04/16/2019
%    rev. 2: 11/04/2019
%    rev. 3: 01/20/2020
%    rev. 4: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% 0A: Initial
% 4: Translation and organization for publication.
%% Variables list

function [Yt1f_pv1,Yt1f_eol1, Yfres1, Ifres1, xt_pvf1,xt_eolf1,kk1]...
    =  Disturb_forecast_update_4(xt_pv_old, xt_eol_old, Yfres_old, Ifres_old,...
    kk_old, ii, qf,Pgf,velf,S_eol,Yres,Ires)

global Ts
iff=0;
tforecast = 1;
Yfres1 = zeros(2,1);
Ifres1 = zeros(2,1);
Yt1f_eol = zeros(1, length(qf));
It1feo = zeros(1, length(qf));
Yt1f_pv = zeros(1, length(qf));
It1fpv = zeros(1, length(qf));
Xf_pv= zeros(length(qf),4);
Xf_eol = zeros(length(velf),length(xt_eol_old));
%% Initial Conditions
xt_pvf1 = xt_pv_old;
xt_eolf1 = xt_eol_old;
% Parameters
tensao = 220;
atual = kk_old;

%% Next instant forecast
for kk1 = kk_old:1:kk_old+Ts
    if kk1 == atual
        
        Yfres1(tforecast) = 0; %Potencia em kW
        Ifres1(tforecast) =  0;
        % O segundo valor do vetor old deve ser igual ao valor real/atual em ii
        Yfres_old(2) = Yres(ii); %Potencia em kW
        Ifres_old(2) =  Ires(ii);
        
        % Moves to the next index of the matrix
        tforecast = tforecast+1;
        
    else
        %% Forecasted PV power
        Tf = qf(kk1-1,1); % Degree Celsius
        lambdaf = qf(kk1-1,5);
        
        % Generates new MPPT for the new temperature and GHI in each iteration 
        [~, xt1_pv] = pv_sim_0(Tf, lambdaf);
        xt_pvf1 = round(xt1_pv,6);
        Xf_pv(kk1+1,:) = round(xt1_pv,6);    
        
        %% Forecasted wind power
        uf_eol = [Pgf(kk1-1) velf(kk1-1)];
        [xt1_eol, ~, ~, ~, fl_eolf, ~] = mldsim(S_eol, xt_eolf1', uf_eol);
        
        if ~isequal(fl_eolf,1)
            fprintf('Error wind model flag num. %d, instant %d\n',fl_eolf, kk1)
            iff = iff+1;
            disp(iff)
            keyboard;
        end
        
        xt_eolf1 = round(xt1_eol,6);
        Xf_eol(kk1+1,:) = round(xt1_eol,6);
        Yt1f_eol(kk1) = round(xt1_eol(1),6);
        It1feo(kk1) = round(Yt1f_eol(kk1)/tensao,2); %Current (A)
        Yt1f_pv(kk1) = round(xt1_pv,6);
        It1fpv(kk1) = round(Yt1f_pv(kk1)/tensao,2);
        
        %% Save the forecasted PV and wind power in the forecasted array. 
        %captura somente os valores simulados
        Yfres1(tforecast) = (Yt1f_pv(kk1) + Yt1f_eol(kk1))/1000; %Potencia em kW Yf_eol(kk)
        Ifres1(tforecast) = It1fpv(kk1) + It1feo(kk1);
        tforecast = tforecast+1;
        
    end
end

%% Atualizacao dos vetores
Yt1f_pv1 = Yt1f_pv(kk1)/1000;
Yt1f_eol1 = Yt1f_eol(kk1)/1000;
Yfres1 = [Yfres_old(2:end); Yfres1(end)];
Ifres1 = [Ifres_old(2:end); Ifres1(end)];
end