function [OnTrace] = DensityPlot(X,Y,patterns,grids,scans,Lims)
% Fonction pour tracer des maps de densit?
% Cette version 2 (12/10) ne tient pas compte de la valeur scans pour plus
% scanner, mais l'utilise comme tirage MC

MedFitOpt = scans;

Xmin = Lims(1); 
Xmax = Lims(2);
Ymin = Lims(3);
Ymax = Lims(4);

% Data
E1 = X;
E2 = Y;

clear X Y % temporaire, vite fait d'un vieux script

NbCase = grids;
%NbCalc = scans;

Xpas = (Xmax-Xmin)/(NbCase-1);
Ypas = (Ymax-Ymin)/(NbCase-1);
% Xdecal = (Xmax-Xmin)/(NbCalc-1);
% Ydecal = (Ymax-Ymin)/(NbCalc-1);

X = Xmin:Xpas:Xmax;
Y = Ymin:Ypas:Ymax;

LeRes = NaN.*zeros(NbCase);

h = waitbar(0,'Please wait...');

for iX = 1:NbCase
    % Waitbar
    waitbar(iX/NbCase,h)
    % Define X
    XlimInf=X(iX)-Xpas*0.5;
    XlimSup=X(iX)+Xpas*0.5;
    % Verif si on deborde, seulement deux cas possibles ici
    if XlimInf < Xmin
        XlimInf = Xmin;
    end
    if XlimSup > Xmax
        XlimSup = Xmax;
    end
    
    for iY = 1:NbCase
        % Define Y
        YlimInf=Y(iY)-Ypas*0.5;
        YlimSup=Y(iY)+Ypas*0.5;
        % Verif
        if YlimInf < Ymin 
            YlimInf = Ymin;
        end
        if YlimSup > Ymax
            YlimSup = Ymax;
        end

        % Enfin, on compte
        LeRes(iY,iX) = length(find(E1(:) > XlimInf & E1(:) < XlimSup & E2(:) > YlimInf & E2(:) < YlimSup));%lin/col
        
    end
end
close(h)

if MedFitOpt > 1
    OnTrace = LeRes;   % instead    medfilt2(LeRes,[MedFitOpt,MedFitOpt]);
    Lincrem = max(max(OnTrace))/64;
    for i=1:length(OnTrace(:))
        if OnTrace(i) > 0
            OnTrace(i) = OnTrace(i)+Lincrem;
        else
            OnTrace(i) = Lincrem;
        end
    end
    imagesc(X,Y,OnTrace)
    set(gca,'YDir','normal')
    %ColorScale = load('ColorScale.txt','-ASCII');
    %colormap([0,0,0.5625;1,1,1;ColorScale])
    colormap(jet(64))
    caxis([min(min(LeRes)) max(max(LeRes))])
    %caxis([min(min(medfilt2(LeRes,[MedFitOpt,MedFitOpt]))) max(max(medfilt2(LeRes,[MedFitOpt,MedFitOpt])))])
    hold on
    [C,h] = contour(X,Y,LeRes,patterns,'k','linewidth',1);
    %[C,h] = contour(X,Y,medfilt2(LeRes,[MedFitOpt,MedFitOpt]),patterns,'k','linewidth',1);
else
    OnTrace = LeRes;
    Lincrem = max(max(OnTrace))/64;
    for i=1:length(OnTrace(:))
        if OnTrace(i) > 0
            OnTrace(i) = OnTrace(i)+Lincrem;
        else
            OnTrace(i) = Lincrem;
        end
    end
    imagesc(X,Y,OnTrace)
    set(gca,'YDir','normal')
    %ColorScale = load('ColorScale.txt','-ASCII');
    %colormap([0,0,0.5625;1,1,1;ColorScale])
    %colormap(jet(64))
    colormap(jet(64))
    caxis([min(min(LeRes)) max(max(LeRes))])
    hold on
    [C,h] = contour(X,Y,LeRes,patterns,'k') % minimum
    %[C,h] = contour(X,Y,medfilt2(LeRes,[2,2]),patterns,'k') % minimum
end



% contourf(X,Y,LeRes,patterns)
% 
% ColorScale = load('ColorScale.txt','-ASCII');
% colormap(ColorScale)
% 
% keyboard
% 
% contourf(X,Y,LeRes,patterns)
return