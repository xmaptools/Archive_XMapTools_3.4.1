function [T, Pressure, lnKd] = NThermoGCpRavna2000Fe3(Data,handles,InputVariables)
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


%% Setup

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass



%% Garnet
NbOx = 24;

Analyse = Data(1,:);
TravMat = [];

Fe2O3_grt = 0;
FeO_grt = Analyse(4);

TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
TravMat(4) = FeO_grt;
TravMat(5) = Fe2O3_grt;
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;

TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_grt_temp = lesResults(1);
Ti_grt_temp = lesResults(2);
Al_grt_temp = lesResults(3); 
Fe_grt_temp = lesResults(4)+ lesResults(5);
Mn_grt_temp = lesResults(6);
Mg_grt_temp = lesResults(7);
Ca_grt_temp = lesResults(8); 
Na_grt_temp = lesResults(9); 
K_grt_temp = lesResults(10);

%Andradite Si4+(3)Fe3+(2)Ca2+(3)
%Ferrous   Si4+(3)Al3+(2)XX2+(3)   with XX= Fe2+ Mg2+ Ca2+ or Mn2+

Diff_grt_temp = 5 - (Si_grt_temp+Al_grt_temp);                           % + Ti ????

if Diff_grt_temp > 0                    
    Fe2_grt_temp = Fe_grt_temp - Diff_grt_temp;
    Fe3_grt_temp = Diff_grt_temp;

    if Fe2_grt_temp
        XFe3_grt_temp = Fe3_grt_temp/(Fe3_grt_temp+Fe2_grt_temp);      
    else
        XFe3_grt_temp = 1;                                       % 100% Fe3+
    end

    FeO_grt = Analyse(4) * (1-XFe3_grt_temp);
    Fe2O3_grt = Analyse(4) * XFe3_grt_temp;

else
    % bad analysis ? 
    %   --> we calculate with Fetot = Fe2+            
end


TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3 FeO
TravMat(4) = FeO_grt;
TravMat(5) = Fe2O3_grt;
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;

TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_grt = lesResults(1);
Ti_grt = lesResults(2);
Al_grt = lesResults(3); 
Fe2_grt = lesResults(4);
Fe3_grt = lesResults(5);
Mn_grt = lesResults(6);
Mg_grt = lesResults(7);
Ca_grt = lesResults(8); 
Na_grt = lesResults(9); 
K_grt = lesResults(10);



%% Cpx
NbOx = 6;

Analyse = Data(2,:);
TravMat = [];


Fe2O3_cpx = 0;
FeO_cpx = Analyse(4);

TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
TravMat(4) = FeO_cpx;
TravMat(5) = Fe2O3_cpx; 
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;

TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_cpx_temp = lesResults(1);
Ti_cpx_temp = lesResults(2);
Al_cpx_temp = lesResults(3); 
Fe_cpx_temp = lesResults(4)+ lesResults(5);
Mn_cpx_temp = lesResults(6);
Mg_cpx_temp = lesResults(7);
Ca_cpx_temp = lesResults(8); 
Na_cpx_temp = lesResults(9); 
K_cpx_temp = lesResults(10);


if Si_cpx_temp <= 2
    Si_T1_Temp = Si_cpx_temp;
    Al_T1_Temp = 2 - Si_cpx_temp;
    Xcats_Temp = Al_T1_Temp / 2;
else
    Si_T1_Temp = Si_cpx_temp;
    Al_T1_Temp = 0;
    Xcats_Temp = 0;
end

Al_M1_Temp = Al_cpx_temp - Al_T1_Temp;

Diff23_cpx_temp = Na_cpx_temp - (Al_M1_Temp - Xcats_Temp);

if Diff23_cpx_temp > 0  
    Fe3_Temp = Na_cpx_temp - (Al_M1_Temp - Xcats_Temp);
    Fe2_Temp = Fe_cpx_temp - Fe3_Temp;
    XFe3_cpx = Fe3_Temp/(Fe3_Temp+Fe2_Temp);

    Fe2O3_cpx = Analyse(4) * XFe3_cpx;
    FeO_cpx = Analyse(4) * (1-XFe3_cpx);
else
    % Fetot = Fe2+
end


% Recalculation with Fe2+ and Fe3+

TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
TravMat(4) = FeO_cpx;
TravMat(5) = Fe2O3_cpx; 
TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

AtomicPer = TravMat./Cst.*Num;

TheSum = sum((AtomicPer .* NumO) ./ Num);
RefOx = TheSum/NbOx;

lesResults = AtomicPer / RefOx;

Si_cpx = lesResults(1);
Ti_cpx = lesResults(2);
Al_cpx = lesResults(3); 
Fe2_cpx = lesResults(4); 
Fe3_cpx = lesResults(5);
Mn_cpx = lesResults(6);
Mg_cpx = lesResults(7);
Ca_cpx = lesResults(8); 
Na_cpx = lesResults(9); 
K_cpx = lesResults(10);



%% Grenat-Cpx thermometer


% Ravna, (2000)

XCa_Gar = Ca_grt/(Fe2_grt+Mg_grt+Ca_grt+Mn_grt);
XMn_Gar = Mn_grt/(Fe2_grt+Mg_grt+Ca_grt+Mn_grt);
XMg_Gar = Mg_grt/(Fe2_grt+Mg_grt);                          % + Ca & Mn ???

Kd = (Fe2_grt/Mg_grt)/(Fe2_cpx/Mg_cpx);
lnKd = log(Kd);

T = ((1939.9 + 3270*XCa_Gar - 1396*XCa_Gar^2 + 3319*XMn_Gar - 3535*XMn_Gar^2 ...
    + 1105*XMg_Gar - 3561*XMg_Gar^2 + 2324*XMg_Gar^3 + 169.4*Pressure/10) ...
    / (lnKd + 1.223)) - 273.15;


return






