function [Si_T1,Si_T2,Al_T2,Al_M1,Fe_M1,Mg_M1,Mn_M1,V_M1,Ti_M2,Fe_M2,Mg_M2,Mn_M2,K_A,Ca_A,Na_A,V_A,XMg,XFe,XAnn,XPhl,XSid,XEas,XTibt,XMnbt,Xsum] = StructFctBiotite(Data,handles)
% -
% XMapTools External Function: structural formula of biotite 
%   
% 
%  ++03.2020 New structural formula for biotite (with Ti and Mn EM)
%       - Ti assumed to be ordered onto M2
%       - Al assumed to be ordered onto M1
%       - Mn added (ordered onto M12)
%  ++11.2015 
%       - End-member proportions based on biotite Al-content
%   
%   ----------------------------------------------------
%   End-member      T1(2)   T2(2)   M1(1)   M2(2)   A(1)
%   ----------------------------------------------------
%   Phlogopite      Si,Si   Si,Al   Mg      Mg,Mg   K
%   Annite          Si,Si   Si,Al   Fe      Fe,Fe   K
%   Eastonite       Si,Si   Al,Al   Al      Mg,Mg   K
%   Siderophyllite  Si,Si   Al,Al   Al      Fe,Fe   K
%   Ti-biotite      Si,Si   Si,Al   Mg      Ti,Mg   K
%   Mn-biotite      Si,Si   Si,Al   Mn      Mn,Mn   K
%   ----------------------------------------------------   
%   Not considered:
%   Muscovite       Si,Si   Si,Al   V       Mg,Mg   K
%   ----------------------------------------------------
%
% 11 Oxygens 
%
% Created by P. Lanari (August 2011) - Last update 09.03.2020
% Find out more at http://www.xmaptools.com


Si_T1 = zeros(1,length(Data(:,1)));
Si_T2 = zeros(1,length(Data(:,1)));
Al_T2 = zeros(1,length(Data(:,1)));

Al_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Mn_M1 = zeros(1,length(Data(:,1)));
V_M1 = zeros(1,length(Data(:,1)));

Ti_M2 = zeros(1,length(Data(:,1)));
Fe_M2 = zeros(1,length(Data(:,1)));
Mg_M2 = zeros(1,length(Data(:,1)));
Mn_M2 = zeros(1,length(Data(:,1)));

K_A = zeros(1,length(Data(:,1)));
Ca_A = zeros(1,length(Data(:,1)));
Na_A = zeros(1,length(Data(:,1)));
V_A = zeros(1,length(Data(:,1)));

XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));

XAnn = zeros(1,length(Data(:,1)));
XPhl = zeros(1,length(Data(:,1)));
XSid = zeros(1,length(Data(:,1)));
XEas = zeros(1,length(Data(:,1)));
XTibt = zeros(1,length(Data(:,1)));
XMnbt = zeros(1,length(Data(:,1)));
Xsum = zeros(1,length(Data(:,1)));

Fe3Per = 0;

XmapWaitBar(0,handles);

% General function for structural formula (new 3.4.1)
WhereMin = find(sum(Data,2) > 50);
[MatrixSF,El] = XMT_StructuralFormula(Data(WhereMin,:),'SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O',11);

hCompt = 0;
for ii=1:length(WhereMin) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(ii/length(WhereMin),handles);
        hCompt = 1;
    end
    
    i = WhereMin(ii);
    
    % Association:
    Si = MatrixSF(ii,1);
    Ti = MatrixSF(ii,2);
    Al= MatrixSF(ii,3);
    Fe= MatrixSF(ii,4);
    Mn= MatrixSF(ii,5);
    Mg= MatrixSF(ii,6);
    Ca= MatrixSF(ii,7);
    Na= MatrixSF(ii,8);
    K= MatrixSF(ii,9);
    
    
    % Structural Formula (version SWOT - March 2020)
    XMg(i) = Mg/(Mg+Fe);
    XFe(i) = 1-XMg(i);
    
    Si_T1(i) = 2;
    Si_T2(i) = Si-Si_T1(i);
    
    Al_T2_theo = 2-(Si_T2(i));   % This is the amount free in T2 for Al
    
    if Al_T2_theo > Al
        Al_T2(i) = Al;         % we have not enough Al !!!
    else
        Al_T2(i) = Al_T2_theo;
    end
    
    Alvi = Al-Al_T2(i);
    
    % M2:
    Mn_M2(i) = 2*Mn/3;
    Ti_M2(i) = Ti;
    Mg_M2(i) = Ti;
    
    FeMg_M2 = 2-(Mn_M2(i)+Ti_M2(i));
    FeMgEqui_M2 =  FeMg_M2-Mg_M2(i);
    
    Mg_M2(i) = Mg_M2(i) + FeMgEqui_M2*XMg(i);
    Fe_M2(i) = FeMgEqui_M2*XFe(i);
    
    %Sum_M2 = Mn_M2(i)+Ti_M2(i)+Mg_M2(i)+Fe_M2(i);
    
    % M1:
    Mn_M1(i) = Mn/3;
    Mg_M1(i) = Ti;     % contribution from Tibt
    
    if (Alvi + Mn_M1(i) + Mg_M1(i)) < 1
        Al_M1(i) = Alvi;
    else
        Al_M1(i) = 1 - (Mn_M1(i) + Mg_M1(i));
    end
    
    FeMg_Equi_M1 = (Fe+Mg) - (Fe_M2(i)+Mg_M2(i)) - Mg_M1(i);
    
    if FeMg_Equi_M1 + Mn_M1(i) + Mg_M1(i) + Al_M1(i) < 1
        V_M1(i) = 1 - (FeMg_Equi_M1 + Mn_M1(i) + Mg_M1(i) + Al_M1(i));
        Mg_M1(i) = Mg_M1(i) + XMg(i)*FeMg_Equi_M1;
        Fe_M1(i) = XFe(i)*FeMg_Equi_M1;
    else
        V_M1(i) = 0;
        AvailableFeMgM1 = 1 - (Mn_M1(i) + Mg_M1(i) + Al_M1(i));
        Mg_M1(i) = Mg_M1(i) + XMg(i)*AvailableFeMgM1;
        Fe_M1(i) = XFe(i)*AvailableFeMgM1;
    end
    
    % A
    K_A(i) = K;
    Ca_A(i) = Ca;
    Na_A(i) = Na;
    
    if K+Ca+Na <= 1;
        V_A(i) = 1-(K+Ca+Na);
    else
        V_A(i) = 0;            % to high interfoliar sum !!!
    end
    
    % EM proportions (version SWOT - March 2020)
    % I added filtering to avoid calculating EM fractions of mixing pixels
    XTibt(i) = Ti_M2(i);    
    XMnbt(i) = Mn_M1(i);
    
    if XTibt(i) + XMnbt(i) > 1 % Filter 1
        XTibt(i) = Ti_M2(i)/(Ti_M2(i) + Mn_M1(i));
        XMnbt(i) = Mn_M1(i)/(Ti_M2(i) + Mn_M1(i));
    end
    
    XOrd = 1 - (XTibt(i)+XMnbt(i));
    XSidEast = Al_T2(i)-1;
    XPhlAnn = XOrd - XSidEast;
    
    if (XTibt(i) + XMnbt(i) + abs(XSidEast) + abs(XPhlAnn)) <= 1 % Filter 2
        XAnn(i) = XPhlAnn * XFe(i);
        XPhl(i) = XPhlAnn * XMg(i);
        XSid(i) = XSidEast * XFe(i);
        XEas(i) = XSidEast * XMg(i);
    end
    
    Xsum(i) = XTibt(i)+XMnbt(i)+XAnn(i)+XPhl(i)+XSid(i)+XEas(i);

end

XmapWaitBar(1,handles);
return







hCompt = 1;

NbOx = 11; % Oxygens, DO NOT CHANGE !!!

% Arbitrary cut-off threshold
WhereMin = find(sum(Data,2) > 50);


for ii=1:length(WhereMin) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(ii/length(WhereMin),handles);
        hCompt = 1;
    end
    
    i = WhereMin(ii);
    
    Analyse = Data(i,:);
    
    
    TravMat= NaN*zeros(1,29); % Working matrix
    
    % SiO2 / TiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O
    Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
    NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxyg??nes.
    Cst = [60.09,79.86,101.96,71.85,159.68,70.94,40.30,56.08, ...
        61.98,94.20]; % atomic mass
    
    TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
    TravMat(5) = 0; % Fe2O3
    TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O
    
    for j=1:10
        TravMat(j+10) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
    end
    
    % adding Fe3+
    TravMat(14) = (1-(Fe3Per*0.01)) * Analyse(4) / Cst(4);
    TravMat(15) = Analyse(4) / Cst(4) - TravMat(14);
    
    TravMat(21) = sum((TravMat(11:20) .* NumO) ./ Num); % Oxygen sum
    TravMat(22) = TravMat(21) / NbOx; % ref Ox
    
    TravMat(23:32) = TravMat(11:20) ./ TravMat(22);
    
    % Association:
    Si = TravMat(:,23);
    Ti = TravMat(:,24);
    Al= TravMat(:,25);
    Fe= TravMat(:,26)+ TravMat(:,27);
    Mn= TravMat(:,28);
    Mg= TravMat(:,29);
    Ca= TravMat(:,30);
    Na= TravMat(:,31);
    K= TravMat(:,32);
    
    
    % Structural Formula (version SWOT - March 2020)
    XMg(i) = Mg/(Mg+Fe);
    XFe(i) = 1-XMg(i);
    
    Si_T1(i) = 2;
    Si_T2(i) = Si-Si_T1(i);
    
    Al_T2_theo = 2-(Si_T2(i));   % This is the amount free in T2 for Al
    
    if Al_T2_theo > Al
        Al_T2(i) = Al;         % we have not enough Al !!!
    else
        Al_T2(i) = Al_T2_theo;
    end
    
    Alvi = Al-Al_T2(i);
    
    % M2:
    Mn_M2(i) = 2*Mn/3;
    Ti_M2(i) = Ti;
    Mg_M2(i) = Ti;
    
    FeMg_M2 = 2-(Mn_M2(i)+Ti_M2(i));
    FeMgEqui_M2 =  FeMg_M2-Mg_M2(i);
    
    Mg_M2(i) = Mg_M2(i) + FeMgEqui_M2*XMg(i);
    Fe_M2(i) = FeMgEqui_M2*XFe(i);
    
    %Sum_M2 = Mn_M2(i)+Ti_M2(i)+Mg_M2(i)+Fe_M2(i);
    
    % M1:
    Mn_M1(i) = Mn/3;
    Mg_M1(i) = Ti;     % contribution from Tibt
    
    if (Alvi + Mn_M1(i) + Mg_M1(i)) < 1
        Al_M1(i) = Alvi;
    else
        Al_M1(i) = 1 - (Mn_M1(i) + Mg_M1(i));
    end
    
    FeMg_Equi_M1 = (Fe+Mg) - (Fe_M2(i)+Mg_M2(i)) - Mg_M1(i);
    
    if FeMg_Equi_M1 + Mn_M1(i) + Mg_M1(i) + Al_M1(i) < 1
        V_M1(i) = 1 - (FeMg_Equi_M1 + Mn_M1(i) + Mg_M1(i) + Al_M1(i));
        Mg_M1(i) = Mg_M1(i) + XMg(i)*FeMg_Equi_M1;
        Fe_M1(i) = XFe(i)*FeMg_Equi_M1;
    else
        V_M1(i) = 0;
        AvailableFeMgM1 = 1 - (Mn_M1(i) + Mg_M1(i) + Al_M1(i));
        Mg_M1(i) = Mg_M1(i) + XMg(i)*AvailableFeMgM1;
        Fe_M1(i) = XFe(i)*AvailableFeMgM1;
    end
    
    % A
    K_A(i) = K;
    Ca_A(i) = Ca;
    Na_A(i) = Na;
    
    if K+Ca+Na <= 1;
        V_A(i) = 1-(K+Ca+Na);
    else
        V_A(i) = 0;            % to high interfoliar sum !!!
    end
    
    % EM proportions (version SWOT - March 2020)
    % I added filtering to avoid calculating EM fractions of mixing pixels
    XTibt(i) = Ti_M2(i);    
    XMnbt(i) = Mn_M1(i);
    
    if XTibt(i) + XMnbt(i) > 1 % Filter 1
        XTibt(i) = Ti_M2(i)/(Ti_M2(i) + Mn_M1(i));
        XMnbt(i) = Mn_M1(i)/(Ti_M2(i) + Mn_M1(i));
    end
    
    XOrd = 1 - (XTibt(i)+XMnbt(i));
    XSidEast = Al_T2(i)-1;
    XPhlAnn = XOrd - XSidEast;
    
    if (XTibt(i) + XMnbt(i) + abs(XSidEast) + abs(XPhlAnn)) <= 1 % Filter 2
        XAnn(i) = XPhlAnn * XFe(i);
        XPhl(i) = XPhlAnn * XMg(i);
        XSid(i) = XSidEast * XFe(i);
        XEas(i) = XSidEast * XMg(i);
    end
    
    Xsum(i) = XTibt(i)+XMnbt(i)+XAnn(i)+XPhl(i)+XSid(i)+XEas(i);

end

XmapWaitBar(1,handles);
return






