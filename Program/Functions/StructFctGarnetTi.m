function [XAlm,XSps,XPrp,XGrs,SI,TI,AL,MG,FE,MN,CA] = StructFctGarnetTi(Data,handles)
% -
% XMapTools External Function: Structural formula of Garnet (including Ti)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Garnet>Gar-StructForm-Ti>StructFctGarnetTi>XAlm XSps XPrp XGrs Si Ti 
%     Al Mg Fe Mn Ca>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   12 Oxygens
%
% 
% Created by P. Lanari (August 2011) - Last update 19/12/13.
% Find out more at http://www.xmaptools.com



% Preloading: 
SI = zeros(1,length(Data(:,1)));
TI = zeros(1,length(Data(:,1)));
AL = zeros(1,length(Data(:,1)));
MG = zeros(1,length(Data(:,1)));
FE = zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));
CA = zeros(1,length(Data(:,1)));
XAlm = zeros(1,length(Data(:,1)));
XSps = zeros(1,length(Data(:,1)));
XPrp = zeros(1,length(Data(:,1)));
XGrs = zeros(1,length(Data(:,1)));


Fe3Per = 0;


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
        k= TravMat(:,32);

        
        % Si Al XMg
        
        % Structural Formula
        SI(i) = Si;
        TI(i) = Ti;
        AL(i) = Al;
        MG(i) = Mg;
        FE(i) = Fe;
        MN(i) = Mn;
        CA(i) = Ca;
        
        % Solid solution
        XGrs(i) = Ca/(Ca+Fe+Mg+Mn);
        XSps(i) = Mn/(Ca+Fe+Mg+Mn);
        XPrp(i) = Mg/(Ca+Fe+Mg+Mn);
        XAlm(i) = Fe/(Ca+Fe+Mg+Mn);
        
        
    else
        SI(i) = 0;
        TI(i) = 0;
        AL(i) = 0;
        MG(i) = 0;
        FE(i) = 0;
        CA(i) = 0;
        XGrs(i) = 0;
        XSps(i) = 0;
        XPrp(i) = 0;
        XAlm(i) = 0;
    end
        
end


XmapWaitBar(1,handles);
return






