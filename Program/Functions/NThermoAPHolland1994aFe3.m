function [T,Pressure, Y] = NThermoAPHolland1994aFe3(Data,handles,InputVariables)
% -
% XMapTools external function
%
% This function calculates the Temperature for a amphibole-plagio assemblage 
% using the method of Holland & Blundy (1994)  -WARNING WITHOUT QUARTZ- 
%
% [Values] = NThermoAPHolland1994a(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Amphibole+Plagioclase>Holland&Blundy 1994a>NThermoAPBlundy1990>T Pressure Y>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 23 Oxygens for amphiboles
% 8 Oxygens for plagio
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 07/11/11.
% Version with pre-loading... 


%   (1) Amphibole // NbOx = 23
%   (2) Plagioclase // NbOx = 8



%% Input Variables: Pressure
Pressure = InputVariables(1);


%% Amphibole
NbOx = 23;

Analyse = Data(1,:);
TravMat= NaN*zeros(1,10); % Working matrix

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

% Pierre 27 Juillet 2012
Si = lesResults(1);
Ti = lesResults(2);
Al = lesResults(3); 
Fe = lesResults(4)+ lesResults(5);
Mn = lesResults(6);
Mg = lesResults(7);
Ca = lesResults(8); 
Na = lesResults(9); 
K = lesResults(10);


CatTotwithoutCaNaK = Si+Ti+Al+Fe+Mn+Mg;
TS = 13/CatTotwithoutCaNaK;

Si_norm = Si*TS;
Ti_norm = Ti*TS;
Al_norm = Al*TS;
Fe_norm = Fe*TS;
%Mn_norm = Mn*TS;
Mg_norm = Mg*TS;
Ca_norm = Ca*TS;
Na_norm = Na*TS;
%K_norm = K*TS;

Fe3_norm = 2*NbOx*(1-TS);

if Fe3_norm>Fe
    Fe2_norm=0;
else
    Fe2_norm=Fe_norm-Fe3_norm;
end

% end



Si_Amp = Si_norm;%lesResults(1);
Ti_Amp = Ti_norm;%lesResults(2);
Al_Amp= Al_norm;%lesResults(3); 
Fe_Amp= Fe_norm;%lesResults(4)+ lesResults(5);
Mn_Amp= lesResults(6);
Mg_Amp= Mg_norm;%lesResults(7);
Ca_Amp= Ca_norm;%lesResults(8); 
Na_Amp= Na_norm;%lesResults(9); 
K_Amp= lesResults(10);


% following Holland & Blundy 1994 Apendix (2)
cm = Si_Amp+Al_Amp+Ti_Amp+Fe_Amp+Mg_Amp+Mn_Amp-13;

XSi_T1 = (Si_Amp - 4) / 4;
XAl_T1 = (8 - Si_Amp) / 4;
XAl_M2 = (Al_Amp + Si_Amp - 8) / 2;
XK_A = K_Amp;
XV_A = 3 - Ca_Amp - Na_Amp - K_Amp - cm;
XNa_A = Ca_Amp + Na_Amp + cm - 2;
XNa_M4 = (2 - Ca_Amp - cm) / 2;
XCa_M4 = Ca_Amp/2;


%% Plagioclase
NbOx = 8;

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

R = 0.0083144;

Xab = Na_Pla/(Na_Pla+Ca_Pla+K_Pla);
Xan = Ca_Pla/(Na_Pla+Ca_Pla+K_Pla);

Y = 3;
if Xab < .5
    Y = 12*(2*Xab - 1) + 3;
end

leHaut = 78.44 + Y - 33.6*(XNa_M4) - (66.8 - 2.92*Pressure)*(XAl_M2)+78.5*(XAl_T1) + 9.4*XNa_A; 
K = (27*XNa_M4*XSi_T1*Xan)/(64*XCa_M4*XAl_T1*Xab);

T = leHaut/(0.0721 - R * log(K));
T = T-273.15; % (?C)


return






