function [Aliv,Alvi,Fe3,Fe2,Al_M4,Si_T1,Si_T2,Al_T2,V_M1,Al_M2M3,Al_M1,Mg_M1,Fe_M1,Mg_M2M3,Fe_M2M3,X_MgFe,DeltaLacune,XAme,XClc,XDph,XSud,Xsum] = StructFctChlorite(Data,handles)
% -
% XMapTools External Function: Structural formula of chlorite 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Chlorite>Chl-StructForm>StructFctChlorite>Aliv Alvi Fe3 Fe2 Al_M4 
%     Si_T1 Si_T2 Al_T2 V_M1 Al_M2M3 Al_M1 Mg_M1 Fe_M1 Mg_M2M3 Fe_M2M3 
%     X_MgFe DeltaLacune XAme XClc XDph XSud Xsum>SiO2 Al2O3 FeO MnO MgO 
%     CaO Na2O K2O>
%
%   14 Oxygens
%
% 
% Created by P. Lanari (July 2010) - Last update 05.04.2018
% Find out more at http://www.xmaptools.com


Aliv = zeros(1,length(Data(:,1)));
Alvi = zeros(1,length(Data(:,1)));
Fe3 = zeros(1,length(Data(:,1)));
Fe2 = zeros(1,length(Data(:,1)));
Al_M4 = zeros(1,length(Data(:,1)));
Si_T1 = zeros(1,length(Data(:,1)));
Si_T2 = zeros(1,length(Data(:,1)));
Al_T2 = zeros(1,length(Data(:,1)));
V_M1 = zeros(1,length(Data(:,1)));
Al_M2M3 = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Mg_M2M3 = zeros(1,length(Data(:,1)));
Fe_M2M3 = zeros(1,length(Data(:,1)));
X_MgFe = zeros(1,length(Data(:,1))); 
DeltaLacune = zeros(1,length(Data(:,1)));
XAme = zeros(1,length(Data(:,1)));
XClc = zeros(1,length(Data(:,1)));
XDph = zeros(1,length(Data(:,1)));
XSud = zeros(1,length(Data(:,1)));
Xsum = zeros(1,length(Data(:,1)));



Fe3Per = 0;
Fe3Per = str2num(char(inputdlg('Fe3+ (0-50%)','Input',1,{'0'})));
%XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 14; % Oxygens, DO NOT CHANGE !!!

XmapWaitBar(0,handles);


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
        NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
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

        % Structural Formulae (P. Lanari - 2010)
        
        Aliv(i) = 4 - Si;
        Alvi(i) = Al - Aliv(i);
        
        Fe3(i)=TravMat(:,24);
        Fe2(i)=TravMat(:,23);
        
        Al_M4(i) = 1 - Fe3(i);
        
        XMg = Mg./(Mg+Fe2(i));
        R2 = Fe2(i) + Mg + Mn + Ca; % With Ca (May 2010)
        R1 = Na + K;
        
        % IV:
        Si_T1(i) = 2;
        Si_T2(i) = Si - Si_T1(i);
        Al_T2(i) = 2 - Si_T2(i);
        
        % VI:
        V_M1(i) = (Alvi(i) - Aliv(i) + Fe3(i) - R1)/2; % OV (May 2010)
        Al_M2M3(i) = Alvi(i) - Aliv(i) + Fe3(i); % OV (May 2010)
        Al_M1(i) = Alvi(i) - Al_M4(i) - Al_M2M3(i);
        
        FeMg_M1 = 1 - V_M1(i) - Al_M1(i);% - Mn; % Without Mn
        FeMg_M2M3 = R2 - FeMg_M1;
        
        Mg_M1(i) = XMg * FeMg_M1;
        Fe_M1(i) = (1-XMg) .* FeMg_M1;
        
        Mg_M2M3(i) = Mg - Mg_M1(i);
        Fe_M2M3(i) = Fe2(i) - Fe_M1(i);
        
        X_MgFe(i) = Mg / (Fe2(i)+Mg);
        
        OctCatSum = Alvi(i) + Fe2(i) + Fe3(i) + Mg + Mn + Ca + R1;
        
        DeltaLacune(i) = (V_M1(i) - 6 + OctCatSum) * 100 / (6 - OctCatSum);
        
        % SS : 
        XAme(i) = Al_M1(i);
        XClc(i) = Mg_M1(i);
        XDph(i) = Fe_M1(i);
        XSud(i) = 1-XAme(i)-XClc(i)-XDph(i); %V_M1(i);
        
        Xsum(i) = XAme(i)+XClc(i)+XDph(i)+XSud(i);
        
        if Aliv(i) < 0 || Alvi(i) < 0 || Al_M4(i) < 0 || XSud(i) < 0 || XDph(i) < 0 || XClc(i) < 0 ||Mg_M2M3(i) < 0 || Fe_M2M3(i) < 0 || Al_M2M3(i) < 0 || Al_T2(i) < 0 || V_M1(i) < 0 || Fe_M1(i) < 0 || Al_M1(i) < 0 || Mg_M1(i) < 0
            Aliv(i) = 0;
            Alvi(i) = 0;
            Fe3(i) = 0;
            Fe2(i) = 0;
            Al_M4(i) = 0;
            Si_T1(i) = 0;
            Si_T2(i) = 0;
            Al_T2(i) = 0;
            V_M1(i) = 0;
            Al_M2M3(i) = 0;
            Al_M1(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Mg_M2M3(i) = 0;
            Fe_M2M3(i) = 0;
            X_MgFe(i) = 0;
            DeltaLacune(i) = 0;
            XAme(i) = 0;
            XClc(i) = 0;
            XDph(i) = 0;
            XSud(i) = 0;
            Xsum(i) = 0;
        end
        
        
    end
end

% Aliv Alvi Fe3 Fe2 Al_M4 Si_T1 Si_T2 Al_T2 V_M1 Al_M2M3 Al_M1 Mg_M1 Fe_M1
% Mg_M2M3 Fe_M2M3 DeltaLacune XAme XClc XDph XSud Xsum


XmapWaitBar(1,handles);
return






