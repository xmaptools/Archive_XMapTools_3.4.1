function varargout = VER_XMTModBinary_804(varargin)
% VER_XMTMODBINARY_804 M-file for VER_XMTModBinary_804.fig
%      VER_XMTMODBINARY_804, by itself, creates a new VER_XMTMODBINARY_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODBINARY_804 returns the handle to a new VER_XMTMODBINARY_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODBINARY_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODBINARY_804.M with the given input arguments.
%
%      VER_XMTMODBINARY_804('Property','Value',...) creates a new VER_XMTMODBINARY_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModBinary_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModBinary_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModBinary_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:33:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModBinary_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModBinary_804_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



% --- Executes just before VER_XMTModBinary_804 is made visible.
function VER_XMTModBinary_804_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.axesCarto,'Visible','off');
set(handles.axes2,'Visible','off');

set(handles.CleanA1,'Visible','off');

handles.colorbar = 1; % do not clean the colorbar


LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']); axis image;
image(img);
set(gca,'visible','off');

img2 = imread([LocBase4Logo,'/Dev/logo/logo_xmap_final_white.png']);
handles.LogoXMapToolsWhite = img2;

% - - - Time for Density - - - 
set(handles.DPText1,'String','5');
set(handles.DPText2,'String','300');
%set(handles.DPText3,'String','3');

GridSize = str2num(get(handles.DPText2,'String'));
%TimeCalc = 0.086 * GridSize - 0.99;
%set(handles.ComputingTime,'String',[char(num2str(round(TimeCalc))),' s']);


if length(varargin) < 3 || length(varargin)-3 ~= length(varargin{end-2})
    disp('Error')
    handles.output = 0;
    guidata(hObject, handles);
    return
end

% - - - MaskFile (new 2.6.1) - - -
MaskFile(1).Name = '*** Maskfile Menu ***';
MaskFile(1).InitialCentroids = [];
MaskFile(1).Classification = [];
MaskFile(1).Binary = [];
MaskFile(1).Lims = [];
MaskFile(1).Method = [];

set(handles.MaskFileMenu,'String',{MaskFile(1).Name});
set(handles.PlotOriginal,'Enable','Off');
set(handles.PlotMap,'Enable','Off');
handles.MaskFile = MaskFile;

% - - - Data organisation - - -
for i=1:length(varargin)-3
    Data(i).values = varargin{i}(:);
    Data(i).label = varargin{end-2}(i);
    Labels(i) = Data(i).label;
    Data(i).reshape = varargin{end-1};
end

PositionXMapTools = varargin{end};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.95]);

set(gcf,'Position',PositionGui);

% - - - Variable save - - -
handles.Data = Data;
guidata(hObject, handles);


% - - - Settings - - -
set(handles.PPSerieX,'String',Labels);
set(handles.PPSerieY,'String',Labels);


% - - - Plot - - -
OnPlot(1) = 1;
OnPlot(2) = 2;

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;


% Update Min Max
MinMaxLimits_Callback(x ,y, hObject, eventdata, handles)

% Update Graph
XYPlot_Callback(OnPlot, hObject, eventdata, handles)


% Choose default command line output for VER_XMTModBinary_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModBinary_804_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;
return



% #########################################################################
%     G E N E R A L   F U N C T I O N S
% #########################################################################

% *** MAIN PLOT FUNCTION
function XYPlot_Callback(OnPlot, hObject, eventdata, handles)
% Cette fonction permet de faire tous les plots 2D
Data = handles.Data;

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

MinX = str2num(get(handles.Xmin,'String'));
MaxX = str2num(get(handles.Xmax,'String'));
MinY = str2num(get(handles.Ymin,'String'));
MaxY = str2num(get(handles.Ymax,'String'));


% - - - X vs Y - - -
axes(handles.axes1);
hold off

% If a mask is active
if get(handles.MaskFileMenu,'Value') > 1
    
    MaskFile = handles.MaskFile;
    SelectedMaskFile = get(handles.MaskFileMenu,'Value');
    
    % Update a few display things
    set(handles.PlotMap,'Enable','On');
    set(handles.KmeansMethods,'Value',MaskFile(SelectedMaskFile).Method);
    
    
    if ~isequal(MaskFile(SelectedMaskFile).Binary(1),OnPlot(1)) || ~isequal(MaskFile(SelectedMaskFile).Binary(2),OnPlot(2))
        set(handles.PlotOriginal,'Enable','On');
    else
        set(handles.PlotOriginal,'Enable','Off');
    end
    
    Classification = MaskFile(SelectedMaskFile).Classification;
    NbMasks = max(Classification);
    
    TheColors = [0,0,0;hsv(NbMasks)];
    
    
    for i = 1:NbMasks
        Indx = find(Classification == i);
        plot(x(Indx),y(Indx),'.','markersize',1,'MarkerFaceColor',TheColors(i+1,:),'MarkerEdgeColor',TheColors(i+1,:));
        hold on
    end
    
    % Group proportions
    set(handles.PanelKM,'Visible','on');
    
    NbPx = zeros(NbMasks,1);
    for i = 1:NbMasks
        NbPx(i) = length(find(Classification == i));
    end
    NbTot = numel(Classification);
    NbSel = sum(NbPx);
    NbRest = NbTot-NbSel;
    
    Chaine = 'Group proportions: ';
    for i=1:length(NbPx)
        Chaine = [Chaine,'Grp ',char(num2str(i)),': ',char(num2str(NbPx(i)/NbTot*100)),'% ; '];
    end
    Chaine = [Chaine,'NaM: ',char(num2str(NbRest/NbTot*100)),'%'];
    
    set(handles.AffPropKM,'String',Chaine);
  
    % Should we display the map?
    PlotMap = get(handles.PlotMap,'Value');
    
    if isequal(PlotMap,1)
        
        LeMask = zeros(Data(OnPlot(1)).reshape);
        SelectedPx = ones(Data(OnPlot(1)).reshape);
        
        GrName{1} = 'Unselected';
        for i = 1:NbMasks
            Indx = find(Classification == i);
            LeMask(Indx) = i*ones(size(Indx));
            GrName{i+1} = ['Grp-',num2str(i)]; 
        end
        
        axes(handles.axesCarto)
        imagesc(LeMask)
        axis image,
        colormap(TheColors)%[0,0,0;hsv(length(XXmin))])
        
        
        if size(LeMask,2) > size(LeMask,1)
            hcb = colorbar('XTickLabel',GrName); caxis([0 NbMasks+1]);
            set(hcb,'Location','SouthOutside');
            set(hcb,'XTickMode','manual','XTick',[0.5:1:NbMasks+0.5]);
        else
            hcb = colorbar('YTickLabel',GrName); caxis([0 NbMasks+1]);
            set(hcb,'YTickMode','manual','YTick',[0.5:1:NbMasks+0.5]);
        end
        
        set(gca,'XTick',[],'YTick',[])
        handles.colorbar = hcb;
        set(hcb,'FontName','Times New Roman');
        
        % To come back to the other plot
        axes(handles.axes1);
        %keyboard
    else
        
        axes(handles.axesCarto)
        cla,
        set(handles.axesCarto,'Visible','off');
        colorbar('off');
        
    end
    
    
else
    set(handles.PanelKM,'Visible','off');
    
    set(handles.PlotOriginal,'Enable','Off');
    set(handles.PlotMap,'Enable','Off');
    
    %dscatter(x,y,'MSIZE',1); colorbar
    plot(x,y,'.b','markersize',1);
end

xlabel(Data(OnPlot(1)).label);
ylabel(Data(OnPlot(2)).label);

if MaxX > MinX & MaxY > MinY
    axis([MinX MaxX MinY MaxY]);
elseif MaxX+1 > MinX-1 & MaxY+1 > MinY-1
    axis([MinX-1 MaxX+1 MinY-1 MaxY+1]);
else
    axis auto
end

CheckForLog(handles);

% - - - Histograms - - - 
axes(handles.histX)
hist(x(find(x > MinX & x < MaxX)),str2num(get(handles.NbXbars,'String')))
title(char(Data(OnPlot(1)).label));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','b','EdgeColor','k');

axes(handles.histY)
hist(y(find(y > MinY & y < MaxY)),str2num(get(handles.NbYbars,'String')))
title(char(Data(OnPlot(2)).label));
h = findobj(gca,'Type','patch');
set(h,'FaceColor','b','EdgeColor','k'); 
        

set(handles.PPSerieX,'Value',OnPlot(1));
set(handles.PPSerieY,'Value',OnPlot(2));

set(handles.axes1,'FontName','Times New Roman','FontSize',10);
set(handles.histX,'FontName','Times New Roman','FontSize',9);
set(handles.histY,'FontName','Times New Roman','FontSize',9);

axes(handles.axes2)
if MaxX > MinX & MaxY > MinY
    axis([MinX MaxX MinY MaxY]);
elseif MaxX+1 > MinX-1 & MaxY+1 > MinY-1
    axis([MinX-1 MaxX+1 MinY-1 MaxY+1]);
else
    axis auto
end

return


% Set Limits
function MinMaxLimits_Callback(x ,y, hObject, eventdata, handles)

MinX = min(x(find(x(:) > 0)));
MaxX = max(x(find(x(:) > 0)));

if ~length(MinX)
    MinX = 0;
end
if ~length(MaxX)
    MaxX = 0;
end

MinY = min(y(find(y(:) > 0)));
MaxY = max(y(find(y(:) > 0)));

if ~length(MinY)
    MinY = 0;
end
if ~length(MaxY)
    MaxY = 0;
end

set(handles.Xmin,'String',num2str(MinX));
set(handles.Xmax,'String',num2str(MaxX));
set(handles.Ymin,'String',num2str(MinY));
set(handles.Ymax,'String',num2str(MaxY));

return


% Detect Autolvl
function AutoLvl_Callback(LaValTri, hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;


TrieeX = sort(x(:));
TrieeY = sort(y(:));

TrieeX = TrieeX(find(TrieeX > 0));
TrieeY = TrieeY(find(TrieeY > 0));

ValX = round(length(TrieeX) * LaValTri);
ValY = round(length(TrieeY) * LaValTri);

if ValX > 1
    MinX = TrieeX(ValX);
    MaxX = TrieeX(length(TrieeX) - ValX);
    
    if MaxX > MinX
        set(handles.Xmin,'String',num2str(MinX));
        set(handles.Xmax,'String',num2str(MaxX));
    end
end
% Sinon, pas de mise ? jour possible...


if ValY > 1
    MinY = TrieeY(ValX);
    MaxY = TrieeY(length(TrieeY) - ValX);
    
    if MaxY > MinY
        set(handles.Ymin,'String',num2str(MinY));
        set(handles.Ymax,'String',num2str(MaxY));
    end
end
% Sinon, pas de mise ? jour possible...
return


% Close Panel Identify Pixels
function Close1_Callback(hObject, eventdata, handles)
set(handles.PanelIP,'Visible','off');
return

% Close Panel Multi Groups
function Close2_Callback(hObject, eventdata, handles)
set(handles.PanelMG,'Visible','off');
return



% #########################################################################
%       XkmeansX function  (V1.6.2)
function [idx, C, sumD, D] = XkmeansX(X, k, varargin)
%
% k-means for VER_XMapTools_750
% P. Lanari (Sept 2012)
%
%
%

if nargin < 2
    error('At least two input arguments required.');
end

% n points in p dimensional space
[n, p] = size(X);
Xsort = []; Xord = [];

pnames = {   'distance'  'start' 'replicates' 'maxiter' 'emptyaction' 'display'};
dflts =  {'sqeuclidean' 'sample'          []       100        'error'  'notify'};
[errmsg,distance,start,reps,maxit,emptyact,display] ...
    = statgetargs(pnames, dflts, varargin{:});
error(errmsg);

if ischar(distance)
    distNames = {'sqeuclidean','cityblock','cosine','correlation','hamming'};
    i = strmatch(lower(distance), distNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''distance'' parameter value:  %s.', distance));
    elseif isempty(i)
        error(sprintf('Unknown ''distance'' parameter value:  %s.', distance));
    end
    distance = distNames{i};
    switch distance
        case 'cityblock'
            [Xsort,Xord] = sort(X,1);
        case 'cosine'
            Xnorm = sqrt(sum(X.^2, 2));
            if any(min(Xnorm) <= eps * max(Xnorm))
                error(['Some points have small relative magnitudes, making them ', ...
                    'effectively zero.\nEither remove those points, or choose a ', ...
                    'distance other than ''cosine''.'], []);
            end
            X = X ./ Xnorm(:,ones(1,p));
        case 'correlation'
            X = X - repmat(mean(X,2),1,p);
            Xnorm = sqrt(sum(X.^2, 2));
            if any(min(Xnorm) <= eps * max(Xnorm))
                error(['Some points have small relative standard deviations, making them ', ...
                    'effectively constant.\nEither remove those points, or choose a ', ...
                    'distance other than ''correlation''.'], []);
            end
            X = X ./ Xnorm(:,ones(1,p));
        case 'hamming'
            if ~all(ismember(X(:),[0 1]))
                error('Non-binary data cannot be clustered using Hamming distance.');
            end
    end
else
    error('The ''distance'' parameter value must be a string.');
end

if ischar(start)
    startNames = {'uniform','sample','cluster'};
    i = strmatch(lower(start), startNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''start'' parameter value:  %s.', start));
    elseif isempty(i)
        error(sprintf('Unknown ''start'' parameter value:  %s.', start));
    elseif isempty(k)
        error('You must specify the number of clusters, K.');
    end
    start = startNames{i};
    if strcmp(start, 'uniform')
        if strcmp(distance, 'hamming')
            error('Hamming distance cannot be initialized with uniform random values.');
        end
        Xmins = min(X,1);
        Xmaxs = max(X,1);
    end
elseif isnumeric(start)
    CC = start;
    start = 'numeric';
    if isempty(k)
        k = size(CC,1);
    elseif k ~= size(CC,1);
        error('The ''start'' matrix must have K rows.');
    elseif size(CC,2) ~= p
        error('The ''start'' matrix must have the same number of columns as X.');
    end
    if isempty(reps)
        reps = size(CC,3);
    elseif reps ~= size(CC,3);
        error('The third dimension of the ''start'' array must match the ''replicates'' parameter value.');
    end
    
    % Need to center explicit starting points for 'correlation'. (Re)normalization
    % for 'cosine'/'correlation' is done at each iteration.
    if isequal(distance, 'correlation')
        CC = CC - repmat(mean(CC,2),[1,p,1]);
    end
else
    error('The ''start'' parameter value must be a string or a numeric matrix or array.');
end

if ischar(emptyact)
    emptyactNames = {'error','drop','singleton'};
    i = strmatch(lower(emptyact), emptyactNames);
    if length(i) > 1
        error(sprintf('Ambiguous ''emptyaction'' parameter value:  %s.', emptyact));
    elseif isempty(i)
        error(sprintf('Unknown ''emptyaction'' parameter value:  %s.', emptyact));
    end
    emptyact = emptyactNames{i};
else
    error('The ''emptyaction'' parameter value must be a string.');
end

if ischar(display)
    i = strmatch(lower(display), strvcat('off','notify','final','iter'));
    if length(i) > 1
        error(sprintf('Ambiguous ''display'' parameter value:  %s.', display));
    elseif isempty(i)
        error(sprintf('Unknown ''display'' parameter value:  %s.', display));
    end
    display = i-1;
else
    error('The ''display'' parameter value must be a string.');
end

if k == 1
    error('The number of clusters must be greater than 1.');
elseif n < k
    error('X must have more rows than the number of clusters.');
end

% Assume one replicate
if isempty(reps)
    reps = 1;
end

%
% Done with input argument processing, begin clustering
%

dispfmt = '%6d\t%6d\t%8d\t%12g';
D = repmat(NaN,n,k);   % point-to-cluster distances
Del = repmat(NaN,n,k); % reassignment criterion
m = zeros(k,1);

totsumDBest = Inf;
for rep = 1:reps
    switch start
        case 'uniform'
            C = unifrnd(Xmins(ones(k,1),:), Xmaxs(ones(k,1),:));
            % For 'cosine' and 'correlation', these are uniform inside a subset
            % of the unit hypersphere.  Still need to center them for
            % 'correlation'.  (Re)normalization for 'cosine'/'correlation' is
            % done at each iteration.
            if isequal(distance, 'correlation')
                C = C - repmat(mean(C,2),1,p);
            end
        case 'sample'
            C = double(X(randsample(n,k),:)); % X may be logical
        case 'cluster'
            Xsubset = X(randsample(n,floor(.1*n)),:);
            [dum, C] = kmeans(Xsubset, k, varargin{:}, 'start','sample', 'replicates',1);
        case 'numeric'
            C = CC(:,:,rep);
    end
    changed = 1:k; % everything is newly assigned
    idx = zeros(n,1);
    totsumD = Inf;
    
    if display > 2 % 'iter'
        disp(sprintf('  iter\t phase\t     num\t         sum'));
    end
    
    %
    % Begin phase one:  batch reassignments
    %
    
    converged = false;
    iter = 0;
    while true
        % Compute the distance from every point to each cluster centroid
        D(:,changed) = distfun(X, C(changed,:), distance, iter);
        
        % Compute the total sum of distances for the current configuration.
        % Can't do it first time through, there's no configuration yet.
        if iter > 0
            totsumD = sum(D((idx-1)*n + (1:n)'));
            % Test for a cycle: if objective is not decreased, back out
            % the last step and move on to the single update phase
            if prevtotsumD <= totsumD
                idx = previdx;
                [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
                iter = iter - 1;
                break;
            end
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,1,length(moved),totsumD));
            end
            if iter >= maxit, break; end
        end
        
        % Determine closest cluster for each point and reassign points to clusters
        previdx = idx;
        prevtotsumD = totsumD;
        [d, nidx] = min(D, [], 2);
        
        if iter == 0
            % Every point moved, every cluster will need an update
            moved = 1:n;
            idx = nidx;
            changed = 1:k;
        else
            % Determine which points moved
            moved = find(nidx ~= previdx);
            if length(moved) > 0
                % Resolve ties in favor of not moving
                moved = moved(D((previdx(moved)-1)*n + moved) > d(moved));
            end
            if length(moved) == 0
                break;
            end
            idx(moved) = nidx(moved);
            
            % Find clusters that gained or lost members
            changed = unique([idx(moved); previdx(moved)])';
        end
        
        % Calculate the new cluster centroids and counts.
        [C(changed,:), m(changed)] = gcentroids(X, idx, changed, distance, Xsort, Xord);
        iter = iter + 1;
        
        % Deal with clusters that have just lost all their members
        empties = changed(m(changed) == 0);
        if ~isempty(empties)
            switch emptyact
                case 'error'
                    error(sprintf('Empty cluster created at iteration %d.',iter));
                case 'drop'
                    % Remove the empty cluster from any further processing
                    D(:,empties) = NaN;
                    changed = changed(m(changed) > 0);
                    if display > 0
                        warning(sprintf('Empty cluster created at iteration %d.',iter));
                    end
                case 'singleton'
                    if display > 0
                        warning(sprintf('Empty cluster created at iteration %d.',iter));
                    end
                    
                    for i = empties
                        % Find the point furthest away from its current cluster.
                        % Take that point out of its cluster and use it to create
                        % a new singleton cluster to replace the empty one.
                        [dlarge, lonely] = max(d);
                        from = idx(lonely); % taking from this cluster
                        C(i,:) = X(lonely,:);
                        m(i) = 1;
                        idx(lonely) = i;
                        d(lonely) = 0;
                        
                        % Update clusters from which points are taken
                        [C(from,:), m(from)] = gcentroids(X, idx, from, distance, Xsort, Xord);
                        changed = unique([changed from]);
                    end
            end
        end
    end % phase one
    
    % Initialize some cluster information prior to phase two
    switch distance
        case 'cityblock'
            Xmid = zeros([k,p,2]);
            for i = 1:k
                if m(i) > 0
                    % Separate out sorted coords for points in i'th cluster,
                    % and save values above and below median, component-wise
                    Xsorted = reshape(Xsort(idx(Xord)==i), m(i), p);
                    nn = floor(.5*m(i));
                    if mod(m(i),2) == 0
                        Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                    elseif m(i) > 1
                        Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                    else
                        Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                    end
                end
            end
        case 'hamming'
            Xsum = zeros(k,p);
            for i = 1:k
                if m(i) > 0
                    % Sum coords for points in i'th cluster, component-wise
                    Xsum(i,:) = sum(X(idx==i,:), 1);
                end
            end
    end
    
    %
    % Begin phase two:  single reassignments
    %
    changed = find(m' > 0);
    lastmoved = 0;
    nummoved = 0;
    iter1 = iter;
    while iter < maxit
        % Calculate distances to each cluster from each point, and the
        % potential change in total sum of errors for adding or removing
        % each point from each cluster.  Clusters that have not changed
        % membership need not be updated.
        %
        % Singleton clusters are a special case for the sum of dists
        % calculation.  Removing their only point is never best, so the
        % reassignment criterion had better guarantee that a singleton
        % point will stay in its own cluster.  Happily, we get
        % Del(i,idx(i)) == 0 automatically for them.
        switch distance
            case 'sqeuclidean'
                for i = changed
                    mbrs = (idx == i);
                    sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                    if m(i) == 1
                        sgn(mbrs) = 0; % prevent divide-by-zero for singleton mbrs
                    end
                    Del(:,i) = (m(i) ./ (m(i) + sgn)) .* sum((X - C(repmat(i,n,1),:)).^2, 2);
                end
            case 'cityblock'
                for i = changed
                    if mod(m(i),2) == 0 % this will never catch singleton clusters
                        ldist = Xmid(repmat(i,n,1),:,1) - X;
                        rdist = X - Xmid(repmat(i,n,1),:,2);
                        mbrs = (idx == i);
                        sgn = repmat(1-2*mbrs, 1, p); % -1 for members, 1 for nonmembers
                        Del(:,i) = sum(max(0, max(sgn.*rdist, sgn.*ldist)), 2);
                    else
                        Del(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
                    end
                end
            case {'cosine','correlation'}
                % The points are normalized, centroids are not, so normalize them
                normC(changed) = sqrt(sum(C(changed,:).^2, 2));
                if any(normC < eps) % small relative to unit-length data points
                    error(sprintf('Zero cluster centroid created at iteration %d.',iter));
                end
                % This can be done without a loop, but the loop saves memory allocations
                for i = changed
                    XCi = X * C(i,:)';
                    mbrs = (idx == i);
                    sgn = 1 - 2*mbrs; % -1 for members, 1 for nonmembers
                    Del(:,i) = 1 + sgn .*...
                        (m(i).*normC(i) - sqrt((m(i).*normC(i)).^2 + 2.*sgn.*m(i).*XCi + 1));
                end
            case 'hamming'
                for i = changed
                    if mod(m(i),2) == 0 % this will never catch singleton clusters
                        % coords with an unequal number of 0s and 1s have a
                        % different contribution than coords with an equal
                        % number
                        unequal01 = find(2*Xsum(i,:) ~= m(i));
                        numequal01 = p - length(unequal01);
                        mbrs = (idx == i);
                        Di = abs(X(:,unequal01) - C(repmat(i,n,1),unequal01));
                        Del(:,i) = (sum(Di, 2) + mbrs*numequal01) / p;
                    else
                        Del(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
                    end
                end
        end
        
        % Determine best possible move, if any, for each point.  Next we
        % will pick one from those that actually did move.
        previdx = idx;
        prevtotsumD = totsumD;
        [minDel, nidx] = min(Del, [], 2);
        moved = find(previdx ~= nidx);
        if length(moved) > 0
            % Resolve ties in favor of not moving
            moved = moved(Del((previdx(moved)-1)*n + moved) > minDel(moved));
        end
        if length(moved) == 0
            % Count an iteration if phase 2 did nothing at all, or if we're
            % in the middle of a pass through all the points
            if (iter - iter1) == 0 | nummoved > 0
                iter = iter + 1;
                if display > 2 % 'iter'
                    disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
                end
            end
            converged = true;
            break;
        end
        
        % Pick the next move in cyclic order
        moved = mod(min(mod(moved - lastmoved - 1, n) + lastmoved), n) + 1;
        
        % If we've gone once through all the points, that's an iteration
        if moved <= lastmoved
            iter = iter + 1;
            if display > 2 % 'iter'
                disp(sprintf(dispfmt,iter,2,nummoved,totsumD));
            end
            if iter >= maxit, break; end
            nummoved = 0;
        end
        nummoved = nummoved + 1;
        lastmoved = moved;
        
        oidx = idx(moved);
        nidx = nidx(moved);
        totsumD = totsumD + Del(moved,nidx) - Del(moved,oidx);
        
        % Update the cluster index vector, and rhe old and new cluster
        % counts and centroids
        idx(moved) = nidx;
        m(nidx) = m(nidx) + 1;
        m(oidx) = m(oidx) - 1;
        switch distance
            case 'sqeuclidean'
                C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
            case 'cityblock'
                for i = [oidx nidx]
                    % Separate out sorted coords for points in each cluster.
                    % New centroid is the coord median, save values above and
                    % below median.  All done component-wise.
                    Xsorted = reshape(Xsort(idx(Xord)==i), m(i), p);
                    nn = floor(.5*m(i));
                    if mod(m(i),2) == 0
                        C(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                        Xmid(i,:,1:2) = Xsorted([nn, nn+1],:)';
                    else
                        C(i,:) = Xsorted(nn+1,:);
                        if m(i) > 1
                            Xmid(i,:,1:2) = Xsorted([nn, nn+2],:)';
                        else
                            Xmid(i,:,1:2) = Xsorted([1, 1],:)';
                        end
                    end
                end
            case {'cosine','correlation'}
                C(nidx,:) = C(nidx,:) + (X(moved,:) - C(nidx,:)) / m(nidx);
                C(oidx,:) = C(oidx,:) - (X(moved,:) - C(oidx,:)) / m(oidx);
            case 'hamming'
                % Update summed coords for points in each cluster.  New
                % centroid is the coord median.  All done component-wise.
                Xsum(nidx,:) = Xsum(nidx,:) + X(moved,:);
                Xsum(oidx,:) = Xsum(oidx,:) - X(moved,:);
                C(nidx,:) = .5*sign(2*Xsum(nidx,:) - m(nidx)) + .5;
                C(oidx,:) = .5*sign(2*Xsum(oidx,:) - m(oidx)) + .5;
        end
        changed = sort([oidx nidx]);
    end % phase two
    
    if (~converged) & (display > 0)
        warning(sprintf('Failed to converge in %d iterations.', maxit));
    end
    
    % Calculate cluster-wise sums of distances
    nonempties = find(m(:)'>0);
    D(:,nonempties) = distfun(X, C(nonempties,:), distance, iter);
    d = D((idx-1)*n + (1:n)');
    sumD = zeros(k,1);
    for i = 1:k
        sumD(i) = sum(d(idx == i));
    end
    if display > 1 % 'final' or 'iter'
        disp(sprintf('%d iterations, total sum of distances = %g',iter,totsumD));
    end
    
    % Save the best solution so far
    if totsumD < totsumDBest
        totsumDBest = totsumD;
        idxBest = idx;
        Cbest = C;
        sumDBest = sumD;
        if nargout > 3
            Dbest = D;
        end
    end
end

% Return the best solution
idx = idxBest;
C = Cbest;
sumD = sumDBest;
if nargout > 3
    D = Dbest;
end

function D = distfun(X, C, dist, iter)
%DISTFUN Calculate point to cluster centroid distances.
[n,p] = size(X);
D = zeros(n,size(C,1));
clusts = 1:size(C,1);

switch dist
    case 'sqeuclidean'
        for i = clusts
            D(:,i) = sum((X - C(repmat(i,n,1),:)).^2, 2);
        end
    case 'cityblock'
        for i = clusts
            D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2);
        end
    case {'cosine','correlation'}
        % The points are normalized, centroids are not, so normalize them
        normC = sqrt(sum(C.^2, 2));
        if any(normC < eps) % small relative to unit-length data points
            error(sprintf('Zero cluster centroid created at iteration %d.',iter));
        end
        % This can be done without a loop, but the loop saves memory allocations
        for i = clusts
            D(:,i) = 1 - (X * C(i,:)') ./ normC(i);
        end
    case 'hamming'
        for i = clusts
            D(:,i) = sum(abs(X - C(repmat(i,n,1),:)), 2) / p;
        end
end

function [centroids, counts] = gcentroids(X, index, clusts, dist, Xsort, Xord)
%GCENTROIDS Centroids and counts stratified by group.
[n,p] = size(X);
num = length(clusts);
centroids = repmat(NaN, [num p]);
counts = zeros(num,1);
for i = 1:num
    members = find(index == clusts(i));
    if length(members) > 0
        counts(i) = length(members);
        switch dist
            case 'sqeuclidean'
                centroids(i,:) = sum(X(members,:),1) / counts(i);
            case 'cityblock'
                % Separate out sorted coords for points in i'th cluster,
                % and use to compute a fast median, component-wise
                Xsorted = reshape(Xsort(index(Xord)==clusts(i)), counts(i), p);
                nn = floor(.5*counts(i));
                if mod(counts(i),2) == 0
                    centroids(i,:) = .5 * (Xsorted(nn,:) + Xsorted(nn+1,:));
                else
                    centroids(i,:) = Xsorted(nn+1,:);
                end
            case {'cosine','correlation'}
                centroids(i,:) = sum(X(members,:),1) / counts(i); % unnormalized
            case 'hamming'
                % Compute a fast median for binary data, component-wise
                centroids(i,:) = .5*sign(2*sum(X(members,:), 1) - counts(i)) + .5;
        end
    end
end

function [emsg,varargout]=statgetargs(pnames,dflts,varargin)
%STATGETARGS Process parameter name/value pairs for statistics functions
%   [EMSG,A,B,...]=STATGETARGS(PNAMES,DFLTS,'NAME1',VAL1,'NAME2',VAL2,...)
%   accepts a cell array PNAMES of valid parameter names, a cell array
%   DFLTS of default values for the parameters named in PNAMES, and
%   additional parameter name/value pairs.  Returns parameter values A,B,...
%   in the same order as the names in PNAMES.  Outputs corresponding to
%   entries in PNAMES that are not specified in the name/value pairs are
%   set to the corresponding value from DFLTS.  If nargout is equal to
%   length(PNAMES)+1, then unrecognized name/value pairs are an error.  If
%   nargout is equal to length(PNAMES)+2, then all unrecognized name/value
%   pairs are returned in a single cell array following any other outputs.
%
%   EMSG is empty if the arguments are valid, or the text of an error message
%   if an error occurs.  STATGETARGS does not actually throw any errors, but
%   rather returns an error message so that the caller may throw the error.
%   Outputs will be partially processed after an error occurs.
%
%   This utility is used by some Statistics Toolbox functions to process
%   name/value pair arguments.
%
%   Example:
%       pnames = {'color' 'linestyle', 'linewidth'}
%       dflts  = {    'r'         '_'          '1'}
%       varargin = {{'linew' 2 'nonesuch' [1 2 3] 'linestyle' ':'}
%       [emsg,c,ls,lw] = statgetargs(pnames,dflts,varargin{:})    % error
%       [emsg,c,ls,lw,ur] = statgetargs(pnames,dflts,varargin{:}) % ok

%   Copyright 1993-2002 The MathWorks, Inc.
%   $Revision: 1.4 $  $Date: 2002/02/04 19:25:45 $

% We always create (nparams+1) outputs:
%    one for emsg
%    nparams varargs for values corresponding to names in pnames
% If they ask for one more (nargout == nparams+2), it's for unrecognized
% names/values

% Initialize some variables
emsg = '';
nparams = length(pnames);
varargout = dflts;
unrecog = {};
nargs = length(varargin);

% Must have name/value pairs
if mod(nargs,2)~=0
    emsg = sprintf('Wrong number of arguments.');
else
    % Process name/value pairs
    for j=1:2:nargs
        pname = varargin{j};
        if ~ischar(pname)
            emsg = sprintf('Parameter name must be text.');
            break;
        end
        i = strmatch(lower(pname),pnames);
        if isempty(i)
            % if they've asked to get back unrecognized names/values, add this
            % one to the list
            if nargout > nparams+1
                unrecog((end+1):(end+2)) = {varargin{j} varargin{j+1}};
                
                % otherwise, it's an error
            else
                emsg = sprintf('Invalid parameter name:  %s.',pname);
                break;
            end
        elseif length(i)>1
            emsg = sprintf('Ambiguous parameter name:  %s.',pname);
            break;
        else
            varargout{i} = varargin{j+1};
        end
    end
end

varargout{nparams+1} = unrecog;



% #########################################################################
%     C A L L B A C K      F U N C T I O N S
% #########################################################################


% List X
function PPSerieX_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

cla(handles.axes2)
set(handles.axes2,'Visible','off')
cla(handles.axesCarto)
set(handles.axesCarto,'Visible','off')
set(handles.CleanA1,'Visible','off')


% Update Min Max
MinMaxLimits_Callback(x ,y, hObject, eventdata, handles)

% Update Graph
XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% List Y
function PPSerieY_Callback(hObject, eventdata, handles)
PPSerieX_Callback(hObject, eventdata, handles)
return


% Xmin txt
function Xmin_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Xmax txt
function Xmax_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Ymin txt
function Ymin_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Ymax txt
function Ymax_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% *** ZOOM V1.5.2 
function ButtonAuto1_Callback(hObject, eventdata, handles)

axes(handles.axes1);

P1 = ginput(1);
hold on, 
plot(P1(1),P1(2),'.k','linewidth',2,'markersize',10)
P2 = ginput(1);
hold on
plot(P2(1),P2(2),'.k','linewidth',2,'markersize',10)
plot([P1(1),P2(1)],[P1(2),P1(2)],'-k')
plot([P2(1),P2(1)],[P1(2),P2(2)],'-k')
plot([P2(1),P1(1)],[P2(2),P2(2)],'-k')
plot([P1(1),P1(1)],[P2(2),P1(2)],'-k')
hold off

lesX=[P1(1),P2(1)];
lesY=[P1(2),P2(2)];

set(handles.Ymin,'String',num2str(min(lesY)));
set(handles.Ymax,'String',num2str(max(lesY)));

set(handles.Xmin,'String',num2str(min(lesX)));
set(handles.Xmax,'String',num2str(max(lesX)));


Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

guidata(hObject, handles);
XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Auto 94%
function ButtonAuto2_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

LaValTri = 0.06;

AutoLvl_Callback(LaValTri, hObject, eventdata, handles)

guidata(hObject, handles);
XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Auto 90%
function ButtonAuto3_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

LaValTri = 0.0001;

AutoLvl_Callback(LaValTri, hObject, eventdata, handles)

guidata(hObject, handles);
XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Reset Auto
function ButtonAutoRes_Callback(hObject, eventdata, handles)
PPSerieX_Callback(hObject, eventdata, handles)
return


% *** DENSITY PLOT
function DensityPlotCompute_Callback(hObject, eventdata, handles)

axes(handles.axesCarto), cla, colorbar('off')
set(handles.axesCarto,'Visible','off');
set(handles.PanelMG,'Visible','off');
set(handles.PanelIP,'Visible','off');

set(handles.ButtonIndentify,'Enable','off');
set(handles.MenuIdentify,'Enable','off');
set(handles.ExportAxes1,'Visible','off');

% Masks
set(handles.MaskFileMenu,'Value',1,'Visible','off');
set(handles.RunKmeans,'Visible','off');
set(handles.KmeansMethods,'Visible','off');
set(handles.PlotOriginal,'Visible','off');
set(handles.PlotMap,'Visible','off');

set(handles.PPSerieX,'Enable','off');
set(handles.PPSerieY,'Enable','off');

axes(handles.axes2)

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

Patterns = str2num(get(handles.DPText1,'String'));
Grids = str2num(get(handles.DPText2,'String'));

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));

axes(handles.axes1), cla
set(handles.axes1,'Visible','off')

axes(handles.axes2)

% First filter of the zeros (important for the colorbar)
X = x(find(x > 0 & y > 0));
Y = y(find(x > 0 & y > 0));

Answer = questdlg('What kind of density image do you want?','XMapTools','Density map (quick)','Spots coloured by density (slow)','Density map (quick)');

switch Answer
    case 'Density map (quick)'   % this is the old method
        
        if get(handles.IsLogColorbar,'Value')
            DensityPlotBinaryInternal(X,Y,Patterns,Grids,[Xmin,Xmax,Ymin,Ymax],'log');
        else
            DensityPlotBinaryInternal(X,Y,Patterns,Grids,[Xmin,Xmax,Ymin,Ymax],'linear');
        end
        
        axis([Xmin Xmax Ymin Ymax]) 
        
        set(handles.axes2,'Visible','on')
        
        set(handles.CloseDens,'Visible','on');
        set(handles.ExportsAxes2,'Visible','on');


    case 'Spots coloured by density (slow)'
        if get(handles.IsLogColorbar,'Value')
            DensityPlotBinaryInternalScatter(X,Y,'log',Xmin,Xmax,Ymin,Ymax,Grids,handles);
        else
            DensityPlotBinaryInternalScatter(X,Y,'linear',Xmin,Xmax,Ymin,Ymax,Grids,handles);
        end
        
        
end



%XYPlot_Callback(OnPlot, hObject, eventdata, handles)

guidata(hObject, handles);
return


% *** CLASSIC DENSITY PLOT FUNCTION  MODIFIED 2.6.2
function [OnTrace] = DensityPlotBinaryInternal(E1,E2,patterns,MapSize,Lims,mode)
% New function to plot density map

Xmin = Lims(1); 
Xmax = Lims(2);
Ymin = Lims(3);
Ymax = Lims(4);

Xstep = (Xmax-Xmin)/(MapSize-1);
Ystep = (Ymax-Ymin)/(MapSize-1);

Xi = Xmin:Xstep:Xmax;
Yi = Ymin:Ystep:Ymax;

% New version (PL - 2019)
X = E1(find(E1 > 0 & E2 > 0));
Y = E2(find(E1 > 0 & E2 > 0));

minx = Xmin;
maxx = Xmax;
miny = Ymin;
maxy = Ymax;

nbins = [min(numel(unique(X)),MapSize) ,min(numel(unique(Y)),MapSize) ];

edges1 = linspace(minx, maxx, nbins(1)+1);
ctrs1 = edges1(1:end-1) + .5*diff(edges1);
edges1 = [-Inf edges1(2:end-1) Inf];
edges2 = linspace(miny, maxy, nbins(2)+1);
ctrs2 = edges2(1:end-1) + .5*diff(edges2);
edges2 = [-Inf edges2(2:end-1) Inf];

[n,p] = size(X);
bin = zeros(n,2);
% Reverse the columns to put the first column of X along the horizontal
% axis, the second along the vertical.
[dum,bin(:,2)] = histc(X,edges1); 
[dum,bin(:,1)] = histc(Y,edges2);

OnTrace = accumarray(bin,1,nbins([2 1])); 

% keyboard
% 
% Xstep = (Xmax-Xmin)/(MapSize-1);
% Ystep = (Ymax-Ymin)/(MapSize-1);
% 
% X = Xmin:Xstep:Xmax;
% Y = Ymin:Ystep:Ymax;
% 
% LeRes = NaN.*zeros(MapSize);
% 
% %tic
% h = waitbar(0,'XMapTools is running numbers; please wait...');
% ComptWaitBar = 0;
% 
% for iX = 1:MapSize
%     % Waitbar
%     ComptWaitBar = ComptWaitBar+1;
%     if ComptWaitBar > MapSize/20
%         ComptWaitBar = 0; 
%         waitbar(iX/MapSize,h)
%     end
%     % Define X
%     XlimInf=X(iX)-Xstep*0.5;
%     XlimSup=X(iX)+Xstep*0.5;
%     % Verif si on deborde, seulement deux cas possibles ici
%     if XlimInf < Xmin
%         XlimInf = Xmin;
%     end
%     if XlimSup > Xmax
%         XlimSup = Xmax;
%     end
%     
%     for iY = 1:MapSize
%         % Define Y
%         YlimInf=Y(iY)-Ystep*0.5;
%         YlimSup=Y(iY)+Ystep*0.5;
%         % Verif
%         if YlimInf < Ymin 
%             YlimInf = Ymin;
%         end
%         if YlimSup > Ymax
%             YlimSup = Ymax;
%         end
% 
%         % Enfin, on compte
%         LeRes(iY,iX) = length(find(E1(:) >= XlimInf & E1(:) < XlimSup & E2(:) >= YlimInf & E2(:) < YlimSup));%lin/col
%         
%     end
% end
% close(h);
% %toc
% 
% OnTrace = LeRes; 

switch mode
    case 'log'
        
        imagesc(Xi,Yi,log(OnTrace))
        
        Cmin = min(OnTrace(find(OnTrace)))+1; 
        Cmax = max(OnTrace(find(OnTrace)))+1;
        
        caxis([min(log(OnTrace(find(OnTrace)))),max(log(OnTrace(:)))]);
        set(gca,'YDir','normal');
        
        tk = logspace(log(Cmin),log(Cmax),5);
        
        originalSize1 = get(gca, 'Position');
        hc = colorbar('vertical');
        colormap([1,1,1;jet(64)])
        set(gca,'Position',originalSize1);

        Labels = get(hc,'YTickLabel');

        for i = 1:length(Labels)
            LabelsOk{i} = num2str(round(exp(str2num(char(Labels(i,:))))),'%.0f');
        end
        
        %LabelsOk; 
        
        set(hc,'YTickLabel',LabelsOk);
        
        %set(hc,'YScale','log');

        
    case 'linear'
        imagesc(Xi,Yi,OnTrace)
        set(gca,'YDir','normal')
        
        originalSize1 = get(gca, 'Position');
        hc = colorbar('vertical');
        colormap(jet(64))
        set(gca,'Position',originalSize1);
        
end




return


% *** SCATTER DENSITY PLOT FUNCTION
function DensityPlotBinaryInternalScatter(X,Y,LOG,Xmin,Xmax,Ymin,Ymax,Grids,handles)
% DSCATTER creates a scatter plot coloured by density.
%
%   DSCATTER(X,Y) creates a scatterplot of X and Y at the locations
%   specified by the vectors X and Y (which must be the same size), colored
%   by the density of the points.
%
%   DSCATTER(...,'MARKER',M) allows you to set the marker for the
%   scatter plot. Default is 's', square.
%
%   DSCATTER(...,'MSIZE',MS) allows you to set the marker size for the
%   scatter plot. Default is 10.
%
%   DSCATTER(...,'FILLED',false) sets the markers in the scatter plot to be
%   outline. The default is to use filled markers.
%
%   DSCATTER(...,'PLOTTYPE',TYPE) allows you to create other ways of
%   plotting the scatter data. Options are "surf','mesh' and 'contour'.
%   These create surf, mesh and contour plots colored by density of the
%   scatter data.
%
%   DSCATTER(...,'BINS',[NX,NY]) allows you to set the number of bins used
%   for the 2D histogram used to estimate the density. The default is to
%   use the number of unique values in X and Y up to a maximum of 200.
%
%   DSCATTER(...,'SMOOTHING',LAMBDA) allows you to set the smoothing factor
%   used by the density estimator. The default value is 20 which roughly
%   means that the smoothing is over 20 bins around a given point.
%
%   DSCATTER(...,'LOGY',true) uses a log scale for the yaxis.
%
%   Examples:
%
%       [data, params] = fcsread('SampleFACS');
%       dscatter(data(:,1),10.^(data(:,2)/256),'log',1)
%       % Add contours
%       hold on
%       dscatter(data(:,1),10.^(data(:,2)/256),'log',1,'plottype','contour')
%       hold off
%       xlabel(params(1).LongName); ylabel(params(2).LongName);
%       
%   See also FCSREAD, SCATTER.

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision:  $   $Date:  $

% Reference:
% Paul H. C. Eilers and Jelle J. Goeman
% Enhancing scatterplots with smoothed densities
% Bioinformatics, Mar 2004; 20: 623 - 628.

hwait = waitbar(1,'XMapTools is running numbers; please wait...');

lambda = [];
nbins = [];
plottype = 'scatter';
contourFlag = false;
msize = 1;
marker = 's';
logy = false;
filled = true;
% if nargin > 2
%     if rem(nargin,2) == 1
%         error('Bioinfo:IncorrectNumberOfArguments',...
%             'Incorrect number of arguments to %s.',mfilename);
%     end
%     okargs = {'smoothing','bins','plottype','logy','marker','msize','filled'};
%     for j=1:2:nargin-2
%         pname = varargin{j};
%         pval = varargin{j+1};
%         k = strmatch(lower(pname), okargs); %#ok
%         if isempty(k)
%             error('Bioinfo:UnknownParameterName',...
%                 'Unknown parameter name: %s.',pname);
%         elseif length(k)>1
%             error('Bioinfo:AmbiguousParameterName',...
%                 'Ambiguous parameter name: %s.',pname);
%         else
%             switch(k)
%                 case 1  % smoothing factor
%                     if isnumeric(pval)
%                         lambda = pval;
%                     else
%                         error('Bioinfo:InvalidScoringMatrix','Invalid smoothing parameter.');
%                     end
%                 case 2
%                     if isscalar(pval)
%                         nbins = [ pval pval];
%                     else
%                         nbins = pval;
%                     end
%                 case 3
%                     logy = pval;
%                     Y = log10(Y);
%                 case 4
%                     contourFlag = pval;
%                 case 5
%                     marker = pval;
%                 case 6
%                     msize = pval;
%                 case 7
%                     filled = pval;
%             end
%         end
%     end
% end

minx = Xmin;
maxx = Xmax;
miny = Ymin;
maxy = Ymax;

if isempty(nbins)
    nbins = [min(numel(unique(X)),Grids) ,min(numel(unique(Y)),Grids) ];
end

if isempty(lambda)
    lambda = 20;
end

edges1 = linspace(minx, maxx, nbins(1)+1);
ctrs1 = edges1(1:end-1) + .5*diff(edges1);
edges1 = [-Inf edges1(2:end-1) Inf];
edges2 = linspace(miny, maxy, nbins(2)+1);
ctrs2 = edges2(1:end-1) + .5*diff(edges2);
edges2 = [-Inf edges2(2:end-1) Inf];

[n,p] = size(X);
bin = zeros(n,2);
% Reverse the columns to put the first column of X along the horizontal
% axis, the second along the vertical.
[dum,bin(:,2)] = histc(X,edges1);
[dum,bin(:,1)] = histc(Y,edges2);
H = accumarray(bin,1,nbins([2 1])) ./ n;
G = smooth1D(H,nbins(2)/lambda);
F = smooth1D(G',nbins(1)/lambda)';
% = filter2D(H,lambda);

Density = accumarray(bin,1,nbins([2 1]));

if logy
    ctrs2 = 10.^ctrs2;
    Y = 10.^Y;
end
okTypes = {'surf','mesh','contour','image','scatter'};
k = strmatch(lower(plottype), okTypes); %#ok
if isempty(k)
    error('dscatter:UnknownPlotType',...
        'Unknown plot type: %s.',plottype);
elseif length(k)>1
    error('dscatter:AmbiguousPlotType',...
        'Ambiguous plot type: %s.',plottype);
else  

    axes(handles.axes2);
    switch(k)

        case 1 %'surf'
            h = surf(ctrs1,ctrs2,F,'edgealpha',0);
        case 2 % 'mesh'
            h = mesh(ctrs1,ctrs2,F);
        case 3 %'contour'
            [dummy, h] =contour(ctrs1,ctrs2,F);
        case 4 %'image'
            nc = 256;
            F = F./max(F(:));
            colormap(repmat(linspace(1,0,nc)',1,3));
            h =image(ctrs1,ctrs2,floor(nc.*F) + 1);
        case 5 %'scatter'
            %F = F./max(F(:));
            ind = sub2ind(size(F),bin(:,1),bin(:,2));
            col = F(ind);
            
            col = Density(ind);
            
            %keyboard
            if isequal(LOG,'log')
                h = scatter(X,Y,msize,log(col),marker,'filled');
                
                OnTrace = col;
                
                Cmin = min(OnTrace(find(OnTrace)))+1; 
                Cmax = max(OnTrace(find(OnTrace)))+1;
                caxis([min(log(OnTrace(find(OnTrace)))),max(log(OnTrace(:)))]);
                
                tk = logspace(log(Cmin),log(Cmax),5);
                originalSize1 = get(gca, 'Position');
                hc = colorbar('vertical');
                colormap(jet(64))
                set(gca,'Position',originalSize1);

                Labels = get(hc,'YTickLabel');

                for i = 1:length(Labels)
                    LabelsOk{i} = num2str(round(exp(str2num(char(Labels(i,:))))),'%.0f');
                end

                set(hc,'YTickLabel',LabelsOk);
                
            else
                h = scatter(X,Y,msize,col,marker,'filled');
                
                originalSize1 = get(gca, 'Position');
                hc = colorbar('vertical');
                colormap(jet(64))
                set(gca,'Position',originalSize1);
                
            end
    end

end

axis([Xmin Xmax Ymin Ymax])

set(handles.axes2,'Visible','on')

set(handles.CloseDens,'Visible','on');
set(handles.ExportsAxes2,'Visible','on');

figure(hwait); 
drawnow

if logy
    set(gca,'yscale','log');
end
if nargout > 0
    hAxes = get(h,'parent');
end
%%%% This method is quicker for symmetric data.
% function Z = filter2D(Y,bw)
% z = -1:(1/bw):1;
% k = .75 * (1 - z.^2);
% k = k ./ sum(k);
% Z = filter2(k'*k,Y);
close(hwait)
return

function Z = smooth1D(Y,lambda)
[m,n] = size(Y);
E = eye(m);
D1 = diff(E,1);
D2 = diff(D1,1);
P = lambda.^2 .* D2'*D2 + 2.*lambda .* D1'*D1;
Z = (E + P) \ Y;
return





% Grid size
function DPText2_Callback(hObject, eventdata, handles)

%GridSize = str2num(get(handles.DPText2,'String'));
%TimeCalc = 0.086 * GridSize - 0.99;
%set(handles.ComputingTime,'String',[char(num2str(round(TimeCalc))),' s']);



return


% NbBars Xhist
function NbXbars_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% NbBars Yhist
function NbYbars_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% Export Histograms.
function ExportHist_Callback(hObject, eventdata, handles)
Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));

figure, 
subplot(2,1,1)
hist(x(find(x > Xmin & x < Xmax)),str2num(get(handles.NbXbars,'String')))
title(Data(OnPlot(1)).label);

subplot(2,1,2)
hist(y(find(y > Ymin & y < Ymax)),str2num(get(handles.NbYbars,'String')))
title(Data(OnPlot(2)).label);

guidata(hObject, handles);
return


% Export Density
function ExportsAxes2_Callback(hObject, eventdata, handles)

XLabels = get(handles.PPSerieX,'String');
XSelect = get(handles.PPSerieX,'Value');
XLabel = char(XLabels{XSelect});

YLabels = get(handles.PPSerieY,'String');
YSelect = get(handles.PPSerieY,'Value');
YLabel = char(YLabels{YSelect});

CheckLogColormap = get(handles.IsLogColorbar,'Value');

axes(handles.axes2)
CMap = colormap;

XLim = get(handles.axes2,'XLim');
YLim = get(handles.axes2,'YLim');
DataAspectRatio = get(handles.axes2,'DataAspectRatio');

lesInd = get(handles.axes2,'child');
CLim = get(handles.axes2,'CLim');
YDir = get(handles.axes2,'YDir');

% New 2.6.1 - Save the zoom options
ZoomValues = get(gca,{'xlim','ylim'});

figure,
text(0.3,0.5,'This might take some time - be patient :)')
drawnow
pause(1)
cla

% set the figure large enough and centered
FigPosition = get(gcf,'Position');
ScreenSize = get(0,'ScreenSize');

FigHeight = ScreenSize(4)*0.8;
FigWidth = ScreenSize(3)*0.8; %FigHeight/FigPosition(4)*FigPosition(3);
FigX = (ScreenSize(3)-FigWidth)/2;
FigY = (ScreenSize(4)-FigHeight)/3;

set(gcf,'Position',[FigX,FigY,FigWidth,FigHeight])

hold on

% On trace d'abord les images...
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            switch CheckLogColormap
                case 1
                    MapData = exp(get(lesInd(i),'CData'));
                    imagesc([XLim(1):(XLim(2)-XLim(1))/(size(MapData,2)-1):XLim(2)],[YLim(1):(YLim(2)-YLim(1))/(size(MapData,1)-1):YLim(2)],log(MapData))
                case 0
                    MapData = get(lesInd(i),'CData');
                    imagesc([XLim(1):(XLim(2)-XLim(1))/(size(MapData,2)-1):XLim(2)],[YLim(1):(YLim(2)-YLim(1))/(size(MapData,1)-1):YLim(2)],MapData)
                    
            end 
            
            hc = colorbar('peer',gca,'vertical');
            %disp('read')
        end
    end
    
end

% ensuite les scatters
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if isequal(leType,'hggroup')
        
        scatter(get(lesInd(i),'XData'),get(lesInd(i),'YData'),1,get(lesInd(i),'CData'),'s','filled');
       
        hc = colorbar('peer',gca,'vertical');
    end
    
end


% ensuite les lignes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

% puis les textes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'text'
            LaPosition = get(lesInd(i),'Position');
            LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd(i),'String'));
            set(LeTxt,'Color',get(lesInd(i),'Color'),'BackgroundColor',get(lesInd(i),'BackgroundColor'), ...
                'FontName',get(lesInd(i),'FontName'),'FontSize',get(lesInd(i),'FontSize'));
        end
    end
end

set(gca,'DataAspectRatio',DataAspectRatio);

ha1 = gca;

set(ha1,'YDir',YDir);
set(ha1,{'xlim','ylim'},ZoomValues);
%set(ha1,'xtick',[], 'ytick',[]);
set(ha1,'box','on') 
set(ha1,'LineStyleOrder','-')
set(ha1,'LineWidth',1)

xlabel(XLabel)
ylabel(YLabel);

% Adjust first the colormap
colormap(CMap)
set(ha1,'CLim',CLim);

switch CheckLogColormap
    case 1
        Labels = get(hc,'YTickLabel');
        for i = 1:length(Labels) 
            Value = exp(str2num(char(Labels(i,:))));
            if Value >= 10
                LabelsOk{i} = num2str(round(Value),'%.0f');
            elseif Value >= 1
                LabelsOk{i} = num2str(Value,'%.2f');
            elseif Value >= 0.01
                LabelsOk{i} = num2str(Value,'%.4f');
            else
                LabelsOk{i} = num2str(Value,'%.6f');
            end
            
            %LabelsOk{i} = num2str(round(exp(str2num(Labels(i,:)))),'%.0f');
        end
        set(hc,'YTickLabel',LabelsOk);
end


return
% Hold export function (not working with the new function)...

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

Patterns = str2num(get(handles.DPText1,'String'));
Grids = str2num(get(handles.DPText2,'String'));
%Scans = str2num(get(handles.DPText3,'String'));

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));


figure,
if get(handles.IsLogColorbar,'Value')
    DensityPlotBinaryInternal(x,y,Patterns,Grids,[Xmin,Xmax,Ymin,Ymax],'log');
else
    DensityPlotBinaryInternal(x,y,Patterns,Grids,[Xmin,Xmax,Ymin,Ymax],'linear');
end

axis([Xmin Xmax Ymin Ymax])

%DensityPlot(x,y,Patterns,Grids,Scans,[Xmin,Xmax,Ymin,Ymax]);
%axis([Xmin Xmax Ymin Ymax])
%colorbar horizontal

%xlabel(Data(OnPlot(1)).label);
%ylabel(Data(OnPlot(2)).label);

%guidata(hObject, handles);
return


% *** EXPORT MAIN-GRAPH V1.5.1
function ExportAxes1_Callback(hObject, eventdata, handles)


% La maintenant la grande question est comment r?cup?rer la colorbar
axes(handles.axes1)
CMap = colormap;

lesInd = get(handles.axes1,'child');

YDir = get(handles.axes1,'YDir');
XLim = get(handles.axes1,'XLim');
YLim = get(handles.axes1,'YLim');

leXLabel = get(get(handles.axes1,'XLabel'),'String');
leYLabel = get(get(handles.axes1,'YLabel'),'String');

figure, 
hold on

% On trace d'abord les images...
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            imagesc(get(lesInd(i),'CData')), axis image
        end
    end
    
end

% ensuite les lignes
for i=length(lesInd):-1:1
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

% puis les textes
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 4
        if leType == 'text'
            LaPosition = get(lesInd(i),'Position');
            LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd(i),'String'));
            set(LeTxt,'Color',get(lesInd(i),'Color'),'BackgroundColor',get(lesInd(i),'BackgroundColor'), ...
                'FontName',get(lesInd(i),'FontName'),'FontSize',get(lesInd(i),'FontSize'));
        end
    end
end


set(gca,'YDir',YDir);
%set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)
set(gca,'XLim',XLim)
set(gca,'YLim',YLim)

xlabel(leXLabel);
ylabel(leYLabel);


% Data = handles.Data;
% OnPlot(1) = get(handles.PPSerieX,'Value');
% OnPlot(2) = get(handles.PPSerieY,'Value');
% 
% x = Data(OnPlot(1)).values;
% y = Data(OnPlot(2)).values;
% 
% Xmin = str2num(get(handles.Xmin,'String'));
% Xmax = str2num(get(handles.Xmax,'String'));
% Ymin = str2num(get(handles.Ymin,'String'));
% Ymax = str2num(get(handles.Ymax,'String'));
% 
% figure, 
% plot(x,y,'.k','markersize',1)
% axis([Xmin Xmax Ymin Ymax])
% 
% xlabel(Data(OnPlot(1)).label);
% ylabel(Data(OnPlot(2)).label);
% 
% guidata(hObject, handles);
return


% *** IDENTIFY PIXELS V1.5.1
function Return2Map_Callback(hObject, eventdata, handles)

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

% Here we apply a cleaning step if we come from masks (2.6.1)
if get(handles.MaskFileMenu,'Value') > 1
    set(handles.MaskFileMenu,'Value',1);
    XYPlot_Callback(OnPlot, hObject, eventdata, handles);
end

if handles.colorbar ~= 1
    CleanA1_Callback(hObject, eventdata, handles);
end

cla(handles.axes2);
set(handles.axes2,'Visible','off');

%XYPlot_Callback(OnPlot, hObject, eventdata, handles)
%cla(handles.axes2)
%set(handles.axes2,'Visible','off')
% cla(handles.axesCarto)
% set(handles.axesCarto,'Visible','off')
% set(handles.CleanA1,'Visible','off')

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));

axes(handles.axes1);

P1 = ginput(1);
hold on, 
plot(P1(1),P1(2),'.r','linewidth',2,'markersize',10)
P2 = ginput(1);
hold on
plot(P2(1),P2(2),'.r','linewidth',2,'markersize',10)
plot([P1(1),P2(1)],[P1(2),P1(2)],'-r')
plot([P2(1),P2(1)],[P1(2),P2(2)],'-r')
plot([P2(1),P1(1)],[P2(2),P2(2)],'-r')
plot([P1(1),P1(1)],[P2(2),P1(2)],'-r')
hold off

XXmin = min(P1(1),P2(1));
XXmax = max(P1(1),P2(1));
YYmin = min(P1(2),P2(2));
YYmax = max(P1(2),P2(2));

LeMask = zeros(Data(OnPlot(1)).reshape);
SelectedPx = ones(Data(OnPlot(1)).reshape);
OuiMask = 0;

for i=1:length(x)
    if x(i) <= XXmax && x(i) >= XXmin && y(i) <= YYmax && y(i) >= YYmin
        LeMask(i) = 2.5;
        SelectedPx(i) = 2; % Grp2
    elseif x(i) > 0 && y(i) > 0
        LeMask(i) = 1.5;
    else
        OuiMask = 1;
    end
end


handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Pour exporter le graph !
handles.export_iP.OuiMask = OuiMask;
handles.export_iP.LeMask = LeMask;

set(handles.CleanA1,'Visible','on')

%Img4Disp = reshape(LeMask(:),Data(OnPlot(1)).reshape(1),Data(OnPlot(1)).reshape(2));

set(handles.axesCarto,'Visible','on')
axes(handles.axesCarto)
imagesc(LeMask), axis image
set(handles.axesCarto,'XTick',[],'YTick',[]);

if OuiMask == 1
    colormap([0,0,0;0.2,0.3,1;1,0,0])
    
    if size(LeMask,2) > size(LeMask,1)
        hcb = colorbar('XTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
        set(hcb,'Location','SouthOutside');
        set(hcb,'XTickMode','manual','XTick',[0.5,1.5,2.5]);
    else
        hcb = colorbar('YTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
        set(hcb,'YTickMode','manual','YTick',[0.5,1.5,2.5]);
    end
    
	
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
else
    colormap([0.2,0.3,1;1,0,0])
   
    if size(LeMask,2) > size(LeMask,1)
        hcb = colorbar('XTickLabel',{'...','Selected'}); caxis([1 3]);
        set(hcb,'Location','SouthOutside');
        set(hcb,'XTickMode','manual','XTick',[1.5,2.5]);
    else
        hcb = colorbar('YTickLabel',{'...','Selected'}); caxis([1 3]);
        set(hcb,'YTickMode','manual','YTick',[1.5,2.5]);
    end
    
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
end

guidata(hObject, handles);

axes(handles.axes1)
hold on, plot(x(find(LeMask(:) == 2.5)),y(find(LeMask(:) == 2.5)),'.r','markersize',1)

set(handles.PanelIP,'Visible','on');
if OuiMask
    Nb1 = length(find(LeMask(:) == 2.5)) + length(find(LeMask(:) == 1.5));
else
    Nb1 = length(LeMask(:));
end
Nb2 = length(find(LeMask(:) == 2.5));
Nb3 = Nb2/Nb1*100;
Nb4 = 100-Nb3;
set(handles.DispNb1,'String',num2str(Nb1-Nb2));
set(handles.DispNb2,'String',num2str(Nb2));
set(handles.DispNb3,'String',[num2str(Nb3),' %']);
set(handles.DispNb4,'String',[num2str(Nb4),' %']);
set(handles.DispNb5,'String',num2str(Nb1));

return


% *** IDENTIFY PIXELS (FREE SHAPE) V2.5.1
function Return2MapFreeShape_Callback(hObject, eventdata, handles)

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));

axes(handles.axes1); 
hold on,

Compt = 0;
while 1
    Compt = Compt+1;
    [Xi,Yi,Button]= ginput(1);
    
    if Button > 2 && Compt > 2
        plot([P(Compt-1,1),P(1,1)],[P(Compt-1,2),P(1,2)],'-r')
        drawnow
        break
    end
    
    P(Compt,:) = [Xi,Yi];
    
    plot(P(Compt,1),P(Compt,2),'.r','MarkerSize',10);
    
    if Compt > 1
        plot([P(Compt-1,1),P(Compt,1)],[P(Compt-1,2),P(Compt,2)],'-r')
    end
    
    
    drawnow 
    
end

% Extract the pixels in the polygon
IN = inpolygon(x,y,P(:,1),P(:,2));
Indx = find(IN);

% Check if all the pixels have been defined (or not)
NonNull = find(x>0 & y>0);
Null = find(x==0 & y==0);

if isequal(length(NonNull),length(x)) 
    OuiMask = 0;
else
    OuiMask = 1;
end

LeMask = zeros(Data(OnPlot(1)).reshape);
LeMask(NonNull) = 1.5*ones(size(NonNull));
LeMask(Indx) = 2.5*ones(size(Indx));

SelectedPx = ones(Data(OnPlot(1)).reshape);
SelectedPx(Indx) = 2*ones(size(Indx));


handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Pour exporter le graph !
handles.export_iP.OuiMask = OuiMask;
handles.export_iP.LeMask = LeMask;


plot(x(Indx),y(Indx),'.r','markersize',1);

set(handles.CleanA1,'Visible','on')

set(handles.axesCarto,'Visible','on')
axes(handles.axesCarto)
imagesc(LeMask), axis image
set(handles.axesCarto,'XTick',[],'YTick',[]); 

   
if OuiMask == 1
    colormap([0,0,0;0.2,0.3,1;1,0,0])
    
    if size(LeMask,2) > size(LeMask,1)
        hcb = colorbar('XTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
        set(hcb,'Location','SouthOutside');
        set(hcb,'XTickMode','manual','XTick',[0.5,1.5,2.5]);
    else
        hcb = colorbar('YTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
        set(hcb,'YTickMode','manual','YTick',[0.5,1.5,2.5]);
    end
    
	
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
else
    colormap([0.2,0.3,1;1,0,0])
   
    if size(LeMask,2) > size(LeMask,1)
        hcb = colorbar('XTickLabel',{'...','Selected'}); caxis([1 3]);
        set(hcb,'Location','SouthOutside');
        set(hcb,'XTickMode','manual','XTick',[1.5,2.5]);
    else
        hcb = colorbar('YTickLabel',{'...','Selected'}); caxis([1 3]);
        set(hcb,'YTickMode','manual','YTick',[1.5,2.5]);
    end
    
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
end

guidata(hObject, handles);

%axes(handles.axes1)
%hold on, plot(x(find(LeMask(:) == 2.5)),y(find(LeMask(:) == 2.5)),'.r','markersize',1)

set(handles.PanelIP,'Visible','on');
if OuiMask
    Nb1 = length(find(LeMask(:) == 2.5)) + length(find(LeMask(:) == 1.5));
else
    Nb1 = length(LeMask(:));
end
Nb2 = length(find(LeMask(:) == 2.5));
Nb3 = Nb2/Nb1*100;
Nb4 = 100-Nb3;
set(handles.DispNb1,'String',num2str(Nb1-Nb2));
set(handles.DispNb2,'String',num2str(Nb2));
set(handles.DispNb3,'String',[num2str(Nb3),' %']);
set(handles.DispNb4,'String',[num2str(Nb4),' %']);
set(handles.DispNb5,'String',num2str(Nb1));

return


% *** CLEAN AXES V1.5.2
function CleanA1_Callback(hObject, eventdata, handles)
cla(handles.axes1)

axes(handles.axesCarto)
cla,
set(handles.axesCarto,'Visible','off');
colorbar('off');

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles);

set(handles.CleanA1,'Visible','off');

set(handles.PanelIP,'Visible','off');
set(handles.PanelMG,'Visible','off');

return


% *** BUILD A MASK FILE FROM IDENTIFY PIXELS  V1.5.2
function BuildMF(hObject, eventdata, handles)

Groups = handles.SelectedPx;

[Success,Message,MessageID] = mkdir('Maskfiles');

cd Maskfiles
    [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export maskfile as');
cd ..

 
if Directory
    NbGroups = max(Groups(:));
    
    Options = questdlg('Do you want to export only the selected pixels?', 'Maskfile','Yes', 'No', 'Yes');
    
    Selected = ones(1,NbGroups);
    
    switch Options
        case 'Yes'
            Selected(1) = 0;
    end
    
    Titles = {'Mask'};
    Names = {'Unselected'};
    for i = 2:NbGroups
        Names{i} = ['Selection_',num2str(i-1)];
        Titles{i} = 'Mask';
    end
    
    Names=inputdlg(Titles,'Maskfile',1,Names);
    
    
    % Save the maskfile (as before 1.5.2)
    
    save([char(pathname),char(Directory)],'Groups','-ASCII');
    
    
    fid = fopen([char(pathname),'info_',char(Directory)],'w');
    
    fprintf(fid,'%s\n','     ---------------------------------------------------');
    fprintf(fid,'%s\n','     | Information for maskfile generated by XMapTools |');
    fprintf(fid,'%s\n\n','     ---------------------------------------------------');
     
     
    fprintf(fid,'\n%s\n','>1 Type');
    fprintf(fid,'%s\n\n','2        | Maskfile generated by an XMapTools module');
    
    fprintf(fid,'\n%s\n','>2 Selected masks for import in XMapTools');
    for i = 1:length(Selected)
        fprintf(fid,'%.0f\n',Selected(i));
    end
    
    fprintf(fid,'\n\n%s\n','>3 Mask names');
    for i = 1:length(Selected)
        fprintf(fid,'%s\n',char(Names{i}));
    end
    
    fprintf(fid,'\n\n');
    
    fclose(fid);
    
end







return


% --- Executes on button press in BuildMF1.
function BuildMF1_Callback(hObject, eventdata, handles)
BuildMF(hObject, eventdata, handles)
return

% --- Executes on button press in BuildMF2.
function BuildMF2_Callback(hObject, eventdata, handles)
BuildMF(hObject, eventdata, handles)
return



% *** MULTI_GROUPS V1.5.2
function Return2Map2_Callback(hObject, eventdata, handles)

if handles.colorbar ~= 1
    CleanA1_Callback(hObject, eventdata, handles);
end

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

axes(handles.axes1), cla, hold on
plot(x,y,'.k','markersize',1);

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));


clique = 1;
ComptResult = 0;
GrName(1) = {'NaM'};
    
while clique < 2
    ComptResult = ComptResult+1;
    [P1(ComptResult,1),P1(ComptResult,2),clique] = ginput(1);
    if clique > 2
        break
    end
    hold on, 
    plot(P1(ComptResult,1),P1(ComptResult,2),'.r','linewidth',2,'markersize',10)
    
    [P2(ComptResult,1),P2(ComptResult,2),clique] = ginput(1);
    hold on
    plot(P2(ComptResult,1),P2(ComptResult,2),'.r','linewidth',2,'markersize',10)

    plot([P1(ComptResult,1),P2(ComptResult,1)],[P1(ComptResult,2),P1(ComptResult,2)],'-r')
    plot([P2(ComptResult,1),P2(ComptResult,1)],[P1(ComptResult,2),P2(ComptResult,2)],'-r')
    plot([P2(ComptResult,1),P1(ComptResult,1)],[P2(ComptResult,2),P2(ComptResult,2)],'-r')
    plot([P1(ComptResult,1),P1(ComptResult,1)],[P2(ComptResult,2),P1(ComptResult,2)],'-r')
    
    XXmin(ComptResult) = min(P1(ComptResult,1),P2(ComptResult,1));
    XXmax(ComptResult) = max(P1(ComptResult,1),P2(ComptResult,1));
    YYmin(ComptResult) = min(P1(ComptResult,2),P2(ComptResult,2));
    YYmax(ComptResult) = max(P1(ComptResult,2),P2(ComptResult,2));
    
    GrName(ComptResult+1) = {['Grp ',num2str(ComptResult)]};
    
    leTxt = text(P1(ComptResult,1),P1(ComptResult,2),[char(num2str(ComptResult))]);
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',9)
    
    
end
hold off

set(handles.CleanA1,'Visible','on')

TheColors = [0,0,0;hsv(ComptResult-1)];

LeMask = zeros(Data(OnPlot(1)).reshape);
SelectedPx = ones(Data(OnPlot(1)).reshape);

axes(handles.axes1), hold on

for i = 1:ComptResult-1    
    Indx = find(x <= XXmax(i) & x >= XXmin(i) & y <= YYmax(i) & y >= YYmin(i));
    
    LeMask(Indx) = i*ones(size(Indx));
    SelectedPx(Indx) = (i+1)*ones(size(Indx));
    
    plot(x(Indx),y(Indx),'.','markersize',1,'MarkerFaceColor',TheColors(i+1,:),'MarkerEdgeColor',TheColors(i+1,:));
    drawnow
end

%h = waitbar(0,'Please wait...');
% for iM=1:length(XXmin)
%     waitbar(iM/length(XXmin),h)
%     for i=1:length(x)
%         if x(i) <= XXmax(iM) && x(i) >= XXmin(iM) && y(i) <= YYmax(iM) && y(i) >= YYmin(iM)
%             LeMask(i) = iM;
%             SelectedPx(i) = iM+1;   % OR THE EXPORTED MASK WILL BE WRONG !!! P. LANARI 3.06.2014
%         end
%     end
% end
%close(h)

handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Pour exporter l'image
handles.export_MG.LeMask = LeMask;
handles.export_MG.GrName = GrName;

axes(handles.axesCarto)
imagesc(LeMask)
axis image,
colormap([0,0,0;hsv(length(XXmin))])

if size(LeMask,2) > size(LeMask,1)
    hcb = colorbar('XTickLabel',GrName); caxis([0 length(XXmin)+1]);
    set(hcb,'Location','SouthOutside');
    set(hcb,'XTickMode','manual','XTick',[0.5:1:length(XXmin)+0.5]);
else
    hcb = colorbar('YTickLabel',GrName); caxis([0 length(XXmin)+1]);
    set(hcb,'YTickMode','manual','YTick',[0.5:1:length(XXmin)+0.5]);
end

set(gca,'XTick',[],'YTick',[]) 
handles.colorbar = hcb;
set(hcb,'FontName','Times New Roman');


% hcb = colorbar('YTickLabel',GrName); caxis([0 length(XXmin)+1]);
% set(hcb,'YTickMode','manual','YTick',[0.5:1:length(XXmin)+0.5]);


% figure, imagesc(medfilt2(LeMask,[2,2]))
% axis image
% colormap([0,0,0;jet(length(XXmin))])
% hcb = colorbar('YTickLabel',GrName); caxis([0 length(XXmin)+1]);
% set(hcb,'YTickMode','manual','YTick',[0.5:1:length(XXmin)+0.5]);
% title('Groups with medianfilter [2 2]')
% set(gca,'XTick',[],'YTick',[])

handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

guidata(hObject, handles);


% Mise a jour 1.5 Affichage du module "Chemical groups"
set(handles.PanelMG,'Visible','on');


% Affichage des proportions (new 1.5)
for i=1:max(LeMask(:))
    NbPx(i) = length(find(LeMask == i));
end
NbTot = length(LeMask(:));
NbSel = sum(NbPx);
NbRest = NbTot-NbSel;

Chaine = 'Map proportions: ';
for i=1:length(NbPx)
    Chaine = [Chaine,'Grp ',char(num2str(i)),': ',char(num2str(NbPx(i)/NbTot*100)),'% ; '];
end
Chaine = [Chaine,'NaM: ',char(num2str(NbRest/NbTot*100)),'%'];
    
set(handles.AffProp,'String',Chaine);


return



% *** MULTI_GROUPS (FREE SHAPE)V2.5.1
function Return2Map2FreeShape_Callback(hObject, eventdata, handles)

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

axes(handles.axes1), cla, hold on
plot(x,y,'.k','markersize',1);

Xmin = str2num(get(handles.Xmin,'String'));
Xmax = str2num(get(handles.Xmax,'String'));
Ymin = str2num(get(handles.Ymin,'String'));
Ymax = str2num(get(handles.Ymax,'String'));


clique = 1;
ComptResult = 0;
GrName(1) = {'NaM'};

axes(handles.axes1), hold on
while 1
    % Add a new group
    
    ComptResult = ComptResult+1;
    GrName(ComptResult+1) = {['Grp ',num2str(ComptResult)]};
    
    Compt = 0;
    P = [];
    while 1
        Compt = Compt+1;
        [Xi,Yi,Button]= ginput(1);

        if Button > 2 && Compt > 2
            plot([P(Compt-1,1),P(1,1)],[P(Compt-1,2),P(1,2)],'-r')
            drawnow
            %P(Compt,:) = [Xi,Yi];
            break
        end

        P(Compt,:) = [Xi,Yi];

        plot(P(Compt,1),P(Compt,2),'.r','MarkerSize',10);

        if Compt > 1
            plot([P(Compt-1,1),P(Compt,1)],[P(Compt-1,2),P(Compt,2)],'-r')
        end
        drawnow 

    end
    
    leTxt = text(P(1,1),P(1,2),[char(num2str(ComptResult))]);
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',9)

    Poly(ComptResult).P = P;
    
    
    % Ask if the user wants to add a new group
    ButtonName = questdlg('Do you want to add one more group?','Binary Module','Yes', 'No (continue)', 'Yes');
    switch ButtonName
        case 'No (continue)'
            break
    end
end

TheColors = [0,0,0;hsv(ComptResult)];

LeMask = zeros(Data(OnPlot(1)).reshape);
SelectedPx = ones(Data(OnPlot(1)).reshape);

axes(handles.axes1), hold on
for i = 1:ComptResult
    % Extract the pixels in the polygon
    IN = inpolygon(x,y,Poly(i).P(:,1),Poly(i).P(:,2));
    Indx = find(IN);
    
    LeMask(Indx) = i*ones(size(Indx));
    SelectedPx(Indx) = (i+1)*ones(size(Indx));
    
    plot(x(Indx),y(Indx),'.','markersize',1,'MarkerFaceColor',TheColors(i+1,:),'MarkerEdgeColor',TheColors(i+1,:));
    drawnow
end

handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Pour exporter l'image
handles.export_MG.LeMask = LeMask;
handles.export_MG.GrName = GrName;

axes(handles.axesCarto)
imagesc(LeMask)
axis image,
colormap([0,0,0;hsv(ComptResult)])

if size(LeMask,2) > size(LeMask,1)
    hcb = colorbar('XTickLabel',GrName); caxis([0 ComptResult+1]);
    set(hcb,'Location','SouthOutside');
    set(hcb,'XTickMode','manual','XTick',[0.5:1:ComptResult+0.5]);
else
    hcb = colorbar('YTickLabel',GrName); caxis([0 ComptResult+1]);
    set(hcb,'YTickMode','manual','YTick',[0.5:1:ComptResult+0.5]);
end

set(gca,'XTick',[],'YTick',[]) 
handles.colorbar = hcb;
set(hcb,'FontName','Times New Roman');

set(handles.CleanA1,'Visible','on')

handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

guidata(hObject, handles);


% Mise a jour 1.5 Affichage du module "Chemical groups"
set(handles.PanelMG,'Visible','on');


% Affichage des proportions (new 1.5)
for i=1:max(LeMask(:))
    NbPx(i) = length(find(LeMask == i));
end
NbTot = length(LeMask(:));
NbSel = sum(NbPx);
NbRest = NbTot-NbSel;

Chaine = 'Map proportions: ';
for i=1:length(NbPx)
    Chaine = [Chaine,'Grp ',char(num2str(i)),': ',char(num2str(NbPx(i)/NbTot*100)),'% ; '];
end
Chaine = [Chaine,'NaM: ',char(num2str(NbRest/NbTot*100)),'%'];
    
set(handles.AffProp,'String',Chaine);


return


% *** EXPORT-MAP IDENT. PIXELS (V1.5.2)
function ExportM1_Callback(hObject, eventdata, handles)
% Save pour exporter le graph
OuiMask = handles.export_iP.OuiMask;
LeMask = handles.export_iP.LeMask;

figure,
imagesc(LeMask), axis image
set(gca,'XTick',[],'YTick',[]);


% Fonctionnalit? 1.5
if OuiMask == 1
    colormap([0,0,0;0.2,0.3,1;1,0,0])
    hcb = colorbar('YTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
	set(hcb,'YTickMode','manual','YTick',[0.5,1.5,2.5]);

else
    colormap([0,0,0;1,0,0])
    hcb = colorbar('YTickLabel',{'...','Selected'}); caxis([1 3]);
	set(hcb,'YTickMode','manual','YTick',[1.5,2.5]);

end

return


% *** EXPORT-MAP MULTI-GRPS (V1.5.2)
function ExportM2_Callback(hObject, eventdata, handles)


LeMask = handles.export_MG.LeMask;
GrName = handles.export_MG.GrName;

figure, 
imagesc(LeMask)
axis image,
colormap([0,0,0;hsv(max(LeMask(:)))])
hcb = colorbar('YTickLabel',GrName); caxis([0 max(LeMask(:))+1]);
set(hcb,'YTickMode','manual','YTick',[0.5:1:max(LeMask(:))+0.5]);

set(gca,'XTick',[],'YTick',[]);

return


% Sampling
function Sampling_Callback(hObject, eventdata, handles)
axes(handles.axes1);
[leX,leY] = ginput(1);


set(handles.dispX,'String',num2str(leX),'Visible','on');
set(handles.dispY,'String',num2str(leY),'Visible','on');

return


% ON EST ICI


% --- Executes during object creation, after setting all properties.
function PPSerieX_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function PPSerieY_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Xmin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Xmax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Ymin_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Ymax_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DPText1_Callback(hObject, eventdata, handles)
% hObject    handle to DPText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function DPText1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPText1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function DPText2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPText2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function DPText3_Callback(hObject, eventdata, handles)
% hObject    handle to DPText3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function DPText3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DPText3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NbXbars_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NbYbars_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function CheckForLog(handles)
%
if get(handles.IsLogY,'Value')
    set(handles.axes1,'YScale','log','FontSize',10);
    set(handles.axes2,'YScale','log','FontSize',10);
    set(handles.histY,'XScale','log');
    
else
    set(handles.axes1,'YScale','linear','FontSize',10);
    set(handles.axes2,'YScale','linear','FontSize',10);
    set(handles.histY,'XScale','linear');
end

if get(handles.IsLogX,'Value')
    set(handles.axes1,'XScale','log','FontSize',10);
    set(handles.axes2,'XScale','log','FontSize',10);
    set(handles.histX,'XScale','log');
else
    set(handles.axes1,'XScale','linear','FontSize',10);
    set(handles.axes2,'XScale','linear','FontSize',10);
    set(handles.histX,'XScale','linear');
end

if get(handles.IsLogY,'Value') || get(handles.IsLogX,'Value')
    set(handles.DensityPlotCompute,'Enable','Off');
    set(handles.DPText1,'Enable','Off');
    set(handles.DPText2,'Enable','Off');
    set(handles.IsLogColorbar,'Enable','Off');
else
    set(handles.DensityPlotCompute,'Enable','On');
    set(handles.DPText1,'Enable','On');
    set(handles.DPText2,'Enable','On');
    set(handles.IsLogColorbar,'Enable','On');
end

drawnow
return

% --- Executes on button press in IsLogY.
function IsLogY_Callback(hObject, eventdata, handles)
%
CleanA1_Callback(hObject, eventdata, handles)
CloseDens_Callback(hObject, eventdata, handles);
CheckForLog(handles);
return


% --- Executes on button press in IsLogX.
function IsLogX_Callback(hObject, eventdata, handles)
%
CleanA1_Callback(hObject, eventdata, handles)
CloseDens_Callback(hObject, eventdata, handles);
CheckForLog(handles);
return


% --- Executes on button press in CloseDens.
function CloseDens_Callback(hObject, eventdata, handles)
%
set(handles.ExportsAxes2,'Visible','off');

set(handles.MaskFileMenu,'Visible','on');
set(handles.RunKmeans,'Visible','on');
set(handles.KmeansMethods,'Visible','on');
set(handles.PlotOriginal,'Visible','on');
set(handles.PlotMap,'Visible','on');

set(handles.PPSerieX,'Enable','on');
set(handles.PPSerieY,'Enable','on');


axes(handles.axes2),
colorbar('off')
cla

set(handles.axes2,'Visible','off');
set(handles.axes1,'Visible','on')
set(handles.CloseDens,'Visible','off');
set(handles.ButtonIndentify,'Enable','on');
set(handles.MenuIdentify,'Enable','on');
set(handles.ExportAxes1,'Visible','on');
XYPlot_Callback([get(handles.PPSerieX,'Value'),get(handles.PPSerieY,'Value')], hObject, eventdata, handles);
return


% --- Executes on button press in IsLogColorbar.
function IsLogColorbar_Callback(hObject, eventdata, handles)
%

if isequal(get(handles.axes2,'Visible'),'on')
    CloseDens_Callback(hObject, eventdata, handles);
    CheckForLog(handles);
end
return


% --- Executes on button press in ButtonIndentify.
function ButtonIndentify_Callback(hObject, eventdata, handles)
%
CleanA1_Callback(hObject, eventdata, handles)
switch get(handles.MenuIdentify,'Value')
    case 1
        Return2Map_Callback(hObject, eventdata, handles);
        
    case 2
            
        Return2MapFreeShape_Callback(hObject, eventdata, handles);
        
    case 3    
        Return2Map2_Callback(hObject, eventdata, handles);
        
    case 4
        Return2Map2FreeShape_Callback(hObject, eventdata, handles);
end

return

% --- Executes on selection change in MenuIdentify.
function MenuIdentify_Callback(hObject, eventdata, handles)
%


% --- Executes during object creation, after setting all properties.
function MenuIdentify_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuIdentify (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% 


% --- Executes on button press in RunKmeans.
function RunKmeans_Callback(hObject, eventdata, handles)
% 

MaskFile = handles.MaskFile;

MinX = str2num(get(handles.Xmin,'String'));
MaxX = str2num(get(handles.Xmax,'String'));
MinY = str2num(get(handles.Ymin,'String'));
MaxY = str2num(get(handles.Ymax,'String'));


waitfor(warndlg({'You need to define the initial position for the centroid of each cluster', ...
    '[1] Click on the image to add a new cluster with the centroid at this position ', ...
    '[2] Validate your selection: right-clicking or click outside the figure axes '},'XMapTools'));

WeAreHappy = 0;
while 1
    
    if WeAreHappy
        break
    end
    
    % clean the figure
    CleanA1_Callback(hObject, eventdata, handles)
    axes(handles.axes1), hold on
    
    click = 1; ComptMask = 1;
    CenterPixels = [];
    while click < 2
        [SelPixel(1),SelPixel(2),click] = ginput(1); % we select the pixel
        
        
        if SelPixel(1) < MinX | SelPixel(2) < MinY | SelPixel(1) > MaxX | SelPixel(2) > MaxY
            break
        end
        
        if click < 2
            CenterPixels(ComptMask,:) = SelPixel;
            plot(CenterPixels(:,1),CenterPixels(:,2), 'mo','linewidth', 2)
            ComptMask = ComptMask+1;
            drawnow   % added 2.6.2
        end
        
        
        
    end
    
    if size(CenterPixels,1) > 1
    
        Reply = questdlg('Are you happy with this selection?');

        switch Reply
            case 'Yes'
                WeAreHappy = 1;
            case 'Cancel'
                return
        end
    
    else
        errordlg('You need to define at least two clusters','XMapTools')
        return
    end
    
end

%
NbMask = size(CenterPixels,1);

Data = handles.Data;
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;

IndOk = find(x > 0 & y > 0);

xk = x(IndOk);
yk = y(IndOk);

MethodList = get(handles.KmeansMethods,'String');
MethodSelected = get(handles.KmeansMethods,'Value');

h = waitbar(1,'XMapTools is running numbers; please wait...');
Groups = XkmeansX([xk,yk], NbMask, 'start', CenterPixels,'Distance',char(MethodList{MethodSelected}));  %'MaxIter',0
close(h);

Classification = zeros(size(x));
Classification(IndOk) = Groups;


% Add a new maskfile
MaskList = get(handles.MaskFileMenu,'String');
if ~iscell(MaskList)
    Text = MaskList;
    clear MaskList
    MaskList{1} = Text;
end

Where = length(MaskList)+1;

Els1 = get(handles.PPSerieX,'String');
El1 = char(Els1{OnPlot(1)});
Els2 = get(handles.PPSerieY,'String');
El2 = char(Els1{OnPlot(2)});

NewName = char(inputdlg({'Maskfile name'},'XMapTools',1,{['MaskFile-',num2str(Where-1),'-',El1,'vs',El2,'-',num2str(NbMask),'-clusters']}));

MaskList{Where} = NewName;
set(handles.MaskFileMenu,'String',MaskList,'Value',Where);


MaskFile(Where).Name = NewName;
MaskFile(Where).InitialCentroids = CenterPixels;
MaskFile(Where).Classification = Classification;
MaskFile(Where).Binary = OnPlot;
MaskFile(Where).Lims = [MinX,MaxX,MinY,MaxY];
MaskFile(Where).Method = MethodSelected;

handles.MaskFile = MaskFile;
guidata(hObject, handles);


% Finally, we plot...
XYPlot_Callback(OnPlot, hObject, eventdata, handles)

return











% --- Executes on selection change in MaskFileMenu.
function MaskFileMenu_Callback(hObject, eventdata, handles)
% 
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
return


% --- Executes during object creation, after setting all properties.
function MaskFileMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaskFileMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in PlotOriginal.
function PlotOriginal_Callback(hObject, eventdata, handles)
%
MaskFile = handles.MaskFile;

Where = get(handles.MaskFileMenu,'Value');
OnPlot = MaskFile(Where).Binary;

set(handles.Xmin,'String',num2str(MaskFile(Where).Lims(1)));
set(handles.Xmax,'String',num2str(MaskFile(Where).Lims(2)));
set(handles.Ymin,'String',num2str(MaskFile(Where).Lims(3)));
set(handles.Ymax,'String',num2str(MaskFile(Where).Lims(4)));

XYPlot_Callback(OnPlot, hObject, eventdata, handles)
%MaskFile(Where).Lims = [MinX,MaxX,MinY,MaxY];
return


% --- Executes on button press in PlotMap.
function PlotMap_Callback(hObject, eventdata, handles)
%
OnPlot(1) = get(handles.PPSerieX,'Value');
OnPlot(2) = get(handles.PPSerieY,'Value');

XYPlot_Callback(OnPlot, hObject, eventdata, handles);
return


% --- Executes on selection change in KmeansMethods.
function KmeansMethods_Callback(hObject, eventdata, handles)
%

% Check if we have a mask displayed
SelectedMask = get(handles.MaskFileMenu,'Value');
if SelectedMask > 1
    
    MaskFile = handles.MaskFile;
    
    MethodUsed = MaskFile(SelectedMask).Method;
    MethodSelected = get(handles.KmeansMethods,'Value');
    
    
    if ~isequal(MethodUsed,MethodSelected)
        
        % we udpate the maskfile
        
        CenterPixels = MaskFile(SelectedMask).InitialCentroids;
        
        NbMask = size(CenterPixels,1);
        
        Data = handles.Data;
        OnPlot(1) = MaskFile(SelectedMask).Binary(1);
        OnPlot(2) = MaskFile(SelectedMask).Binary(2);
        
        x = Data(OnPlot(1)).values;
        y = Data(OnPlot(2)).values;
        
        IndOk = find(x > 0 & y > 0);
        
        xk = x(IndOk);
        yk = y(IndOk);
        
        MethodList = get(handles.KmeansMethods,'String');
        
        h = waitbar(1,'XMapTools is running numbers; please wait...');
        Groups = XkmeansX([xk,yk], NbMask, 'start', CenterPixels,'Distance',char(MethodList{MethodSelected}));  %'MaxIter',0
        close(h);
        
        Classification = zeros(size(x));
        Classification(IndOk) = Groups;
        
        Where = SelectedMask;
        
        % We only update part of the maskfile:
        MaskFile(Where).Classification = Classification;
        MaskFile(Where).Method = MethodSelected;

        handles.MaskFile = MaskFile;
        guidata(hObject, handles);
        
        
        % Finally, we plot...
        XYPlot_Callback(OnPlot, hObject, eventdata, handles)
        
    end
    
end
    
    
    
    



% --- Executes during object creation, after setting all properties.
function KmeansMethods_CreateFcn(hObject, eventdata, handles)
% hObject    handle to KmeansMethods (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
