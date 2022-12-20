function [Si, Al, Mg, Fe2, Fe3, Mn, Ca, Y, Th, Ti, La, Ce, Pr, Nd,Sm, Gd, Dy, U, Pb, Na, Sr, Sum_REE, Sum_M, Sum_A,Sum_REE_Th, Sum_A_M] = StructFctAllanite(Data,handles)
% -
% XMapTools External Function: Structural formula of REE-rich epidote (allanite) 
%
%   [outputs] = function_Name(Data,handles);
%
%   1>Epidote>Allanite-StructForm>StructFctAllanite>Si Al Mg Fe2 Fe3 Mn Ca 
%     Yt Th Ti La Ce Pr Nd Sm Gd Dy U Pb Na Sr Sum_REE Sum_M Sum_A Sum_REE_Th 
%     Sum_A_M>SiO2 Al2O3 MgO FeO MnO CaO Y2O3 ThO2 TiO2 La2O3 Ce2O3 Pr2O3 
%     Nd2O3 Sm2O3 Gd2O3 Dy2O3 UO2 PbO Na2O SrO>
%
%   12.5 Oxygens
%
% 
% Created by M. Burn (November 2013) - Last update 11/12/13.
% Find out more at http://www.xmaptools.com


Si = zeros(1,length(Data(:,1)));
Al = zeros(1,length(Data(:,1)));
Mg = zeros(1,length(Data(:,1)));
Fe2 = zeros(1,length(Data(:,1)));
Fe3 =zeros(1,length(Data(:,1)));
Mn = zeros(1,length(Data(:,1)));
Ca = zeros(1,length(Data(:,1)));
Y = zeros(1,length(Data(:,1)));
Th = zeros(1,length(Data(:,1)));
Ti = zeros(1,length(Data(:,1)));

La = zeros(1,length(Data(:,1)));
Ce = zeros(1,length(Data(:,1)));
Pr = zeros(1,length(Data(:,1)));
Nd = zeros(1,length(Data(:,1)));
Sm = zeros(1,length(Data(:,1)));
Gd = zeros(1,length(Data(:,1)));
Dy = zeros(1,length(Data(:,1)));

U = zeros(1,length(Data(:,1)));
Pb = zeros(1,length(Data(:,1)));

Na = zeros(1,length(Data(:,1)));
Sr = zeros(1,length(Data(:,1)));

Sum_REE = zeros(1,length(Data(:,1)));
Sum_M = zeros(1,length(Data(:,1)));
Sum_A = zeros(1,length(Data(:,1)));
Sum_REE_Th = zeros(1,length(Data(:,1)));
Sum_A_M = zeros(1,length(Data(:,1)));


XmapWaitBar(0,handles);
hCompt = 1;
NbOx = 12.5; % Oxygens, DO NOT CHANGE !!!


% SiO2  / Al2O3 / MgO / FeO / Fe2O3 / MnO / CaO / Y2O3 / ThO2 / TiO2 / 
% La2O3 / Ce2O3 / Pr2O3 / Nd2O3 / Sm2O3 / Gd2O3 / Dy2O3 / UO2 / PbO / 
% Na2O / SrO
Num = [1,2,1,1,2,1,1,2,1,1,2,2,2,2,2,2,2,1,1,2,1]; % Nombre de cations.
NumO= [2,3,1,1,3,1,1,3,2,2,3,3,3,3,3,3,3,2,1,1,1]; % Nombre d'Oxygenes.
Cst = [60.0843, 101.96128, 40.3044, 71.8464, 159.6922, 70.9374,...
    56.0774, 225.81, 264.0369, 79.8788, 325.8092, 328.2382, 329.8136,...
    336.4782, 348.7182, 362.4982, 372.859, 270.0278, 223.1994, 61.9789,...
    103.6194]; % atomic mass


for i = 1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analyse = Data(i,:);
    
    if Analyse(1) > 0.0001 % detection...
        OnCal = 1;
        Map(i) =1;
    else
        OnCal = 0;
        Map(i) =0;
    end

    TravMat = []; % initialization required... 

    if OnCal
        
        Fe2O3 = 0;
        FeO = Analyse(4);
        
        TravMat(1:4) = Analyse(1:4); % Si02 Al2O3 MgO FeO
        TravMat(5) = Fe2O3; % Fe2O3
        TravMat(6:21) = Analyse(5:20); % MnO CaO Y2O3 ThO2 TiO2 La2O3 Ce2O3
                                      % Pr2O3 Nd2O3 Sm2O3 Gd2O3 Dy2O3 UO2 
                                      % PbO Na2O SrO
        
        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si_ = lesResults(1);
        Al_ = lesResults(2);
        Mg_ = lesResults(3); 
        Fe2_ = lesResults(4);
        Fe3_ = lesResults(5);
        Mn_ = lesResults(6);
        Ca_ = lesResults(7);
        Y_ = lesResults(8);
        Th_ = lesResults(9);
        Ti_ = lesResults(10);
        La_ = lesResults(11);
        Ce_ = lesResults(12);
        Pr_ = lesResults(13);
        Nd_ = lesResults(14);
        Sm_ = lesResults(15);
        Gd_ = lesResults(16);
        Dy_ = lesResults(17);
        U_ = lesResults(18);
        Pb_ = lesResults(19);
        Na_ = lesResults(20);
        Sr_ = lesResults(21);
        
            
        A = (Y_ + La_ + Ce_ + Pr_ + Nd_ + Sm_ + Gd_ + Dy_)*3 + (Th_ + U_) * 4 +...
            Na_ *1 + (Mg_ + Mn_ + Ca_ + Pb_ + Sr_)*2 ...
        - 2 * sum(lesResults([3 6:9 11:20]));
        
        if (A > 0) && (A < (Fe2_ + Fe3_))   % allanite (Fe2+ + Fe3+)
            Fe2_ = A;
            Fe3_ = sum(lesResults([4 5]))-A;
            a = Fe3_/(Fe2_+Fe3_);
            
            FeG =Analyse(4) * 55.847 / 71.8464 + Analyse(5)*2*55.9332/159.6922;
            Fe2O3 = a * FeG * 159.6922 / 55.933/2;
            FeO = (1-a) *FeG * 71.8464/55.847;
            
        elseif A < 0   % epidote (Fe3+)
            
            Fe2_ = 0;
            Fe3_ = sum(lesResults([4 5]));
            a = Fe3_/(Fe2_+Fe3_);
            
            FeG =Analyse(4) * 55.847 / 71.8464 + Analyse(5)*2*55.9332/159.6922;
            Fe2O3 = a * FeG * 159.6922 / 55.933/2;
            FeO = (1-a) *FeG * 71.8464/55.847;
            
        else
            Fe2O3 = 0;  % bad analysis ?
        end
    
        
        TravMat(1:3) = Analyse(1:3); % Si02 Al2O3 MgO 
        TravMat(4) = FeO; % FeO
        TravMat(5) = Fe2O3; % Fe2O3
        TravMat(6:21) = Analyse(5:20); % MnO CaO Y2O3 ThO2 TiO2 La2O3 Ce2O3
                                      % Pr2O3 Nd2O3 Sm2O3 Gd2O3 Dy2O3 UO2 
                                      % PbO Na2O SrO
        
        AtomicPer = TravMat./Cst.*Num;

        TheSum = sum((AtomicPer .* NumO) ./ Num);
        RefOx = TheSum/NbOx;

        lesResults = AtomicPer / RefOx;

        Si_ = lesResults(1);
        Al_ = lesResults(2);
        Mg_ = lesResults(3); 
        Fe2_ = lesResults(4);
        Fe3_ = lesResults(5);
        Mn_ = lesResults(6);
        Ca_ = lesResults(7);
        Y_ = lesResults(8);
        Th_ = lesResults(9);
        Ti_ = lesResults(10);
        La_ = lesResults(11);
        Ce_ = lesResults(12);
        Pr_ = lesResults(13);
        Nd_ = lesResults(14);
        Sm_ = lesResults(15);
        Gd_ = lesResults(16);
        Dy_ = lesResults(17);
        U_ = lesResults(18);
        Pb_ = lesResults(19);
        Na_ = lesResults(20);
        Sr_ = lesResults(21);
        
        Si(i) = Si_;
        Al (i) = Al_;
        Mg (i) = Mg_;
        Fe2 (i) = Fe2_;
        Fe3 (i) = Fe3_;
        Mn (i) = Mn_;
        Ca (i) = Ca_;
        Y (i) = Y_;
        Th (i) = Th_;
        Ti (i) = Ti_;
        La (i) = La_;
        Ce (i) = Ce_;
        Pr (i) = Pr_;
        Nd (i) = Nd_;
        Sm (i) = Sm_;
        Gd (i) = Gd_;
        Dy (i) = Dy_;
        U (i) = U_;
        Pb(i) = Pb_;
        Na (i) = Na_;
        Sr (i) = Sr_;
        

    
        %Structural Formulae (M. Burn - 2013)
        
        Sum_REE (i) = La_ + Ce_ + Pr_ + Nd_ + Sm_ + Gd_ + Dy_;
        Sum_REE_Th (i) = Sum_REE (i) + Th_; 
              
        if Si_ < 3
            Sum_M (i) = Al_-(3-Si_)  + Ti_ + Fe2_ + Fe3_;
            
        else
             Sum_M (i) = Al_  + Ti_ + Fe2_ + Fe3_;
        end
            
        Sum_A (i) = Mn_ + Ca_ + Y_ + Th_ + Ti_ + La_ + Ce_ + Pr_ + Nd_...
            + Sm_ + Gd_ + Dy_ + U_ + Pb_ + Na_ + Sr_;     
        
        Sum_A_M(i) = Sum_A(i)+Sum_M(i);
    end
end



XmapWaitBar(1,handles);


return




