function [Si,Ti,Al,V,Cr,Fe3,Fe2,Mn,Mg,Ca,H2,SumTetra,SumOcta,SumDod,SumCharges_vect,FeO,Fe2O3,Total] = StructFctGarnetH2O_ChargeOpti(Data,handles)
% -
% XMapTools External Function: Structural formula of Garnet (including Fe3+ estimate)
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Garnet_H2O>Grt_Meth2-ChargeOpti>StructFctGarnetH2O_ChargeOpti>Si Ti Al V Cr Fe3 Fe2 Mn Mg 
%   Ca H SumTetra SumOcta SumDod SumCharges_vect FeO Fe2O3 Total>SiO2 TiO2 Al2O3 V2O3 Cr2O3 
%   FeO MnO MgO CaO H2O>
%
%   Normalized on 8 Cations
%
%   *** Method 2 ***    
%   ChargeOpti (Fe3+ is approximated on the basis of Sum(Charges) = 24; 
%   No Fe2+ in Octahedral site)
%
%
% Created by J. Reynes & implemented by P. Lanari (February 2019) - Last update PL 05/02/19.
% Find out more at http://www.xmaptools.com


Si=zeros(1,length(Data(:,1)));
Ti=zeros(1,length(Data(:,1)));
Al=zeros(1,length(Data(:,1)));
V=zeros(1,length(Data(:,1)));
Cr=zeros(1,length(Data(:,1)));
Fe3=zeros(1,length(Data(:,1)));
Fe2=zeros(1,length(Data(:,1)));
Mn=zeros(1,length(Data(:,1)));
Mg=zeros(1,length(Data(:,1)));
Ca=zeros(1,length(Data(:,1)));
H2=zeros(1,length(Data(:,1)));
SumTetra=zeros(1,length(Data(:,1)));
SumOcta=zeros(1,length(Data(:,1)));
SumDod=zeros(1,length(Data(:,1)));
Total=zeros(1,length(Data(:,1)));
SumCharges_vect=zeros(1,length(Data(:,1)));
FeO=zeros(1,length(Data(:,1)));
Fe2O3=zeros(1,length(Data(:,1)));

% Molar mass
M_SiO2=60.0848;
M_TiO2=79.8988;
M_Al2O3=101.96;
M_V2O3=149.881;
M_Cr2O3=151.99;
M_Fe2O3=159.69;
M_FeO=71.8464;
M_MnO=70.9374;
M_MgO=40.3044;
M_CaO=56.0794;
M_H2O=18.01528;

Hsite=2;

Charges_vect=[4 4 3 3 3 3 2 2 2 2 Hsite]; %warning use H2
NbCations_vect=[1 1 2 2 2 2 1 1 1 1 1]; %warning use H2
NbOx_vect=[2 2 3 3 3 3 1 1 1 1 1]; %warning use H2
MolarMass_vect=[M_SiO2 M_TiO2 M_Al2O3 M_V2O3 M_Cr2O3 M_Fe2O3 M_FeO M_MnO M_MgO M_CaO (Hsite/2)*M_H2O];


NbSamples = length(Data(:,1));
XmapWaitBar(0,handles);

for i=1:NbSamples
    
    %Initialisation
    if ~mod(i,1000)==1;
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    if sum(Data(i,:)) > 0.1  % Is garnet
        
        %1    2    3     4    5     6   7   8   9   10
        %SiO2 TiO2 Al2O3 V2O3 Cr2O3 FeO MnO MgO CaO H2O
        
        SampleWt=[Data(i,1) Data(i,2) Data(i,3) Data(i,4) Data(i,5) 0 Data(i,6) Data(i,7) Data(i,8) Data(i,9) Data(i,10)];
        MolesOxides=SampleWt./MolarMass_vect;
        MolesOxygen=MolesOxides.*NbOx_vect;
        MolesCations=MolesOxides.*NbCations_vect;
        
        OxygenFactor=12/sum(MolesOxygen);
        CationicFactor=8/sum(MolesCations([1:11])); %method
        
        Normalisation_Obasis=MolesCations.*OxygenFactor;
        Normalisation_Cbasis=MolesCations.*CationicFactor;
        
        
        SumCharges=sum(Normalisation_Cbasis.*Charges_vect);
        
        FeOt=Data(i,6);
        Fe2O3_c=(24-SumCharges)/CationicFactor/2*M_Fe2O3;
        FeO_c=FeOt-0.8988*Fe2O3_c;
        
        if FeO_c<0; %Avoid negative values if Fe2+
            FeO_c=0;
            Fe2O3_c=FeOt*0.8988;
        end
        if Fe2O3_c<0;
            FeO_c=FeOt;
            Fe2O3_c=0;
        end
        
        
        Fe2O3(i)=Fe2O3_c;
        FeO(i)=FeO_c;
        
        SampleWt=[Data(i,1) Data(i,2) Data(i,3) Data(i,4) Data(i,5) Fe2O3_c FeO_c Data(i,7) Data(i,8) Data(i,9) Data(i,10)];
        Total(i)=sum(SampleWt);
        
        MolesOxides=SampleWt./MolarMass_vect;
        MolesOxygen=MolesOxides.*NbOx_vect;
        MolesCations=MolesOxides.*NbCations_vect;
        
        CationicFactor=8/sum(MolesCations([1:11])); %method
        Normalisation_Cbasis=MolesCations.*CationicFactor;
        
        SumTetra_Cbasis=sum(Normalisation_Cbasis([1 11]));
        SumOcta_Cbasis=sum(Normalisation_Cbasis([2 3 4 5 6]));
        SumDod_Cbasis=sum(Normalisation_Cbasis([7 8 9 10]));
        
        SumCharges=sum(Normalisation_Cbasis.*Charges_vect);
        
        %Fill the results vectors
        Si(i)=Normalisation_Cbasis(1);
        Ti(i)=Normalisation_Cbasis(2);
        Al(i)=Normalisation_Cbasis(3);
        V(i)=Normalisation_Cbasis(4);
        Cr(i)=Normalisation_Cbasis(5);
        Fe3(i)=Normalisation_Cbasis(6);
        Fe2(i)=Normalisation_Cbasis(7);
        Mn(i)=Normalisation_Cbasis(8);
        Mg(i)=Normalisation_Cbasis(9);
        Ca(i)=Normalisation_Cbasis(10);
        H2(i)=Normalisation_Cbasis(11);
        SumTetra(i)=SumTetra_Cbasis;
        SumOcta(i)=SumOcta_Cbasis;
        SumDod(i)=SumDod_Cbasis;
        SumCharges_vect(i)=SumCharges;
        
    end
    
end

XmapWaitBar(1,handles);
return
