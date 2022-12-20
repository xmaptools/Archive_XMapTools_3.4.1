function [P Si4 T] = ThermoFctMassone(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the Si4+ content of a set 
% of phengites, using the method of Massone & Schreyer, 1987.
%
% [Si4] = ThermoFctMassone(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>WhiteMica>Massone&Schreyer1987>ThermoFctMassone>P Si4 T>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% We use others element (Mn Ca Na K) to detect bad analyses.
%
% Created by P. Lanari (Juillet 2010) - TESTED & VERIFIED 27/07/10. 


Si4 = zeros(1,length(Data(:,1)));
T = zeros(1,length(Data(:,1)));
P = zeros(1,length(Data(:,1)));


Fe3Per = 0;

Tinput = str2num(char(inputdlg('Temperature (∞C)','Input',1,{'400'})));

XmapWaitBar(0,handles);
hCompt = 1;



NbOx = 11; % Oxygens, DO NOT CHANGE !!!

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);

    if Analyse(1) > 1 % Phengite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
    
        % SiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg√®nes.
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

        
        % Massone & Schreyer, 1987
        Si4(i) = Si;
        P(i) = 0.0112*Tinput+(25*Si-80.36); % Lanari fit 2011... 
        T(i) = Tinput;
        
        
    else
        Si4(i) = 0;
        T(i) = 0;
        P(i) = 0;
    end
        
end

XmapWaitBar(1,handles);
return






