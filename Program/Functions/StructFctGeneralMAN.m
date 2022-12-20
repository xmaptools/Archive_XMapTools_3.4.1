function [Z_mean] = StructFctGeneralMAN(Data,handles)
% -
% XMapTools External Function ---------------------------------------------
%
% This function calculates the Mean Atomic Number (MAN)
%
% [Values] = StructFctGenerale(Data);
%
% Data is a matrix with n lines and m columns. n is the number of pixel of
% the map, or the number of selected points. m is the oxyde weight values
% set in the setup file. 
% Order : SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O
%
% Setup : 
% 4>General>Gnrle-MeanAtomicNumber>StructFctGeneralMAN>Z_mean>SiO2 TiO2 Al2O3 FeO MnO MgO CaO Na2O K2O>
%
%Possibility for the user to either take in account the amount of H2O or
%not, by deducing it from the sum of the oxides in wt% such as 100-sum(oxide)
%
% Created by T. Bovay (July 2017) - TESTED & VERIFIED 27/07/17.
% Version with pre-loading... 

Z_mean = zeros(1,length(Data(:,1)));

% Query: H2O?
UseH2O = 0;
Choice = questdlg('Would you like to use (100 - SumOx) = H2O?','MAN','Yes','No','Yes');
switch Choice
    case 'Yes'
        UseH2O = 1;
end

XmapWaitBar(0,handles);
hCompt = 1;

% SiO2 / TIO2 / Al2O3 / FeO / Fe2O3 / MnO / MgO / CaO / Na2O / K2O / H2O
Nb_Cat = [1,1,2,1,2,1,1,1,2,2,2]; % Nb cations
Nb_O= [2,2,3,1,3,1,1,1,1,1,1]; % Nb Oxygenes
% Z number Si Ti Al Fe2 Fe3 Mn Mg Ca Na K H
Z_Cat = [14, 22, 13, 26, 26, 25, 12, 20, 11, 19, 1];
%Z number O
Z_O = 8*ones(1,length(Nb_Cat));
%molar mass Si, Ti, Al, Fe, Fe, Mn, Mg, Ca, Na, K, H
Mm_Cat = [28.0855, 47.867, 26.981539, 55.845, 55.845, 54.938045, 24.305, 40.078, 22.989769, 39.0983, 1.00794];
%molar mass Oxygen
Mm_O = 15.999*ones(1,length(Nb_O));

Mm_Ox = Mm_Cat.*Nb_Cat+Mm_O.*Nb_O;

%Calculation bar

for i = 1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    
    %Import data in wt%
    Analyse = Data(i,:);
    
    %Take in acount H2O or not
    if UseH2O
       if sum(Data(i,:)) < 100
        Analyse(end+1) = 100-sum(Data(i,:));
       else
           Analyse(end+1) = 0;
       end
       
     else
       Analyse(end+1) = 0;
     end
    
    %Check if there is SiO2 if no then relly slow
    if Analyse(1) > 0.0001 % detection...
        OnCal = 1;
    else
        OnCal = 0;
    end

    TravMat = []; % initialization required

    if OnCal
        TravMat(1:4) = Analyse(1:4); % Si02 TiO2 Al2O3 FeO
        TravMat(5) = 0; % Fe2O3
        TravMat(6:11) = Analyse(5:10); % MnO MgO CaO Na2O K2O H2O
        
        %atomic number per oxide
        Z_Ox = TravMat.*(Z_Cat.*Mm_Cat.*Nb_Cat./Mm_Ox+Z_O.*Mm_O.*Nb_O./Mm_Ox);
        %Mean Atomic Number
        Z_mean(i)=sum(Z_Ox)/sum(TravMat);

    end
end

XmapWaitBar(1,handles);

return

