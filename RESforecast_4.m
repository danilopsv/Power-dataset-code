%%  geracao das previssoes de energia renov�vel
%    rev. 0A: 03/07/2019
%    rev. 0B: 03/06/2019
%    rev. 0:  03/27/2019
%    rev. 1:  04/03/2019
%    rev. 2:  04/16/2019
%    rev. 3:  01/16/2020
%    rev. 4: 10/07/2021
%    author: Danilo Silva,
%    Federal University of Espirito Santo

% Description
% 0A: Initial
% 4: Translation and organization for publication.
%%  Main Variables
% Variable      Description                                         Unit
% Yfeol         Forecasted Wind power                               kW
% Yfpv          Forecasted PV power                                 kW
% Yfres         Forecasted Wind power + PV power                    kW
% Ifres         Forecasted Wind current + PV current                kW
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Yfpv, Yfeol, Yfres, Ifres, xt_eolf, xt_pvf, kk] =  RESforecast_4(xt_pv, xt_eol,ii,qf,Pgf...
          ,velf,Y_pv,Y_eol,tensao,S_eol)

      global Ts
      N=1;
      tforecast = 1;%
      Yfpv = zeros(N,1);
      Yfeol = zeros(N,1);
      Yfres = zeros(N,1);
      Ifres = zeros(N,1);
      Xf_pv= zeros(length(qf),1);
      Xf_eol = zeros(length(velf),length(xt_eol));
      Yt1f_eol = zeros(1, length(qf));
      It1feo = zeros(1, length(qf));
      Yt1f_pv = zeros(1, length(qf));
      It1fpv = zeros(1, length(qf));
      %% Initial Conditions
      xt_pvf = xt_pv;
      xt_eolf = xt_eol;
      atual = ii;
      
      %% Forecast loop to the N horizon
      for kk = ii:1:ii+((N-1)*Ts)
          % Current value = value measured by the weather station 
          if kk == atual
              Yfres(tforecast) = (Y_pv(kk) + Y_eol(kk))/1000; %Power em kW
              Ifres(tforecast) =  Yfres(tforecast)*1000./tensao;
              % Moves to the next index of the matrix
              tforecast = tforecast+1;
              
          else
              %% Forecasted Wind Power
              Tf = qf(kk-1,1); % Degree celsius
              lambdaf = qf(kk-1,5);
              
              % Generates new MPPT for the new temperature and GHI in each iteration 
              [~, xt1_pv] = pv_sim_0(Tf, lambdaf);
              xt_pvf = round(xt1_pv,6);
              Xf_pv(kk+1,:) = round(xt1_pv,6);
              
              %% Forecasted Wind Power 
              
              uf_eol = [Pgf(kk-1) velf(kk-1)];
              [xt1_eol, ~, ~, ~, fl_eolf, ~] = mldsim(S_eol, xt_eolf', uf_eol);
              
              if ~isequal(fl_eolf,1)
                  fprintf('Error wind model flag num. %d, instant %d\n',fl_eolf, kk)
                  iff = iff+1;
                  disp(iff)
              end
              
              xt_eolf = round(xt1_eol,6);
              Xf_eol(kk+1,:) = round(xt1_eol,6);
              Yt1f_eol(kk) = round(xt1_eol(1),6);
              It1feo(kk) = round(Yt1f_eol(kk)/tensao,2); %Current (A)                           
              Yt1f_pv(kk) = round(xt1_pv,6);
              It1fpv(kk) = round(Yt1f_pv(kk)/tensao,2);
                            
              %% Armazenar as saidas previstas PV e WT no vetor de estados.
              %captura somente os valores simulados
              Yfpv(tforecast)=Yt1f_pv(kk)/1000;
              Yfeol(tforecast)=Yt1f_eol(kk)/1000;
              Yfres(tforecast) = (Yt1f_pv(kk) + Yt1f_eol(kk))/1000; %Renewable Power in kW 
              tforecast = tforecast+1;              
          end         
          
      end      
      
end


