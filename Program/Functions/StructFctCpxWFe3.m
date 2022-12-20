function [Si_T1,XMg,XFe,Fe2,Fe3,Al_M1,Mg_M1,Fe_M1,Ca_M2,Na_M2,XJd,XDi,XHd,XAcm,Xsum,SumM1,SumM2] = StructFctCpxWFe3(Data,handles)
% -
% XMapTools External Function: Structural formula of clinopyroxene (Fe3+ no cats)
%
%   Note: Fe3+ is estimated using the proportion of the acmite end-member.
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Clinopyroxene>Cpx-StructForm-Fe3>StructFctCpxWFe3>Si_T1 XMg XFe Fe2 
%     Fe3 Al_M1 Mg_M1 Fe_M1 Ca_M2 Na_M2 XJd XDi XHd XAcm Xsum SumM1 SumM2
%     >SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   6 Oxygens
%
% 
% Created by P. Lanari (May 2012) - Last update 04.08.2018
% Find out more at http://www.xmaptools.com



Si_T1 = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
Fe2 = zeros(1,length(Data(:,1)));
Fe3 = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Ca_M2 = zeros(1,length(Data(:,1)));
Na_M2 = zeros(1,length(Data(:,1)));
XJd = zeros(1,length(Data(:,1)));
XDi = zeros(1,length(Data(:,1)));
XHd = zeros(1,length(Data(:,1)));
XAcm = zeros(1,length(Data(:,1))); 
Xsum = zeros(1,length(Data(:,1)));
SumM1 = zeros(1,length(Data(:,1)));
SumM2 = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 6; % Oxygens, DO NOT CHANGE !!!


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
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
        
        Fe2O3 = 0;
        FeO = Analyse(4);
        
        TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
        TravMat(4) = FeO;
        TravMat(5) = Fe2O3; 
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

        Diff23 = Na - Al;
        
        if Diff23 > 0  
            Fe3_Temp = Diff23;
        	Fe2_Temp = Fe-Fe3_Temp;
            XFe3 = Fe3_Temp/(Fe3_Temp+Fe2_Temp);

            Fe2O3 = Analyse(4) * XFe3 * (1/0.89992485);   % Corrected PL (04.08.2018);
            FeO = Analyse(4) * (1-XFe3);
        else
            % Fetot = Fe2+
        end
        
        
        % Recalculation with Fe2+ and Fe3+

        TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
        TravMat(4) = FeO;
        TravMat(5) = Fe2O3; 
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe2(i) = lesResults(4); 
        Fe3(i) = lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);
        
        
        % Structural Formulae (P. Lanari - 2011)
        
        
        if Si <= 2
            Si_T1(i) = Si;
        else
            Si_T1(i) = 2;
        end
        
   
        %Si_T1(i) = Si;
        Alvi = Al;
        
        Al_M1(i) = Alvi;
        XMg(i) = Mg/(Mg+Fe2(i));
        XFe(i) = Fe2(i)/(Mg+Fe2(i)); 
        Mg_M1(i) = Mg;
        Fe_M1(i) = Fe;
        Ca_M2(i) = Ca;
        Na_M2(i) = Na;
        
        % Solid solution model
        XAcm(i) = Na_M2(i) - Al_M1(i);
        XJd(i) = Na_M2(i)- XAcm(i);
        XDi(i) = Mg_M1(i);
        
        Xsum(i) = XHd(i)+XJd(i)+XDi(i)+XAcm(i);
        
        Fe2(i) = Fe-XAcm(i);
        Fe3(i) = XAcm(i);

        XHd(i) = Fe2(i);
        
        SumM1(i) = Al_M1(i)+Mg_M1(i)+Fe_M1(i); % M1
        SumM2(i) = Ca_M2(i)+Na_M2(i); % M2


        if Si_T1(i) < 0 ||  Al_M1(i) < 0 || Mg_M1(i) < 0 || Fe_M1(i) < 0 || ...
           Ca_M2(i) < 0 || Na_M2(i) < 0 || XJd(i) < 0 || ...
           XDi(i) < 0 || XHd(i) < 0 || XAcm(i) < 0 
       
            Si_T1(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Fe2(i) = 0;
            Fe3(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Ca_M2(i) = 0;
            Na_M2(i) = 0;
            XJd(i) = 0;
            XDi(i) = 0;
            XHd(i) = 0;
            XAcm(i) = 0;
            Xsum(i) = 0;
            SumM1(i) = 0;
            SumM2(i) = 0;
        end
        
    else
            Si_T1(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Fe2(i) = 0;
            Fe3(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Ca_M2(i) = 0;
            Na_M2(i) = 0;
            XJd(i) = 0;
            XDi(i) = 0;
            XHd(i) = 0;
            XAcm(i) = 0;
            Xsum(i) = 0;
            SumM1(i) = 0;
            SumM2(i) = 0;
    end
end

XmapWaitBar(1,handles);




return




