function [SI,AL,FE,MG,MN,XMg,XCld,XFcld,XMcld] = StructFctChloritoid(Data,handles)
% -
% XMapTools External Function: Structural formula of chloritoid 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Chloritoid>Ctd-StructForm>StructFctChloritoid>Si Al Fe Mg Mn XMg XCld 
%     XFcld XMcld>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   12 Oxygens
%
% 
% Created by P. Lanari (Octobre 2011) - Last update 05.04.2018
% Find out more at http://www.xmaptools.com


XMg = zeros(1,length(Data(:,1)));
SI = zeros(1,length(Data(:,1)));
AL = zeros(1,length(Data(:,1)));
FE = zeros(1,length(Data(:,1)));
MG = zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));

XCld = zeros(1,length(Data(:,1)));
XFcld = zeros(1,length(Data(:,1)));
XMcld = zeros(1,length(Data(:,1)));


Fe3Per = 0;
XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 12; % Oxygens, DO NOT CHANGE !!!


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

    if Analyse(1) > 0.0001 % Chloritoid
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


        % Structural Formulae (P. Lanari - 2013)

        SI(i) = Si;
        AL(i) = Al;
        FE(i) = Fe;
        MG(i) = Mg;
        MN(i) = Mn;
        
        XMg(i) = Mg/(Mg+Fe);
        
        XCld(i) = Mg/(Mg+Fe+Mn);
        XFcld(i) = Fe/(Mg+Fe+Mn);
        XMcld(i) = Mn/(Mg+Fe+Mn);
        

        
        if Si < 0 || Al < 0 || Fe < 0 || Mn < 0 || Mg < 0 || Ca < 0 || Na < 0 || K < 0
            XMg(i) = 0;
            SI(i) = 0;
            AL(i) = 0;
            FE(i) = 0;
            MG(i) = 0;
            MN(i) = 0;

            XCld(i) = 0;
            XFcld(i) = 0;
            XMcld(i) = 0;
        end
        
        
    else
      
        XMg(i) = 0;
        SI(i) = 0;
        AL(i) = 0;
        FE(i) = 0;
        MG(i) = 0;
        MN(i) = 0;

        XCld(i) = 0;
        XFcld(i) = 0;
        XMcld(i) = 0;
        
    end
end



XmapWaitBar(1,handles);
return






