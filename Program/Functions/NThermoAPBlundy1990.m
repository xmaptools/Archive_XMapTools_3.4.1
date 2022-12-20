function [T,lnKd, Pressure, Y] = NThermoAPBlundy1990(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature for a amphibole-plagio assemblage 
% using the method of Blundy and Holland, (1990).  -WARNING WITH QUARTZ- 
%
% [Values] = NThermoAPBlundy1990(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Amphibole+Plagioclase>Blundy&Holland 1990>NThermoAPBlundy1990>T ln_Kd Pressure Y>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 23 Oxygens for amphiboles
% 8 Oxygens for plagio
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 28/10/11.
% Version with pre-loading... 


%   (1) Amphibole // NbOx = 23
%   (2) Plagioclase // NbOx = 8


%% Input Variables: Pressure
Pressure = InputVariables(1);


%% Amphibole
NbOx = 23;

Analyse = Data(1,:);
TravMat= NaN*zeros(1,32); % Working matrix

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,1,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass

TravMat(1:4) = Analyse(1:4); % Si02 TiO2Al2O3 FeO
TravMat(5) = 0; % Fe2O3
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O



for j=1:10
    TravMat(j+10) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
end
TravMat(21) = sum((TravMat(11:20) .* NumO) ./ Num); % Oxygen sum
TravMat(22) = TravMat(21) / NbOx; % ref Ox
    
TravMat(23:32) = TravMat(11:20) ./ TravMat(22);

Si_Amp = TravMat(:,23);
Ti_Amp = TravMat(:,24);
Al_Amp= TravMat(:,25); 
Fe_Amp= TravMat(:,26)+ TravMat(:,27);
Mn_Amp= TravMat(:,28);
Mg_Amp= TravMat(:,29);
Ca_Amp= TravMat(:,30); 
Na_Amp= TravMat(:,31); 
K_Amp= TravMat(:,32);



%% Plagioclase
NbOx = 8;

Analyse = Data(1,:);
TravMat= NaN*zeros(1,32); % Working matrix

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,1,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass

TravMat(1:4) = Analyse(1:4); % Si02 TiO2Al2O3 FeO
TravMat(5) = 0; % Fe2O3
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O



for j=1:10
    TravMat(j+10) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
end
TravMat(21) = sum((TravMat(11:20) .* NumO) ./ Num); % Oxygen sum
TravMat(22) = TravMat(21) / NbOx; % ref Ox
    
TravMat(23:32) = TravMat(11:20) ./ TravMat(22);

Si_Pla = TravMat(:,23);
Ti_Pla = TravMat(:,24);
Al_Pla= TravMat(:,25); 
Fe_Pla= TravMat(:,26)+ TravMat(:,27);
Mn_Pla= TravMat(:,28);
Mg_Pla= TravMat(:,29);
Ca_Pla= TravMat(:,30); 
Na_Pla= TravMat(:,31); 
K_Pla = TravMat(:,32);






%% Amphibole-Plagioclase thermometer

% non ideality parameter Y
Xab = Na_Pla/(Na_Pla+Ca_Pla+K_Pla);
Y = 0;
if Xab < .5
    Y = -8.06+25.5*(1-Xab)^2;
end

Kd = ((Si_Amp - 4)/(8 - Si_Amp))*Xab;
lnKd = log(Kd);

T = (0.6777*Pressure - 48.98 + Y)/(-0.0429 - 0.008314* lnKd) - 273.15;    



return






