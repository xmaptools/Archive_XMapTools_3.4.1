function [T,Al4] = ThermoFctChlZang(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the Temperature and the Aliv content of a set 
% of chlorites, using the thermometer of Zang & Fyfe, 1995.
%
% [Temp,Aliv] = ThermoFctZang(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>Chlorite>Chl-T Zang&Fyfe 1995>ThermoFctChlZang>T Al4>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%
% We use others element (Mn Ca Na K) to detect bad analyses.
%
% Created by P. Lanari (Juillet 2010) - TESTED & VERIFIED 27/07/10. 

T = zeros(1,length(Data(:,1)));
Al4 = zeros(1,length(Data(:,1)));

% Fe3 input
Fe3Per = inputdlg('Fe3+ (%)','Input',1,{num2str(0)});
Fe3Per = str2num(char(Fe3Per));

if Fe3Per 
    ButtonName = questdlg('Warning, this thermometer has been quantified with Fetotal = Fe2+. Do you want to include Fe3+ ?', 'Message', 'Yes','No','Yes');
    if length(ButtonName) < 3
        T = 0; Al4 = 0;
        return
    end
end
        
XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 14; % Oxygens, DO NOT CHANGE !!!

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);

    if Analyse(1) > 1 % Chlorite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
    
        % SiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygènes.
        Cst = [60.09,101.96,71.85,159.68,70.94,40.30,56.08, ...
            61.98,94.20]; % atomic mass

        TravMat(1:3) = Analyse(1:3); % Si02 Al2O3 FeO
        TravMat(4) = 0; % Fe2O3
        TravMat(5:9) = Analyse(4:8); % MnO MgO CaO Na2O K2O
    
        for j=1:9
            TravMat(j+9) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
        end
    
        % adding Fe3+ 
        TravMat(12) = (1-(Fe3Per*0.01)) * Analyse(3) / Cst(3);
        TravMat(13) = Analyse(3) / Cst(3) - TravMat(12);
    
        TravMat(19) = sum((TravMat(10:18) .* NumO) ./ Num); % Oxygen sum
        TravMat(20) = TravMat(19) / NbOx; % ref Ox
    
        TravMat(21:29) = TravMat(10:18) ./ TravMat(20);

        % Association: 
        Si = TravMat(:,21);
        Al= TravMat(:,22); 
        Fe= TravMat(:,23)+ TravMat(:,24);
        Mn= TravMat(:,25);
        Mg= TravMat(:,26);
        Ca= TravMat(:,27); 
        Na= TravMat(:,28); 
        K= TravMat(:,29);

        
        % Zang & Fyfe, 1994 (28 OX !!!)
        Aliv = 4 - Si;
        Aliv = Aliv * 2;
        
        FeMg = (Fe*2)/((Fe*2)+(Mg*2));
        
        AlivCorr = Aliv - 0.88*(FeMg-0.34);
        
        T(i) = 106.2*AlivCorr + 17.5;
        Al4(i) = AlivCorr/2; % 14 Oxygens
        
        
    else
        T(i) = 0;
        Al4(i) = 0;
    end
        
end

XmapWaitBar(1,handles);
return






