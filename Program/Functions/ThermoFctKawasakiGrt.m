function [T Ti_VI Si_VI] = ThermoFctKawasakiGrt(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the structural formulas of a set 
% of Garnet.
%
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>Garnet>Structural Formulae>StructFctGarnet>XAlm XSpe XPyr XGro Si Al Mg Fe K Na Ca>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 
% 
% Created by P. Lanari (Aout 2011) 
% LAST TESTED & VERIFIED 22/08/11 from Vernon & Clarke (2008) Principle of metamorphic petrology. Cambridge ed. 
% Results are the same close to 900°C


% Preloading: 
T = zeros(1,length(Data(:,1)));
Ti_VI = zeros(1,length(Data(:,1)));
Si_VI = zeros(1,length(Data(:,1)));



Fe3Per = 0;

% Limites = inputdlg({'Si < ...','Al < ...','Fe+Mg+Mn+Ca < ...'},'Limits',1,{'6.5','4.5','6.5'});
% LIM1 = str2num(char(Limites{1}));
% LIM2 = str2num(char(Limites{2}));
% LIM3 = str2num(char(Limites{3}));


XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 12; % Oxygens, DO NOT CHANGE !!!

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);

    if Analyse(1) > 0.001 % Garnet
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
    
        % SiO2 / TiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'OxygÃ¨nes.
        Cst = [60.09,79.86,101.96,71.85,159.68,70.94,40.30,56.08, ...
            61.98,94.20]; % atomic mass

        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O
    
        for j=1:10
            TravMat(j+10) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
        end
    
        % adding Fe3+ 
        TravMat(14) = (1-(Fe3Per*0.01)) * Analyse(4) / Cst(4);
        TravMat(15) = Analyse(4) / Cst(4) - TravMat(14);
    
        TravMat(21) = sum((TravMat(11:20) .* NumO) ./ Num); % Oxygen sum
        TravMat(22) = TravMat(21) / NbOx; % ref Ox
    
        TravMat(23:32) = TravMat(11:20) ./ TravMat(22);

        % Association: 
        Si = TravMat(:,23);
        Ti = TravMat(:,24);
        Al= TravMat(:,25); 
        Fe= TravMat(:,26)+ TravMat(:,27);
        Mn= TravMat(:,28);
        Mg= TravMat(:,29);
        Ca= TravMat(:,30); 
        Na= TravMat(:,31); 
        k= TravMat(:,32);
        
        % Thermometer
        if Si+Ti > 3
            TI = 3 - Si;
            SI = Si;
        else
            TI = Ti;
            SI = Si;
        end

        
        laT = -15366/(log(TI/SI)-5.962)-273.15;
        

        if TI > 0 && SI > 0 && laT > 0
            T(i) = laT;
            Si_VI(i) = SI;
            Ti_VI(i) = TI;
        else
            T(i) = 0;
            Si_VI(i) = 0;
            Ti_VI(i) = 0;
        end
        
    else
        T(i) = 0;
        Si_VI(i) = 0;
        Ti_VI(i) = 0;
    end
        
end

XmapWaitBar(1,handles);
return






