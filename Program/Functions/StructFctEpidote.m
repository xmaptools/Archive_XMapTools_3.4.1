function [Si_T,Al_M1,Al_M2,Al_M3,Fe_M1,Fe_M3,Ca_A,XEp,XCzo,XFep] = StructFctEpidote(Data,handles)
% -
% XMapTools External Function: Structural formula of epidote 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Epidote>Epi-StructForm>StructFctEpidote>Si_T Al_M1 Al_M2 Al_M3 Fe_M1 
%     Fe_M3 Ca_A XEp XCzo XFep>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   12.5 Oxygens
%
% 
% Created by P. Lanari (Octobre 2013) - Last update 19.06.18.
% Find out more at http://www.xmaptools.com


Si_T = zeros(1,length(Data(:,1)));
Al_M1 = zeros(1,length(Data(:,1)));
Al_M2 = zeros(1,length(Data(:,1)));
Al_M3 = zeros(1,length(Data(:,1)));
Fe_M1 = zeros(1,length(Data(:,1)));
Fe_M3 = zeros(1,length(Data(:,1)));
Ca_A = zeros(1,length(Data(:,1)));
XEp = zeros(1,length(Data(:,1)));
XCzo = zeros(1,length(Data(:,1)));
XFep = zeros(1,length(Data(:,1)));

Fe3Per = 0;

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 12.5; % Oxygens, DO NOT CHANGE !!!

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);

    if Analyse(1) > 0.001 % Epidote
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        TravMat= NaN*zeros(1,29); % Working matrix
            
        % SiO2 / TiO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O 
        Num = [1,1,2,1,2,1,1,1,2,2]; % Nombre de cations.
        NumO= [2,2,3,1,3,1,1,1,1,1]; % Nombre d'Oxygenes.
        Cst = [60.09,79.86,101.96,71.85,159.68,70.94,40.30,56.08, ...
            61.98,94.20]; % atomic mass

        TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3 FeO
        TravMat(4) = 0; % FeO
        TravMat(5) = Analyse(4)*1.1123; % FeO -> Fe2O3
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O
    
        for j=1:10
            TravMat(j+10) = TravMat(j) / Cst(j) * Num(j); % Atomic% = Oxyde/M.Molaire * Ncat
        end
    
        % adding Fe3+ 
        TravMat(14) = (1-(Fe3Per*0.01)) * Analyse(4) / Cst(4);
        TravMat(15) = Analyse(4) / Cst(4) - TravMat(14);
    
        TravMat(21) = sum((TravMat(11:20) .* NumO) ./ Num); % Oxygen sum
        TravMat(22) = TravMat(21) / NbOx; % ref Ox
    
        TravMat(23:32) = TravMat(11:20) ./ TravMat(22);

        % Association: 
        Si = TravMat(:,23);
        Ti = TravMat(:,24);
        Al= TravMat(:,25); 
        Fe= TravMat(:,26)+ TravMat(:,27);
        Mn= TravMat(:,28);
        Mg= TravMat(:,29);
        Ca= TravMat(:,30); 
        Na= TravMat(:,31); 
        K= TravMat(:,32);
        

        % Simple structural formula (October 2013)
        
        Si_T(i) = Si;
        
        if Al >= 1
            Al_M2(i) = 1;
            AlM1M3 = Al-1;
        else
            Al_M2(i) = Al;
            AlM1M3 = 0;
        end

        if Fe >= 1
            Fe_M3(i) = 1;
            Fe_M1(i) = Fe-1;
        else
            Fe_M3(i) = Fe;
            Fe_M1(i) = 0;
        end
        
        FreeM3 = 1 - Fe_M3(i);
        
        if FreeM3 <= AlM1M3 
            Al_M3(i) = FreeM3;
            Al_M1(i) = Al-1-FreeM3;   % Warning: Al_M1 + Fe_M1 could be > 1
        else
            Al_M3(i) = AlM1M3;
            Al_M1(i) = 0;
        end
        
        Ca_A(i) = Ca;
        
        XFep(i) = Fe_M1(i);
        XEp(i) = Fe_M3(i)-XFep(i);
        XCzo(i) = 1-(XEp(i)+XFep(i));
         
        
    else
        Si_T(i) = 0;
        Al_M2(i) = 0;
        Al_M1(i) = 0;
        Al_M3(i) = 0;
        
        Fe_M1(i) = 0;
        Fe_M3(i) = 0;
        
        Ca_A(i) = 0;
        
        XEp(i) = 0;
        XCzo(i) = 0;
        XFep(i) = 0;
        
    end
        
end

XmapWaitBar(1,handles);
return






