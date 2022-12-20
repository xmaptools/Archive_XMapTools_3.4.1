function [Si4,Al_T2,Si_T2,V_M1,Fe_M1,Mg_M1,Al_M2M3,Mg_M2M3,Fe_M2M3,XMg,XFe,K_A,V_A,Na_A,Sum_A,XCel,XMs,XPrl,XPg,Xsum] = StructFctPhengite(Data,handles)
% -
% XMapTools External Function: Structural formula of white mica 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Amphibole>Amp-StrucForm>StructFctAmphiboles>Si4 Aliv Alvi Al_T2 Al_M2 
%     XFe XMg Mg_M2 Fe_M2 Fe_M13 Mg_M13 Ca_M4 V_M4 Na_A V_A Xtr Xftr Xts 
%     Xparg Xgl>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   11 Oxygens
%
% 
% Created by P. Lanari (July 2010) - Last update 22/08/17.
% Find out more at http://www.xmaptools.com


Si4 = zeros(1,length(Data(:,1)));
Al_T2 = zeros(1,length(Data(:,1)));
Si_T2 = zeros(1,length(Data(:,1)));
V_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Al_M2M3 = zeros(1,length(Data(:,1)));
Mg_M2M3 = zeros(1,length(Data(:,1)));
Fe_M2M3 = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
K_A = zeros(1,length(Data(:,1)));
V_A = zeros(1,length(Data(:,1)));
Na_A = zeros(1,length(Data(:,1)));
Sum_A = zeros(1,length(Data(:,1)));
XCel = zeros(1,length(Data(:,1)));
XMs = zeros(1,length(Data(:,1)));
XPrl = zeros(1,length(Data(:,1)));
XPg = zeros(1,length(Data(:,1)));
Xsum = zeros(1,length(Data(:,1)));


Fe3Per = 0;
Fe3Per = str2num(char(inputdlg('Fe3+ (30-70%)','Input',1,{'0'})));

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
        K= TravMat(:,29);

        Fe2 = TravMat(:,23); Fe3 = TravMat(:,24);
        
        % Structural Formula
        Si4(i) = Si;
        Al_T2(i) = 4-Si;
        Si_T2(i) = 2-Al_T2(i);
        Al_M2M3(i) = Al-Al_T2(i);
        XMg_l = Mg/(Mg+Fe2);
        FeMg_M2M3 = 2 - Al_M2M3(i) - Fe3;
        FeMg_M1 = (Fe2+Mg) - FeMg_M2M3;
        Mg_M2M3(i) =  XMg_l * FeMg_M2M3;
        Fe_M2M3(i) = (1-XMg_l) * FeMg_M2M3;
        Fe_M1(i) = (1-XMg_l) * FeMg_M1;
        Mg_M1(i) = XMg_l * FeMg_M1;
        
        XMg(i) = XMg_l;
        XFe(i) = (1-XMg_l);
         
        V_M1(i) = 1 - FeMg_M1;
        K_A(i) = K;
        Na_A(i) = Na;
        V_A(i) = 1 - K - Na - Ca;
        
        Sum_A(i) = K_A(i)+Na_A(i);
        
        % Solid Solution LAST P. LANARI version (see notice):

        Npar = Na_A(i);
        Nmu = Al_T2(i) - Na_A(i);
        if V_A(i) > 0
            Npyr = V_A(i);
        else
            Npyr = 0;
        end
        Ncel = FeMg_M2M3;
         
        XPg(i) = Npar/(Npar+Nmu+Npyr+Ncel);
        XMs(i) = Nmu/(Npar+Nmu+Npyr+Ncel);
        XPrl(i) = Npyr/(Npar+Nmu+Npyr+Ncel);
        XCel(i) = Ncel/(Npar+Nmu+Npyr+Ncel);
        
        
        
        
        
%         XPrl(i) = V_A(i);
%         XPhl(i) = Mg_M1(i); 
%         XMus(i) = Al_T2(i) - XPrl(i); 
%         if Si - 3 - XPrl(i) > 0;
%             XCel(i) = Si - 3 - XPrl(i);
%         else 
%             XCel(i) = 1 - XPrl(i) - XPhl(i) - XMus(i);
%         end
        
%         XPrl(i) = V_A(i);
%         XPhl(i) = Mg_M1(i); % Al_M2M3(i) + Fe + Mn + Mg - 2;
%         XCel(i) = (Fe + Mn + Mg) - 3* XPhl(i); 
%         XMus(i) = (Al_M2M3(i) - (2*XPrl(i) + XCel(i)))/2; 
        
        Xsum(i) = XPg(i)+XCel(i)+XPrl(i)+XMs(i); 
        
        % Analysis filter:
        if XPg(i) > 1 || XCel(i) > 1 || XPrl(i) > 1 || XMs(i) > 1 || ...
             XPg(i) < 0 || XCel(i) < 0 || XPrl(i) < 0 || XMs(i) < 0 
            Si4(i) = 0;
            Al_T2(i) = 0;
            Si_T2(i) = 0;
            V_M1(i) = 0;
            Fe_M1(i) = 0;
            Mg_M1(i) = 0;
            Al_M2M3(i) = 0;
            Mg_M2M3(i) = 0;
            Fe_M2M3(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            K_A(i) = 0;
            V_A(i) = 0;
            Na_A(i) = 0;
            Sum_A(i) = 0;
            XCel(i) = 0;
            XMs(i) = 0;
            XPrl(i) = 0;
            XPg(i) = 0;
            Xsum(i) = 0;
        end
        
    end
        
end

XmapWaitBar(1,handles);
return






