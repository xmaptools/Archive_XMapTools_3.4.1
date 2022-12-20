function [T,lnKd, XCa_Gar] = NThermoGAPerchuk1985(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature for a garnet-amphibole assemblage 
% using the method of Perchuk et al., 1985. 
%
% [Values] = NThermoGAPerchuk 1985(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% >2>Garnet+Amphibole>Ravna 1991>NThermoGARavna2000>T XcaGrt XMnGrt lnKd>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 23 Oxygens for amphiboles
% 24 Oxygens for garnet
%
% Created by P. Lanari (November 2011) - TESTED & VERIFIED 16/11/11.
% Version with pre-loading... 



%   (1) Garnet  // NbOx = 24
%   (2) Amphibole // NbOx = 23

%% Garnet
NbOx = 24;

Analyse = Data(1,:);
TravMat= NaN*zeros(1,32); % Working matrix

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
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

Si_Gar = TravMat(:,23);
Ti_Gar = TravMat(:,24);
Al_Gar= TravMat(:,25); 
Fe_Gar= TravMat(:,26)+ TravMat(:,27);
Mn_Gar= TravMat(:,28);
Mg_Gar= TravMat(:,29);
Ca_Gar= TravMat(:,30); 
Na_Gar= TravMat(:,31); 
K_Gar= TravMat(:,32);



%% Amphibole
NbOx = 23;

Analyse = Data(2,:);
TravMat= NaN*zeros(1,32); % Working matrix

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
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


%% Grenat-Amphibole thermometer
Kd = (Fe_Gar/Mg_Gar)/(Fe_Amp/Mg_Amp);
lnKd = log(Kd);

XCa_Gar = Ca_Gar / (Ca_Gar + Fe_Gar + Fe_Gar + Mn_Gar);

% Perchuk and others (1985)
T = 3330/(lnKd + 2.333) - 273.15;


return






