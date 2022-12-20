function PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,Scaling);
% 
% Fonction to calculate the position of any GUI from the actual position of
% XMapTools' main window. 
%
% Pierre Lanari 15.07.17
%

ScalingX = Scaling(1);
ScalingY = Scaling(2);

PositionGui = zeros(1,4);

PositionGui(3) = PositionXMapTools(3)*ScalingX;
PositionGui(4) = PositionXMapTools(4)*ScalingY;

PositionGui(1) = PositionXMapTools(1)+0.5*(PositionXMapTools(3)-PositionGui(3));
PositionGui(2) = PositionXMapTools(2)+0.5*(PositionXMapTools(4)-PositionGui(4));

return