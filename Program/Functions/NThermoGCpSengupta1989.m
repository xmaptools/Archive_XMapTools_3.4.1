function [T, Pressure, lnKd] = NThermoGCpSengupta1989(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature for a garnet-cpx assemblage 
% using the method of Sengupta (1989). 
%
% [Values] = NThermoGCpSengupta1989(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Garnet+Clinopyroxene>T- Sengupta etal 1989>NThermoGCpSengupta1989>T P lnKd>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
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



%% Grenat-Cpx thermometer


% Pattison & Newton (1989). 
Xgrs = Ca_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);
Xalm = Fe_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);
Xpyr = Mg_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);
Xspe = Mn_Gar/(Fe_Gar+Mg_Gar+Ca_Gar+Mn_Gar);

% Estimation des coefs
a = Xgrs^2 * (1.52 - 5.17*Xalm);
b = Xpyr^2 * (0.10 + 2.26*Xalm);
c = Xgrs * Xpyr * ((3.01 - 6.67 * Xalm) + 1.05 * Xgrs - 1.5 * Xpyr);
d = Xgrs * Xspe * (0.98 - 4.08 * Xalm);
e = Xpyr * Xspe * (0.02 + 3.71 * Xalm);

yFe = exp(a+b+c+d+e);

a = Xalm^2 * (1.23 - 2.26 * Xpyr);
b = Xspe^2 * (-0.26 + 3 * Xpyr);
c = Xgrs * Xalm * ((3.53 - 4.85 * Xpyr) + 2.58 * Xalm - 2.58 * Xgrs);
d = Xalm * Xspe * (1.30 - 2.75 * Xpyr) + 0.78 * Xspe^2;
e = Xgrs * Xspe * (1.27 + 3*Xpyr);

yMg = exp(a+b+c+d+e);


Kd = (Fe_Gar/Mg_Gar)/(Fe_Cpx/Mg_Cpx);
lnKd = log(Kd);

T = (3030 + 10.86*Pressure) / (lnKd + 1.9034 + log(yFe) - log(yMg)) - 273.15;

return






