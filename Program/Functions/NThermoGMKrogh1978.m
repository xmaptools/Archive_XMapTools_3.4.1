function [T,ln_Kd,Pressure] = NThermoGMKrogh1978(Data,handles,InputVariables)
% -
% XMapTools external function
%
%
% (1) Garnet / NbOx = 12;
% (2) Mica / NbOx = 11;
%
%
% ! Created by P. Lanari (Septembre 2011) ! 
% ! LAST TESTED & VERIFIED 08/09/11 from GPT.xls ! 
%


%% Input Variables: Pressure
Pressure = InputVariables(1);


%% Garnet
NbOx = 12;

Analyse = Data(1,:);

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass

TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
TravMat(5) = 0; % Fe2O3
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;
 
TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_Gar = lesResults(1);
Ti_Gar = lesResults(2);
Al_Gar= lesResults(3); 
Fe_Gar= lesResults(4)+ lesResults(5);
Mn_Gar= lesResults(6);
Mg_Gar= lesResults(7);
Ca_Gar= lesResults(8); 
Na_Gar= lesResults(9); 
K_Gar= lesResults(10);

 

clear TravMat AtomicPer TheSum RefOx

%% Mica
NbOx = 11;

Analyse = Data(2,:);

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass

TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
TravMat(5) = 0; % Fe2O3
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;
 
TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_Mica = lesResults(1);
Ti_Mica = lesResults(2);
Al_Mica = lesResults(3); 
Fe_Mica = lesResults(4)+ lesResults(5);
Mn_Mica = lesResults(6);
Mg_Mica = lesResults(7);
Ca_Mica = lesResults(8); 
Na_Mica = lesResults(9); 
K_Mica = lesResults(10);




%% Garnet-Muscovite thermometer
Xalm = Fe_Gar/(Fe_Gar+Mg_Gar+Mn_Gar+Ca_Gar);
Xpyr = Mg_Gar/(Fe_Gar+Mg_Gar+Mn_Gar+Ca_Gar);

ln_Kd = log((Xalm*Mg_Mica)/(Fe_Mica*Xpyr));

% Krogh & Raheim, 1978
T = (3685 + 0.0771*Pressure)/(ln_Kd+3.52) - 273.15;






return