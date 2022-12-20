function [FE2,FE3,CR,MG,MN,NI,TI,SI,AL,CA,ZN,XFe3] = StructFctMagnetite(Data,handles)
% -
% XMapTools External Function: Structural formula of Garnet (including Fe3+ estimate)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Magnetite>Mgt-StructForm>StructFctMagnetite>Fe2 Fe3 Cr Mg Mn Ni Ti Si Al Ca Zn XFe3
%   >FeO Cr2O3 MgO MnO NiO TiO2 SiO2 Al2O3 CaO ZnO>
%
%   Normalized to 3 cations and 4 oxygen
%
% Created by  P. Lanari & F. Piccoli (Nov. 2018) - Last update FP 14/11/18 (TESTED)
% Find out more at http://www.xmaptools.com


FE2 = zeros(1,length(Data(:,1)));
FE3 = zeros(1,length(Data(:,1)));
CR = zeros(1,length(Data(:,1)));
MG = zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));
NI = zeros(1,length(Data(:,1)));
TI = zeros(1,length(Data(:,1)));
SI = zeros(1,length(Data(:,1)));
AL = zeros(1,length(Data(:,1)));
CA = zeros(1,length(Data(:,1)));
ZN = zeros(1,length(Data(:,1)));
XFe3 = zeros(1,length(Data(:,1)));




XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 4; % Oxygens, DO NOT CHANGE !!!
NbCat = 3; % Cations

% FeO Cr2O3 MgO MnO NiO TiO2 SiO2 Al2O3 CaO ZnO Fe2O3
Num = [1,2,1,1,1,1,1,2,1,1,2]; % Nombre de cations.
NumO= [1,3,1,1,1,2,2,3,1,1,3]; % Nombre d'Oxygenes.
Cst = [71.85,151.99,40.30,70.94,74.69,79.88,60.09,101.96,56.08,81.38,159.69];


for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);
    
    if Analyse(1) > 0.001 % Magnetite
        OnCal = 1;
    else
        OnCal = 0;
    end
    
    if OnCal
        
        % FeO Cr2O3 MgO MnO NiO TiO2 SiO2 Al2O3 CaO ZnO & Fe2O3
        
        Fe2O3 = 0;
        FeO = Analyse(1);
        
        
        TravMat(1) = FeO;
        TravMat(2:10) = Analyse(2:10); % Cr2O3 MgO MnO NiO TiO2 SiO2 Al2O3 CaO ZnO
        TravMat(11) = Fe2O3; 

        MolCat = TravMat./Cst.*Num;
        MolOxy = TravMat./Cst.*NumO;
        
        SumMolCat = sum(MolCat);
        SumMolOxy = sum(MolOxy);
        
        NormCat = NbCat * MolCat/SumMolCat;
        NormOxy = NormCat.*NumO./Num;
        
        Charge = sum(NormCat.*[2,3,2,2,2,4,4,3,2,2,3]);
        
        AtomUnit = NormCat;
        if 2*NbOx-Charge > 0
            AtomUnit(end) = 2*NbOx-Charge;
            AtomUnit(1) = NormCat(1) - AtomUnit(end);
        end
        
%         NormOxyFinal = NormOxy;
%         NormOxyFinal(1) = AtomUnit(1).*NumO(1)./Num(1);
%         NormOxyFinal(end) = AtomUnit(end).*NumO(end)./Num(end);

        FE2(i) = AtomUnit(1);
        FE3(i) = AtomUnit(end);
        CR(i) = AtomUnit(2);
        MG(i) = AtomUnit(3);
        MN(i) = AtomUnit(4);
        NI(i) = AtomUnit(5);
        TI(i) = AtomUnit(6);
        SI(i) = AtomUnit(7);
        AL(i) = AtomUnit(8);
        CA(i) = AtomUnit(9);
        ZN(i) = AtomUnit(10);
        XFe3(i) = FE3(i)/(FE3(i)+FE2(i));
        
    end
end

XmapWaitBar(1,handles);
return
