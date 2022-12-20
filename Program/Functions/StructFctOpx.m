function [Si_T1,Si_T2,Al_T2,Al_M1,XMg,XFe,Mg_M1,Fe_M1,Fe_M2,Mg_M2,XEn,XFs,XMgts] = StructFctOpx(Data,handles)
% -
% XMapTools External Function: Structural formula of orthopyroxene
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Orthopyroxene>Opx-StrucForm>StructFctOpx>Si_T1 Si_T2 Al_T2 Al_M1 XMg 
%     XFe Mg_M1 Fe_M1 Fe_M2 Mg_M2 XEn XFs XMgts>SiO2 TiO2 Al2O3 FeO MnO MgO 
%     CaO Na2O K2O>
%
%   6 Oxygens
%
% 
% Created by P. Lanari (April 2013, Ivrea) - Last update 05/02/13.
% Find out more at http://www.xmaptools.com


Si_T1 = zeros(1,length(Data(:,1)));
Si_T2 = zeros(1,length(Data(:,1)));
Al_T2 = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
Mg_M1 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Fe_M2 = zeros(1,length(Data(:,1)));
Mg_M2 = zeros(1,length(Data(:,1)));
XEn = zeros(1,length(Data(:,1)));
XFs = zeros(1,length(Data(:,1)));
XMgts = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 6; % Oxygens, DO NOT CHANGE !!!


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

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe = lesResults(4)+ lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);


        % Structural Formulae (P. Lanari - 2013)
                
        Si_T1(i) = 1;
        Si_T2(i) = Si - 1;
        Al_T2(i) = 2 - Si;
        
        Al_M1(i) = Al - Al_T2(i);
        
        MgFe_M1 = 1 - Al_M1(i);

        XMg(i) = Mg/(Fe+Mg);
        XFe(i) = Fe/(Fe+Mg);
        
        Mg_M1(i) = MgFe_M1 * XMg(i);
        Fe_M1(i) = MgFe_M1 * XFe(i);
        
        Mg_M2(i) = Mg - Mg_M1(i);
        Fe_M2(i) = Fe - Fe_M1(i);
        
        XEn(i) = Mg_M1(i);
        XFs(i) = Fe_M1(i);
        XMgts(i) = Al_M1(i);
          
        
        if Si_T2(i) < 0 || Al_M1(i) < 0 || MgFe_M1 < 0 || ...
           XMg(i) < 0 || XFe(i) < 0 || Mg_M1(i) < 0 || Fe_M1(i) < 0 || ...
           Mg_M2(i) < 0 || Fe_M2(i) < 0 || XEn(i) < 0 || XFs(i) < 0 || XMgts(i) < 0
            
            Si_T1(i) = 0;
            Si_T2(i) = 0;
            Al_T2(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Fe_M2(i) = 0;
            Mg_M2(i) = 0;
            XEn(i) = 0;
            XFs(i) = 0;
            XMgts(i) = 0;
            
        end
        
    else
            Si_T1(i) = 0;
            Si_T2(i) = 0;
            Al_T2(i) = 0;
            Al_M1(i) = 0;
            XMg(i) = 0;
            XFe(i) = 0;
            Mg_M1(i) = 0;
            Fe_M1(i) = 0;
            Fe_M2(i) = 0;
            Mg_M2(i) = 0;
            XEn(i) = 0;
            XFs(i) = 0;
            XMgts(i) = 0;
    end
end

XmapWaitBar(1,handles);
return



