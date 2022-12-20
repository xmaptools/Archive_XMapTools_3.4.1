function [T, Pressure, lnKd] = NThermoGCpRavna2000(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature for a garnet-cpx assemblage 
% using the method of Ravna (2000). 
%
% [Values] = NThermoGCpRavna2000(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Garnet+Clinopyroxene>T- Ravna 2000>NThermoGCpRavna2000>T P lnKd>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 6 Oxygens for cpx
% 24 Oxygens for garnet
%
% Created by P. Lanari (November 2011) - TESTED & VERIFIED 16/11/11.
% Version with pre-loading... 


%   (1) Garnet  // NbOx = 24
%   (2) Cpx // NbOx = 6

%% Input Variables: Pressure
Pressure = InputVariables(1);


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



%% Cpx
NbOx = 6;

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

Si_Cpx = TravMat(:,23);
Ti_Cpx = TravMat(:,24);
Al_Cpx = TravMat(:,25); 
Fe_Cpx = TravMat(:,26)+ TravMat(:,27);
Mn_Cpx = TravMat(:,28);
Mg_Cpx = TravMat(:,29);
Ca_Cpx = TravMat(:,30); 
Na_Cpx = TravMat(:,31); 
K_Cpx = TravMat(:,32);


if Si_Cpx <= 2
    Si_T1 = Si_Cpx;
    Al_T1 = 2 - Si_Cpx;
    Xcats = Al_T1 / 2;
else
    Si_T1 = 2;
    Al_T1 = 0;
    Xcats = 0;
end

Al_M1 = Al_Cpx - Al_T1;

Diff23 = Na_Cpx - (Al_M1 - Xcats);

if Diff23 > 0
    Fe3_Cpx = Na_Cpx - (Al_M1 - Xcats);
    Fe2_Cpx = Fe_Cpx-Fe3_Cpx;
else
    Fe3_Cpx = 0;
    Fe2_Cpx = Fe_Cpx;
end


%% Grenat-Cpx thermometer


% Ravna, (2000)

XCa_Gar = Ca_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);
XMn_Gar = Mn_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);
XMg_Gar = Mg_Gar/(Fe_Gar+Mg_Gar);

Kd = (Fe_Gar/Mg_Gar)/(Fe2_Cpx/Mg_Cpx);
lnKd = log(Kd);

T = ((1939.9 + 3270*XCa_Gar - 1396*XCa_Gar^2 + 3319*XMn_Gar - 3535*XMn_Gar^2 ...
    + 1105*XMg_Gar - 3561*XMg_Gar^2 + 2324*XMg_Gar^3 + 169.4*Pressure/10) ...
    / (lnKd + 1.223)) - 273.15;


return






