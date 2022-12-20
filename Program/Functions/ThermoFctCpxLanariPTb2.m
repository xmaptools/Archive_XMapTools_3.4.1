function [P,T] = ThermoFctCpxLanariPTb2(Data,handles)
% -
% XmapTools Function (version 1.5)
% Use this function only with XmapTools 1.5.
%
% LANARI function for Cpx+Garnet+Phengite
% T was estimated with Ravna (2000) between omphacite and garnet
% P-T estimates in Cpx garnet model from Ganguly (PT-mafic 2.0) 
%
%
% Fe_cpx = Fe_2+
%
% [Values] = ThermoFctCpxLanariPTb2(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>Clinopyroxene>Cpx-P-T Rav Fe3 (Cpx-Grt-Phg)>ThermoFctCpxLanariPTb2>P T>
%   SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%
% 6 Oxygens
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 8/11/11.
% Version with pre-loading...


P = zeros(1,length(Data(:,1)));
T = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 6; % Oxygens, DO NOT CHANGE !!!

% Input Garnet composition
lesNames = {'Xalmandin (Xalm)','Xpyrope (Xpyr)','Xgrossular (Xgro)'};
lesDef = {'0.48','0.33','0.18'};

[Values] = str2num(char(inputdlg(lesNames,'Input Garnet compositions',1,lesDef)));

XFe_gar = Values(1); 
XMg_gar = Values(2);
XCa_gar = Values(3);
XMn_gar = 1-(XFe_gar+XMg_gar+XCa_gar);

clear Values lesNames lesDef

% Input Phg composition
lesNames = {'Si','Al','Ti','Cr','Fe','Mn','Mg','Ca','Na','K'};
lesDef = {'3.28','2.22','0.065','0.055','0.065','0','0.34','0.005','0.02','0.975'};

[Values] = str2num(char(inputdlg(lesNames,'Input Phg compositions',1,lesDef)));

Si_phg = Values(1);
Al_phg = Values(2);
Ti_phg = Values(3);
Cr_phg = Values(4);
Fe_phg = Values(5);
Mn_phg = Values(6);
Mg_phg = Values(7);
Ca_phg = Values(8);
Na_phg = Values(9);
K_phg  = Values(10);

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
        
        
        %Fe2-Fe3 / Cpx
        Diff23 = Na_cpx - (Al_cpx - (Si_cpx-2) / 2);
        
        % Update for Fe3+ ...
        if Diff23 > 0 % Fe3+
            Fe3_cpx = Diff23;
            Fe_cpx = Fe_cpx - Fe3_cpx; 
        end

    
    
        % Temperature estimates (Ravna, 2000)
        Kd_cg = (XFe_gar/XMg_gar)/(Fe_cpx/Mg_cpx); % cpx-gar
        
        % Pressure
        
        
        P1 = 25;
        
        T1 = HGTempFromPressure(XCa_gar,XMn_gar,XMg_gar,P1,Kd_cg);
        
        %
        P2 = WMPressureFromTemp(T1,P1,Si_cpx,Ti_cpx,Al_cpx,Fe_cpx,Mn_cpx,Mg_cpx,Ca_cpx,Na_cpx,K_cpx,Cr_cpx ...
            ,Si_phg,Al_phg,Ti_phg,Cr_phg,Fe_phg,Mn_phg,Mg_phg,Ca_phg,Na_phg,K_phg ...
            ,XFe_gar,XMg_gar,XCa_gar,XMn_gar);

        
        T2 = HGTempFromPressure(XCa_gar,XMn_gar,XMg_gar,P2,Kd_cg);
        
      

        Compt = 0;
        while abs(P2-P1) > 0.01 
            Compt = Compt+1;
            if Compt==15
                break
            end
            
            P1 = P2;
            T1 = T2;

            T2 = HGTempFromPressure(XCa_gar,XMn_gar,XMg_gar,P2,Kd_cg);
            P2 = WMPressureFromTemp(T2,P2,Si_cpx,Ti_cpx,Al_cpx,Fe_cpx,Mn_cpx,Mg_cpx,Ca_cpx,Na_cpx,K_cpx,Cr_cpx ...
            ,Si_phg,Al_phg,Ti_phg,Cr_phg,Fe_phg,Mn_phg,Mg_phg,Ca_phg,Na_phg,K_phg ...
            ,XFe_gar,XMg_gar,XCa_gar,XMn_gar);
        
        end


        if  T1 > 1 && T1 < 1200 && P2 > 1 && P2 < 50 && isreal(T1) && isreal(P2)
       
            P(i) = P2;
            T(i) = T1;
            
        else
            P(i) = 0;
            T(i) = 0;
            
        end
        
        
    else
            P(i) = 0;
            T(i) = 0;
            
    end
end


XmapWaitBar(1,handles);

return





function [laT] = HGTempFromPressure(XCa_gar,XMn_gar,XMg_gar,laP,Kd_cg)

lnKd = log(Kd_cg);

laT = ((1939.9 + 3270*XCa_gar - 1396*XCa_gar^2 + 3319*XMn_gar - 3535*XMn_gar^2 ...
    + 1105*XMg_gar - 3561*XMg_gar^2 + 2324*XMg_gar^3 + 169.4*laP/10) ...
    / (lnKd + 1.223)) - 273.15;

return



function P = WMPressureFromTemp(laT,laP,Si_cpx,Ti_cpx,Al_cpx,Fe_cpx,Mn_cpx,Mg_cpx,Ca_cpx,Na_cpx,K_cpx,Cr_cpx,Si_phg,Al_phg,Ti_phg,Cr_phg,Fe_phg,Mn_phg,Mg_phg,Ca_phg,Na_phg,K_phg,XFe_gar,XMg_gar,XCa_gar,XMn_gar);
T = laT+273.15;
P = laP;
R = 8.3144;



% GARNET
WCaMg = 21627 - T * 5.78 + 1000 * P * 0.012; 
WMgCa = 9834 - T * 5.78 + 1000 * P * 0.058;
WCaFe = 873 - T * 1.69 + 1000 * P * 0;
WFeCa = 6773 - T * 1.69 + 1000 * P * 0.03;
WMgFe = 2117 - T * 0 + 1000 * P * 0.07;
WFeMg = 695 - T * 0 + 1000 * P * 0;
WMgMn = 12083 - T * 7.67 + 1000 * P * 0.04;
WMnMg = 12083 - T * 7.67 + 1000 * P * 0.03;
WFeMn = 539 - T * 0 + 1000 * P * 0.04;
WMnFe = 539 - T * 0 + 1000 * P * 0.01;

RTlnyFe_gar = (1-2*XFe_gar)*(WFeMg*XMg_gar^2+WFeCa*XCa_gar^2+WFeMn*XMn_gar^2) + 2*(1-XFe_gar)*(WMgFe*XFe_gar*XMg_gar+WCaFe*XCa_gar*XFe_gar+WMnFe*XMn_gar*XFe_gar) - 2*(WMgCa*XMg_gar*XCa_gar^2+WCaMg*XCa_gar*XMg_gar^2+WMgMn*XMg_gar*XMn_gar^2+WMnMg*XMn_gar*XMg_gar^2)+0.5*(1-2*XFe_gar)*(XMg_gar*XCa_gar*(WFeMg+WMgFe+WFeCa+WCaFe+WMgCa+WCaMg)+XMg_gar*XMn_gar*(WFeMg+WMgFe+WFeMn+WMnFe+WMgMn+WMnMg)+XCa_gar*XMn_gar*(WFeCa+WCaFe+WFeMn+WMnFe))-XMg_gar*XCa_gar*XMn_gar*(WMgCa+WCaMg+WMgMn+WMnMg);
lnyFe_gar = RTlnyFe_gar / (R*T);
yFe_gar = exp(lnyFe_gar);
aAlm = (yFe_gar * XFe_gar)^3;

RTlnyCa_gar = (1-2*XCa_gar)*(WCaMg*XMg_gar^2+WCaFe*XFe_gar^2)+2*(1-XCa_gar)*(WMgCa*XMg_gar*XCa_gar+WFeCa*XCa_gar*XFe_gar)-2*(WMgFe*XMg_gar*XFe_gar^2+WFeMg*XFe_gar*XMg_gar^2+WMgMn*XMg_gar*XMn_gar^2+WMnMg*XMn_gar*XMg_gar^2+WMnFe*XMn_gar*XFe_gar^2+WFeMn*XFe_gar*XMn_gar^2)+0.5*(1-2*XCa_gar)*(XMg_gar*XFe_gar*(WCaMg+WMgCa+WCaFe+WFeCa+WMgFe+WFeMg)+XMg_gar*XMn_gar*(WCaMg+WMgCa+WMgMn+WMnMg)+XFe_gar*XMn_gar*(WCaFe+WFeCa+WFeMn+WMnFe))-XMg_gar*XFe_gar*XMn_gar*(WMgFe+WFeMg+WMgMn+WMnMg+WFeMn+WMnFe);
lnyCa_gar = RTlnyCa_gar / (R*T);
yCa_gar = exp(lnyCa_gar);
aGro = (yCa_gar * XCa_gar)^3; 


RTlnyMg_gar = (1-2*XMg_gar)*(WMgCa*XCa_gar^2+WMgFe*XFe_gar^2+WMgMn*XMn_gar^2)+2*(1-XMg_gar)*(WCaMg*XMg_gar*XCa_gar+WFeMg*XMg_gar*XFe_gar+WMnMg*XMn_gar*XMg_gar)-2*(WCaFe*XCa_gar*XFe_gar^2+WFeCa*XFe_gar*XCa_gar^2+WMnFe*XMn_gar*XFe_gar^2+WFeMn*XFe_gar*XMn_gar^2)+0.5*(1-2*XMg_gar)*(XCa_gar*XFe_gar*(WMgCa+WCaMg+WMgFe+WFeMg+WCaFe+WFeCa)+XCa_gar*XMn_gar*(WMgCa+WCaMg+WMgMn+WMnMg)+XFe_gar*XMn_gar*(WMgFe+WFeMg+WMgMn+WMnMg+WFeMn+WMnFe))-XCa_gar*XFe_gar*XMn_gar*(WCaFe+WFeCa+WFeMn+WMnFe);
lnyMg_gar = RTlnyMg_gar / (R*T);
yMg_gar = exp(lnyMg_gar);
aPyr = (yMg_gar * XMg_gar)^3;


% PHG
Aliv_phg = 4-Si_phg;
Alvi_phg = Al_phg-Aliv_phg;

Si_phg = Si_phg*2; Al_phg = Al_phg*2; Ti_phg = Ti_phg*2; Cr_phg = Cr_phg*2; 
Fe_phg = Fe_phg*2; Mn_phg = Mn_phg*2; Mg_phg = Mg_phg*2; 
Ca_phg = Ca_phg*2; Na_phg = Na_phg*2; K_phg = K_phg*2;
Aliv_phg = Aliv_phg*2; Alvi_phg = Alvi_phg*2;

A_phg = Ca_phg+Na_phg+K_phg;
C_phg = Si_phg+Al_phg+Ti_phg+Cr_phg+Fe_phg+Mn_phg+Mg_phg+Ca_phg+Na_phg+K_phg;
CA_phg = C_phg-A_phg;

leFactor_phg = 12/CA_phg;

Si_phg = Si_phg*leFactor_phg;
Aliv_phg = 8-Si_phg;
Alvi_phg = Al_phg*leFactor_phg-Aliv_phg;
Ti_phg = Ti_phg*leFactor_phg;
Cr_phg = Cr_phg*leFactor_phg;
Fe_phg = Fe_phg*leFactor_phg;
Mn_phg = Mn_phg*leFactor_phg;
Mg_phg = Mg_phg*leFactor_phg;
Ca_phg = Ca_phg*leFactor_phg;
Na_phg = Na_phg*leFactor_phg;
K_phg = K_phg*leFactor_phg;

XAl_M2A_phg = (Alvi_phg-2)/2;
XMg_M2_phg = Mg_phg/2;
XFe_M2_phg = Fe_phg/2;
XSi_T1_phg = (Si_phg-4)/4;
XAl_T1_phg = 1 - XSi_T1_phg;
XK_Mu_phg = K_phg/2;

aMu = 4*XAl_M2A_phg*XSi_T1_phg*XAl_T1_phg*XK_Mu_phg;
aCel = XK_Mu_phg*XMg_M2_phg*XSi_T1_phg^2;



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

RTlnyDi_cpx = Na_cpx*(0*26+Mg_M1_cpx*1+Alvi_cpx*26);
lnyDi_cpx = RTlnyDi_cpx/(0.001*R*T);
yDi_cpx = exp(lnyDi_cpx);

aDi = Mg_M1_cpx*XCa_M2_cpx*yDi_cpx;


% PRESSURE ESTIMATE
leK = (aGro^2 * aPyr * aCel^3) / (aMu^3 * aDi^6);
lnK = log(leK);

P = 18.013 + 0.002425 * T * lnK + 0.027806*T;


return








if 0
% :::::::  Save Waters en dessous  :::::::
R = 8.3144;

laT = laT+273.15;


% Garnet
lny_pyr = ((13807 - 6.276*laT)*Xgro_val*(1-Xpyr_val))/(R*laT);
lny_gro = ((13807 - 6.273*laT)*Xpyr_val*(1-Xgro_val))/(R*laT);

lna_pyr = 3*log(Xpyr_val) + 3*lny_pyr + 2*log(Al_gar_val/2);
lna_gro = 3*log(Xgro_val) + 3*lny_gro + 2*log(Al_gar_val/2);


% cpx
lny_di = (Na_cpx*(26000*(Al_cpx+0)+Fe_cpx*(26000-25000)))/(R*laT);

lna_di = log(Ca_cpx*Mg_cpx) + lny_di;


% Phengite
a_phg = ((Al_phg_val+Si_phg_val-4)*(4-Si_phg_val))/(Mg_phg_val*(Si_phg_val-2));

lnK = 6*lna_di - lna_pyr - 2*lna_gro + 3* log(a_phg);

laP = 28.05 + 0.02044*laT - 0.003539*laT*lnK;

end




        

