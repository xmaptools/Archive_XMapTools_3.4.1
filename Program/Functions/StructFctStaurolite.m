function [Si_t Al_t Fe_t Mg_t Mn_t St Mst Mnst] = StructFctStaurolite(Data,handles)
% -
% XMapTools External Function: Structural formula of staurolite
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Staurolite>Sta-StructForm>StructFctStaurolite>Si Al Fe Mg Mn St Mst 
%     Mnst>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   22 Oxygens
%
% 
% Created by P. Lanari (December 2013) - NOT TESTED.
% Find out more at http://www.xmaptools.com



Si_t = zeros(1,length(Data(:,1)));
Al_t = zeros(1,length(Data(:,1)));
Fe_t = zeros(1,length(Data(:,1)));
Mg_t = zeros(1,length(Data(:,1)));
Mn_t = zeros(1,length(Data(:,1)));
St = zeros(1,length(Data(:,1)));
Mst = zeros(1,length(Data(:,1)));
Mnst = zeros(1,length(Data(:,1)));


Fe3Per = 0;

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 24; % Oxygens, DO NOT CHANGE !!!


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
        

        % Structural formula (P. Lanari - December 2013)
        
        Si_t(i) = Si;
        Al_t(i) = Al;
        Fe_t(i) = Fe;
        Mg_t(i) = Mg;
        Mn_t(i) = Mn;
        St(i) = Fe/(Fe+Mg+Mn);
        Mst(i) = Mg/(Fe+Mg+Mn);
        Mnst(i) = Mn/(Fe+Mg+Mn);        
    end
        
end

XmapWaitBar(1,handles);
return






