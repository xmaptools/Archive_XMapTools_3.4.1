function [P] = ThermoFctCpxLanariPa(Data,handles)
% -
% XmapTools Function (version 1.5)
% Use this function only with XmapTools 1.5.
%
% LANARI function for Cpx+Plagio+Amphibole
% Pressure estimate with the callibration of Holland... 
%
%
% [Values] = ThermoFctCpxLanariPTa(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>Clinopyroxene>Cpx P-T (Cpx-Gar-Phg)>ThermoFctCpxLanariPTa> 
% P T Al_phg Si_phg Mg_phg Xalm Xpyr Xgro Xalm
% >SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 6 Oxygens
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 8/11/11.
% Version with pre-loading...


P = zeros(1,length(Data(:,1)));
%T = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 6; % Oxygens, DO NOT CHANGE !!!

% Input Plagio composition
lesNames = {'Xalb (Xalb)'};
lesDef = {'0.87'};
[Values] = str2num(char(inputdlg(lesNames,'Input Plagioclase composition',1,lesDef)));
Xalb = Values(1); 
clear Values lesNames lesDef

% Input Amphibole composition
lesNames = {'Si_amp','Al_amp','Fe_amp','Mg_amp','Na_amp','Ca_amp'};
lesDef = {'6.4','2.32','1.24','3.07','0.81','1.72'};
[Values] = str2num(char(inputdlg(lesNames,'Input Amphiboles compositions',1,lesDef)));
Si_amp = Values(1);
Al_amp = Values(2);
Fe_amp = Values(3);
Mg_amp = Values(4);
Na_amp = Values(5);
Ca_amp = Values(6);
clear Values lesNames lesDef


% Input Temperature composition
lesNames = {'Temperature (°C)'};
lesDef = {'700'};
[Values] = str2num(char(inputdlg(lesNames,'Input Temperature',1,lesDef)));
T = Values(1); 

T = T+273.17;


clear Values lesNames lesDef






% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20]; % atomic mass


for i=1:length(Data(:,1)) % one by one
    
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
    	TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si_cpx = lesResults(1);
        Ti_cpx = lesResults(2);
        Al_cpx = lesResults(3); 
        Fe_cpx = lesResults(4)+ lesResults(5);
        Mn_cpx = lesResults(6);
        Mg_cpx = lesResults(7);
        Ca_cpx = lesResults(8); 
        Na_cpx = lesResults(9); 
        K_cpx = lesResults(10);
        Cr_cpx = 0;
        
        
        % Pressure estimate: 
        
        
        
        R = 0.008314472;
        % units Kb & kJ, K. 
        
        
        % AMPHIBOLES 
        
        % Margules Parameters
        Wpargts = 0;
        Wpargtr = 30;
        Wpargftr = 38;
        Wtstr = 20;
        Wtsftr = -38;
        Wtrftr = 10;
        
        % Compositional variables
        x = Fe_amp/(Fe_amp+Mg_amp); % XFe
        y = (Al_amp -  (8 - Si_amp))/2; % XAl,M2
        a = Na_amp - (2 - Ca_amp); % Na,A
        
        % Proportion of independent end-members
        ptr = 1-0.5*a - y - 1/5*x*(5 - 2*y);
        pftr = (1/5)*x*(5 - 2*y);
        pts = y - 0.5*a;
        pparg = a;
        
        % Site fractions
        XV_A = 1-a;
        XNa_A = a;
        XMg_M13 = 1-x;
        XFe_M13 = x;
        XAl_M2 = y;
        XMg_M2 = (1-y)*(1-x);
        XFe_M2 = (1-y)*x;
        XAl_T1 = (1/4)*a + 0.5*y;
        XSi_T1 = 1 - (1/4)*a - 0.5*y;
        
        
        % ideal mixing activities
        aiparg = 16*XNa_A * (XMg_M13)^3 * XMg_M2 * XAl_M2 * XAl_T1 * XSi_T1;
        aitr = XV_A * XMg_M13^3 * XMg_M2^2 * XSi_T1^2;
        aits = 4 * XV_A * XMg_M13^3 * XAl_M2^2 * XAl_T1 * XSi_T1;
        
        
        RTlny_tr = - pparg*pts*Wpargts + pparg*(1-ptr)*Wpargtr - pparg*pftr*Wpargftr ...
            + pts*(1-ptr)*Wtstr - pts*pftr*Wtsftr + (1-ptr)*pftr*Wtrftr;
        
        RTlny_parg = (1-pparg)*pts*Wpargts + (1-pparg)*ptr*Wpargtr + (1-pparg)*pftr*Wpargftr ...
            - pts*ptr*Wtstr - pts*pftr*Wtsftr - ptr*pftr*Wtrftr;
        
        RTlny_ts = pparg*(1-pts)*Wpargts - pparg*ptr*Wpargtr - pparg*pftr*Wpargftr ...
            + (1-pts)*ptr*Wtstr + (1-pts)*pftr*Wtsftr - ptr*pftr*Wtrftr;
        
        
        y_tr = exp(RTlny_tr/(R*T));
        y_parg = exp(RTlny_parg/(R*T));
        y_ts = exp(RTlny_ts/(R*T));
        
        aparg = aiparg * y_parg;
        atr = aitr * y_tr;
        ats = aits * y_ts;
        
        
        % CPX
        if Si_cpx < 2
            Aliv_cpx = 2-Si_cpx;
        else
            Aliv_cpx = 0;
        end

        Alvi_cpx = Al_cpx-Aliv_cpx;

        XFe_cpx = Fe_cpx/(Fe_cpx+Mg_cpx);
        XMg_cpx = Mg_cpx/(Fe_cpx+Mg_cpx);

        MgFe_M1_cpx = 1 - (Alvi_cpx+Ti_cpx+Cr_cpx); % + Fe3+ 
        Fe_M1_cpx = XFe_cpx*MgFe_M1_cpx;
        Mg_M1_cpx = XMg_cpx*MgFe_M1_cpx;

        MgFe_M2_cpx = 1 - (Mn_cpx+Ca_cpx+Na_cpx);
        XCa_M2_cpx = Ca_cpx/(Ca_cpx+MgFe_M2_cpx+Mn_cpx+Na_cpx);

        RTlny_jd = Ca_cpx*(Mg_M1_cpx*26 + (MgFe_M1_cpx - Mg_M1_cpx)*25);
        y_jd = exp(RTlny_jd/(R*T));
        
        ajd = Alvi_cpx*Na_cpx*y_jd;
        
        
        % PLAGIOCLASE
        aalb = Xalb;
        
        
        % barometer
        lnK = log((aparg^2 * aalb^6)/(ajd^8 * atr^1 * ats^1));
        
        laP = (0.35064*T - 59.34 - R*T*lnK)/11.924; 

        if  laP > 1 && laP < 40 
       
            P(i) = laP;

            
        else
            P(i) = 0;

            
        end
        
        
    else
            P(i) = 0;

            
    end
end

XmapWaitBar(1,handles);

return




% 
% function [laT] = HGTempFromPressure(XCa_gar,laP,Kd_cg)
% 
% laT = (3104*XCa_gar + 3030 + 10.86*laP) / (log(Kd_cg) + 1.9034) - 273.15;
% 
% return
% 
% 
% 
% function P = WMPressureFromTemp(laT,laP,Si_cpx,Ti_cpx,Al_cpx,Fe_cpx,Mn_cpx,Mg_cpx,Ca_cpx,Na_cpx,K_cpx,Cr_cpx,Si_phg,Al_phg,Ti_phg,Cr_phg,Fe_phg,Mn_phg,Mg_phg,Ca_phg,Na_phg,K_phg,XFe_gar,XMg_gar,XCa_gar,XMn_gar);
% T = laT+273.15;
% P = laP;
% R = 8.3144;
% 
% 
% 
% % GARNET
% WCaMg = 21627 - T * 5.78 + 1000 * P * 0.012; 
% WMgCa = 9834 - T * 5.78 + 1000 * P * 0.058;
% WCaFe = 873 - T * 1.69 + 1000 * P * 0;
% WFeCa = 6773 - T * 1.69 + 1000 * P * 0.03;
% WMgFe = 2117 - T * 0 + 1000 * P * 0.07;
% WFeMg = 695 - T * 0 + 1000 * P * 0;
% WMgMn = 12083 - T * 7.67 + 1000 * P * 0.04;
% WMnMg = 12083 - T * 7.67 + 1000 * P * 0.03;
% WFeMn = 539 - T * 0 + 1000 * P * 0.04;
% WMnFe = 539 - T * 0 + 1000 * P * 0.01;
% 
% RTlnyFe_gar = (1-2*XFe_gar)*(WFeMg*XMg_gar^2+WFeCa*XCa_gar^2+WFeMn*XMn_gar^2) + 2*(1-XFe_gar)*(WMgFe*XFe_gar*XMg_gar+WCaFe*XCa_gar*XFe_gar+WMnFe*XMn_gar*XFe_gar) - 2*(WMgCa*XMg_gar*XCa_gar^2+WCaMg*XCa_gar*XMg_gar^2+WMgMn*XMg_gar*XMn_gar^2+WMnMg*XMn_gar*XMg_gar^2)+0.5*(1-2*XFe_gar)*(XMg_gar*XCa_gar*(WFeMg+WMgFe+WFeCa+WCaFe+WMgCa+WCaMg)+XMg_gar*XMn_gar*(WFeMg+WMgFe+WFeMn+WMnFe+WMgMn+WMnMg)+XCa_gar*XMn_gar*(WFeCa+WCaFe+WFeMn+WMnFe))-XMg_gar*XCa_gar*XMn_gar*(WMgCa+WCaMg+WMgMn+WMnMg);
% lnyFe_gar = RTlnyFe_gar / (R*T);
% yFe_gar = exp(lnyFe_gar);
% aAlm = (yFe_gar * XFe_gar)^3;
% 
% RTlnyCa_gar = (1-2*XCa_gar)*(WCaMg*XMg_gar^2+WCaFe*XFe_gar^2)+2*(1-XCa_gar)*(WMgCa*XMg_gar*XCa_gar+WFeCa*XCa_gar*XFe_gar)-2*(WMgFe*XMg_gar*XFe_gar^2+WFeMg*XFe_gar*XMg_gar^2+WMgMn*XMg_gar*XMn_gar^2+WMnMg*XMn_gar*XMg_gar^2+WMnFe*XMn_gar*XFe_gar^2+WFeMn*XFe_gar*XMn_gar^2)+0.5*(1-2*XCa_gar)*(XMg_gar*XFe_gar*(WCaMg+WMgCa+WCaFe+WFeCa+WMgFe+WFeMg)+XMg_gar*XMn_gar*(WCaMg+WMgCa+WMgMn+WMnMg)+XFe_gar*XMn_gar*(WCaFe+WFeCa+WFeMn+WMnFe))-XMg_gar*XFe_gar*XMn_gar*(WMgFe+WFeMg+WMgMn+WMnMg+WFeMn+WMnFe);
% lnyCa_gar = RTlnyCa_gar / (R*T);
% yCa_gar = exp(lnyCa_gar);
% aGro = (yCa_gar * XCa_gar)^3; 
% 
% 
% RTlnyMg_gar = (1-2*XMg_gar)*(WMgCa*XCa_gar^2+WMgFe*XFe_gar^2+WMgMn*XMn_gar^2)+2*(1-XMg_gar)*(WCaMg*XMg_gar*XCa_gar+WFeMg*XMg_gar*XFe_gar+WMnMg*XMn_gar*XMg_gar)-2*(WCaFe*XCa_gar*XFe_gar^2+WFeCa*XFe_gar*XCa_gar^2+WMnFe*XMn_gar*XFe_gar^2+WFeMn*XFe_gar*XMn_gar^2)+0.5*(1-2*XMg_gar)*(XCa_gar*XFe_gar*(WMgCa+WCaMg+WMgFe+WFeMg+WCaFe+WFeCa)+XCa_gar*XMn_gar*(WMgCa+WCaMg+WMgMn+WMnMg)+XFe_gar*XMn_gar*(WMgFe+WFeMg+WMgMn+WMnMg+WFeMn+WMnFe))-XCa_gar*XFe_gar*XMn_gar*(WCaFe+WFeCa+WFeMn+WMnFe);
% lnyMg_gar = RTlnyMg_gar / (R*T);
% yMg_gar = exp(lnyMg_gar);
% aPyr = (yMg_gar * XMg_gar)^3;
% 
% 
% % PHG
% Aliv_phg = 4-Si_phg;
% Alvi_phg = Al_phg-Aliv_phg;
% 
% Si_phg = Si_phg*2; Al_phg = Al_phg*2; Ti_phg = Ti_phg*2; Cr_phg = Cr_phg*2; 
% Fe_phg = Fe_phg*2; Mn_phg = Mn_phg*2; Mg_phg = Mg_phg*2; 
% Ca_phg = Ca_phg*2; Na_phg = Na_phg*2; K_phg = K_phg*2;
% Aliv_phg = Aliv_phg*2; Alvi_phg = Alvi_phg*2;
% 
% A_phg = Ca_phg+Na_phg+K_phg;
% C_phg = Si_phg+Al_phg+Ti_phg+Cr_phg+Fe_phg+Mn_phg+Mg_phg+Ca_phg+Na_phg+K_phg;
% CA_phg = C_phg-A_phg;
% 
% leFactor_phg = 12/CA_phg;
% 
% Si_phg = Si_phg*leFactor_phg;
% Aliv_phg = 8-Si_phg;
% Alvi_phg = Al_phg*leFactor_phg-Aliv_phg;
% Ti_phg = Ti_phg*leFactor_phg;
% Cr_phg = Cr_phg*leFactor_phg;
% Fe_phg = Fe_phg*leFactor_phg;
% Mn_phg = Mn_phg*leFactor_phg;
% Mg_phg = Mg_phg*leFactor_phg;
% Ca_phg = Ca_phg*leFactor_phg;
% Na_phg = Na_phg*leFactor_phg;
% K_phg = K_phg*leFactor_phg;
% 
% XAl_M2A_phg = (Alvi_phg-2)/2;
% XMg_M2_phg = Mg_phg/2;
% XFe_M2_phg = Fe_phg/2;
% XSi_T1_phg = (Si_phg-4)/4;
% XAl_T1_phg = 1 - XSi_T1_phg;
% XK_Mu_phg = K_phg/2;
% 
% aMu = 4*XAl_M2A_phg*XSi_T1_phg*XAl_T1_phg*XK_Mu_phg;
% aCel = XK_Mu_phg*XMg_M2_phg*XSi_T1_phg^2;
% 
% 
% 
% % CPX
% if Si_cpx < 2
%     Aliv_cpx = 2-Si_cpx;
% else
%     Aliv_cpx = 0;
% end
% 
% Alvi_cpx = Al_cpx-Aliv_cpx;
% 
% XFe_cpx = Fe_cpx/(Fe_cpx+Mg_cpx);
% XMg_cpx = Mg_cpx/(Fe_cpx+Mg_cpx);
% 
% MgFe_M1_cpx = 1 - (Alvi_cpx+Ti_cpx+Cr_cpx); % + Fe3+ 
% Fe_M1_cpx = XFe_cpx*MgFe_M1_cpx;
% Mg_M1_cpx = XMg_cpx*MgFe_M1_cpx;
% 
% MgFe_M2_cpx = 1 - (Mn_cpx+Ca_cpx+Na_cpx);
% XCa_M2_cpx = Ca_cpx/(Ca_cpx+MgFe_M2_cpx+Mn_cpx+Na_cpx);
% 
% RTlnyDi_cpx = Na_cpx*(0*26+Mg_M1_cpx*1+Alvi_cpx*26);
% lnyDi_cpx = RTlnyDi_cpx/(0.001*R*T);
% yDi_cpx = exp(lnyDi_cpx);
% 
% aDi = Mg_M1_cpx*XCa_M2_cpx*yDi_cpx;
% 
% 
% % PRESSURE ESTIMATE
% leK = (aGro^2 * aPyr * aCel^3) / (aMu^3 * aDi^6);
% lnK = log(leK);
% 
% P = 18.013 + 0.002425 * T * lnK + 0.027806*T;
% 
% 
% return
% 
% 
% 
% 
% 
% 
% 
% 
% if 0
% % :::::::  Save Waters en dessous  :::::::
% R = 8.3144;
% 
% laT = laT+273.15;
% 
% 
% % Garnet
% lny_pyr = ((13807 - 6.276*laT)*Xgro_val*(1-Xpyr_val))/(R*laT);
% lny_gro = ((13807 - 6.273*laT)*Xpyr_val*(1-Xgro_val))/(R*laT);
% 
% lna_pyr = 3*log(Xpyr_val) + 3*lny_pyr + 2*log(Al_gar_val/2);
% lna_gro = 3*log(Xgro_val) + 3*lny_gro + 2*log(Al_gar_val/2);
% 
% 
% % cpx
% lny_di = (Na_cpx*(26000*(Al_cpx+0)+Fe_cpx*(26000-25000)))/(R*laT);
% 
% lna_di = log(Ca_cpx*Mg_cpx) + lny_di;
% 
% 
% % Phengite
% a_phg = ((Al_phg_val+Si_phg_val-4)*(4-Si_phg_val))/(Mg_phg_val*(Si_phg_val-2));
% 
% lnK = 6*lna_di - lna_pyr - 2*lna_gro + 3* log(a_phg);
% 
% laP = 28.05 + 0.02044*laT - 0.003539*laT*lnK;
% 
% end




        

