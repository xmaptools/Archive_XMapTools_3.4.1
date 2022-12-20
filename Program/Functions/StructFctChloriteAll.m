function [SiT,Aliv,Alvi,DT,XAlvi,fe2,fe3,XMg,XFe,V_M1,Al_M1,Mg_M1,Fe2_M1,Al_M23,Mg_M23,Fe2_M23,Al_M4,Mg_M4,Fe2_M4,XAlfchl,XAme,XClc,XDph,XSud,Xsum] = StructFctChloriteAll(Data,handles)
% -
% XMapTools External Function: Structural formula of chlorite 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Chlorite>Chl-StructForm>StructFctChlorite>Aliv Alvi Fe3 Fe2 Al_M4 
%     Si_T1 Si_T2 Al_T2 V_M1 Al_M2M3 Al_M1 Mg_M1 Fe_M1 Mg_M2M3 Fe_M2M3 
%     X_MgFe DeltaLacune XAme XCli XDap XSud Xsum>SiO2 Al2O3 FeO MnO MgO 
%     CaO Na2O K2O>
%
%   14 Oxygens
%
% 
% Created by P. Lanari (May 2014) - Last update 05.04.2018
% Find out more at http://www.xmaptools.com


SiT = zeros(1,length(Data(:,1)));
Aliv = zeros(1,length(Data(:,1)));
Alvi = zeros(1,length(Data(:,1)));
DT = zeros(1,length(Data(:,1)));
XAlvi = zeros(1,length(Data(:,1)));
fe2 = zeros(1,length(Data(:,1)));
fe3 = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
V_M1 = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Fe2_M1 = zeros(1,length(Data(:,1)));
Al_M23 = zeros(1,length(Data(:,1)));
Mg_M23 = zeros(1,length(Data(:,1)));
Fe2_M23 = zeros(1,length(Data(:,1))); 
Al_M4 = zeros(1,length(Data(:,1)));
Mg_M4 = zeros(1,length(Data(:,1)));
Fe2_M4 = zeros(1,length(Data(:,1)));
XAlfchl = zeros(1,length(Data(:,1)));
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

        fe2(i) = TravMat(:,23);
        fe3(i) = TravMat(:,24);
        
        
        % Structural Formulae (P. Lanari - 2014)
        
        
        SiT(i) = Si; 
        Aliv(i) = 4-Si;
        Alvi(i) = Al-Aliv(i);
        
        DT(i) = (Alvi(i) + fe3(i)) - Aliv(i);
        V_M1(i) = DT(i)/2;
        
        XAlvi(i) = Alvi(i)/(Alvi(i)+fe3(i));
        Al_M23(i) = DT(i);                       % same as in Si<3 function 
        
        % Al_M4
        if Alvi(i)-Al_M23(i) > 1
            Al_M4(i) = 1-fe3(i);
        else
            if Alvi(i) - Al_M23(i) + fe3(i) > 1
                Al_M4(i) = 1-fe3(i);
            else
                Al_M4(i) = Alvi(i)-Al_M23(i);
            end
        end
        
        Al_M1(i) = Alvi(i) - Al_M4(i) - Al_M23(i);
        
        XFe(i) = fe2(i)/(fe2(i)+Mg);
        XMg(i) = 1-XFe(i);
        
        Mg_M4(i) = (1-Al_M4(i)-fe3(i))*XMg(i);
        Fe2_M4(i) = (1-Al_M4(i)-fe3(i))*XFe(i);
        
        FeMg_M1 = 1-Al_M1(i)-V_M1(i);
        FeMg_M23 = Mg + fe2(i) - FeMg_M1 - Mg_M4(i) - Fe2_M4(i);
        
        Mg_M1(i) = FeMg_M1*XMg(i);
        Fe2_M1(i) = FeMg_M1*XFe(i);
        
        Mg_M23(i) = FeMg_M23*XMg(i);
        Fe_M23(i) = FeMg_M23*XFe(i);
        
        
        XAlfchl(i) = Mg_M4(i) + Fe2_M4(i);
        XAme(i) = Al_M1(i);
        XClc(i) = Mg_M1(i) - Mg_M4(i);
        XDph(i) = Fe2_M1(i) - Fe2_M4(i);
        XSud(i) = V_M1(i);
        
        Xsum(i) = XAlfchl(i)+XAme(i)+XClc(i)+XDph(i)+XSud(i);
        
        
        if SiT(i) < 0 || Aliv(i) < 0 || Aliv(i) < 0 || DT(i) < 0 || XAlvi(i) < 0 || fe2(i) < 0 || fe3(i) < 0 || XMg(i) < 0 || XFe(i) < 0 || V_M1(i) < 0 || Al_M1(i) < 0 || Mg_M1(i) < 0 || Fe2_M1(i) < 0 || Al_M23(i) < 0 || Mg_M23(i) < 0 || Fe2_M23(i) < 0 || Al_M4(i) < 0 || Mg_M4(i) < 0 || Fe2_M4(i) < 0 || XAlfchl(i) < 0 || XAme(i) < 0 || XClc(i) < 0 || XDph(i) < 0 || XSud(i) < 0 || Xsum(i) < 0
            
            
            SiT(i) = 0;
            Aliv(i) = 0;
            Alvi(i) = 0;
            DT(i) = 0;
            XAlvi(i) = 0;
            fe2(i) = 0;
            fe3(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            V_M1(i) = 0;
            Al_M1(i) = 0;
            Mg_M1(i) = 0;
            Fe2_M1(i) = 0;
            Al_M23(i) = 0;
            Mg_M23(i) = 0;
            Fe2_M23(i) = 0; 
            Al_M4(i) = 0;
            Mg_M4(i) = 0;
            Fe2_M4(i) = 0;
            XAlfchl(i) = 0;
            XAme(i) = 0;
            XClc(i) = 0;
            XDph(i) = 0;
            XSud(i) = 0;
            Xsum(i) = 0;
        end
        
        
    else
      
        SiT(i) = 0;
        Aliv(i) = 0;
        Alvi(i) = 0;
        DT(i) = 0;
        XAlvi(i) = 0;
        fe2(i) = 0;
        fe3(i) = 0;
        XMg(i) = 0;
        XFe(i) = 0;
        V_M1(i) = 0;
        Al_M1(i) = 0;
        Mg_M1(i) = 0;
        Fe2_M1(i) = 0;
        Al_M23(i) = 0;
        Mg_M23(i) = 0;
        Fe2_M23(i) = 0; 
        Al_M4(i) = 0;
        Mg_M4(i) = 0;
        Fe2_M4(i) = 0;
        XAlfchl(i) = 0;
        XAme(i) = 0;
        XClc(i) = 0;
        XDph(i) = 0;
        XSud(i) = 0;
        Xsums(i) = 0;

        
    end
end

XmapWaitBar(1,handles);
return






