function [DensCpx XJd XDi XHd XCats XAcm] = DensityCpxOmph(Data,handles)
% -
% XMapTools Density Function (introduced in 2.3.1)
%
% This function calculates the structural formula of cpx and the 
% corresponding density
%
% [Values] = DensityCpxOmph(Data,handles);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file.
% 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 5>Cpx>Density_Cpx>DensityCpx>DensCpx XJd XDi XHd XCats XAcm>SiO2 TiO2 
% Al2O3 FeO MnO MgO CaO Na2O K2O>
%
% 6 Oxygen basis
%
% Created by P. Lanari (February 2016) - TESTED & VERIFIED 11/02/16.
%


DensCpx = zeros(1,length(Data(:,1)));
XJd = zeros(1,length(Data(:,1)));
XDi = zeros(1,length(Data(:,1)));
XHd = zeros(1,length(Data(:,1)));
XCats = zeros(1,length(Data(:,1)));
XAcm = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 6; 


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


        if Si <= 2
            Si_T1_Temp = Si;
            Al_T1_Temp = 2 - Si;
            Xcats_Temp = Al_T1_Temp / 2;
        else
            Si_T1_Temp = Si;
            Al_T1_Temp = 0;
            Xcats_Temp = 0;
        end
        
        Al_M1_Temp = Al - Al_T1_Temp;
        
        Diff23 = Na - (Al_M1_Temp - Xcats_Temp);
        
        if Diff23 > 0  
            Fe3_Temp = Na - (Al_M1_Temp - Xcats_Temp);
        	Fe2_Temp = Fe-Fe3_Temp;
            XFe3 = Fe3_Temp/(Fe3_Temp+Fe2_Temp);

            Fe2O3 = Analyse(4) * XFe3;
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
        Fe2 = lesResults(4); 
        Fe3 = lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);
        
        
        % Structural Formulae (P. Lanari - 2014)
        
        if Si <= 2
            Si_T1 = Si;
            Al_T1 = 2 - Si;
            XCats(i) = Al_T1 / 2;
        else
            Si_T1 = 2;
            Al_T1 = 0;
            XCats(i) = 0;
        end

        Al_M1 = Al - Al_T1;
      
        XMg = Mg/(Mg+Fe2);
        XFe = Fe2/(Mg+Fe2); 
        Mg_M1 = Mg;
        Fe2_M1 = Fe2;
        Fe3_M1 = Fe3;
        Ca_M2 = Ca;
        Na_M2 = Na;
        
        % Solid solution model
        XHd(i) = Fe2_M1;
        XAcm(i) = Fe3_M1;
        XJd(i) = Na_M2-XAcm(i);
        XDi(i) = Mg_M1;
 
        DensCpx(i) = 3.68*XHd(i) + 3.59*XAcm(i) + 3.39*XJd(i) + 3.26*XDi(i) + 3.44*XCats(i); 

    end
end

XmapWaitBar(1,handles);




return










