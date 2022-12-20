function [DensChl,XAlfchl,XAmes,XMgAmes,XFeAmes,XClin,XDaph,XSud,XSum] = DensityChloriteAll(Data,handles)
% -
% XMapTools Density Function (introduced in 2.3.1)
%
% This function calculates the structural formula of chlorite and the 
% corresponding density
%
% [Values] = DensityChloriteAll(Data,handles);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file.
% 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 5>Chlorite>Density_Chl_All>DensityChloriteAll>DensChl XAlfchl XAmes 
% XMgAmes XFeAmes XClin XDaph XSud XSum>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 6 Oxygen basis
%
% Created by P. Lanari (March 2016) - TESTED & VERIFIED 30/03/16.
%


DensChl = zeros(1,length(Data(:,1)));
XAlfchl = zeros(1,length(Data(:,1)));
XAmes = zeros(1,length(Data(:,1)));
XMgAmes = zeros(1,length(Data(:,1)));
XFeAmes = zeros(1,length(Data(:,1)));
XClin = zeros(1,length(Data(:,1)));
XDaph = zeros(1,length(Data(:,1)));
XSud = zeros(1,length(Data(:,1)));
XSum = zeros(1,length(Data(:,1)));


Fe3Per = 0;
Fe3Per = str2num(char(inputdlg('Fe3+ (0-50%)','Input',1,{'0'})));
hCompt = 1;
NbOx = 14; % Oxygens, DO NOT CHANGE !!!

XmapWaitBar(0,handles);

% SiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass

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
    
    TravMat = []; % initialization required... 
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
    
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

        fe2 = TravMat(:,23);
        fe3 = TravMat(:,24);
        
        
        % Structural Formulae (P. Lanari - 2014)
        
        SiT = Si; 
        Aliv = 4-Si;
        Alvi = Al-Aliv;
        
        DT = (Alvi + fe3) - Aliv;
        V_M1 = DT/2;
        
        XAlvi = Alvi/(Alvi+fe3);
        Al_M23 = DT;                       % same as in Si<3 function 
        
        % Al_M4
        if Alvi-Al_M23 > 1
            Al_M4 = 1-fe3;
        else
            if Alvi - Al_M23 + fe3 > 1
                Al_M4 = 1-fe3;
            else
                Al_M4 = Alvi-Al_M23;
            end
        end
        
        Al_M1 = Alvi - Al_M4 - Al_M23;
        
        XFe = fe2/(fe2+Mg);
        XMg = 1-XFe;
        
        Mg_M4 = (1-Al_M4-fe3)*XMg;
        Fe2_M4 = (1-Al_M4-fe3)*XFe;
        
        FeMg_M1 = 1-Al_M1-V_M1;
        FeMg_M23 = Mg + fe2 - FeMg_M1 - Mg_M4 - Fe2_M4;
        
        Mg_M1 = FeMg_M1*XMg;
        Fe2_M1 = FeMg_M1*XFe;
        
        Mg_M23 = FeMg_M23*XMg;
        Fe2_M23 = FeMg_M23*XFe;
        
        
        XAlfchl(i) = Mg_M4 + Fe2_M4;
        XAmes(i) = Al_M1;
        XClin(i) = Mg_M1 - Mg_M4;
        XDaph(i) = Fe2_M1 - Fe2_M4;
        XSud(i) = V_M1;
        
        XMgAmes(i) = XAmes(i) * XMg;
        XFeAmes(i) = XAmes(i) * XFe;
        
        XSum(i) = XAlfchl(i)+XAmes(i)+XClin(i)+XDaph(i)+XSud(i);
        
        % -----------------------------------------------------------------
        % Those ref. densities are temporary values. There is no reference 
        % density for FeAmes, pure MgAmes or Alfchl (assumed to be XMg of 
        % .5 here)
        % P. Lanari (30.03.16)
        DensChl(i) = 3.01 * XAlfchl(i) + 2.77 * XMgAmes(i) + 3.5 * XFeAmes(i) + 2.65 * XClin(i) + 3.4 * XDaph(i) + 2.65 * XSud(i);
        
        
        if SiT < 0 || Aliv < 0 || Aliv < 0 || DT < 0 || XAlvi < 0 || fe2 < 0 || fe3 < 0 || XMg < 0 || XFe < 0 || V_M1 < 0 || Al_M1 < 0 || Mg_M1 < 0 || Fe2_M1 < 0 || Al_M23 < 0 || Mg_M23 < 0 || Fe2_M23 < 0 || Al_M4 < 0 || Mg_M4 < 0 || Fe2_M4 < 0 || XAlfchl(i) < 0 || XAmes(i) < 0 || XClin(i) < 0 || XDaph(i) < 0 || XSud(i) < 0 || XSum(i) < 0
            
            
            DensChl(i) = 0;
            XMgAmes(i) = 0;
            XFeAmes(i) = 0;
            
            XAlfchl(i) = 0;
            XAmes(i) = 0;
            XClin(i) = 0;
            XDaph(i) = 0;
            XSud(i) = 0;
            XSum(i) = 0;
        end
    end
end

XmapWaitBar(1,handles);
return






