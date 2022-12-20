function [Si_T,Fe_M,Mg_M,XFe,XMg,Cr_M,Ni_M] = StructFctSerpentine(Data,handles)
% -
% XMapTools External Function: Structural formula of serpentine 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Serpentine>Serp-StructForm>StructFctSerpentine>Si_T Fe_M Mg_M XFe XMg 
%     Cr_M Ni_M>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O NiO Cr2O3>
%
%   7 Oxygens
%
% 
% Created by P. Lanari (Octobre 2011) - Last update 27/10/11.
% Find out more at http://www.xmaptools.com


Si_T = zeros(1,length(Data(:,1)));
Fe_M = zeros(1,length(Data(:,1)));
Mg_M = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
Cr_M = zeros(1,length(Data(:,1)));
Ni_M = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 7; % Oxygens, DO NOT CHANGE !!!


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O / NiO / Cr2O3 
Num = [1,1,2,1,2,1,1,1,2,2,1,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1,1,3]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20,74.6928,151.99]; % atomic mass


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
        TravMat(6:12) = Analyse(5:11); % MnO MgO CaO Na2O K2O NiO Cr2O3

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
        Ni = lesResults(11);
        Cr = lesResults(12);



        % Structural Formulae (P. Lanari 2011)
        
        Si_T(i) = Si;
        Mg_M(i) = Mg;
        Fe_M(i) = Fe;
        
        XMg(i) = Mg/(Mg+Fe+Cr+Ni);
        XFe(i) = Fe/(Mg+Fe+Cr+Ni);
        
        Cr_M(i) = Cr;
        Ni_M(i) = Ni;
        
    else
        Si_T(i) = 0;
        Fe_M(i) = 0;
        Mg_M(i) = 0;
        XFe(i) = 0;
        XMg(i) = 0;
        Cr_M(i) = 0;
        Ni_M(i) = 0;

    end
end

XmapWaitBar(1,handles);




return




