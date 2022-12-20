function [logfO2] = OxibaroGE_EpVar_Walters(Data,handles)
% -
% XMapTools external function
%
% Calculate fO2 using HP thermodynamic data, EoS's and activity models
%
%
% Created by Jesse Walters and implemented by P. Lanari (Last change: 06.12.2019)
% -


%% INPUT GARNET COMPOSITION (PL)
lesNames = {'Fe2 (apfu)','Ca (apfu)','Mg (apfu)','Mn (apfu)','Fe3 (apfu)','Al (apfu)'};
lesDef = {'1.81','0.73','0.40','0.06','0.06','0.94'};
[Values] = str2num(char(inputdlg(lesNames,'Input Garnet composition',1,lesDef)));
Fe2 = Values(1); 
Ca = Values(2);
Mg = Values(3);
Mn = Values(4);
Fe3 = Values(5);
Al = Values(6);


%% P-T conditions (PL)
lesNames = {'T (dC)','P (GPa)'};
lesDef = {'530','2.16'};
[InputVariables] = str2num(char(inputdlg(lesNames,'Input P-T conditions',1,lesDef)));
T = InputVariables(1);    % 
P = InputVariables(2);


% Initial garnet calculations

Pbar=P*1E9; %converts GPa to Pa
TK=T+273.15; %converts celsius to kelvin
R=0.0083143*1000; %Gas constant (J/(K*mol))

[a_alm,~,a_gr,~,~]=Grt_ActivityCalc2(T,Fe2,Ca,Mg,Mn,Fe3,Al); %calculates activities of almandine and grossular

%solve G for garnet
Grt_thermo = ...
    [-5260700	342	0.00011525	677.3	0	-3772700	-5044	0.0000212	1.9E+11	2.98	-1.60E-11	20; ...
    -6643010	255	0.00012535	626	0	-5779200	-4002.9	0.000022	1.72E+11	5.53	-3.20E-11	20];

%MOLAR THERMODYNAMIC PROPERTIES
Hf=Grt_thermo(:,1); %enthalpies of fortmation (J)
S0=Grt_thermo(:,2); %entropies at 1 bar 298K (J/(K*mol))
V0=Grt_thermo(:,3); %volume at 1 bar 298K (m^3/mol)
%Heat capacity terms
a=Grt_thermo(:,4);
b=Grt_thermo(:,5);
c=Grt_thermo(:,6);
d=Grt_thermo(:,7);
alpha=Grt_thermo(:,8); %thermal expansivity (1/K)
K0=Grt_thermo(:,9); %bulk modulus (Pa)
dK0=Grt_thermo(:,10); %first derv. bulk modulus
d2K0=Grt_thermo(:,11); %second derv. bulk modulus (1/Pa)
n=Grt_thermo(:,12); %number of atoms per formula unit

[G_Grt]=GibbsSolid(Hf,S0,V0,a,b,c,d,alpha,K0,dK0,d2K0,P,T,n); %G for pure Garnet in J

%solve H for O2
O2 = [0.00E+00	205.2	48.3	-0.000691	499200	-420.7	54.5963	-8.6392	0.918301	-3305.58	0.00230524	0.000693054	-8.38293E-05	0	100000];

%MOLAR THERMODYNAMIC PROPERTIES
Hf_O2=O2(:,1); %enthalpies of fortmation (J)
S0_O2=O2(:,2); %entropies at 1 bar 298K (J/(K*mol))
%Heat capacity terms
a_O2=O2(:,3); 
b_O2=O2(:,4);
c_O2=O2(:,5);
d_O2=O2(:,6);
%cork parameters
Ca0=O2(:,7);
Ca1=O2(:,8);
Cb0=O2(:,9);
Cc0=O2(:,10);
Cc1=O2(:,11);
Cd0=O2(:,12);
Cd1=O2(:,13);
Tcf=O2(:,14); %critical T (K)
Pcf=O2(:,15); %critical P (Pa)

[G_O2]= GibbsO2(T,P,Hf_O2,S0_O2,a_O2,b_O2,c_O2,d_O2,Ca0,Ca1,Cb0,Cc0,Cc1,Cd0,Cd1,Tcf,Pcf); %G for pure O2 in J

%solve H for H2O
H2O = [-241810	188.8	40.1	8.66E-03	487500	-251.2];

%MOLAR THERMODYNAMIC PROPERTIES
Hf_H2O=H2O(:,1); %enthalpies of fortmation (J)
S0_H2O=H2O(:,2); %entropies at 1 bar 298K (J/(K*mol))
%Heat capacity terms
a_H2O=H2O(:,3); 
b_H2O=H2O(:,4);
c_H2O=H2O(:,5);
d_H2O=H2O(:,6);

%Gibbs free energies of Fluids and solids
[GH2O]=GibbsH2O(T,P,Hf_H2O,S0_H2O,a_H2O,b_H2O,c_H2O,d_H2O);



%% Computation for each Ep composition
logfO2 = zeros(1,length(Data(:,1)));

XmapWaitBar(0,handles);
hCompt = 1;
%Compt = 0;

for i=1:length(Data(:,1)) % one by one
    if sum(Data(i,:))
        
        hCompt = hCompt+1;
        if hCompt == 30; % if < 150, the function is very slow.
            XmapWaitBar(i/length(Data(:,1)),handles);
            hCompt = 1;
        end
        
        %Compt = Compt+1;
        R=0.0083143*1000; %Gas constant (J/(K*mol))
        
        Ep = Data(i,:);
        
        % XMapTools order:  1    2    3     4     5    6   7   8   9   10   11
        %                   SiO2 TiO2 Al2O3 Cr2O3 Y2O3 FeO MnO MgO CaO Na2O K2O
        
        % Epidote
        Ep(6) = Ep(6) * 1/0.899; %Conversion FeO (map) to Fe2O3      (PL)
        Ep = [Ep(1:4),Ep(6:end)];
        
        % Garnet
        %Grt = Grt(1:end-1);
        
        %Ep2=load('epidote2.txt');
        %Grt2=load('garnet2.txt');
        
        
        %% Calculate compositions for oxybarometry
        %[Fe2,Ca,Mg,Mn,Fe3,Al]=Grt_comp(Grt); %calls garnet composition calculator function
        
        [fep]=Ep_Comp(Ep); % calls epidote composition calculator
        
        
        %% Activity calculation
        
        %calculate activities for epidote and garnet
        [a_ep,~,~]=Ep_ActivityCalc(T,P,fep); %calculates activity of the epidote endmember
        
        
        %% calculate oxygen activity
        %reaction: 12Ep = 8 Gr + 4 Alm + 6H2O + 302
        
        %solve G for epidote
        Ep_thermo = ...
            [-6895540.000000000	301.000000000	0.000136300	630.900000000	0.013693000	-6645800.000000000	-3731.100000000	0.000023300	119700000000.000000000	4.070000000	-3.40E-11	22.000000000; ...
            -6473830.000000000	315.000000000	0.000139200	613.300000000	0.022070000	-7160000.000000000	-2987.700000000	0.000023400	134000000000.000000000	4.000000000	-3.00E-11	22.000000000; ...
            -6028590.000000000	329.000000000	0.000142100	584.700000000	0.030447000	-7674200.000000000	-2244.300000000	0.000023100	151300000000.000000000	4.000000000	-2.60E-11	22.000000000];
        
        %MOLAR THERMODYNAMIC PROPERTIES
        Hf=Ep_thermo(:,1); %enthalpies of fortmation (J)
        S0=Ep_thermo(:,2); %entropies at 1 bar 298K (J/(K*mol))
        V0=Ep_thermo(:,3); %volume at 1 bar 298K (m^3/mol)
        %Heat capacity terms
        a=Ep_thermo(:,4);
        b=Ep_thermo(:,5);
        c=Ep_thermo(:,6);
        d=Ep_thermo(:,7);
        alpha=Ep_thermo(:,8); %thermal expansivity (1/K)
        K0=Ep_thermo(:,9); %bulk modulus (Pa)
        dK0=Ep_thermo(:,10); %first derv. bulk modulus
        d2K0=Ep_thermo(:,11); %second derv. bulk modulus (1/Pa)
        n=Ep_thermo(:,12); %number of atoms per formula unit
        
        [G_Ep]=GibbsSolid(Hf,S0,V0,a,b,c,d,alpha,K0,dK0,d2K0,P,T,n); %G for pure epidote in J
        
        
        %solve for the gibbs free energy of O2
        DG_O2=(12*(G_Ep(2,:)+R*TK*log(a_ep))-8*(G_Grt(2,:)+R*TK*log(a_gr))-4*(G_Grt(1,:)+R*TK*log(a_alm))-6*GH2O)/3; %in J
        
        %solve for activity of O2 at PT
        RTlna_O2=DG_O2-G_O2; %natural log term, G_O2 = G of pure O2 + RTln(aO2)
        a_O2=exp(RTlna_O2/(R*TK)); %activity of O2
        
        %% calculate oxygen fugacity
        
        %Standard state P,T
        % Tref=298.15; %T (K)
        Pref=0.0001; %1 bar converted to GPa
        R=0.0083143; %redefines R to kJ
        
        % Note: the standard way of reporting the relationship between activity and fugacity
        % is a=f/f0 where f0 is the fugacity at 1 bar and the temperature of interest
        
        %molar gibbs free energy (chemical potential) at standard state
        [G_O2_0]= GibbsO2(T,Pref,Hf_O2,S0_O2,a_O2,b_O2,c_O2,d_O2,Ca0,Ca1,Cb0,Cc0,Cc1,Cd0,Cd1,Tcf,Pcf); %G for pure O2 in J
        
        %calculates fO2, G's are converted to kJ
        logfO2(i)=(1/(2.303*R*TK))*((G_O2-G_O2_0)/1000)+log10(a_O2);

        
    end
end

XmapWaitBar(1,handles);

return



function [Fe2,Ca,Mg,Mn,Fe3,Al]=Grt_comp(Grt)
%calculates Grt formula  

%input wt % oxide in the following order
%column1: SiO2
%column2: TiO2
%column3: Al2O3
%column4: Cr2O3
%column5: Y2O3
%column6: FeO
%column7: MnO
%column8: MgO
%column9: CaO
%column10: Na2O

%OUTPUT: Structural formula (APFU)
%column1: Si (T)
%column2: Al (T)
%column3: Fe3+ (T)
%column4: sum of T site
%column5: Al (Y)
%column6: Ti (Y)
%column7: Cr (Y)
%column8: Fe3+ (Y)
%column9: sum of Y site
%column10: Y (X)
%column11: Fe2+ (X)
%column12: Mn (X)
%column13: Mg (X)
%column14: Ca (X)
%column15: Na (X)
%column16: sum of X site


cat=8.0; %cations per formula unit
Opfu=12.0; %oxygens per formula unit


%% Molecular weights

SiO2=60.084;
TiO2=79.866;
Al2O3=101.961;
Fe2O3=159.688;
Cr2O3=151.99;
Y2O3=225.81;
FeO=71.844;
MnO=70.937;
MgO=40.304;
CaO=56.077;
Na2O=61.979;
K2O=94.196;

W=[SiO2,TiO2,Al2O3,Cr2O3,Y2O3,FeO,MnO,MgO,CaO,Na2O];

%% Calculate cations units

[m,n]=size(Grt); %finds the x and y size of the input data matrix
MC=zeros(size(Grt)); %creates a matrix of zeroes the size of the input data
MC(:,1)=Grt(:,1)./W(:,1); %for SiO2
MC(:,2)=Grt(:,2)./W(:,2); %for TiO2
MC(:,3)=(Grt(:,3)./W(:,3)).*2; %for Al2O3
MC(:,4)=(Grt(:,4)./W(:,4)).*2; %for Cr2O3
MC(:,5)=(Grt(:,5)./W(:,5)).*2; %for Y2O3
MC(:,6)=Grt(:,6)./W(:,6); %for FeO
MC(:,7)=Grt(:,7)./W(:,7); %for MnO
MC(:,8)=Grt(:,8)./W(:,8); %for MgO
MC(:,9)=Grt(:,9)./W(:,9); %for CaO
MC(:,10)=(Grt(:,10)./W(:,10)).*2; %for Na2O


MCnormfact=zeros(m,1); %creates a zeromatrix for the totals of the mole cation matrix 
MCnormfact=cat./sum(MC,2); %normalization factor

%% Calculate normalized cations units

MCnorm=MCnormfact.*MC; %creates a matrix of normalized cations

%% Calculate Oxygen Units

O2=zeros(size(Grt));
O2(:,1)=MCnorm(:,1).*2; %for SiO2
O2(:,2)=MCnorm(:,2).*2; %for TiO2
O2(:,3)=MCnorm(:,3).*(3/2); %for Al2O3
O2(:,4)=MCnorm(:,4).*(3/2); %for Cr2O3
O2(:,5)=MCnorm(:,5).*(3/2); %for Y2O3
O2(:,5)=MCnorm(:,6); %for FeO
O2(:,6)=MCnorm(:,7); %for MnO
O2(:,7)=MCnorm(:,8); %for MgO
O2(:,8)=MCnorm(:,9); %for CaO
O2(:,9)=MCnorm(:,10)./2; %for Na2O


O2total=sum(O2,2); %O2 totals

%% Atoms pfu

APFU=zeros(m,n+3); %matrix of zeroes to be filled, n+2 for Fe3+ and total

APFU(:,1)=MCnorm(:,1); %for Si
APFU(:,2)=MCnorm(:,2); %for Ti
APFU(:,3)=MCnorm(:,3); %for Al
APFU(:,5)=MCnorm(:,4); %for Cr2O3
APFU(:,6)=MCnorm(:,5); %for Y2O3
APFU(:,8)=MCnorm(:,7); %for MnO
APFU(:,9)=MCnorm(:,8); %for MgO
APFU(:,10)=MCnorm(:,9); %for CaO
APFU(:,11)=MCnorm(:,10); %for Na2O


%calculation of Fe3+ from stoichiometry and charge balance
%the following if statement firsts checks if totalO2 = 6
%if so, then there is no Fe3+
%if totalO2 < 6, then we assume that the deficiency is caused by the
%assumption Fetotal = Fe2+
%in the nested if statement, if FeTotal > 2*(6-totalO2) then the amount
%of Fe3+ = 2*(6-totalO2), if false then, all Fe is Fe3+

for c=1:m
    if (Opfu-O2total(c,1)) > 0;
        if MCnorm(c,6) > 2*(Opfu-O2total(c,1));
            APFU(c,4)=2*(Opfu-O2total(c,1)); 
        else
            APFU(c,4)=MCnorm(c,6);
        end
    else
        APFU(c,4)=MCnorm(c,6);
    end
end

APFU(:,7)=MCnorm(:,6)-APFU(:,4); %the APFU of Fe2+ equals totalFe-Fe3+

APFU(:,12)=sum(APFU,2); %calculations the total, which should be 8

% Oxygen deficiency 
APFU(:,13)=Opfu-O2total; %must be greater than zero

%% structural formula calculation

StrctFrm=zeros(m,n+6);%creates a matrix to be filled
%T SITE
%Si
StrctFrm=APFU(:,1);

%Al(T)
for c=1:m
    if 3-StrctFrm(c,1)>APFU(c,3) %if low Al Grt, all Al may be in T
        StrctFrm(c,2)=APFU(c,3);
    else
        if 3-StrctFrm(c,1)>0 
           StrctFrm(c,2)=3-StrctFrm(c,1); %for most Grt's, only some Al will be in T
        else
            StrctFrm(c,2)=0; %if Si is 3 or more, no Al in T
        end
    end
end

%Fe3+(T), for Al poor Grt
for c=1:m
    if 3-(StrctFrm(c,1)+StrctFrm(c,1))>0
        StrctFrm(c,3)=3-(StrctFrm(c,1)+StrctFrm(c,1));
    else
        StrctFrm(c,3)=0;
    end
end

%Sum of T site
StrctFrm(:,4)=StrctFrm(:,1)+StrctFrm(:,2)+StrctFrm(:,3);

%Y SITE

%Al (Y)
StrctFrm(:,5)=APFU(:,3)-StrctFrm(:,2);

%Ti (Y)
StrctFrm(:,6)=APFU(:,2);

%Cr (Y) 
StrctFrm(:,7)=APFU(:,5);

%Fe3+ (Y)
StrctFrm(:,8)=APFU(:,4)-StrctFrm(:,3);

%Y sum
StrctFrm(:,9)=StrctFrm(:,8)+StrctFrm(:,7)+StrctFrm(:,6)+StrctFrm(:,5);

%X SITE

%Y (X)
StrctFrm(:,10)=APFU(:,6);

%Fe2+ (X)
StrctFrm(:,11)=APFU(:,7);

%Mn (X)
StrctFrm(:,12)=APFU(:,8);

%Mg (X)
StrctFrm(:,13)=APFU(:,9);

%Ca (X)
StrctFrm(:,14)=APFU(:,10);

%Na (X)
StrctFrm(:,15)=APFU(:,11);

% X Sum
StrctFrm(:,16)=StrctFrm(:,15)+StrctFrm(:,14)+StrctFrm(:,13)+StrctFrm(:,12)+StrctFrm(:,11)+StrctFrm(:,10);

%% 

Fe2=StrctFrm(:,11);
Ca=StrctFrm(:,14);
Mg=StrctFrm(:,13);
Mn=StrctFrm(:,12);
Fe3=StrctFrm(:,8);
Al=StrctFrm(:,5);
return


function [fep]=Ep_Comp(Ep)

%input wt % oxide in the following order
%column1: SiO2
%column2: TiO2
%column3: Al2O3
%column4: Cr2O3
%column5: Fe2O3
%column6: MnO
%column7: MgO
%column8: CaO
%column9: Na2O
%column10: K2O

%OUTPUTS

%StrctFrm: Structural formula for individual analyses
%column1: Si (T)
%column2: Ti (T)
%column3: Al (T)
%column4: T sum
%column5: Ti (M)
%column6: Al (M)
%column7: Cr (M)
%column8: Mn (M)
%column9: Fe3+ (M)
%column10: M sum
%column11: Fe2+ (A)
%column12: Mg (A)
%column13: Ca (A)
%column14: Na (A)
%column15: K (A)
%column16: A sum

%AveStrctFrm: Average of the Structural formula analyses with 1sigma
%standard deviation

Opfu=12.5; %oxygens per formula unit


%% Molecular weights

SiO2=60.084;
TiO2=79.866;
Al2O3=101.961;
Cr2O3=151.99;
Fe2O3=159.688;
FeO=71.844;
MnO=70.937;
MgO=40.304;
CaO=56.077;
Na2O=61.979;
K2O=94.196;

W=[SiO2,TiO2,Al2O3,Cr2O3,Fe2O3,MnO,MgO,CaO,Na2O,K2O];


%% Calculate cations units

[m,n]=size(Ep); %finds the x and y size of the input data matrix
MC=zeros(size(Ep)); %creates a matrix of zeroes the size of the input data
MC(:,1)=Ep(:,1)./SiO2; %for SiO2
MC(:,2)=Ep(:,2)./TiO2; %for TiO2
MC(:,3)=Ep(:,3)./Al2O3; %for Al2O3
MC(:,4)=Ep(:,4)./Cr2O3; %for Cr2O3
MC(:,5)=Ep(:,5)./(2*FeO); %for Fe2O3
MC(:,6)=Ep(:,6)./MnO; %for MnO
MC(:,7)=Ep(:,7)./MgO; %for MgO
MC(:,8)=Ep(:,8)./CaO; %for CaO
MC(:,9)=Ep(:,9)./Na2O; %for Na2O
MC(:,10)=Ep(:,10)./K2O; %for K2O

%% Calculate Oxygen Units

O2=zeros(size(Ep));
O2(:,1)=MC(:,1).*2; %for SiO2
O2(:,2)=MC(:,2).*2; %for TiO2
O2(:,3)=MC(:,3).*(3); %for Al2O3
O2(:,4)=MC(:,4).*(3); %for Cr2O3
O2(:,5)=MC(:,5).*(3); %for Fe2O3
O2(:,6)=MC(:,6); %for MnO
O2(:,7)=MC(:,7); %for MgO
O2(:,8)=MC(:,8); %for CaO
O2(:,9)=MC(:,9); %for Na2O
O2(:,10)=MC(:,10); %for K2O

O2total=sum(O2,2); %O2 totals

%% Normalized Oxygen Units

O2norm=O2.*(Opfu./O2total);

%% Atoms pfu

APFU=zeros(m,n+1); %matrix of zeroes to be filled, n+2 for Fe3+ and total

for c=1:m
APFU(c,1)=O2norm(c,1)./2; %for Si
end

for c=1:m
APFU(c,2)=O2norm(c,2)./2; %for Ti
end

for c=1:m
APFU(c,3)=O2norm(c,3).*(2/3); %for Al
end

for c=1:m
APFU(c,4)=O2norm(c,4).*(2/3); %for Cr3+
end

for c=1:m
APFU(c,5)=O2norm(c,5).*(2/3); %for Fe3+
end

for c=1:m
APFU(c,6)=O2norm(c,6); %for Mn
end

for c=1:m
APFU(c,7)=O2norm(c,7); %for Mg
end

for c=1:m
APFU(c,8)=O2norm(c,8); %for Ca
end

for c=1:m
APFU(c,9)=O2norm(c,9).*2; %for Na
end

for c=1:m
APFU(c,10)=O2norm(c,10).*2; %for K
end

APFU(:,11)=sum(APFU,2);

%% Structural Formula
%T site - Si, Ti, Al (sums to 3)
%M sites - Ti, Al, Cr3+, Fe3+, Mn3+
%A site - Ca, Na, K, Mg, Fe2+ (Sums to 2)

% if Al + Fe3+ + Cr + Ti + Mn in the M site is > 3 then the remaining Fe3+ is
% converted to Fe2+ in the A site

StrctFrm=zeros(m,16);%creates a matrix to be filled

%T SITE
%Si 
for c=1:m
    StrctFrm(c,1)=APFU(c,1);
end

%Ti(T)
for c=1:m
    if StrctFrm(c,1)<3
        if (StrctFrm(c,1)+APFU(c,2))>3
            StrctFrm(c,2)=3-APFU(c,1);
        else
            StrctFrm(c,2)=APFU(c,2);
        end
    else
        StrctFrm(c,2)=0;
    end
end

%Al(T)
for c=1:m
    if (StrctFrm(c,1)+StrctFrm(c,2))<3
        StrctFrm(c,3)=3-(StrctFrm(c,1)+StrctFrm(c,2));
    else
        StrctFrm(c,3)=0;
    end
end

%T-site sum
for c=1:m
    StrctFrm(c,4)=StrctFrm(c,3)+StrctFrm(c,2)+StrctFrm(c,1);
end

%M site

%Ti (M)
for c=1:m
    StrctFrm(c,5)=APFU(c,2)-StrctFrm(c,2);
end

%Al (M)
for c=1:m
    StrctFrm(c,6)=APFU(c,3)-StrctFrm(c,3);
end

%Cr (M)
for c=1:m
    StrctFrm(c,7)=APFU(c,4);
end

%Mn (M)
for c=1:m
    StrctFrm(c,8)=APFU(c,6);
end

%Fe3+ (M)
for c=1:m
    if (StrctFrm(c,5)+StrctFrm(c,6)+StrctFrm(c,7)+StrctFrm(c,8)+APFU(c,5))>3
        StrctFrm(c,9)=3-(StrctFrm(c,5)+StrctFrm(c,6)+StrctFrm(c,7)+StrctFrm(c,8));
    else
        StrctFrm(c,9)=APFU(c,5);
    end
end

%M site sum
for c=1:m
    StrctFrm(c,10)=StrctFrm(c,5)+StrctFrm(c,6)+StrctFrm(c,7)+StrctFrm(c,8)+StrctFrm(c,9);
end

%A sites

%Fe2+ (A)
for c=1:m
    StrctFrm(c,11)=APFU(c,5)-StrctFrm(c,9);
end

%Mg (A)
for c=1:m
    StrctFrm(c,12)=APFU(c,7);
end

%Ca (A)
for c=1:m
    StrctFrm(c,13)=APFU(c,8);
end

%Na (A)
for c=1:m
    StrctFrm(c,14)=APFU(c,9);
end

%K (A)
for c=1:m
    StrctFrm(c,15)=APFU(c,10);
end

%A site sum
for c=1:m
    StrctFrm(c,16)=StrctFrm(c,11)+StrctFrm(c,12)+StrctFrm(c,13)+StrctFrm(c,14)+StrctFrm(c,15);
end


%% ferri-epidote fraction

fep=StrctFrm(:,9)/(StrctFrm(:,9)+StrctFrm(:,6)); %Fe3/(Fe3 + Al) in the M site
return


function [a_ep,a_cz,a_fep]=Ep_ActivityCalc(T,P,fep)
%epidote activity  A-X model following Holland and Powell (1998; 1996)
%the solutioin model includes the following endmembers:
%czo: Ca(AlAl)AlSi3O12(OH)
%ep: Ca(AlFe3+)AlSi3O12(OH)
%fep: Ca(Fe3+Fe3+)AlSi3O12(OH)
% Al always occupies the M2 site
% Fe3+ and Al are assigned between M1 and M3

%Thermodynamic data for endmembers:
%row 1: clinozoisite
%row 2: epidote (ordered)
%row 3: ferri-epidote

D= ...
    [-6895540.000000000	301.000000000	0.000136300	630.900000000	0.013693000	-6645800.000000000	-3731.100000000	0.000023300	119700000000.000000000	4.070000000	-3.40E-11	22.000000000; ...
    -6473830.000000000	315.000000000	0.000139200	613.300000000	0.022070000	-7160000.000000000	-2987.700000000	0.000023400	134000000000.000000000	4.000000000	-3.00E-11	22.000000000; ...
    -6028590.000000000	329.000000000	0.000142100	584.700000000	0.030447000	-7674200.000000000	-2244.300000000	0.000023100	151300000000.000000000	4.000000000	-2.60E-11	22.000000000];
Hf=D(:,1); %enthalpies of fortmation (J)
S0=D(:,2); %entropies at 1 bar 298K (J/(K*mol))
V0=D(:,3); %volume at 1 bar 298K (m^3/mol)

%Heat capacity terms
a=D(:,4);
b=D(:,5);
c=D(:,6);
d=D(:,7);

alpha=D(:,8); %thermal expansivity (1/K)
K0=D(:,9); %bulk modulus (Pa)
dK0=D(:,10); %first derv. bulk modulus
d2K0=D(:,11); %second derv. bulk modulus (1/Pa)
nmin=D(:,12); %number of atoms per formula unit

R=0.0083143*1000; %Gas constant (J/(K*mol))
TK=T+273.15; %convert T to kelvin 
Pbar=P*1E9; % Pascals

%Margules parameters and dH
Wczfep=3.0*1000; %J/mol 
Wczep=1.0*1000; %j/mol  
Wfepep=1.0*1000; %J/mol 

%% Calculate dH of the internal reaction

%Integral(Cp)dT
T0=298.15;
intCpdT=(a.*TK+0.5.*b*TK.*TK-c./TK+2.*d.*sqrt(TK))-(a.*T0+0.5.*b.*T0.*T0-c./T0+2.0.*d.*sqrt(T0));

% Integral(Cp/T)dT
intCpoverTdT=a.*log(TK./298.15)+b.*(TK-298.15)-(c./2).*(1./(TK.*TK)-1./(298.15.*298.15))-2.*d.*(1./sqrt(TK)-1./(sqrt(298.15)));

%volume contribution to the Gibbs free energy
intVdP=TEOS(V0,alpha,K0,dK0,d2K0,Pbar,TK,S0,nmin); %calls the TEOS

%Gibbs free energy of endmembers at P & T of interest
Gs=Hf+intCpdT-TK.*(S0+intCpoverTdT)+intVdP; %in J

%dH for the internal reaction czo + fep = 2ep
dH=(2*Gs(2)-(Gs(1)+Gs(3))); %J

%for constant dH use:
%dH=-25*1000; %J, dH for the internal reaction czo + fep = 2ep

%% solve for Q
sym N; %makes the symbol N for algebraic calculation of Q

%Gibbs free energy equation written in terms of the internal reaction
%Czo+Fep=2Ep


Q0=0:0.00001:1; %step size of Q from 0 to 1.0 for itteration 
N0=transpose(Q0)/2; %writes the initial guess in terms of N
G=zeros(size(N0)); %creates a matrix of Gibbs free energy values to be filled

%calculates G for N itterations, the value closest to zero will correspond
%to the correct Q

for n=1:size(N0)
G(n,1)=R*TK*log((fep+N0(n,1))*(1-fep+N0(n,1))/((fep-N0(n,1))*(1-fep-N0(n,1))))+2*N0(n,1)*(Wczfep-2*Wczep-2*Wfepep)+dH+2*Wczep-Wczfep+2*fep*(Wfepep-Wczep);
end

[val,idx]=min(abs(G)); %find the index of Q where Gibbs free energy is closest to zero

Q=Q0(idx); %give value of Q for the internal reaction
N=Q/2; %gives N value for internal reaction

%% calculate endmember activities 

Pfep=fep-N; %proportion of ferri-epidote 
Pcz=1-fep-N; %proportion of clinozoisite
Pep=Q; %proportion of epidote 

%ideal terms
ai_cz=(1-Pfep)*Pcz; %ideal activity of clinozoisite 
ai_fep=Pfep*(1-Pcz); %ideal activity of ferri-epidote
ai_ep=(1-Pfep)*(1-Pcz); %ideal activity of epidote 

%activity coefficients
y_cz=exp(((1-Pcz)*Pfep*Wczfep+(1-Pcz)*Pep*Wczep-Pfep*Pep*Wfepep)/(R*TK)); %coefficient for clinozoisite
y_fep=exp(((1-Pfep)*Pcz*Wczfep+Pcz*Pep*Wczep+(1-Pfep)*Pep*Wfepep)/(R*TK)); %coefficient for ferri-epidote
y_ep=exp((-Pcz*Pfep*Wczfep+(1-Pep)*Pcz*Wczep+(1-Pep)*Pfep*Wfepep)/(R*TK)); %coefficient for epidote

%activities
a_cz=ai_cz*y_cz;
a_fep=ai_fep*y_fep;
a_ep=ai_ep*y_ep;
return


function [a_alm,a_py,a_gr,a_sps,a_kho]=Grt_ActivityCalc2(T,Fe2,Ca,Mg,Mn,Fe3,Al)
% MnCFMASO garnet A-X model from White et al. (2014a,b) following the
% ASF of Holland and Powell (2003). For use with Thermocalc DS62.
% The solution model uses the following endmembers:
% Almandine (Fe3Al2Si3O12)
% Pyrope (Mg3Al2Si3O12)
% Spessartine (Mn3Al2Si3O12)
% Grossular (Ca3Al2Si3O12)
% Khoharite (Mg3(Fe3+)2Si3O12)

TK=T+273.15; %convers celsius to kelvin
R=0.0083143; %Gas constant (kJ/(K*mol))

%site fractions
XMg=Mg/(Fe2+Mg+Mn+Ca);
XFe2=Fe2/(Fe2+Mg+Mn+Ca);
XMn=Mn/(Fe2+Mg+Mn+Ca);
XCa=Ca/(Fe2+Mg+Mn+Ca);
XAl=Al/(Fe3+Al);
XFe3=1-XAl;

%compositional variables
x=XFe2/(XFe2+XMg);
z=XCa;
m=XMn;
f=XFe3;

%endmember proportions
Palm=x*(1-m-z);
Ppy=1-f-m-x-z+m*x+x*z;
Psps=m;
Pgr=z;
Pkho=f;

%Margules parameters (kJ/mol)
Wpyalm=2.5;
Wpysps=2;
Wpygr=31;
Wpykho=5.4;
Walmsps=2;
Walmgr=5;
Walmkho=22.6;
Wspsgr=0;
Wspskho=29.4;
Wgrkho=-15.3;

%Van laar size parameters
alpha_alm=1;
alpha_py=1;
alpha_gr=2.7;
alpha_sps=1;
alpha_kho=1;

%% Calculation of phi values 

phi_alm=(Palm*alpha_alm)/(Palm*alpha_alm+Ppy*alpha_py+Pgr*alpha_gr+Psps*alpha_sps+Pkho*alpha_kho);
phi_py=(Ppy*alpha_py)/(Palm*alpha_alm+Ppy*alpha_py+Pgr*alpha_gr+Psps*alpha_sps+Pkho*alpha_kho);
phi_gr=(Pgr*alpha_gr)/(Palm*alpha_alm+Ppy*alpha_py+Pgr*alpha_gr+Psps*alpha_sps+Pkho*alpha_kho);
phi_sps=(Psps*alpha_sps)/(Palm*alpha_alm+Ppy*alpha_py+Pgr*alpha_gr+Psps*alpha_sps+Pkho*alpha_kho);
phi_kho=(Pkho*alpha_kho)/(Palm*alpha_alm+Ppy*alpha_py+Pgr*alpha_gr+Psps*alpha_sps+Pkho*alpha_kho);

%% Calculation of activity coefficients
%note: the activity coefficient equations are broken into multiple parts
%to improve legibility 

%Almandine
alm1=(1-phi_alm)*phi_py*((2*Wpyalm*alpha_alm)/(alpha_alm+alpha_py)); %RTlny term1
alm2=(1-phi_alm)*phi_gr*((2*Walmgr*alpha_alm)/(alpha_alm+alpha_gr)); %RTlny term2
alm3=(1-phi_alm)*phi_kho*((2*Walmkho*alpha_alm)/(alpha_alm+alpha_kho)); %RTlny term3
alm4=(1-phi_alm)*phi_sps*((2*Walmsps*alpha_alm)/(alpha_alm+alpha_sps)); %RTlny term4
alm5=phi_py*phi_gr*((2*Wpygr*alpha_alm)/(alpha_gr+alpha_py)); %RTlny term5
alm6=phi_py*phi_sps*((2*Wpysps*alpha_alm)/(alpha_sps+alpha_py)); %RTlny term6
alm7=phi_py*phi_kho*((2*Wpykho*alpha_alm)/(alpha_kho+alpha_py)); %RTlny term7
alm8=phi_sps*phi_gr*((2*Wspsgr*alpha_alm)/(alpha_gr+alpha_sps)); %RTlny term8
alm9=phi_sps*phi_kho*((2*Wspskho*alpha_alm)/(alpha_kho+alpha_sps)); %RTlny term9
alm10=phi_gr*phi_kho*((2*Wgrkho*alpha_alm)/(alpha_gr+alpha_kho)); %RTkny term 10

RTlny_alm=alm1+alm2+alm3+alm4-alm5-alm6-alm7-alm8-alm9-alm10;
y_alm=exp(RTlny_alm/(R*TK)); %activity coefficient

%Pyrope
py1=(1-phi_py)*phi_alm*((2*Wpyalm*alpha_py)/(alpha_alm+alpha_py)); %RTlny term1
py2=(1-phi_py)*phi_sps*((2*Wpysps*alpha_py)/(alpha_sps+alpha_py)); %RTlny term2
py3=(1-phi_py)*phi_gr*((2*Wpygr*alpha_py)/(alpha_gr+alpha_py)); %RTlny term3
py4=(1-phi_py)*phi_kho*((2*Wpykho*alpha_py)/(alpha_kho+alpha_py)); %RTlny term4
py5=phi_alm*phi_sps*((2*Walmsps*alpha_py)/(alpha_alm+alpha_sps)); %RTlny term5
py6=phi_alm*phi_gr*((2*Walmgr*alpha_py)/(alpha_alm+alpha_gr)); %RTlny term6
py7=phi_alm*phi_kho*((2*Walmkho*alpha_py)/(alpha_alm+alpha_kho)); %Rtlny term7
py8=phi_sps*phi_gr*((2*Wspsgr*alpha_py)/(alpha_sps+alpha_gr)); %RTlny term8
py9=phi_sps*phi_kho*((2*Wspskho*alpha_py)/(alpha_sps+alpha_kho)); %RTlny term9
py10=phi_gr*phi_kho*((2*Wgrkho*alpha_py)/(alpha_gr+alpha_kho)); %RTlny term 10

RTlny_py=py1+py2+py3+py4-py5-py6-py7-py8-py9-py10;
y_py=exp(RTlny_py/(R*TK)); %activity coefficient

%spessartine
sps1=(1-phi_sps)*phi_alm*((2*Walmsps*alpha_sps)/(alpha_alm+alpha_sps)); %RTlny term1
sps2=(1-phi_sps)*phi_py*((2*Wpysps*alpha_sps)/(alpha_py+alpha_sps)); %RTlny term2
sps3=(1-phi_sps)*phi_gr*((2*Wspsgr*alpha_sps)/(alpha_gr+alpha_sps)); %RTlny term3
sps4=(1-phi_sps)*phi_kho*((2*Wspskho*alpha_sps)/(alpha_kho+alpha_sps)); %RTlny term4
sps5=phi_py*phi_alm*((2*Wpyalm*alpha_sps)/(alpha_alm+alpha_py)); %RTlny term5
sps6=phi_py*phi_gr*((2*Wpygr*alpha_sps)/(alpha_py+alpha_gr)); %RTlny term6
sps7=phi_py*phi_kho*((2*Wpykho*alpha_sps)/(alpha_py+alpha_kho)); %RTlny term7
sps8=phi_alm*phi_gr*((2*Walmgr*alpha_sps)/(alpha_alm+alpha_gr)); %RTlny term8
sps9=phi_alm*phi_kho*((2*Walmkho*alpha_sps)/(alpha_alm+alpha_kho)); %RTlny term9
sps10=phi_gr*phi_kho*((2*Wgrkho*alpha_sps)/(alpha_gr+alpha_kho)); %RTlny term10

RTlny_sps=sps1+sps2+sps3+sps4-sps5-sps6-sps7-sps8-sps9-sps10;
y_sps=exp(RTlny_sps/(R*TK)); %activity coefficient

%Grossular
gr1=(1-phi_gr)*phi_alm*((2*Walmgr*alpha_gr)/(alpha_alm+alpha_gr)); %RTlny term1
gr2=(1-phi_gr)*phi_py*((2*Wpygr*alpha_gr)/(alpha_py+alpha_gr)); %RTlny term2
gr3=(1-phi_gr)*phi_sps*((2*Wspsgr*alpha_gr)/(alpha_sps+alpha_gr)); %RTlny term3
gr4=(1-phi_gr)*phi_kho*((2*Wgrkho*alpha_gr)/(alpha_gr+alpha_kho)); %RTlny term4
gr5=phi_py*phi_alm*((2*Wpyalm*alpha_gr)/(alpha_py+alpha_alm)); %RTlny term5
gr6=phi_py*phi_sps*((2*Wpysps*alpha_gr)/(alpha_py+alpha_sps)); %RTlny term6
gr7=phi_py*phi_kho*((2*Wpykho*alpha_gr)/(alpha_py+alpha_kho)); %RTlny term7
gr8=phi_alm*phi_sps*((2*Walmsps*alpha_gr)/(alpha_alm+alpha_sps)); %RTlny term8
gr9=phi_alm*phi_kho*((2*Walmkho*alpha_gr)/(alpha_alm+alpha_kho)); %RTlny term9
gr10=phi_sps*phi_kho*((2*Wspskho*alpha_gr)/(alpha_sps+alpha_kho)); %RTlny term10

RTlny_gr=gr1+gr2+gr3+gr4-gr5-gr6-gr7-gr8-gr9-gr10;
y_gr=exp(RTlny_gr/(R*TK)); %activity coefficient

%Khoharite 
kho1=(1-phi_kho)*phi_alm*((2*Walmkho*alpha_kho)/(alpha_kho+alpha_alm)); %RTlny term1
kho2=(1-phi_kho)*phi_py*((2*Wpykho*alpha_kho)/(alpha_py+alpha_kho)); %RTlny term2
kho3=(1-phi_kho)*phi_sps*((2*Wspskho*alpha_kho)/(alpha_sps+alpha_kho)); %RTlny term3
kho4=(1-phi_kho)*phi_gr*((2*Wgrkho*alpha_kho)/(alpha_gr+alpha_kho)); %RTlny term4
kho5=phi_alm*phi_py*((2*Wpyalm*alpha_kho)/(alpha_py+alpha_alm)); %RTlny term5
kho6=phi_py*phi_sps*((2*Wpysps*alpha_kho)/(alpha_py+alpha_sps)); %RTlny term6
kho7=phi_py*phi_gr*((2*Wpygr*alpha_kho)/(alpha_py+alpha_gr)); %RTlny term7
kho8=phi_alm*phi_sps*((2*Walmsps*alpha_kho)/(alpha_alm+alpha_sps)); %RTlny term8
kho9=phi_alm*phi_gr*((2*Walmgr*alpha_kho)/(alpha_alm+alpha_gr)); %RTlny term9
kho10=phi_sps*phi_gr*((2*Wspsgr*alpha_kho)/(alpha_sps+alpha_gr)); %RTlny term10

RTlny_kho=kho1+kho2+kho3+kho4-kho5-kho6-kho7-kho8-kho9-kho10;
y_kho=exp(RTlny_kho/(R*TK)); %activity coefficient
%% Calculation of activities 

%ideal activities 
ai_alm=(XFe2^3)*(XAl^2); %almandine
ai_py=(XMg^3)*(XAl^2); %pyrope
ai_sps=(XMn^3)*(XAl^2); %spessartine
ai_gr=(XCa^3)*(XAl^2); %grossular
ai_kho=(XMg^3)*(XFe3^2); %Khoharite

%activity
a_alm=ai_alm*y_alm; %almandine
a_py=ai_py*y_py; %pyrope
a_sps=ai_sps*y_sps; %spessartine
a_gr=ai_gr*y_gr; %grossular
a_kho=ai_kho*y_kho; %khoharite
return


function [Gs]= GibbsSolid(Hf,S0,V0,a,b,c,d,alpha,K0,dK0,d2K0,P,T,n)
% Molar Gibbs Free Energy Calculator for Pure Solid Phases
% This function calculates the molar gibbs free energy for solid phases in
% two parts: G=G0+RTlnK
% where
% G0=Hf-TS0-integral(Cp)dT-T*integral(Cp/T)dT+integral(Vsolid)dP

Pbar=P*1e9; %converts GPa to pascals
TK=T+273.15; %converts celsius to kelvin

%% Integral(Cp)dT
T0=298.15;
intCpdT=(a.*TK+0.5.*b*TK.*TK-c./TK+2.*d.*sqrt(TK))-(a.*T0+0.5.*b.*T0.*T0-c./T0+2.0.*d.*sqrt(T0));

%% Integral(Cp/T)dT
intCpoverTdT=a.*log(TK./298.15)+b.*(TK-298.15)-(c./2).*(1./(TK.*TK)-1./(298.15.*298.15))-2.*d.*(1./sqrt(TK)-1./(sqrt(298.15)));
%%
intVdP=TEOS(V0,alpha,K0,dK0,d2K0,Pbar,TK,S0,n); %calls the TEOS to calculate the
%volume contribution to the Gibbs free energy 

Gs=Hf+intCpdT-TK.*(S0+intCpoverTdT)+intVdP;
return


function [Gf]= GibbsO2(T,P,Hff,S0f,af,bf,cf,df,Ca0,Ca1,Cb0,Cc0,Cc1,Cd0,Cd1,Tcf,Pcf)
% This function calculates the molar gibbs free energy for solid phases in
% two parts: G=G0+RTlnK
% where
% G0=Hf-TS0-integral(Cp)dT-T*integral(Cp/T)dT+integral(Vsolid)dP

Pbar=P*1e9; %converts GPa to pascals
TK=T+273.15; %converts celsius to kelvin

%% Integral(Cp)dT
T0=298.15;
intCpdTf=(af.*TK+0.5.*bf*TK.*TK-cf./TK+2.*df.*sqrt(TK))-(af.*T0+0.5.*bf.*T0.*T0-cf./T0+2.0.*df.*sqrt(T0));

%% Integral(Cp/T)dT
intCpoverTdTf=af.*log(TK./298.15)+bf.*(TK-298.15)-(cf./2).*(1./(TK.*TK)-1./(298.15.*298.15))-2.*df.*(1./sqrt(TK)-1./(sqrt(298.15)));
%%
RTlnf=CORK(Ca0,Ca1,Cb0,Cc0,Cc1,Cd0,Cd1,Tcf,Pcf,Pbar,TK); %calls the CORK EoS to calculate the
%volume contribution to the Gibbs free energy 

Gf=Hff+intCpdTf-TK.*(S0f+intCpoverTdTf)+RTlnf;
return


function [GH2O]=GibbsH2O(T,P,Hf_H2O,S0_H2O,a_H2O,b_H2O,c_H2O,d_H2O)
% Molar Gibbs Free Energy Calculator for pure H2O

Pbar=P*10000; %converts GPa to bar
TK=T+273.15; %converts celsius to kelvin

%Integral(Cp)dT
T0=298.15;
intCpdTf=(a_H2O.*TK+0.5.*b_H2O*TK.*TK-c_H2O./TK+2.*d_H2O.*sqrt(TK))-(a_H2O.*T0+0.5.*b_H2O.*T0.*T0-c_H2O./T0+2.0.*d_H2O.*sqrt(T0));

%Integral(Cp/T)dT
intCpoverTdTf=a_H2O.*log(TK./298.15)+b_H2O.*(TK-298.15)-(c_H2O./2).*(1./(TK.*TK)-1./(298.15.*298.15))-2.*d_H2O.*(1./sqrt(TK)-1./(sqrt(298.15)));

%volume contribution to the Gibbs free energy 
[RTlnf_H2O]=H2O_EOS(TK,Pbar);

%solve Gibbs free energy for H2O
GH2O_1=Hf_H2O+intCpdTf-TK.*(S0_H2O+intCpoverTdTf);

GH2O=GH2O_1+(RTlnf_H2O);
return


function [intVdP]=TEOS(V0,alpha,K0,dK0,d2K0,Pbar,TK,S0,n)
%relationship of parameters to bulk modulus and its derivatives at zero
%pressure (Freund & Ingalls, 1989):

aT=(1+dK0)./(1+dK0+K0.*d2K0);
bT=(dK0./K0)-(d2K0./(1+dK0));
cnum=1+dK0+K0.*d2K0;
cden=((dK0.*dK0)+dK0)-(K0.*d2K0);
cT=cnum./cden;

%% Thermal expansion terms

%Einstein Temperature approximation
theta=10636./(S0./n+6.44); 
x=theta/(TK);
x0=theta/298.15;
ex=exp(x);
ex0=exp(x0);

%Einstein thermal energy 
Eth=3.*n.*8.3144598.*theta.*(0.5+(1./(ex-1)));
Eth0=3.*n.*8.3144598.*theta.*(0.5+(1./(ex0-1)));

%Einstein heat capacity
Cv0=3.0.*n.*8.3144598.*((x0.*x0.*ex0)./((ex0-1).*(ex0-1)));

%thermal pressures
Pt=(alpha.*K0.*Eth)./(Cv0);
Pt0=((alpha.*K0.*Eth0)./(Cv0));

%thermal pressure relative to standard state
Pth=Pt-Pt0;
%% intVdP

P0=100000;
psubpth=Pbar-P0-Pth;

intVdP=(Pbar-P0).*V0.*(1-aT+(aT.*(((1-bT.*Pth).^(1-cT))-((1+bT.*(psubpth)).^(1-cT)))./(bT.*(cT-1).*(Pbar-P0))));
return


function [RTlnf]=CORK(Ca0,Ca1,Cb0,Cc0,Cc1,Cd0,Cd1,Tcf,Pcf,Pbar,TK)
% Compensated-Redlich-Kwong (CORK) Equation
%Following Holland and Powell 1991 

R=8.3144598; %J/(K*mol)

%% Equations 9

Ca=((Ca0.*(Tcf.^(2.5)))./Pcf)+((Ca1.*(TK.*Tcf.^(1.5)))./(Pcf));
Cb=(Cb0.*Tcf)./Pcf;
Cc=((Cc0.*Tcf)./(Pcf.^(1.5)))+((TK.*Cc1)./((Pcf.^(1.5))));
Cd=((Cd0.*Tcf)./(Pcf.*Pcf))+((TK.*Cd1)/(Pcf.*Pcf));

%% Fugacity equation
Pr=Pbar-10000; % relative pressure (Pa)

RTlnf=zeros(length(Ca0),1); %makes a column with the proper length of input data
for n=1:length(Ca0)
if Tcf(n)==0 
    RTlnf(n)=0;
elseif Tcf(n)>0 
    RTlnf(n)=R.*TK.*log(1e-5.*Pr)+(Cb.*Pr)+Ca./(Cb.*sqrt(TK)).*(log((R.*TK)+(Cb.*Pr))-log((R.*TK)+(2.*Cb.*Pr)))+((2/3).*Cc.*Pr.*sqrt(Pr))+((Cd./2).*Pr.*Pr);
end
end
 

function [RTlnf_H2O]=H2O_EOS(TK,Pbar)
%EOS for H2O following Pitzer & Sterner (1995)

P0=1.01325; %P in bar of the standard state 
R=83.144; %gas constant in decajoules
R_SI=0.0083143*1000; %gas constant in SI units

%coefficients
PScoeff = ...
    [0.0000000E+00	0.0000000E+00	2.4657688E+05	5.1359951E+01	0.0000000E+00	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	5.8638965E-01	-2.8646939E-03	3.1375577E-05	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	-6.2783840E+00	1.4791599E-02	3.5779579E-04	1.5432925E-08; ...
    0.0000000E+00	0.0000000E+00	0.0000000E+00	-4.2719875E-01	-1.6325155E-05	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	5.6654978E+03	-1.6580167E+01	7.6560762E-02	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	0.0000000E+00	1.0917883E-01	0.0000000E+00	0.0000000E+00; ...
    3.8878656E+12	-1.3494878E+08	3.0916564E+05	7.5591105E+00	0.0000000E+00	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	-6.5537898E+04	1.8810675E+02	0.0000000E+00	0.0000000E+00; ...
    -1.4182435E+13	1.8165390E+08	-1.9769068E+05	-2.3530318E+01	0.0000000E+00	0.0000000E+00; ...
    0.0000000E+00	0.0000000E+00	9.2093375E+04	1.2246777E+02	0.0000000E+00	0.0000000E+00];

c=zeros(10,1);
for n=1:10
    c(n)=PScoeff(n,1)*(TK^(-4))+PScoeff(n,2)*(TK^(-2))+PScoeff(n,3)*(TK^(-1))+PScoeff(n,4)+PScoeff(n,5)*TK+PScoeff(n,6)*(TK^2); %equation 4
end

c1=c(1);
c2=c(2);
c3=c(3);
c4=c(4);
c5=c(5);
c6=c(6);
c7=c(7);
c8=c(8);
c9=c(9);
c10=c(10);

%solves for V

syms V; %makes volume a symbol 
r=1/V; %density (symbol)
V0=3; %initial guess for rootsolving algorithm 

%rootsolving algorithm:
myfun=@(R,TK,Pbar,r,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10) (r+c(1)*(r^2)-(r^2)*((c3+2*c4*r+3*c5*(r^2)+4*c6*(r^3))/((c2+c3*r+c4*(r^2)+c5*(r^3)+c6*(r^4))^2))+c(7)*(r^2)*exp(-c(8)*r)+c(9)*(r^2)*exp(-c(10)*r))*R*TK-Pbar; %equation 2
fun=@(r) myfun(R,TK,Pbar,r,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10);
rho=fzero(fun,V0); %calls the rootsolving algorithm, solves for density
Vsolved=rho^(-1);

%solve equation 1 of Pitzer * Sterner (1995)
Ares=R*TK*(c1*rho+((c2+c3*rho+c4*(rho^2)+c5*(rho^3)+c6*(rho^4))^-1)-(c2^-1)-(c7/c8)*(exp(-c8*rho)-1)-(c9/c10)*(exp(-c10*rho)-1));

%RTlnf for H2O
lnf_H2O=log(rho)+(Ares/(R*TK))+((Pbar)/(rho*R*TK))+log(R*TK)-1; %natural log of fugacity
f_H2O=exp(lnf_H2O)*100000; %solve for fugacity in pascals
RTlnf_H2O=R_SI*TK*lnf_H2O; %RTlnf term for H2O 









