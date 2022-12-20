function [T,Al4] = ThermoFctChlInoue2009(Data,handles)
% -
% XmapTools Function (version 1.4)
% Use this function only with XmapTools 1.4.
%
% This function calculates the Temperature and the Aliv content of a set 
% of chlorites, using the thermometer of Inoue et al. 2009 (quadratic
% method).
%
% [Temp,Aliv] = ThermoFctInoue(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2,Al2O3,FeO,MnO,Mgo,CaO,Na2O,K2O
%
% Setup : 
% 1>Chlorite>Chl-T Inoue etal 2009>ThermoFctChlInoue2009>T Al4>SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% We use others element (Mn Ca Na K) to detect bad analyses.
%
% Created by P. Lanari (Juillet 2010) - TESTED & VERIFIED 23/07/10. 

% Fe3 input

T = zeros(1,length(Data(:,1)));
Al4 = zeros(1,length(Data(:,1)));

Fe3Per = inputdlg('Fe3+ (0-50%)','Input',1,{num2str(20)});
Fe3Per = str2num(char(Fe3Per));

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 14; % Oxygens, DO NOT CHANGE !!!

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
        NumO= [2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygènes.
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

        %Si, Al, Fe, Mn, Mg, Ca, Na, K
        
        % Inoue et al., (2009)
        Aliv = 4 - Si;
        Alvi = Al - Aliv;

        Fe3=TravMat(:,24);
        Fe2=TravMat(:,23);

        XMg = Mg/(Mg+Fe2);

        Si_T1 = 2;
        Si_T2 = Si - Si_T1;
        Al_T2 = 2 - Si_T2;

        if Si - 3 >= 0
            Mg_M4 = (Si - 3); 
        else
            Mg_M4 = 0;
        end

        Al_M4 = 1 - Mg_M4 - Fe3; 

        V_M1 = (Alvi + (Fe3 + Mg_M4) - Al_T2) / 2; 

        Al_M2M3 = 2*V_M1;
        Al_M1 = Alvi - Al_M4 - Al_M2M3;

        FeMg_M1 = 1 - V_M1 - Al_M1;
        FeMg_M2M3 = Fe2 + Mg - FeMg_M1 - Mg_M4;

        % XMg cst:
        Mg_M1 = XMg .* FeMg_M1;
        Fe_M1 = (1-XMg) .* FeMg_M1;

        Mg_M2M3 = XMg .* FeMg_M2M3;
        Fe_M2M3 = (1-XMg) .* FeMg_M2M3;

        % Activity model:
        Act_Afchl = 1 * (Mg/6)^6 * (Si_T2/2)^2; % okOV
        Act_Crdp = 45.563 * (Alvi/6)^2 * (Mg/6)^4 * ((Aliv)/2)^2; % okOV
        Act_Chm = 59.720 * (Fe2/6)^5 * (Alvi/6) * (Si_T2/2) * (Al_T2/2); % okOV
        Act_Sud = 1728 * (Mg/6)^2 * (Alvi/6)^3 * (V_M1/6) * (Si_T2/2) * (Al_T2/2); % okOV

        x = + 3*log10(Act_Crdp) - 3*log10(Act_Sud) - log10(Act_Afchl);
        % x = log10(Act_Crdp^3/(Act_Sud^3 * Act_Afchl)); % other method ok

        Temp = 1/(0.00293 - 5.13e-4 * x + 3.904e-5 * x^2) - 273.15; % quadratic equation
        %T2 = 1/(0.00264 - 2.897e-4 * x) - 273.15; % other solution

        % Cmp computation:
        AtomSiteRep = zeros(4,4);
        AtomSiteRep(1,1) = Si_T2 / 2;
        AtomSiteRep(2,1) = Al_T2 / 2;
        AtomSiteRep(1,2) = Mg_M1;
        AtomSiteRep(2,2) = Fe_M1;
        AtomSiteRep(3,2) = Al_M1;
        AtomSiteRep(4,2) = V_M1;
        AtomSiteRep(1,3) = Mg_M2M3/4;
        AtomSiteRep(2,3) = Fe_M2M3/4;
        AtomSiteRep(3,3) = Al_M2M3/4;
        AtomSiteRep(1,4) = Al_M4;
        AtomSiteRep(1,4) = Al_M4;
        AtomSiteRep(3,4) = Mg_M4;
        AtomSiteRep(2,4) = Fe3;
        
%         if Temp>500
%             AtomSiteRep
%         end
        
        if all(AtomSiteRep >= 0) % Validity (cmp positif) P. Lanari option for the Inoue thermometer. 
            T(i) = Temp;
            Al4(i) = Aliv;
        else
            T(i) = 0;
            Al4(i) = 0;
        end

    else
        T(i) = 0;
        Al4(i) = 0;
    end
        
end

XmapWaitBar(1,handles);
return






