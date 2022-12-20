function [Na Mg Al Si P S Cl K Ca Ti V Cr Mn Fe Co Ni Cu Zn Zr Ag Cd Sn Ce As Sb Cs La Nd Pb Sr Th U Yt Sm Gd Dy Pr BSE SEI TOPO] = StructFctIn2Res(Data,handles)
% -
% XmapTools Function (version 1.X)
% Use this function only with XmapTools 1.X.
%
% This function allows to transfert Intensity data to results. 
%
% [Values] = StructFctIn2Res(Data,handles);
%
%
% Setup : 
%4>General>Gnrle-Intensity2Results>StructFctIn2Res>Na Mg Al Si P S Cl K Ca Ti V Cr Mn Fe Co Ni Cu Zn Zr Ag Cd 
%  Sn Ce As Sb Cs La Nd Pb Sr Th U Yt Sm Gd Dy Pr BSE SEI TOPO>Na Mg Al Si P S Cl K Ca Ti V Cr Mn Fe Co Ni Cu 
%  Zn Zr Ag Cd Sn Ce As Sb Cs La Nd Pb Sr Th U Yt Sm Gd Dy Pr BSE SEI TOPO>
%
%
% Created by P. Lanari (Octobre 2011) - TESTED & VERIFIED 13/12/13.



XmapWaitBar(0,handles);

  

Na = Data(:,1)';
Mg = Data(:,2)';
Al = Data(:,3)';
Si = Data(:,4)';
P = Data(:,5)';
S = Data(:,6)';
Cl = Data(:,7)';
K = Data(:,8)';
Ca = Data(:,9)';
Ti = Data(:,10)';
V = Data(:,11)';
Cr = Data(:,12)';
Mn = Data(:,13)';
Fe = Data(:,14)';
Co = Data(:,15)';
Ni = Data(:,16)';
Cu = Data(:,17)';
Zn = Data(:,18)';
Zr = Data(:,19)';
Ag = Data(:,20)';
Cd = Data(:,21)';
Sn = Data(:,22)';
Ce = Data(:,23)';
As = Data(:,24)';
Sb = Data(:,25)';
Cs = Data(:,26)';
La = Data(:,27)';
Nd = Data(:,28)';
Pb = Data(:,29)';
Sr = Data(:,30)';
Th = Data(:,31)';
U = Data(:,32)';
Yt = Data(:,33)';
Sm = Data(:,34)';
Gd = Data(:,35)';
Dy = Data(:,36)';
Pr = Data(:,37)';
BSE = Data(:,38)';
SEI = Data(:,39)';
TOPO = Data(:,40)';



XmapWaitBar(1,handles);

return










