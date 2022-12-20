function [Si4,Aliv,Alvi,Fe2,Fe3,XFe,XMg,Ti_M2,Ca_M4,Na_M4,Na_A,V_A,XAl_T2,XSi_T2,XTi_M2,XFe3_M2,XFeMg_M2,XAl_M2,XNa_M4,XCa_M4] = StructFctAmphiboles3(Data,handles)
% -
% XMapTools External Function: Structural formula of Ca-amphibole (Fe3+) 
%
%   Note:   Fe3+ is estimated following Holland & Blundy (1994)
%           Ti goes to M2 (Raase 1974)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Amphibole>CaAmp-StructForm-Fe3>StructFctAmphiboles3>Si4 Aliv Alvi Fe2 
%       Fe3 XFe XMg Ti_M2 Ca_M4 Na_M4 Na_A V_A XAl_T2 XSi_T2 XTi_M2 XFe3_M2
%       XFeMg_M2 XAl_M2 XNa_M4 XCa_M4>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O 
%       K2O>
%
%   23 Oxygens
%
% 
% Created by P. Lanari (Octobre 2011) - Last change 22.07.2019  for Michael Jentzer
% Find out more at http://www.xmaptools.com


Si4 = zeros(1,length(Data(:,1)));
Aliv = zeros(1,length(Data(:,1)));
Alvi = zeros(1,length(Data(:,1)));
Fe2 = zeros(1,length(Data(:,1)));
Fe3 = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
Ti_M2 = zeros(1,length(Data(:,1)));
Ca_M4 = zeros(1,length(Data(:,1)));
Na_M4 = zeros(1,length(Data(:,1)));
Na_A = zeros(1,length(Data(:,1)));
V_A = zeros(1,length(Data(:,1)));
XAl_T2 = zeros(1,length(Data(:,1)));
XSi_T2 = zeros(1,length(Data(:,1)));
XTi_M2 = zeros(1,length(Data(:,1)));
XFe3_M2 = zeros(1,length(Data(:,1)));
XFeMg_M2 = zeros(1,length(Data(:,1)));
XAl_M2 = zeros(1,length(Data(:,1)));
XNa_M4 = zeros(1,length(Data(:,1)));
XCa_M4 = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);

hCompt = 1;
NbOx = 23; % Oxygens, DO NOT CHANGE !!!


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
    lesResluts = [];
    

    
    if OnCal
        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe = lesResults(4)+ lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);

        
        % Structural Formulae (P. Lanari - 2019) 
        % Amphiboles Ca with Ti on M2
        WeExclude = 0;
        
        CatTotwithoutCaNaK = Si+Ti+Al+Fe+Mn+Mg;
        TS = 13/CatTotwithoutCaNaK;
        
        Si_norm = Si*TS;
        Ti_norm = Ti*TS;
        Al_norm = Al*TS;
        Fe_norm = Fe*TS;
        %Mn_norm = Mn*TS;
        Mg_norm = Mg*TS;
        Ca_norm = Ca*TS;
        Na_norm = Na*TS;
        %K_norm = K*TS;
        
        Fe3_norm = 2*NbOx*(1-TS);
        
        if Fe3_norm>Fe
            Fe2_norm=0;
        else
            Fe2_norm=Fe_norm-Fe3_norm;
        end
        
        Si4(i) = Si_norm;
        Aliv(i) = 8-Si4(i);
        
        Alvi(i) = Al_norm - Aliv(i);
        
        Fe3(i) = Fe3_norm;
        Fe2(i) = Fe2_norm;
        
        Ti_M2(i) = Ti_norm;
        
        if (Alvi(i) + Fe3(i) + Ti_M2(i)) < 2
            FeMg_M2 = 2 - (Alvi(i) + Fe3(i) + Ti_M2(i)); 
        else
            FeMg_M2 = 0;
            WeExclude = 1;
        end
        
        FeMg_total = Fe2_norm + Mg_norm;
        
        FeMg_M23 = FeMg_total-FeMg_M2;
        
        if FeMg_M23 > 3
            FeMg_M23 = 3;
            FeMg_M4 = FeMg_total - FeMg_M2 - FeMg_M23;
        else
            FeMg_M4 = 0;
        end
            
%         if (FeMg_total - FeMg_M2 - FeMg_M23 ) > 0
%             FeMg_M4 = FeMg_total - FeMg_M2 - FeMg_M23;
%         else
%             FeMg_M4 = 0;
%         end
        
        Na_M4(i) = 2 - Ca_norm - FeMg_M4;
        Ca_M4(i) = Ca_norm;
        
        if (Na_norm - Na_M4(i)) > 0
            Na_A(i) = Na_norm - Na_M4(i);
        else
            Na_A(i) = 0;
        end
        
        V_A(i) = 1-Na_A(i);
        
        XMg(i) = Mg_norm / (Mg_norm + Fe2_norm);
        XFe(i) = Fe2_norm / (Mg_norm + Fe2_norm);
        
        % Site fractions: 
        
        XAl_T2(i) = Aliv(i) / 4;
        XSi_T2(i) = 1 - XAl_T2(i);
       
        XTi_M2(i) = Ti_M2(i) / 2;
        XFe3_M2(i) = Fe3(i) / 2;
        XFeMg_M2(i) = FeMg_M2 / 2;
        XAl_M2(i) = Alvi(i) / 2;
        
        XNa_M4(i) = Na_M4(i) / 2;
        XCa_M4(i) = Ca_M4(i) / 2;

      
        
        if WeExclude || Aliv(i) < 0 || Alvi(i) < 0 || ...
           Ca_M4(i) < 0 || Na_M4(i) < 0 || Na_A(i) < 0 || V_A(i) < 0 || ...
           XAl_T2(i) < 0 || XSi_T2(i) < 0  || XFe3_M2(i) <0 ||  XFeMg_M2(i) <0 || ...
           XAl_M2(i) < 0||  XNa_M4(i)<0 || XCa_M4(i)<0 
           %Xcum(i) < 0 %||Xgl(i) < 0 ||Xmfets(i) < 0 ||Xparg(i) < 0 || ...
           %Xts(i) < 0
            
            Si4(i) = 0;
            Aliv(i) = 0;
            Alvi(i) = 0;
            Fe2(i) = 0;
            Fe3(i) = 0;
            XFe(i) = 0;
            XMg(i) = 0; 
            Ti_M2(i) = 0;
            Ca_M4(i) = 0;
            Na_M4(i) = 0;
            Na_A(i) = 0;
            V_A(i) = 0;
            XAl_T2(i) = 0;
            XSi_T2(i) = 0;
            XTi_M2(i) = 0;
            XFe3_M2(i) = 0;
            XFeMg_M2(i) = 0;
            XAl_M2(i) = 0;
            XNa_M4(i) = 0;
            XCa_M4(i) = 0;
            
        end       
    end
end

XmapWaitBar(1,handles);
return




%         A = [...
%         8   2   0   0   3   2   0; ...
%         8   2   3   0   0   2   0; ...
%         8   0   0   0   5   0   2; ...
%         8   0   5   0   0   0   2; ...
%         6   4   0   0   3   0   2; ...
%         6   4   3   0   0   0   2; ...
%         6   3   0   0   4   1   2; ...
%         6   3   4   0   0   1   2; ...
%         7   1   0   0   5   1   2; ...
%         7   1   5   0   0   1   2; ...
%         6   2   0   2   3   0   2; ...
%         6   2   3   2   0   0   2; ...
%         8   0   0   0   7   0   0; ...
%         8   0   7   0   0   0   0; ...
%         ];
%         
%         %Si() - Al() - Fe2() - Fe3() - Mg() - Na() - Ca()
%         
%         C = [Si_norm(i) Al_norm(i) Fe2_norm(i) Fe3_norm(i) Mg_norm(i) Na_norm(i) Ca_norm(i)];
%         
%         keyboard



        % Somme p?les purs
%         XSum(i) = Xed(i) + Xtr(i) + Xts(i) + Xparg(i) + Xmfets(i) + Xcum(i) + Xgl(i); 
%         
%         Si_rec = 3*Xed(i) + 4*Xtr(i) + 2*Xts(i) + 2*Xparg(i) + 2*Xmfets(i) + 4*Xcum(i) + 4*Xgl(i)
%         Si_mes = Si-4
%         disp('* * * ')
%         Al4_rec = 1*Xed(i) + 0*Xtr(i) + 2*Xts(i) + 2*Xparg(i) + 2*Xmfets(i) + 0*Xcum(i) + 0*Xgl(i)
%         Al4_mes = Aliv(i)
%         disp('* * * ')
%         AlM1_rec = 0*Xed(i) + 0*Xtr(i) + 2*Xts(i) + 1*Xparg(i) + 0*Xmfets(i) + 0*Xcum(i) + 2*Xgl(i)
%         AlM1_mes = Alvi(i)
%         disp('* * * ')
%         NaM4_rec = 0*Xed(i) + 0*Xtr(i) + 0*Xts(i) + 0*Xparg(i) + 0*Xmfets(i) + 0*Xcum(i) + 2*Xgl(i)
%         NaM4_mes = Na_M4(i)
%         disp('* * * ')
%         NaA_rec = 1*Xed(i) + 0*Xtr(i) + 0*Xts(i) + 1*Xparg(i) + 0*Xmfets(i) + 0*Xcum(i) + 0*Xgl(i)
%         NaA_mes = Na_A(i)
%         disp('* * * ')
%         FeMg_M2_rec = 2*Xed(i) + 2*Xtr(i) + 0*Xts(i) + 1*Xparg(i) + 0*Xmfets(i) + 2*Xcum(i) + 0*Xgl(i)
%         NFeMg_M2_mes = FeMg_M2

%XedParg = Na_A;
        
        %Xts(i) = 0.5*(Aliv(i) - XedParg*3 - Xmfets(i)*2);
        
        %Xparg(i) = Alvi(i) - Xgl(i) - 2*Xts(i);
        %Xed(i) = XedParg - Xparg(i);
%         
        %Xtr(i) = FeMg_M2(i)/2 - Xparg(i) - Xed(i) - 2*Xcum(i) ;

        
        

       
        
        
        
        
%         
%         
%         Si4(i) = Si;
%         Aliv(i) = 4 - (Si+Ti - 4);    % +Ti ???
%         Alvi(i) = Al - Aliv(i);
%         Al_T2(i) = Aliv(i);
%         Al_M2(i) = Alvi(i);
%         
%         XFe(i) = Fe/(Fe+Mg+Mn);      % +Mn ???
%         XMg(i) = Mg/(Fe+Mg+Mn);       % +Mn ???
%         
%         FeMg_M2 = 2 - Al_M2(i);
%         FeMg_M23 = (Fe+Mg) - FeMg_M2;
%         
%         Mg_M2(i) = FeMg_M2 * XMg(i);
%         Fe_M2(i) = FeMg_M2 * XFe(i);
%         
%         Mg_M13(i) = FeMg_M23 * XMg(i);
%         Fe_M13(i) = FeMg_M23 * XFe(i);
%         
%         Ca_M4(i) = Ca;
%         Na_M4(i) = 2 - Ca_M4(i);
%         Na_A(i) = Na - Na_M4(i);
%         V_A(i) = 1-Na_A(i); 
%         
%         Xgl(i) = Na_M4(i) / 2;
%         Xparg(i) = Na_A(i);
%         
%         TschParg = Al_T2(i) / 2;
%         Xts(i) = TschParg - Xparg(i);
%         
%         Reste = 1-Xgl(i)-Xparg(i)-Xts(i);
%         Xtr(i) = XMg(i) * Reste;
%         Xftr(i) = XFe(i) * Reste;