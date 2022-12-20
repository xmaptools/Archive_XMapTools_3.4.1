function [XAlm,XSps,XPrp,XGrs,XAdr,SI,TI,AL,MG,FE2,FE3,MN,CA,NA,H] = StructFctGarnetFe3JR(Data,handles)
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
% Created by J. Reynes & implemented by P. Lanari (June 2018) - Last update PL 28/06/18.
% Find out more at http://www.xmaptools.com


SI = zeros(1,length(Data(:,1)));
TI = zeros(1,length(Data(:,1)));
AL = zeros(1,length(Data(:,1)));
MG = zeros(1,length(Data(:,1)));
FE2=zeros(1,length(Data(:,1)));
FE3=zeros(1,length(Data(:,1)));
MN = zeros(1,length(Data(:,1)));
CA = zeros(1,length(Data(:,1)));
NA = zeros(1,length(Data(:,1)));
H = zeros(1,length(Data(:,1)));
XAlm = zeros(1,length(Data(:,1)));
XSps = zeros(1,length(Data(:,1)));
XPrp = zeros(1,length(Data(:,1)));
XGrs = zeros(1,length(Data(:,1)));
XAdr = zeros(1,length(Data(:,1)));



H2O = 0;
H2O = str2num(char(inputdlg('H2O (wt%)','Input',1,{'0'})));

XmapWaitBar(0,handles);
hCompt = 1;

NbOx = 12; % Oxygens, DO NOT CHANGE !!!
NbCat = 8; % Cations




% Internal variables
MolarMass=[60.0848 79.8988 101.96 71.8464 70.9374 40.3044 56.0794 61.9789 18.01528];
%[M(SiO2) M(TiO2) M(Al2O3) M(FeO) M(MnO) M(MgO) M(CaO) M(Na2O) M(H2O)]
OxygenNumbers=[2 2 3 1 1 1 1 1 1];
%[SiO2 TiO2 Al2O3 FeO Mno MgO CaO Na2O H2O]
CationsNumbers=[1 1 2 1 1 1 1 2 2];
%[SiO2 TiO2 Al2O3 FeO Mno MgO CaO Na2O H2O]

% Internal variables(2)
MolarMass2=[60.0848 79.8988 101.96 159.69 71.8464 70.9374 40.3044 56.0794 61.9789 18.01528];
%[M(SiO2) M(TiO2) M(Al2O3) M(Fe2O3) M(FeO) M(MnO) M(MgO) M(CaO) M(Na2O) M(H2O)]
OxygenNumbers2=[2 2 3 3 1 1 1 1 1 1];
%[SiO2 TiO2 Al2O3 Fe2O3 FeO Mno MgO CaO Na2O H2O]
CationsNumbers2=[1 1 2 2 1 1 1 1 2 2];
%[SiO2 TiO2 Al2O3 Fe2O3 FeO Mno MgO CaO Na2O H2O]

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
        
        Data_Oxides = [Analyse(1:8),H2O]; 
        
        %Compute moles of oxides
        MolesOxides=Data_Oxides./MolarMass;
        %Compute moles of cations
        MolesOxygen=MolesOxides.*OxygenNumbers;
        %Compute moles of oxygen
        MolesCations=MolesOxides.*CationsNumbers;
        
        %Compute Oxygen factor = normalisation number/sum(MolesOxygen) (grt=12)
        OxygenFactor=12/sum(MolesOxygen);
        %Compute Cationic factor = normalisation number/sum(MolesCations) (grt=8)
        CationicFactor=8/sum(MolesCations);
        
        
        %Normalisation of the cations on number of O basis
        NormalisationCations_Obasis=MolesCations*OxygenFactor;
        
        %Normalisation of the Oxygens on number of cations basis
        NormalisationOxygens_Cbasis=MolesOxygen*CationicFactor;
        SumOx=sum(NormalisationOxygens_Cbasis);
        
        
        if Analyse(4) <= 0
            
            NormalisationCations_12O(:,Sample)=[NormalisationCations_Obasis([1 2 3]),0,0,NormalisationCations_Obasis([5 6 7 8 9])]; %Si Ti Al Fe3 Fe2 Mn Mg Ca Na H
        
        else
            
            %Optimisation loop from no Fe2(all Fe3) to full Fe2
            FeOt_iter=Analyse(4);
            FeO=[0:FeOt_iter/(50-1):FeOt_iter];
            
                
            SumTetraOct = zeros(size(FeO));
            SumCharge = zeros(size(FeO));
            SumDod = zeros(size(FeO));
            
            for j = 1:length(FeO)
                
                Fe2O3=(Analyse(4)-FeO(j))/0.8998;
                
                Data_Oxides = [Analyse(1:3),Fe2O3,FeO(j),Analyse(5:8),H2O]; 
                
                Charges=[4 4 3 3 2 2 2 2 1 1];
                % Internal variables
                
                % Start computation 2
                %Compute moles of oxides
                MolesOxides=Data_Oxides./MolarMass2;
                %Compute moles of cations
                MolesOxygen=MolesOxides.*OxygenNumbers2;
                %Compute moles of oxygen
                MolesCations=MolesOxides.*CationsNumbers2;
                
                %Compute Oxygen factor = normalisation number/sum(MolesOxygen) (grt=12)
                OxygenFactor=12/sum(MolesOxygen);
                %Compute Cationic factor = normalisation number/sum(MolesCations) (grt=8)
                CationicFactor=8/sum(MolesCations);
                
                
                %Normalisation of the cations on number of O basis
                NormalisationCations_Obasis=MolesCations*OxygenFactor;
                
                %Normalisation cations on cation basis
                NormalisationCations_Cbasis=MolesCations*CationicFactor;
                SumCharge(j)=sum(NormalisationCations_Cbasis.*Charges);
                
                %Normalisation of the Oxygens on number of cations basis
                NormalisationOxygens_Cbasis=MolesOxygen*CationicFactor;
                
                SumTetraOct(j)=sum(NormalisationCations_Obasis([1 2 3 4 9])); %Si Ti Al Fe3 H
                SumDod(j)=sum(NormalisationCations_Obasis([5 6 7 8])); %Fe2 Mn Mg Ca
                
            end %for FeO=0:FeOt
            
            %best solution for tetraOct
            [IdX1,IdX1]=min(abs(SumTetraOct-5));
            %best solution for dodecahedral
            [IdX2,IdX2]=min(abs(SumDod-3));
            
            OptiTetraOct=FeO(IdX1);
            OptiDod=FeO(IdX2);
            ChargeDeficit=24-SumCharge;
            
            %middle between the two optimal solutions
            Middle=(max([OptiTetraOct,OptiDod])+min([OptiTetraOct,OptiDod]))/2;
            
            % Calculate the model
            FeO_f=Middle;
            Fe2O3_f=(Analyse(4)-FeO_f)/0.8998;
            
            Data_Oxides = [Analyse(1:3),Fe2O3_f,FeO_f,Analyse(5:8),H2O];
            
            % Start computation
            %Compute moles of oxides
            MolesOxides=Data_Oxides./MolarMass2;
            %Compute moles of cations
            MolesOxygen=MolesOxides.*OxygenNumbers2;
            %Compute moles of oxygen
            MolesCations=MolesOxides.*CationsNumbers2;
            
            %Compute Oxygen factor = normalisation number/sum(MolesOxygen) (grt=12)
            OxygenFactor=12/sum(MolesOxygen);
            %Compute Cationic factor = normalisation number/sum(MolesCations) (grt=8)
            CationicFactor=8/sum(MolesCations);
            
            
            %Normalisation of the cations on number of O basis
            NormalisationCations_Obasis=MolesCations*OxygenFactor;
            
            %Normalisation of the Oxygens on number of cations basis
            NormalisationOxygens_Cbasis=MolesOxygen*CationicFactor;
            
        end
        
        %Si Ti Al Fe3 Fe2 Mn Mg Ca Na H
        SI(i) = NormalisationCations_Obasis(1);
        TI(i) = NormalisationCations_Obasis(2);
        AL(i) = NormalisationCations_Obasis(3);
        FE3(i) = NormalisationCations_Obasis(4);
        FE2(i) = NormalisationCations_Obasis(5);
        MN(i) = NormalisationCations_Obasis(6);
        MG(i) = NormalisationCations_Obasis(7);
        CA(i) = NormalisationCations_Obasis(8);
        NA(i) = NormalisationCations_Obasis(9);
        H(i) = NormalisationCations_Obasis(10);
        
        XAdr(i) = NormalisationCations_Obasis(4)/2;
        
        XAlm(i) = (1-XAdr(i))*NormalisationCations_Obasis(5)/(NormalisationCations_Obasis(5)+NormalisationCations_Obasis(6)+NormalisationCations_Obasis(7)+NormalisationCations_Obasis(8));
        XSps(i) = (1-XAdr(i))*NormalisationCations_Obasis(6)/(NormalisationCations_Obasis(5)+NormalisationCations_Obasis(6)+NormalisationCations_Obasis(7)+NormalisationCations_Obasis(8));
        XPrp(i) = (1-XAdr(i))*NormalisationCations_Obasis(7)/(NormalisationCations_Obasis(5)+NormalisationCations_Obasis(6)+NormalisationCations_Obasis(7)+NormalisationCations_Obasis(8));
        XGrs(i) = (1-XAdr(i))*NormalisationCations_Obasis(8)/(NormalisationCations_Obasis(5)+NormalisationCations_Obasis(6)+NormalisationCations_Obasis(7)+NormalisationCations_Obasis(8));
        
        
    end
end

XmapWaitBar(1,handles);
return
