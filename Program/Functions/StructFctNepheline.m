function [Si_T, Al_T, Na_M, K_M, Ca_M, Vac_M, XNph, XKls, SumT, SumM] = StructFctNepheline(Data,handles)
% -
% XMapTools External Function: Structural formula of Nepheline (Na,K) 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Nepheline>Neph-StrucForm>StructFctNepheline>Si_T Al_T Na_M K_M Ca_M 
%   Vac_M XNph XKls SumT SumM>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   4 Oxygens
%
% 
% Created by P. Lanari (Octobre 2015) - Last update 19.06.2018.
% Find out more at http://www.xmaptools.com


Si_T = zeros(1,length(Data(:,1)));
Al_T = zeros(1,length(Data(:,1)));
Na_M = zeros(1,length(Data(:,1)));
K_M = zeros(1,length(Data(:,1)));
Ca_M = zeros(1,length(Data(:,1)));
Vac_M = zeros(1,length(Data(:,1)));
XNph = zeros(1,length(Data(:,1)));
XKls = zeros(1,length(Data(:,1)));
SumT = zeros(1,length(Data(:,1)));
SumM = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 4; % Oxygens, DO NOT CHANGE !!!


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


        % Structural Formulae (P. Lanari - 2015)
        
   
        Si_T(i) = Si;
        Al_T(i) = Al;
        
        K_M(i) = K;
        Na_M(i) = Na;
        Ca_M(i) = Ca;
        
        Vac_M(i) = 1-(K+Na+Ca);
        
        % Solid solution model
        XKls(i) = K/(K+Na);
        XNph(i) = Na/(K+Na);

        SumT(i) = Si + Al; % T -sites
        SumM(i) = K + Na + Ca; % M-sites
        

        if Si_T(i) < 0 ||  Al_T(i) < 0 || Na_M(i) < 0 || Ca_M(i) < 0 || ...
           K_M(i) < 0 || XKls(i) < 0 || XNph(i) < 0
       
            
            Si_T(i) = 0;
            Al_T(i) = 0;
            Na_M(i) = 0;
            Ca_M(i) = 0;
            K_M(i) = 0;
            Vac_M(i) = 0;
            XKls(i) = 0;
            XNph(i) = 0;
            SumT(i) = 0;
            SumM(i) = 0;
        end
        
    else
            Si_T(i) = 0;
            Al_T(i) = 0;
            Na_M(i) = 0;
            Ca_M(i) = 0;
            K_M(i) = 0;
            Vac_M(i) = 0;
            XKls(i) = 0;
            XNph(i) = 0;
            SumT(i) = 0;
            SumM(i) = 0;
    end
end

XmapWaitBar(1,handles);




return




