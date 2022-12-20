function [Si,Ti,Al,Fe,Mn,Mg,Ca,Na,K,XMg,As,Sb,Cs] = StructFctBruciteROMAIN(Data,handles)
% -
% XMapTools External Function: Structural formula of brucite 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Brucite>Bruc-StructForm>StructFctBruciteROMAIN>Si Ti Al Fe Mn Mg Ca 
%     Na K XMg As Sb Cs>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O As2O5 
%     Sb2O3 Cs2O>
%
%   1 Oxygen
%
% 
% Created by P. Lanari (Octobre 2012) - Last update 27/10/12.
% Find out more at http://www.xmaptools.com



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
As = zeros(1,length(Data(:,1)));
Sb = zeros(1,length(Data(:,1)));
Cs = zeros(1,length(Data(:,1)));
   

XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 1;               % BRUCITE Mg(OH)2


% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O /As2O5 /
% Sb2O3 / Cs2O
Num = [1,1,2,1,2,1,1,1,2,2,2,2,2]; % Nombre de cations.
NumO= [2,2,3,1,3,1,1,1,1,1,5,3,1]; % Nombre d'Oxygenes.
Cst = [60.09,79.88,101.96,71.85,159.68,70.94,40.30,56.08, ...
    61.98,94.20,229.8402,291.518,281.81]; % atomic mass


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
        TravMat(6:13) = Analyse(5:12); % MnO MgO CaO Na2O K2O As2O5 Sb2O3 Cs2O

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
        As(i) = lesResults(11); 
        Sb(i) = lesResults(12); 
        Cs(i) = lesResults(13);
   
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
        As(i) = 0;
        Sb(i) = 0;
        Cs(i) = 0;

    end
end

XmapWaitBar(1,handles);




return










