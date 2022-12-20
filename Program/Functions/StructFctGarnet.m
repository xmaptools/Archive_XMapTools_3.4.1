function [XAlm,XSps,XPrp,XGrs,SI,AL,MG,FE,MN,CA] = StructFctGarnet(Data,handles)
% -
% XMapTools External Function: Structural formula of Garnet 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Garnet>Gar-StructForm>StructFctGarnet>XAlm XSps XPrp XGrs Si Al Mg Fe 
%     Mn Ca>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   12 Oxygens
%
% 
% Created by P. Lanari (August 2011) - Last update 14/06/19.
% Find out more at http://www.xmaptools.com


SI = zeros(1,length(Data(:,1)));
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

    if Analyse(1) > 0.001 % Biotite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
    
        % SiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
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
        k= TravMat(:,29);

        
        % Si Al XMg
        
        % Structural Formula
        SI(i) = Si;
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
    end
end

XmapWaitBar(1,handles);
return






