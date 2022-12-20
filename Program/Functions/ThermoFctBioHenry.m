function [T TiBio XMg] = ThermoFctBioHenry(Data,handles)
% -
% XmapTools Function (version 1.5)
% Use this function only with XmapTools 1.5.
%
% This function calculates the structural formulas of a set 
% of Biotite and the pressure according to Henry et al. (2005). 
%
% [Values] = ThermoFctBioHenry(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 2>Biotite>Bio-T Henry et al. (2005)>ThermoFctBioHenry>T TiBio XMg>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 22 Oxygens  (same as in Henry et al. 2005)
%
% Created by P. Lanari (Octobre 2013) - TESTED & VERIFIED 05/10/13.
% Version with pre-loading... 


T = zeros(1,length(Data(:,1)));
TiBio = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 22; % Oxygens, DO NOT CHANGE !!!


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


        % Henry et al. (2005)
        XMg(i) = Mg/(Mg+Fe);
        TiBio(i) = Ti;
        
        A = -2.3594;
        B = 4.6482e-9;
        C = -1.7283;
        
        T(i) = ((log(Ti)-A-C*XMg(i)^3)/B)^0.333;

        
        if TiBio(i) < 0 || T(i) < 0 || T(i) > 1000 || TiBio(i) < 0 || ~isreal(T(i))
            
            XMg(i) = 0;
            TiBio(i) = 0;
            T(i) = 0;
        end
        
    else
        XMg(i) = 0;
        TiBio(i) = 0;
        T(i) = 0;
    end
end

XmapWaitBar(1,handles);
return



