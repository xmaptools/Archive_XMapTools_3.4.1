function [Si,Al,Fe,Mg,XFe,XMg,Cr,Ni] = StructFctTsAntigorite(Data,handles)
% -
% XMapTools External Function: Structural formula of serpentine 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Serpentine>Serp-TsAntigorite>StructFctTsAntigorite>Si Al Fe Mg XFe XMg Cr Ni>
%   SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O NiO Cr2O3>
%
%   116 Oxygens (note that apfu values are divided by 8)
%
% 
% Created by P. Lanari (Nov. 2016) - Last update 14/11/16.
% Find out more at http://www.xmaptools.com


Si = zeros(1,length(Data(:,1)));
Al = zeros(1,length(Data(:,1)));
Fe = zeros(1,length(Data(:,1)));
Mg = zeros(1,length(Data(:,1)));
XFe = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));
Cr = zeros(1,length(Data(:,1)));
Ni = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 116; % Oxygens, DO NOT CHANGE !!!


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

        Si_116 = lesResults(1);
        Ti_116 = lesResults(2);
        Al_116 = lesResults(3); 
        Fe_116 = lesResults(4)+ lesResults(5);
        Mn_116 = lesResults(6);
        Mg_116 = lesResults(7);
        Ca_116 = lesResults(8); 
        Na_116 = lesResults(9); 
        K_116 = lesResults(10);
        Ni_116 = lesResults(11);
        Cr_116 = lesResults(12);

        % Structural Formulae (P. Lanari 2011)
        Si(i) = Si_116/8;
        Al(i) = Al_116/8;
        Mg(i) = Mg_116/8;
        Fe(i) = Fe_116/8;
        
        XMg(i) = Mg_116/(Mg_116+Fe_116+Cr_116+Ni_116);
        XFe(i) = Fe_116/(Mg_116+Fe_116+Cr_116+Ni_116);
        
        Cr(i) = Cr_116/8;
        Ni(i) = Ni_116/8;
        
    else
        Si(i) = 0;
        Al(i) = 0;
        Fe(i) = 0;
        Mg(i) = 0;
        XFe(i) = 0;
        XMg(i) = 0;
        Cr(i) = 0;
        Ni(i) = 0;

    end
end

XmapWaitBar(1,handles);


return




