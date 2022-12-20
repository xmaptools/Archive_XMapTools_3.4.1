function [T,ln_Kd,Pressure] = NThermoGCGrambling1990(Data,handles,InputVariables)
% -
% XMapTools external function
%
% XmapTools Function (version 1.4.X)
% Use this function only with XmapTools 1.4.X.
%
% (1) Garnet / NbOx = 12;
% (2) Chl / NbOx = 14;
%
%
% ! Created by P. Lanari (Octobre 2011) ! 
% ! LAST TESTED & VERIFIED 14/10/11 (not verified)
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

%% Chlorite
NbOx = 14;

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

Si_Chl = lesResults(1);
Ti_Chl = lesResults(2);
Al_Chl= lesResults(3); 
Fe_Chl= lesResults(4)+ lesResults(5);
Mn_Chl= lesResults(6);
Mg_Chl= lesResults(7);
Ca_Chl= lesResults(8); 
Na_Chl= lesResults(9); 
K_Chl= lesResults(10);



clear TravMat AtomicPer TheSum RefOx

%% Garnet-Muscovite thermometer


ln_Kd = log((Mg_Gar*Fe_Chl)/(Mg_Chl*Fe_Gar));

% Grambling, 1990. 
T =((-24156-(0.05*Pressure)-(4607*ln_Kd))/-19.02)-273.15;





return