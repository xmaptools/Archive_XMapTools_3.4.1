function [Si_T,Ti_T,Al_T,Al_M,Fe_M,Mg_M,XCrd,XFcrd] = StructFctCordierite(Data,handles)
% -
% XMapTools External Function: Structural formula of cordierite
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Cordierite>Cor-StructForm>StructFctCordierite>Si_T Ti_T Al_T Al_M 
%     Fe_M Mg_M XCrd XFcrd>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   18 Oxygens
%
% 
% Created by P. Lanari (August 2013) - Last update 05.04.2018
% Find out more at http://www.xmaptools.com



Si_T = zeros(1,length(Data(:,1)));
Ti_T = zeros(1,length(Data(:,1)));
Al_T = zeros(1,length(Data(:,1)));
Al_M = zeros(1,length(Data(:,1)));
Fe_M = zeros(1,length(Data(:,1)));
Mg_M = zeros(1,length(Data(:,1)));
XCrd = zeros(1,length(Data(:,1)));
XFcrd = zeros(1,length(Data(:,1)));


Fe3Per = 0;

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 18; % Oxygens, DO NOT CHANGE !!!


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

    if Analyse(1) > 0.001 % Cordierite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
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
        

        % Simple structural formula (August 2013)
        
        XMg = Mg/(Mg+Fe);
        
        Si_T(i) = Si;
        Ti_T(i) = Ti;
        Al_T(i) = 6-(Si+Ti);
        Al_M(i) = Al-Al_T(i);
        Fe_M(i) = Fe;
        Mg_M(i) = Mg;        
        XCrd(i) = Mg/(Mg+Fe);
        XFcrd(i) = Fe/(Mg+Fe);
        
        
        
    end
        
end

XmapWaitBar(1,handles);
return






