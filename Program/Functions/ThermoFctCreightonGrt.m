function [T lnApyr lnAspe MN] = ThermoFctCreightonGrt(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the temperature of garnet according to Creighton
% (2009). 
%
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O Cr2O3
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
lnApyr = zeros(1,length(Data(:,1)));
lnAspe = zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));


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
        % / Cr2O3
        Num = [1,1,2,1,2,1,1,1,2,2,2]; % Nombre de cations.
        NumO= [2,2,3,1,3,1,1,1,1,1,3]; % Nombre d'OxygÃ¨nes.
        Cst = [60.09,79.86,101.96,71.85,159.68,70.94,40.30,56.08, ...
            61.98,94.20,151.99]; % atomic mass

        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:11) = Analyse(5:10); % MnO MgO CaO Na2O K2O Cr2O3
    
        for j=1:11
            TravMat(j+11) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
        end
    
        % adding Fe3+ 
        TravMat(15) = (1-(Fe3Per*0.01)) * Analyse(4) / Cst(4);
        TravMat(16) = Analyse(4) / Cst(4) - TravMat(15);
    
        TravMat(23) = sum((TravMat(12:22) .* NumO) ./ Num); % Oxygen sum
        TravMat(24) = TravMat(23) / NbOx; % ref Ox
    
        TravMat(25:35) = TravMat(12:22) ./ TravMat(24);

        % Association: 
        Si = TravMat(:,25);
        Ti = TravMat(:,26);
        Al= TravMat(:,27); 
        Fe= TravMat(:,28)+ TravMat(:,29);
        Mn= TravMat(:,30);
        Mg= TravMat(:,31);
        Ca= TravMat(:,32); 
        Na= TravMat(:,33); 
        k= TravMat(:,34);
        Cr = TravMat(:,35);
        
        % Thermometer
        apyr = 1.163*(Mg/(Mg+Fe+Ca+Mn)) - 0.248*(Cr/(Cr+Al)) - 0.46;
        apyr = log(apyr);
        
        aspess = 401.6*(Mn/(Mg+Fe+Ca+Mn)) - 3.15*(Cr/(Cr+Al)) - 17.85;
        
        laT = -1635.48 - 184.8*(aspess - apyr);
        
        
        if laT > 100 && isreal(laT) && isreal(apyr) && isreal(aspess)
            T(i) = laT;
            lnApyr(i) = apyr;
            lnAspe(i) = aspess;
            MN(i) = Mn;
        else
            T(i) = 0;
            lnApyr(i) = 0;
            lnAspe(i) = 0;
            MN(i) = 0;
        end
        
        
    else
        T(i) = 0;
        lnApyr(i) = 0;
        lnAspe(i) = 0;
        MN(i) = 0;
    end
    
end


XmapWaitBar(1,handles);
return






