function [T,ln_Kd,Pressure] = NThermoGBGoldman1977(Data,handles,InputVariables)
% -
% XMapTools external function
%
%
% % Created by P. Lanari (Aout 2011) 
% LAST TESTED & VERIFIED 25/08/11 from GPT1.xsl 

%   (1) Garnet  // NbOx = 12
%   (2) Biotite // NbOx = 11


% %% Input: Pressure
% Pressure = str2num(char(inputdlg('Pressure (kBar)','Input',1,{'10'})));


%% Garnet
NbOx = 12;

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
Xalm = Fe_Gar/(Fe_Gar+Mg_Gar+Mn_Gar+Ca_Gar);
Xpyr = Mg_Gar/(Fe_Gar+Mg_Gar+Mn_Gar+Ca_Gar);

if Si_Bio > 4
    tetral = 8;
else
    tetral = 4;
end

XMg_bio = Mg_Bio*4/(tetral*3);
XFe_bio = Fe_Bio*4/(tetral*3);

ln_Kd = log((Xalm/Xpyr)*(XMg_bio/XFe_bio));


% Goldman & Albee, 1977
T = sqrt((-1.4315e6)/(-ln_Kd-0.522)) - 273.15;



return






