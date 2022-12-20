function [Si_T1,XMg,XFe,Al_M1,Mg_M1,Fe_M1,Ca_M2,Na_M2,XJd,XDi,XHd,Xsum,SumM1,SumM2] = StructFctCpxW(Data,handles)
% -
% XMapTools External Function: Structural formula of clinopyroxene (no cats)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Clinopyroxene>Cpx-StructForm-Cats>StructFctCpx>Si_T1 Al_T1 XMg XFe 
%     Al_M1 Mg_M1 Fe_M1 Ca_M2 Na_M2 XJd XDi XHd Xcats Xsum SumM1 SumM2>
%     SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   6 Oxygens
%
% 
% Created by P. Lanari (Octobre 2011) - Last update 05.04.2018
% Find out more at http://www.xmaptools.com



Si_T1 = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Ca_M2 = zeros(1,length(Data(:,1)));
Na_M2 = zeros(1,length(Data(:,1)));
XJd = zeros(1,length(Data(:,1)));
XDi = zeros(1,length(Data(:,1)));
XHd = zeros(1,length(Data(:,1)));
Xsum = zeros(1,length(Data(:,1)));
SumM1 = zeros(1,length(Data(:,1)));
SumM2 = zeros(1,length(Data(:,1)));

% - - - Input - - - 
Tolerance = 5;
Tolerance = str2num(char(inputdlg('Tolerence Al = Ca (1-30%)','Input',1,{'5'})));

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


        % Structural Formulae (P. Lanari - 2011)
        
   
        Si_T1(i) = Si;
        Alvi = Al;
        
        Al_M1(i) = Alvi;
        XMg(i) = Mg/(Mg+Fe);
        XFe(i) = Fe/(Mg+Fe); 
        Mg_M1(i) = Mg;
        Fe_M1(i) = Fe;
        Ca_M2(i) = Ca;
        Na_M2(i) = Na;
        
        % Solid solution model
        XHd(i) = Fe_M1(i);
        XJd(i) = Na_M2(i);
        XDi(i) = Mg_M1(i);
        
        Xsum(i) = XHd(i)+XJd(i)+XDi(i);

        SumM1(i) = Al_M1(i)+Mg_M1(i)+Fe_M1(i); % M1
        SumM2(i) = Ca_M2(i)+Na_M2(i); % M2


        if Si_T1(i) < 0 ||  Al_M1(i) < 0 || Mg_M1(i) < 0 || Fe_M1(i) < 0 || ...
           Ca_M2(i) < 0 || Na_M2(i) < 0 || XJd(i) < 0 || ...
           XDi(i) < 0 || XHd(i) < 0 || abs(Al-Ca) > max([Al,Ca])/100*Tolerance
       
            Si_T1(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Ca_M2(i) = 0;
            Na_M2(i) = 0;
            XJd(i) = 0;
            XDi(i) = 0;
            XHd(i) = 0;
            Xsum(i) = 0;
            SumM1(i) = 0;
            SumM2(i) = 0;
        end
        
    else
            Si_T1(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Ca_M2(i) = 0;
            Na_M2(i) = 0;
            XJd(i) = 0;
            XDi(i) = 0;
            XHd(i) = 0;
            Xsum(i) = 0;
            SumM1(i) = 0;
            SumM2(i) = 0;
    end
end

XmapWaitBar(1,handles);




return




