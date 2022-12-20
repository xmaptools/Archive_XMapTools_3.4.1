function [P Tinput Altot] = ThermoFctAmphAnderson(Data,handles)
% -
% XmapTools Function (version 1.5)
% Use this function only with XmapTools 1.5.
%
% This function calculates the structural formulas of a set 
% of Amphiboles and the pressure according to Anderson & Smith (1995). 
%
% [Values] = StructFctAmphiboles(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>Amphibole>Amp-P-T (Amp+Plagio)>ThermoFctAmphLanariPTa>P T Xab Xan>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 23 Oxygens
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 15/11/11.
% Version with pre-loading... 


Altot = zeros(1,length(Data(:,1)));
P = zeros(1,length(Data(:,1)));
Tinput = zeros(1,length(Data(:,1)));

% Input: Pressure
Temperature = str2num(char(inputdlg('Temperature (°C)','Input',1,{'620'})));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 23; % Oxygens, DO NOT CHANGE !!!


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass


for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);
    
    if Analyse(1) > 0.0001 % detection...
        OnCal = 1;
    else
        OnCal = 0;
    end

    TravMat = []; % initialization required... 

    if OnCal
        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe = lesResults(4)+ lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);


        % Johnson & Rutherford (1987) - Pmax
        Altot(i) = Al;
        P(i) = 4.76*Al -3.01 - (((Temperature-675)/85)*(0.530*Al + 0.005294*(Temperature-675))) ;
        Tinput(i) = Temperature;
        
        
        if Altot(i) < 0 || P(i) < 0 || P(i) > 15 
            
            Altot(i) = 0;
            P(i) = 0;
            Tinput(i) = 0;
        end
        
    else
        Altot(i) = 0;
        P(i) = 0;
        Tinput(i) = 0;
    end
end

XmapWaitBar(1,handles);
return



