function [] = DensityTriPlot(Data,nameA,nameB,nameC,patterns,grids,scans)
% Fonction pour tracer des maps de densités sur des diagrammes
% Triangulaires
% version 01/2011

var=[];

a=nameA; b=nameB; c=nameC;

Xa = Data(:,1)./(Data(:,1)+Data(:,2)+Data(:,3));
Xb = Data(:,2)./(Data(:,1)+Data(:,2)+Data(:,3));
Xc = Data(:,3)./(Data(:,1)+Data(:,2)+Data(:,3));


for i=1:length(Xa)
    if Xa(i)+Xb(i)+Xc(i) ~= 1 || Xa(i) < 0 ||  Xb(i) < 0 ||  Xc(i) < 0
        Xa(i) = NaN;
        Xb(i) = NaN;
        Xc(i) = NaN;
    end
end

% Go Go Go
MedFitOpt = scans;

E1 = Xc+(1-(Xc+Xa))./2;
E2 = Xb;

clear X Y % temporaire, vite fait d'un vieux script

NbCase = grids;

Xmin = 0; Xmax = 1;
Ymin = 0; Ymax = 1;

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
    imagesc(X,Y,LeRes), hold on
    %imagesc(X,Y,medfilt2(LeRes,[MedFitOpt,MedFitOpt])), hold on
    set(gca,'YDir','normal')
    %ColorScale = load('ColorScale.txt','-ASCII');
    %colormap(ColorScale)
    colormap([1,1,1;jet(64)])
    caxis([min(min(LeRes)) max(max(LeRes))])
    %caxis([min(min(medfilt2(LeRes,[MedFitOpt,MedFitOpt]))) max(max(medfilt2(LeRes,[MedFitOpt,MedFitOpt])))])
    hold on
    [C,h] = contour(X,Y,LeRes,patterns,'k','linewidth',1);
    %[C,h] = contour(X,Y,medfilt2(LeRes,[MedFitOpt*2,MedFitOpt*2]),patterns,'k','linewidth',1);
else
    imagesc(X,Y,LeRes), hold on
    set(gca,'YDir','normal')
    %ColorScale = load('ColorScale.txt','-ASCII');
    %colormap(ColorScale)
    colormap([1,1,1;jet(64)])
    caxis([min(min(LeRes)) max(max(LeRes))])
    hold on
    %[C,h] = contour(X,Y,medfilt2(LeRes,[4,4]),patterns,'k')
end

% affichage des donnÃ©es :
plot([0,0.5,1,0],[0,1,0,0],'-k')
axis([-0.2 1.2 -0.2 1.2])

% trace la grille
% plot([0.4,0.8],[0.8,0],'--k')
% plot([0.3,0.6],[0.6,0],'--k')
% plot([0.2,0.4],[0.4,0],'--k')
% plot([0.1,0.2],[0.2,0],'--k')
% 
% plot([0.8,0.9],[0,0.2],'--k')
% plot([0.6,0.8],[0,0.4],'--k')
% plot([0.4,0.7],[0,0.6],'--k')
% plot([0.2,0.6],[0,0.8],'--k')
% 
% plot([0.4,0.6],[0.8,0.8],'--k')
% plot([0.3,0.7],[0.6,0.6],'--k')
% plot([0.2,0.8],[0.4,0.4],'--k')
% plot([0.1,0.9],[0.2,0.2],'--k')

text(0-(length(char(a))/2)*0.018,-0.05,char(a))
text(0.5-(length(char(b))/2)*0.018,1.05,char(b))
text(1-(length(char(c))/2)*0.018,-0.05,char(c))

hold off

return