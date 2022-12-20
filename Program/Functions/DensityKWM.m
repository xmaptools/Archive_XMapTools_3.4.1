function [DensKWM,Xcel,Xmu,Xpyr,Xpar] = DensityKWM(Data,handles)
% -
% XMapTools Density Function (introduced in 2.3.1)
%
% This function calculates the structural formula of K-white-mica and the 
% corresponding density
%
% [Values] = DensityKWM(Data,handles);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file.
% 
% Order : SiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 5>K-WhiteMica>Density_KWM>DensityKWM>DensKWM Xcel Xmu Xpyr Xpar>
% SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 11 Oxygen basis
%
% Created by P. Lanari (August 2016) - TESTED & VERIFIED 31/08/16.
%


DensKWM = zeros(1,length(Data(:,1)));
Xcel = zeros(1,length(Data(:,1)));
Xmu = zeros(1,length(Data(:,1)));
Xpyr = zeros(1,length(Data(:,1))); 
Xpar = zeros(1,length(Data(:,1)));

Fe3Per = 0;
%Fe3Per = str2num(char(inputdlg('Fe3+ (30-70%)','Input',1,{'0'})));

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
        Al_T2 = 4-Si;
        Si_T2 = 2-Al_T2;
        Al_M2M3 = Al-Al_T2;
        XMg = Mg/(Mg+Fe2);
        XFe = 1-XMg;
        FeMg_M2M3 = 2 - Al_M2M3 - Fe3;
        
        if FeMg_M2M3 > Fe2+Mg
            FeMg_M2M3 = Fe2+Mg;
        end
        
        Na_A = Na;
        V_A = 1 - K - Na - Ca;
        
        if V_A < 0
            V_A = 0.000001;
        end
        
        % Solid Solution LAST P. LANARI version:

        Npar = Na_A;
        Nmu = Al_T2 - Na_A;
        Npyr = V_A;
        Ncel = FeMg_M2M3;
         
        Xpar(i) = Npar/(Npar+Nmu+Npyr+Ncel);
        Xmu(i) = Nmu/(Npar+Nmu+Npyr+Ncel);
        Xpyr(i) = Npyr/(Npar+Nmu+Npyr+Ncel);
        Xcel(i) = Ncel/(Npar+Nmu+Npyr+Ncel);
        
        % Densities from Theriak using the SS model of Dubacq et al. (2009)
        % at 450C and 10000 kbar
        
        DensKWM(i) = Xmu(i)*2.834 + Xpar(i)*2.896 + Xpyr(i)*2.827 + Xcel(i)*XFe*3.002 +  Xcel(i)*XMg*2.847;
        
        % Analysis filter:
        if Si < 3 || Xpar(i) > 1 || Xcel(i) > 1 || Xpyr(i) > 1 || Xmu(i) > 1 || ...
             Xpar(i) < 0 || Xcel(i) < 0 || Xpyr(i) < 0 || Xmu(i) < 0 
            DensKWM(i) = 0;
            Xcel(i) = 0;
            Xmu(i) = 0;
            Xpyr(i) = 0;
            Xpar(i) = 0;
        end
        
    else
        DensKWM(i) = 0;
        Xcel(i) = 0;
        Xmu(i) = 0;
        Xpyr(i) = 0;
        Xpar(i) = 0;
    end
        
end

XmapWaitBar(1,handles);
return






