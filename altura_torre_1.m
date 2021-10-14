%%  WIND SPEED HEIGHT CONVERSION
%    rev. 0: 01/20/2020  
%    rev. 1: 10/04/2021 
%    author: Danilo Silva,
%    Federal University of Espirito Santo
% Description
% 0: Initial
% 1: Translation and organization for publication. 

%% Variables list

% Inputs:
% - wind speed (m/s)
% - forecasted speed (m/s),

% Outputs:
% - wind speed at wind turbine height (m/s)
% - forecasted speed at wind turbine height (m/s), 

% H - Weather station height (m)
% Ht - Wind turbine height (m)
% z0 - roughness coefficient
% alfa - friction coefficient 

function [velt, velft]=altura_torre(opt,vel,velf)

H =  10; 
Ht = 20; 
z0 = 1; 
alfa = 0.40; 

if opt == 0
    %% Option 1 - European
    velt = vel*(log(Ht/z0)/log(H/z0));    
    velft = velf*(log(Ht/z0)/log(H/z0));
else
    %% Option 2 - American
    velt = vel*(Ht/H)^alfa;    
    velft = velf*(Ht/H)^alfa;
end

end