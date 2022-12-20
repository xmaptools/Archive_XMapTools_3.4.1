function [Si,Ti,Al,Fe,Mn,Mg,Ca,Na,K,XMg] = StructFctGenerale(Data,handles)
% -
% XmapTools Function (version 1.5)
% Use this function only with XmapTools 1.5.
%
% This function calculates the structural formulas of a set 
% of mineral using the Oxy-number defined by user
%
% [Values] = StructFctGenerale(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 1>General>Structural Formula>StructFctGenerale>Si Ti Al Fe Mn Mg Ca Na K>
% SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%
% N Oxygens (defined by user)
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 27/10/11.
% Version with pre-loading... 


Si = zeros(1,length(Data(:,1)));
Ti = zeros(1,length(Data(:,1)));
Al = zeros(1,length(Data(:,1)));
Fe = zeros(1,length(Data(:,1)));
Mn = zeros(1,length(Data(:,1)));
Mg = zeros(1,length(Data(:,1)));
Ca = zeros(1,length(Data(:,1))); 
Na = zeros(1,length(Data(:,1)));
K = zeros(1,length(Data(:,1)));
XMg = zeros(1,length(Data(:,1)));


% - - - Input - - - 
[UserOxy,Ok] = str2num(char(inputdlg('Oxygen-number','Input',1,{'10'})));
if ~Ok
    UserOxy = 10;
end


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = UserOxy; % Oxygens... defined by users


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

        Si(i) = lesResults(1);
        Ti(i) = lesResults(2);
        Al(i) = lesResults(3); 
        Fe(i) = lesResults(4)+ lesResults(5);
        Mn(i) = lesResults(6);
        Mg(i) = lesResults(7);
        Ca(i) = lesResults(8); 
        Na(i) = lesResults(9); 
        K(i) = lesResults(10);
        XMg(i) = Mg(i)/(Mg(i)+Fe(i));
   
    else
        Si(i) = 0;
        Ti(i) = 0;
        Al(i) = 0;
        Fe(i) = 0;
        Mn(i) = 0;
        Mg(i) = 0;
        Ca(i) = 0; 
        Na(i) = 0;
        K(i) = 0;
        XMg(i) = 0;

    end
end

XmapWaitBar(1,handles);




return










