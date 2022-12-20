function [Na2O MgO Al2O3 SiO2 P2O5 SO2 Cl2O K2O CaO TiO2 V2O5 Cr2O3 MnO FeO CoO NiO CuO ZnO ZrO2 AgO CdO SnO2 CeO2 As2O5 Sb2O3 Cs2O La2O3 Nd2O3 PbO SrO ThO2 UO2 Y2O3 Sm2O3 Gd2O3 Dy2O3 Pr2O3] = StructFctOx2Res(Data,handles)
% -
% XmapTools Function (version 1.X)
% Use this function only with XmapTools 1.X.
%
% This function allows to transfert oxide wt% composition data to results. 
%
% [Values] = StructFctOx2Res(Data,handles);
%
% Setup : 
% 4>General>Gnrle-Oxide2Results>StructFctOx2Res>Na2O MgO Al2O3 SiO2 P2O5 SO2 Cl2O K2O CaO TiO2 V2O5 
%   Cr2O3 MnO FeO CoO NiO CuO ZnO ZrO2 AgO CdO SnO2 CeO2 As2O5 Sb2O3 Cs2O La2O3 Nd2O3 PbO SrO ThO2 
%   UO2 Y2O3 Sm2O3 Gd2O3 Dy2O3 Pr2O3>Na2O MgO Al2O3 SiO2 P2O5 SO2 Cl2O K2O CaO TiO2 V2O5 Cr2O3 MnO 
%   FeO CoO NiO CuO ZnO ZrO2 AgO CdO SnO2 CeO2 As2O5 Sb2O3 Cs2O La2O3 Nd2O3 PbO SrO ThO2 UO2 Y2O3 
%   Sm2O3 Gd2O3 Dy2O3 Pr2O3>
%
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 13/12/13.
 


XmapWaitBar(0,handles);



Na2O = Data(:,1)';
MgO = Data(:,2)';
Al2O3 = Data(:,3)';
SiO2 = Data(:,4)';
P2O5 = Data(:,5)';
SO2 = Data(:,6)';
Cl2O = Data(:,7)';
K2O = Data(:,8)';
CaO = Data(:,9)';
TiO2 = Data(:,10)';
V2O5 = Data(:,11)';
Cr2O3 = Data(:,12)';
MnO = Data(:,13)';
FeO = Data(:,14)';
CoO = Data(:,15)';
NiO = Data(:,16)';
CuO = Data(:,17)';
ZnO = Data(:,18)';
ZrO2 = Data(:,19)';
AgO = Data(:,20)';
CdO = Data(:,21)';
SnO2 = Data(:,22)';
CeO2 = Data(:,23)';
As2O5 = Data(:,24)';
Sb2O3 = Data(:,25)';
Cs2O = Data(:,26)';
La2O3 = Data(:,27)';
Nd2O3 = Data(:,28)';
PbO = Data(:,29)';
SrO = Data(:,30)';
ThO2 = Data(:,31)';
UO2 = Data(:,32)';
Y2O3 = Data(:,33)';
Sm2O3 = Data(:,34)';
Gd2O3 = Data(:,35)';
Dy2O3 = Data(:,36)';
Pr2O3 = Data(:,37)';



XmapWaitBar(1,handles);
return










