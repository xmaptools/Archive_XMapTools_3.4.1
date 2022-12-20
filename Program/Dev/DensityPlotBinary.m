function [OnTrace] = DensityPlot(E1,E2,patterns,MapSize,Lims,mode)
% New function to plot density map

Xmin = Lims(1); 
Xmax = Lims(2);
Ymin = Lims(3);
Ymax = Lims(4);


Xstep = (Xmax-Xmin)/(MapSize-1);
Ystep = (Ymax-Ymin)/(MapSize-1);
% Xdecal = (Xmax-Xmin)/(NbCalc-1);
% Ydecal = (Ymax-Ymin)/(NbCalc-1);

X = Xmin:Xstep:Xmax;
Y = Ymin:Ystep:Ymax;

LeRes = NaN.*zeros(MapSize);

% tic 
% x = E1;
% y = E2;
% 
% width = MapSize;
% height = MapSize;
% 
% limits(1) = min(x);
% limits(2) = max(x);
% limits(3) = min(y);
% limits(4) = max(y);
%     
% deltax = (limits(2) - limits(1)) / width;
% deltay = (limits(4) - limits(3)) / height;
% if 0
%     fudge = sqrt(deltax^2 + deltay^2);
% else
%     fudge = 0;
% end
% dmap = zeros(height, width);
% for ii = 0: height - 1
%     yi = limits(3) + ii * deltay + deltay/2;
%     for jj = 0 : width - 1
%         xi = limits(1) + jj * deltax + deltax/2;
%         dd = 0;
%         for kk = 1: length(x)
%             dist2 = (x(kk) - xi)^2 + (y(kk) - yi)^2;
%             dd = dd + 1 / ( dist2 + fudge);
%         end
%         dmap(ii+1,jj+1) = dd;
%     end
% end
% toc


tic
h = waitbar(0,'Please wait...');
ComptWaitBar = 0;

for iX = 1:MapSize
    % Waitbar
    ComptWaitBar = ComptWaitBar+1;
    if ComptWaitBar > MapSize/20
        ComptWaitBar = 0; 
        waitbar(iX/MapSize,h)
    end
    % Define X
    XlimInf=X(iX)-Xstep*0.5;
    XlimSup=X(iX)+Xstep*0.5;
    % Verif si on deborde, seulement deux cas possibles ici
    if XlimInf < Xmin
        XlimInf = Xmin;
    end
    if XlimSup > Xmax
        XlimSup = Xmax;
    end
    
    for iY = 1:MapSize
        % Define Y
        YlimInf=Y(iY)-Ystep*0.5;
        YlimSup=Y(iY)+Ystep*0.5;
        % Verif
        if YlimInf < Ymin 
            YlimInf = Ymin;
        end
        if YlimSup > Ymax
            YlimSup = Ymax;
        end

        % Enfin, on compte
        LeRes(iY,iX) = length(find(E1(:) >= XlimInf & E1(:) < XlimSup & E2(:) >= YlimInf & E2(:) < YlimSup));%lin/col
        
    end
end
close(h);
toc

OnTrace = LeRes; 

switch mode
    case 'log'
        
        imagesc(X,Y,log(OnTrace))
        
        Cmin = min(OnTrace(find(OnTrace)))+1; 
        Cmax = max(OnTrace(find(OnTrace)))+1;
        
        caxis([min(log(OnTrace(find(OnTrace)))),max(log(OnTrace(:)))])
        set(gca,'YDir','normal')
        
        tk = logspace(log(Cmin),log(Cmax),5);
        
        originalSize1 = get(gca, 'Position');
        hc = colorbar('vertical');
        colormap(jet(64))
        set(gca,'Position',originalSize1);
        
        format longG
        Labels = get(hc,'YTickLabel')

        for i = 1:length(Labels)
            LabelsOk{i} = num2str(round(exp(str2num(Labels(i,:)))),'%.0f');
        end
        
        LabelsOk 
        
        set(hc,'YTickLabel',LabelsOk);
        
        format short
        %set(hc,'YScale','log');

        
end


return


    Lincrem = max(max(OnTrace))/64;
    for i=1:length(OnTrace(:))
        if OnTrace(i) > 0
            OnTrace(i) = OnTrace(i)+Lincrem;
        else
            OnTrace(i) = Lincrem;
        end
    end
    imagesc(X,Y,OnTrace)
    %caxis([min(log(OnTrace(:))),max(log(OnTrace(:)))])
    %tk = logspace(0,1,10);
    %cmap = jet(9);
    
    %keyboard 
    set(gca,'YDir','normal')
    %ColorScale = load('ColorScale.txt','-ASCII');
    %colormap([0,0,0.5625;1,1,1;ColorScale])
    colormap(jet(64))
    caxis([min(min(LeRes)) max(max(LeRes))])
    %caxis([min(min(medfilt2(LeRes,[MedFitOpt,MedFitOpt]))) max(max(medfilt2(LeRes,[MedFitOpt,MedFitOpt])))])
    hold on
    [C,h] = contour(X,Y,LeRes,patterns,'k','linewidth',1);
    %[C,h] = contour(X,Y,medfilt2(LeRes,[MedFitOpt,MedFitOpt]),patterns,'k','linewidth',1);

    
    return
    
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




% contourf(X,Y,LeRes,patterns)
% 
% ColorScale = load('ColorScale.txt','-ASCII');
% colormap(ColorScale)
% 
% keyboard
% 
% contourf(X,Y,LeRes,patterns)
return