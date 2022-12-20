function [Temp,Al4] = ThermoFctChlInoue2(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the Temperature and the Aliv content of a set 
% of chlorites, using the thermometer of Inoue et al. (2009)
%
% 2>Chlorite>Chl-T Inoue etal 2009 (Si>3)>ThermoFctChlInoue2>T Al4>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2,Al2O3,FeO,MnO,Mgo,CaO,Na2O,K2O
%
% Setup : 
% 1>Chlorite>Chl-T Bourdelle>ThermoFctChlBourdelle>T Al4>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%
% We use others element (Mn Ca Na K) to detect bad analyses.
%
% Created by P. Lanari (Mai 2012) - 


Temp = zeros(1,length(Data(:,1)));
Al4 = zeros(1,length(Data(:,1)));


Fe3Per = inputdlg('Fe3+ (0-50%)','Input',1,{num2str(20)});
Fe3Per = str2num(char(Fe3Per));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 14; % Oxygens, DO NOT CHANGE !!!


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass


for i = 1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);
    
    if Analyse(1) > 0.0001 % detection...
        OnCal = 1;
    else
        OnCal = 0;
    end

    TravMat = []; % initialization required... 

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
        
        fe3=TravMat(:,24);
        fe2=TravMat(:,23);
        
        
        % Structural Formulae (P. Lanari - 2012) From Bourdelle spreadsheat
        % 
        
        Si_T2 = Si-2;
        
        Aliv = 4-Si;
        Alvi = Al-Aliv;
        
        Al_T2 = Aliv;
        
        DT = (Alvi + fe3) - Aliv;
        
        V_M1 = DT/2;
        XAl6 = Alvi/(Alvi+fe3);
        
        Al_M23 = DT*XAl6;
        
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
        Fe_M4 = (1-Al_M4-fe3)*XFe;
        
        FeMg_M1 = 1-Al_M1-V_M1;
        FeMg_M23 = Mg + fe2 - FeMg_M1 - Mg_M4 - Fe_M4;
        
        Mg_M1 = FeMg_M1*XMg;
        Fe_M1 = FeMg_M1*XFe;
        
        Mg_M23 = FeMg_M23*XMg;
        Fe_M23 = FeMg_M23*XFe;
        
        Mg_M14 = Mg_M1 + Mg_M4;
        Al_M14 = Al_M1 + Al_M4;
        V_M14 = V_M1;
        
        
        XSi_T2 = (Si-2)/2;
        XAl_T2 = Aliv/2;
        XMg_M14 = Mg_M14/2;
        %XFe_M14 = Fe_M14/2;
        XAl_M14 = Al_M14/2;
        XV_M14 = V_M14/2;
        XMg_M23 = Mg_M23;
        %XFe_M23 = Fe_M23;
        XAl_M23 = Al_M23;

        
        % Activity model:
        Act_Afchl = 1 * (Mg/6)^6 * (Si_T2/2)^2; % okOV
        Act_Crdp = 45.563 * (Alvi/6)^2 * (Mg/6)^4 * ((Aliv)/2)^2; % okOV
        Act_Chm = 59.720 * (fe2/6)^5 * (Alvi/6) * (Si_T2/2) * (Al_T2/2); % okOV
        Act_Sud = 1728 * (Mg/6)^2 * (Alvi/6)^3 * (V_M1/6) * (Si_T2/2) * (Al_T2/2); % okOV

        x = + 3*log10(Act_Crdp) - 3*log10(Act_Sud) - log10(Act_Afchl);
        % x = log10(Act_Crdp^3/(Act_Sud^3 * Act_Afchl)); % other method ok

        T = 1/(0.00293 - 5.13e-4 * x + 3.904e-5 * x^2) - 273.15; % quadratic equation
        %T2 = 1/(0.00264 - 2.897e-4 * x) - 273.15; % other solution
   
        
        %keyboard
        
        AtomSiteRep(1) = XSi_T2;
        AtomSiteRep(2) = XAl_T2;
        AtomSiteRep(3) = XMg_M14;
        AtomSiteRep(4) = XAl_M14;
        AtomSiteRep(5) = XV_M14;
        AtomSiteRep(6) = XMg_M23;
        AtomSiteRep(7) = XAl_M23;
        


        if all(AtomSiteRep >= 0) 
       
            Temp(i) = T;
            Al4(i) = Aliv;
            
        else
            Temp(i) = 0;
            Al4(i) = 0;
        end
        
    else
        Temp(i) = 0;
        Al4(i) = 0;
    end
end

XmapWaitBar(1,handles);




return




