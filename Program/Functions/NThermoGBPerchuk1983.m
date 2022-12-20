function [T,Kd] = NThermoGBPerchuk1983(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature and the Aliv content of a set 
% of chlorites, using the thermometer of Cathelineau 1988.
%
% [Temp,Aliv] = NThermoGBPerchuk1983(Data,handles);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TIO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Garnet+Biotite>Perchuk, (1983)>NThermoGBPerchuk1983>T Kd>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 
%
% Created by P. Lanari (Aout 2011) - TESTED & VERIFIED 09/08/11. 


%   (1) Garnet  // NbOx = 24
%   (2) Biotite // NbOx = 11

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



%% Biotite
NbOx = 11;

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

Si_Bio = TravMat(:,23);
Ti_Bio = TravMat(:,24);
Al_Bio= TravMat(:,25); 
Fe_Bio= TravMat(:,26)+ TravMat(:,27);
Mn_Bio= TravMat(:,28);
Mg_Bio= TravMat(:,29);
Ca_Bio= TravMat(:,30); 
Na_Bio= TravMat(:,31); 
K_Bio= TravMat(:,32);


%% Grenat-Biotite thermometer
MgFe_Bio = Mg_Bio/Fe_Bio;
MgFe_Gar = Mg_Gar/Fe_Gar;

Kd = MgFe_Gar/MgFe_Bio;
% Perchuk (1983)
T = ((3890+9.56*5)/(2.868-log(Kd)))-273.15;


return






