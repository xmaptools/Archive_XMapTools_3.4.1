function [Si_T,Ti_T,Mg_M,Mn_M,Fe3_M,Al_M,Ti_M,Ca,K,Na,F,OH,O,Sum_an,Sum,XTtn,XAlFeF,XAlFeOH] = StructFctTitanite(Data,handles)
% -
% XMapTools External Function: Structural formula of Titanite
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Titanite>Ttn-StructForm>StructFctTitanite>Si_T Ti_T  Mg_M Mn_M 
%   Fe3_M Al_M Ti_M Ca K Na F OH O Sum_an Sum XTtn XAlFeF XAlFeOH>F Na2O 
%   K2O MgO CaO MnO Fe2O3 Al2O3 SiO2 TiO2 FeO>
%
%   Normalized to sum(Ti,Al,Fe3,Mn,Mg,Si) = 2 apfu
%
% Created by  P. Lanari & J. Walters (May 2019) - Last update PL 30/05/19 (TESTED)
% Find out more at http://www.xmaptools.com

 

% Tetrahedral
Si_T = zeros(1,length(Data(:,1)));
Ti_T = zeros(1,length(Data(:,1)));
% Octahedral
Mg_M = zeros(1,length(Data(:,1)));
Mn_M = zeros(1,length(Data(:,1)));
Fe3_M = zeros(1,length(Data(:,1)));
Al_M = zeros(1,length(Data(:,1)));
Ti_M = zeros(1,length(Data(:,1)));
% Decahedral
Ca = zeros(1,length(Data(:,1)));
K = zeros(1,length(Data(:,1)));
Na = zeros(1,length(Data(:,1)));
% Volatiles
F = zeros(1,length(Data(:,1)));
OH = zeros(1,length(Data(:,1)));
O = zeros(1,length(Data(:,1)));
% Sums
Sum_an = zeros(1,length(Data(:,1)));
Sum = zeros(1,length(Data(:,1)));
% End-members
XTtn = zeros(1,length(Data(:,1)));   
XAlFeF = zeros(1,length(Data(:,1))); 
XAlFeOH = zeros(1,length(Data(:,1))); 



XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 4; % Oxygens, DO NOT CHANGE !!!
NbCat = 3; % Cations

% F Na2O K2O MgO CaO MnO Fe2O3 Al2O3 SiO2 TiO2
Num = [1,2,2,1,1,1,2,2,1,1]; % Nombre de cations.
NumO= [0,1,1,1,1,1,3,3,2,2]; % Nombre d'Oxygenes.
Cst = [19,61.98,94.2,40.3,56.08,70.94,159.69,101.96,60.08,79.87];


DataOK = Data(:,1:end-1);   % Exclude FeO

if sum(Data(:,end)) > 0 && isequal(sum(Data(:,7)),0)
    
    % Here we check if the map FeO is FeO values or Fe2O3 values
    Answer = questdlg({'you are using a map labeled FeO whereas this function requires Fe2O3','Specify the type of iron oxide concentrations stored in this map:'},'Titanite structural formula','FeO','Fe2O3','FeO');
    
    switch Answer
        case 'FeO'
            DataOK(:,7) = Data(:,end)*1.111378;
        case 'Fe2O3'
            DataOK(:,7) = Data(:,end);
    end   
end

% Find first the index of each pixel of titanite
IdxAnalyses = find(sum(DataOK,2));


for i=1:length(IdxAnalyses) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(IdxAnalyses),handles);
        hCompt = 1;
    end
    
    Where = IdxAnalyses(i);
    Analyse = DataOK(Where,:);
    
    % F Na2O K2O MgO CaO MnO Fe2O3 Al2O3 SiO2 TiO2
    
    % Moles of cations
    F_mc = Analyse(1)/Cst(1)*Num(1);
    Na_mc = Analyse(2)/Cst(2)*Num(2); 
    K_mc = Analyse(3)/Cst(3)*Num(3);
    Mg_mc = Analyse(4)/Cst(4)*Num(4);
    Ca_mc = Analyse(5)/Cst(5)*Num(5);
    Mn_mc = Analyse(6)/Cst(6)*Num(6);
    Fe3_mc = Analyse(7)/Cst(7)*Num(7);
    Al_mc = Analyse(8)/Cst(8)*Num(8);
    Si_mc = Analyse(9)/Cst(9)*Num(9);
    Ti_mc = Analyse(10)/Cst(10)*Num(10);
    
    %SUM(Ti + Al + Fe + Mn + Mg)+ Si
    
    Sum_Cat = 2/(Ti_mc + Al_mc + Fe3_mc + Mn_mc + Mg_mc + Si_mc);
        
    % Tetrahedral
    Si_T(Where) = Si_mc * Sum_Cat;
    if Si_T(Where) < 1
        Ti_T(Where) = 1-Si_T(Where);
    else
        Ti_T(Where) = 0;
    end
    % Octahedral
    Mg_M(Where) = Mg_mc * Sum_Cat;
    Mn_M(Where) = Mn_mc * Sum_Cat;
    Fe3_M(Where) = Fe3_mc * Sum_Cat;
    Al_M(Where) = Al_mc * Sum_Cat;
    Ti_M(Where) = Ti_mc * Sum_Cat - Ti_T(Where);
    % Decahedral
    Ca(Where) = Ca_mc * Sum_Cat;
    K(Where) = K_mc * Sum_Cat;
    Na(Where) = Na_mc * Sum_Cat;
    % Volatiles
    F(Where) = F_mc * Sum_Cat;
    OH(Where) = Fe3_M(Where)+Al_M(Where)-F(Where);
    O(Where) = 5-(10-(2*Ca(Where)+K(Where)+Na(Where)+2*Mg_M(Where)+2*Mn_M(Where)+3*Fe3_M(Where)+3*Al_M(Where)+4*Si_T(Where)+4*(Ti_T(Where)+Ti_M(Where))));
    % Sums
    Sum_an(Where) = F(Where) + OH(Where) + O(Where);
    Sum(Where) = Si_T(Where)+Ti_T(Where)+Mg_M(Where)+Mn_M(Where)+Fe3_M(Where)+Al_M(Where)+Ti_M(Where)+Ca(Where)+K(Where)+Na(Where)+Sum_an(Where);
    % End-members
    XTtn(Where) = Ti_M(Where)/(Ti_M(Where)+Mg_M(Where)+Mn_M(Where)+Fe3_M(Where)+Al_M(Where));
    XAlFeF(Where) = F(Where)/(Fe3_M(Where)+Al_M(Where)+Ti_M(Where));
    XAlFeOH(Where) = OH(Where)/(Fe3_M(Where)+Al_M(Where)+Ti_M(Where));

end

XmapWaitBar(1,handles);
%keyboard
return
