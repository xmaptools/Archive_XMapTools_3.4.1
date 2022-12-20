function [Temp,Al4] = ThermoFctChlBourdelle(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the Temperature and the Aliv content of a set 
% of chlorites, using the thermometer of Bourdelle (Comm. Per.)
%
% [Temp,Aliv] = ThermoFctChlBourdelle(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2,Al2O3,FeO,MnO,Mgo,CaO,Na2O,K2O
%
% Setup : 
% 2>Chlorite>Chl-T Bourdelle etal 2013>ThermoFctChlBourdelle>T Al4>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%
% We use others element (Mn Ca Na K) to detect bad analyses.
%
% Created by P. Lanari (Mai 2012) - CORRECTED & TESTED 01.01.2016 


Temp = zeros(1,length(Data(:,1)));
Al4 = zeros(1,length(Data(:,1)));



XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 14; % Oxygens, DO NOT CHANGE !!!


% SiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
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
        TravMat(1:3) = Analyse(1:3); % Si02 Al2O3 FeO
        TravMat(4) = 0; % Fe2O3
        TravMat(5:9) = Analyse(4:8); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Al = lesResults(2); 
        Fe = lesResults(3)+ lesResults(4);
        Mn = lesResults(5);
        Mg = lesResults(6);
        Ca = lesResults(7); 
        Na = lesResults(8); 
        K =  lesResults(9);

        fe2 = lesResults(3);
        fe3 = lesResults(4);
        

        % Structural Formulae (P. Lanari - 2012) From Bourdelle spreadsheat
        % 
        
        Aliv = 4-Si;
        Alvi = Al-Aliv;
        
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
        XMg_M23 = Mg_M23/4;                         % corrected PL 01.11.16
        %XFe_M23 = Fe_M23;
        XAl_M23 = Al_M23/4;                         % corrected PL 01.11.16
        
       	
        
        a_afchl = XSi_T2*XSi_T2*XMg_M14*XMg_M14*(XMg_M23^4);
        a_ames = XAl_T2*XAl_T2*XAl_M14*XAl_M14*XMg_M23*XMg_M23*XMg_M23*XMg_M23;
        a_sud = 256*XSi_T2*XAl_T2*XV_M14*XAl_M14*XMg_M23*XMg_M23*XAl_M23*XAl_M23;
        
        K = (a_ames^3)/(a_afchl*(a_sud^3));
        
        LnK = log10(K);
        
        T = (9304.2/(23.239-LnK))-273;
   
        
        %keyboard
        
        AtomSiteRep(1) = XSi_T2;
        AtomSiteRep(2) = XAl_T2;
        AtomSiteRep(3) = XMg_M14;
        AtomSiteRep(4) = XAl_M14;
        AtomSiteRep(5) = XV_M14;
        AtomSiteRep(6) = XMg_M23;
        AtomSiteRep(7) = XAl_M23;
        


        if all(AtomSiteRep >= 0) && T < 500 && T > 0 
       
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




