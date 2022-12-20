function [T,ln_Kd] = NThermoCCVidal1999(Data,handles,InputVariables)
% -
% XMapTools external function
%
% XmapTools Function (version 1.4.X)
% Use this function only with XmapTools 1.4.X.
%
% (1) Chlorite / NbOx = 14;
% (2) Chloritoid / NbOx = 12;
%
%
% ! Created by P. Lanari (Aout 2011) ! 
% ! LAST TESTED & VERIFIED 08/09/11 from Vidal et al. (1999) ! 
%


%% Chlorite
NbOx = 14;

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

%% Chloritoid
NbOx = 12;

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

Si_Ctd = lesResults(1);
Ti_Ctd = lesResults(2);
Al_Ctd= lesResults(3); 
Fe_Ctd= lesResults(4)+ lesResults(5);
Mn_Ctd= lesResults(6);
Mg_Ctd= lesResults(7);
Ca_Ctd= lesResults(8); 
Na_Ctd= lesResults(9); 
K_Ctd= lesResults(10);

% Ferric content of Ctd
% Fe3 = 4-Al_Ctd;
% if Fe3>0
%     Fe_Ctd = Fe_Ctd-Fe3;
% end


%% Chlorite-Ctd thermometer
XMg_Chl = Mg_Chl/(Mg_Chl+Fe_Chl);
XFe_Chl = 1-XMg_Chl;

XMg_Ctd = Mg_Ctd/(Mg_Ctd+Fe_Ctd);
XFe_Ctd = 1-XMg_Ctd;

%ln_Kd = log((XMg_Chl*XFe_Ctd)/(XFe_Chl*XMg_Ctd));
ln_Kd = log((Fe_Ctd/Mg_Ctd)/(Fe_Chl/Mg_Chl));

T = 1977.7 / (ln_Kd + 0.971) - 273.15;

return
