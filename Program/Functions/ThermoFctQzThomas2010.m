function [T,Ti_ppm,aTiO2_Qtz] = ThermoFctQzThomas2010(Data,handles)
% -
% XMapTools external function for thermobarometry
%
% This function calculates quartz formation temperature using Ti-in-Qz 
% calibration of Thomas et al. 2010.
%
% [outputs] = function_Name(Data,handles);
% 
% 2>Quartz>Ti-in-Qz Thomas et al. (2010)>ThermoFctQzThomas2010>T Ti_ppm XQzTiO2>SiO2 TiO2 TiO2_Cl>
%
% This function works either with the TiO2 map or a calibrated CL map
% (CL_Ti -> TiO2_Cl)
%
%
% Created by P. Lanari & Regiane Andrade Fumes (July 2019) - CHECKED 09.07.19


T = zeros(1,length(Data(:,1)));
Ti_ppm = zeros(1,length(Data(:,1)));
aTiO2 = zeros(1,length(Data(:,1)));

% P input
Input = inputdlg({'Pressure (kbar)','aTiO2'},'Input',1,{num2str(15),num2str(1)});
P = str2num(Input{1});
aTiO2 = str2num(Input{2});

XmapWaitBar(0,handles);
hCompt = 1;

for i=1:length(Data(:,1)) % one by one
    
    hCompt = hCompt+1;
    if hCompt == 1000; % if < 150, the function is very slow.
        XmapWaitBar(i/length(Data(:,1)),handles);
        hCompt = 1;
    end
    
    Analysis = Data(i,:);

    
    if Analysis(1) > 0.001
        
        hCompt = hCompt+1;
        if hCompt == 1000; % if < 150, the function is very slow.
            XmapWaitBar(i/length(Data(:,1)),handles);
            hCompt = 1;
        end
        
        
        SiO2 = Analysis(1);
        if Analysis(2) > 0
            TiO2 = Analysis(2);     % TiO2
        else
            TiO2 = Analysis(3);     % TiO2_Cl
        end
        
        Ti_ppm(i) = TiO2 * 5995.1;
        
        aTiO2_Qtz(i) =(Ti_ppm(i)/(10000*0.599*79.87))/((Ti_ppm(i)/(10000*0.599*79.87))+(100-(Ti_ppm(i)/(10000*0.599*79.87)))*1/60.09);
        
        % from Thomas et al 2010 (TitaniQ)
        T(i) = (60952+1741*P)/(1.52-(8.3145*log(aTiO2_Qtz(i)))+(8.3145*log(aTiO2)))-273.15;

    end
   
end

XmapWaitBar(1,handles);
return






