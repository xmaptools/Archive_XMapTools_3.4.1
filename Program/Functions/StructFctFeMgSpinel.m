function [Al_M,Fe_M,Mg_M,XHc,XSpl] = StructFctFeMgSpinel(Data,handles)
% -
% XMapTools External Function: Structural formula of Spinel (Fe-Mg) 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Spinel>FeMg_Spi-StructForm>StructFctFeMgSpinel>Al_M Fe_M Mg_M XHc 
%     XSpl>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   4 Oxygens
%
% 
% Created by P. Lanari (August 2013) - Last update 02/08/13.
% Find out more at http://www.xmaptools.com



Al_M = zeros(1,length(Data(:,1)));
Fe_M = zeros(1,length(Data(:,1)));
Mg_M = zeros(1,length(Data(:,1)));
XHc = zeros(1,length(Data(:,1)));
XSpl = zeros(1,length(Data(:,1)));


Fe3Per = 0;

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 4; % Oxygens, DO NOT CHANGE !!!

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);

    if Analyse(1) > 0.001 % Cordierite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
            
        % SiO2 / TiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
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
        K= TravMat(:,32);
        

        % Simple structural formula for FeMg_Spinel (August 2013)
        
        Al_M(i) = Al;
        Fe_M(i) = Fe;
        Mg_M(i) = Mg;
        XHc(i) = Fe/(Mg+Fe);
        XSpl(i) = Mg/(Mg+Fe);

        
    else
        Al_M(i) = 0;
        Fe_M(i) = 0;
        Mg_M(i) = 0;
        XHc(i) = 0;
        XSpl(i) = 0;
        
    end
        
end

XmapWaitBar(1,handles);
return






