function [XAlm,XSps,XPrp,XGrs,XAdr,SI,TI,AL,MG,FE2,FE3,MN,CA] = StructFctGarnetFe3(Data,handles)
% -
% XMapTools External Function: Structural formula of Garnet (including Fe3+ estimate)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Garnet>Gar-StructForm>StructFctGarnet>XAlm XSps XPrp XGrs Si Al Mg Fe
%     Mn Ca>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%   12 Oxygens
%   Normalized on 8 Cations
%
%
% Created by G. Bonnet (April 2014) - Last update PL 14/06/19.
% Find out more at http://www.xmaptools.com


SI = zeros(1,length(Data(:,1)));
TI = zeros(1,length(Data(:,1)));
AL = zeros(1,length(Data(:,1)));
MG = zeros(1,length(Data(:,1)));
FE = zeros(1,length(Data(:,1)));
FE2=zeros(1,length(Data(:,1)));
FE3=zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));
CA = zeros(1,length(Data(:,1)));
XAlm = zeros(1,length(Data(:,1)));
XSps = zeros(1,length(Data(:,1)));
XPrp = zeros(1,length(Data(:,1)));
XGrs = zeros(1,length(Data(:,1)));
XAdr = zeros(1,length(Data(:,1)));



XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 12; % Oxygens, DO NOT CHANGE !!!
NbCat = 8; % Cations


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
    
    if Analyse(1) > 0.001 % Biotite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        
        Fe2O3 = 0;
        FeO = Analyse(4);
        
        TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3
        TravMat(4) = FeO;
        TravMat(5) = Fe2O3;
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
        
        
        %Andradite Si4+(3)Fe3+(2)Ca2+(3)
        %Ferrous   Si4+(3)Al3+(2)XX2+(3)   with XX= Fe2+ Mg2+ Ca2+ or Mn2+
        
        Diff = 5 - (Si+Al);                                     % + Ti ????
        
        if Diff > 0                    
            Fe2 = Fe - Diff;
            Fe3 = Diff;
            
            if Fe2
                XFe3 = Fe3/(Fe3+Fe2);      
            else
                XFe3 = 1;                                       % 100% Fe3+
            end
         
            FeO = Analyse(4) * (1-XFe3);
            Fe2O3 = Analyse(4) * XFe3 * (1/0.89992485);   % Corrected PL (04.08.2018)   
            
        else
            % bad analysis ? 
            %   --> we calculate with Fetot = Fe2+            
        end
        
        
        TravMat(1:3) = Analyse(1:3); % Si02 TiO2 Al2O3 FeO
        TravMat(4) = FeO;
        TravMat(5) = Fe2O3;
        TravMat(6:10) = Analyse(5:9); % MnO MgO CaO Na2O K2O

        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si = lesResults(1);
        Ti = lesResults(2);
        Al = lesResults(3); 
        Fe2 = lesResults(4);
        Fe3 = lesResults(5);
        Mn = lesResults(6);
        Mg = lesResults(7);
        Ca = lesResults(8); 
        Na = lesResults(9); 
        K = lesResults(10);
        
        
        % Structural Formula
        SI(i) = Si;
        TI(i) = Ti;
        AL(i) = Al;
        MG(i) = Mg;
        FE2(i) = Fe2;
        FE3(i) = Fe3;
        MN(i) = Mn;
        CA(i) = Ca;
        
        
        % End-member proportions:
        
        XAdr(i) = Fe3/2;
        XSps(i) = (1-XAdr(i))*Mn/(Ca+Fe2+Mg+Mn);
        XPrp(i) = (1-XAdr(i))*Mg/(Ca+Fe2+Mg+Mn);
        XAlm(i) = (1-XAdr(i))*Fe2/(Ca+Fe2+Mg+Mn);
        XGrs(i) = (1-XAdr(i))*Ca/(Ca+Fe2+Mg+Mn);
        
        %Andradite Si4+(3)Fe3+(2)Ca2+(3)
        %Ferrous   Si4+(3)Al3+(2)XX2+(3)   with XX= Fe2+ Mg2+ Ca2+ or Mn2+
      
    end
end

XmapWaitBar(1,handles);
return
