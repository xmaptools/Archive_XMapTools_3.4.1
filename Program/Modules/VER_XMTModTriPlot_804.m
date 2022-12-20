function varargout = VER_XMTModTriPlot_804(varargin)
% VER_XMTMODTRIPLOT_804 M-file for VER_XMTModTriPlot_804.fig
%      VER_XMTMODTRIPLOT_804, by itself, creates a new VER_XMTMODTRIPLOT_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODTRIPLOT_804 returns the handle to a new VER_XMTMODTRIPLOT_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODTRIPLOT_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODTRIPLOT_804.M with the given input arguments.
%
%      VER_XMTMODTRIPLOT_804('Property','Value',...) creates a new VER_XMTMODTRIPLOT_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModTriPlot_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModTriPlot_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModTriPlot_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:35:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModTriPlot_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModTriPlot_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModTriPlot_804 is made visible.
function VER_XMTModTriPlot_804_OpeningFcn(hObject, eventdata, handles, varargin)

set(handles.axesCarto,'Visible','off');
set(handles.CleanA1,'Visible','off');

LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

handles.colorbar = 1; % do not clean the colorbar

if length(varargin) < 3 || length(varargin)-3 ~= length(varargin{end-2})
    disp('Error')
    handles.output = 0;
    guidata(hObject, handles);
    return
end

LabelsC(1) = {'Unused'};
% - - - Data organisation - - -
for i=1:length(varargin)-3
    Data(i).values = varargin{i}(:);
    Data(i).label = varargin{end-2}(i);
    Labels(i) = Data(i).label;
    LabelsC(i+1) = Data(i).label;
    Data(i).reshape = varargin{end-1};
end

PositionXMapTools = varargin{end};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.9]);

set(gcf,'Position',PositionGui);


% - - - Plot - - -
OnPlot(1) = 1;
OnPlot(2) = 2;
OnPlot(3) = 3;

x = Data(OnPlot(1)).values;
y = Data(OnPlot(2)).values;
z = Data(OnPlot(3)).values;

% axes(handles.axes1);
% DisplayTriPlot([x(:),y(:),z(:)],Data(OnPlot(1)).label,Data(OnPlot(3)).label,Data(OnPlot(2)).label);
% set(handles.axes1,'xtick',[], 'ytick',[]);

% - - - Update Labels - - -
Gris = 0.4;
set(handles.PoPD1,'String',Labels);
set(handles.PoPD1,'Value',OnPlot(1));

set(handles.PoPD1a,'String',LabelsC,'Value',1);
set(handles.PoPD1b,'String',LabelsC,'Value',1);

set(handles.PoPD1a, 'ForegroundColor',[Gris Gris Gris])
set(handles.PoPD1b, 'ForegroundColor',[Gris Gris Gris])

set(handles.PoPD2,'String',Labels);
set(handles.PoPD2,'Value',OnPlot(2));

set(handles.PoPD2a,'String',LabelsC,'Value',1);
set(handles.PoPD2b,'String',LabelsC,'Value',1);

set(handles.PoPD2a, 'ForegroundColor',[Gris Gris Gris])
set(handles.PoPD2b, 'ForegroundColor',[Gris Gris Gris])

set(handles.PoPD3,'String',Labels);
set(handles.PoPD3,'Value',OnPlot(3));

set(handles.PoPD3a,'String',LabelsC,'Value',1);
set(handles.PoPD3b,'String',LabelsC,'Value',1);

set(handles.PoPD3a, 'ForegroundColor',[Gris Gris Gris])
set(handles.PoPD3b, 'ForegroundColor',[Gris Gris Gris])



% - - - Variable save - - - 
handles.Data = Data;
handles.Gris = Gris;

% Update the plot (new 2.6.2)
MenDerChoice_Callback(hObject, eventdata, handles);

handles.output = hObject;

% Update handles structure
guidata(hObject, handles);



% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModTriPlot_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% #########################################################################
%     G E N E R A L E S      F U N C T I O N S
% #########################################################################

% --- HIDE DENSITY PLOT
function [] = HideThisPlot(Hide,hObject,handles)
%

switch Hide
    case 1
        axes(handles.axes2)
        hc = colorbar;
        cla
        set(hc,'Visible','off')
        set(handles.axes2,'Visible','off');
        
    case 0
        
        set(handles.axes2,'Visible','on');
        
        MenDerChoice_Callback(hObject, [], handles);
        
end 

guidata(hObject, handles);
return

% --- PLOT FUNCTION (CHANGEMENT DES MENUS DEROULANTS)
function [x,y,z,xDisp,yDisp,zDisp] = MenDerChoice_Callback(hObject, eventdata, handles)

set(handles.CleanA1,'Visible','off');

if isequal(get(handles.axesCarto,'Visible'),'on');
    
    % We cannot use the cleaning function here (recursive call)
    cla(handles.axesCarto);
    set(handles.axesCarto,'Visible','off');
    
    hcb = handles.colorbar; % 1.5
    set(hcb,'Visible','off'); % 1.5
    
    % Mise a jour 1.5 Cacher le module "Chemical groups"
    set(handles.ChemicalPanel,'Visible','off');
    set(handles.ChemicalPanel2,'Visible','off');
end

% - - - Plot - - -
Gris = handles.Gris;
Data = handles.Data;

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');

Add1a = get(handles.PoPD1a,'Value');
Add1b = get(handles.PoPD1b,'Value');
Add2a = get(handles.PoPD2a,'Value');
Add2b = get(handles.PoPD2b,'Value');
Add3a = get(handles.PoPD3a,'Value');
Add3b = get(handles.PoPD3b,'Value');

% D1
x = Data(OnPlot(1)).values;
xDisp = Data(OnPlot(1)).label;
if Add1a > 1
    x = x + Data(Add1a-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1a-1).label);
    set(handles.PoPD1a, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD1a, 'ForegroundColor',[Gris Gris Gris])
end
if Add1b > 1
    x = x + Data(Add1b-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1b-1).label);
    set(handles.PoPD1b, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD1b, 'ForegroundColor',[Gris Gris Gris])
end

% D2 
y = Data(OnPlot(2)).values;
yDisp = Data(OnPlot(2)).label;
if Add2a > 1
    y = y + Data(Add2a-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2a-1).label);
	set(handles.PoPD2a, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD2a, 'ForegroundColor',[Gris Gris Gris])
end
if Add2b > 1
    y = y + Data(Add2b-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2b-1).label);
	set(handles.PoPD2b, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD2b, 'ForegroundColor',[Gris Gris Gris])
end

% D3
z = Data(OnPlot(3)).values;
zDisp = Data(OnPlot(3)).label;
if Add3a > 1
    z = z + Data(Add3a-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3a-1).label);
    set(handles.PoPD3a, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD3a, 'ForegroundColor',[Gris Gris Gris])
end
if Add3b > 1
    z = z + Data(Add3b-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3b-1).label);
    set(handles.PoPD3b, 'ForegroundColor',[0 0 0])
else
    set(handles.PoPD3b, 'ForegroundColor',[Gris Gris Gris])
end

axes(handles.axes1);
DisplayTriPlot([x(:),y(:),z(:)],xDisp,yDisp,zDisp);
set(handles.axes1,'xtick',[], 'ytick',[]);

if ~isequal(OnPlot(1),OnPlot(2)) && ~isequal(OnPlot(1),OnPlot(3)) && ~isequal(OnPlot(2),OnPlot(3)) 
    axes(handles.axes2);
    Grids = str2num(get(handles.Grids,'String'));
    DensityTriPlot2([x(:),y(:),z(:)],xDisp,yDisp,zDisp,Grids,handles)
    set(handles.axes2,'xtick',[], 'ytick',[]);
else
    HideThisPlot(1,hObject,handles)
end

guidata(hObject, handles);
return


% --- EXPORT LE GRAPH PRINCIPAL
function Export1_Callback(hObject, eventdata, handles)

% La maintenant la grande question est comment r?cup?rer la colorbar
axes(handles.axes1)
CMap = colormap;

lesInd = get(handles.axes1,'child');

YDir = get(handles.axes1,'YDir');
XLim = get(handles.axes1,'XLim');
YLim = get(handles.axes1,'YLim');

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
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)
set(gca,'XLim',XLim)
set(gca,'YLim',YLim)


if isequal(get(handles.axes2,'Visible'),'on');
    Export2_Callback(hObject, eventdata, handles)
end





return


% --- PLOT DENSITY MAP
function Plot_Callback(hObject, eventdata, handles)
Data = handles.Data;

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');


Add1a = get(handles.PoPD1a,'Value');
Add1b = get(handles.PoPD1b,'Value');
Add2a = get(handles.PoPD2a,'Value');
Add2b = get(handles.PoPD2b,'Value');
Add3a = get(handles.PoPD3a,'Value');
Add3b = get(handles.PoPD3b,'Value');

% D1
x = Data(OnPlot(1)).values;
xDisp = Data(OnPlot(1)).label;
if Add1a > 1
    x = x + Data(Add1a-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1a-1).label);
end
if Add1b > 1
    x = x + Data(Add1b-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1b-1).label);
end

% D2 
y = Data(OnPlot(2)).values;
yDisp = Data(OnPlot(2)).label;
if Add2a > 1
    y = y + Data(Add2a-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2a-1).label);
end
if Add2b > 1
    y = y + Data(Add2b-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2b-1).label);
end

% D3
z = Data(OnPlot(3)).values;
zDisp = Data(OnPlot(3)).label;
if Add3a > 1
    z = z + Data(Add3a-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3a-1).label);
end
if Add3b > 1
    z = z + Data(Add3b-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3b-1).label);
end

%Patterns = str2num(get(handles.Patterns,'String'));
Grids = str2num(get(handles.Grids,'String'));
%Scans = str2num(get(handles.MedianF,'String'));


axes(handles.axes2);
DensityTriPlot2([x(:),y(:),z(:)],xDisp,yDisp,zDisp,Grids,handles)
set(handles.axes2,'xtick',[], 'ytick',[]);

guidata(hObject, handles);
return


% --- NEW FUNCTION FOR DENSITY PLOT (2.6.2)
function [] = DensityTriPlot2(Data,nameA,nameB,nameC,Grids,handles)
%



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

% Variables:
X = Xc+(1-(Xc+Xa))./2;
Y = Xb;

Xmin = 0;
Xmax = 1;
Ymin = 0;
Ymax = 1;


if get(handles.IsLogColorbar,'Value')
    DensityPlotBinaryInternal(X,Y,Grids,[Xmin,Xmax,Ymin,Ymax],'log');
else
    DensityPlotBinaryInternal(X,Y,Grids,[Xmin,Xmax,Ymin,Ymax],'linear');
end

%axis([Xmin Xmax Ymin Ymax])
hold on

%set(gca,'YDir','normal')


plot([0,0.5,1,0],[0,1,0,0],'-k')
axis([-0.12 1.12 -0.12 1.12])

text(0-(length(char(a))/2)*0.018,-0.05,char(a))
text(0.5-(length(char(b))/2)*0.018,1.05,char(b))
text(1-(length(char(c))/2)*0.018,-0.05,char(c))

hold off

%        set(handles.CloseDens,'Visible','on');
%set(handles.Export2,'Visible','on');








return





function [OnTrace] = DensityPlotBinaryInternal(E1,E2,MapSize,Lims,mode)
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
X = E1(find(~isnan(E1)));
Y = E2(find(~isnan(E2)));

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

OnTrace = accumarray(bin,1,nbins([2 1]));  %  

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




% --- EXPORT DENSITY MAP
function Export2_Callback(hObject, eventdata, handles)
Data = handles.Data;

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');

Add1a = get(handles.PoPD1a,'Value');
Add1b = get(handles.PoPD1b,'Value');
Add2a = get(handles.PoPD2a,'Value');
Add2b = get(handles.PoPD2b,'Value');
Add3a = get(handles.PoPD3a,'Value');
Add3b = get(handles.PoPD3b,'Value');

% D1
x = Data(OnPlot(1)).values;
xDisp = Data(OnPlot(1)).label;
if Add1a > 1
    x = x + Data(Add1a-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1a-1).label);
end
if Add1b > 1
    x = x + Data(Add1b-1).values;
    xDisp = strcat(xDisp,'+',Data(Add1b-1).label);
end

% D2 
y = Data(OnPlot(2)).values;
yDisp = Data(OnPlot(2)).label;
if Add2a > 1
    y = y + Data(Add2a-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2a-1).label);
end
if Add2b > 1
    y = y + Data(Add2b-1).values;
    yDisp = strcat(yDisp,'+',Data(Add2b-1).label);
end

% D3
z = Data(OnPlot(3)).values;
zDisp = Data(OnPlot(3)).label;
if Add3a > 1
    z = z + Data(Add3a-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3a-1).label);
end
if Add3b > 1
    z = z + Data(Add3b-1).values;
    zDisp = strcat(zDisp,'+',Data(Add3b-1).label);
end

Patterns = str2num(get(handles.Patterns,'String'));
Grids = str2num(get(handles.Grids,'String'));
Scans = str2num(get(handles.MedianF,'String'));


figure,
DensityTriPlot2([x(:),y(:),z(:)],xDisp,yDisp,zDisp,Grids,handles)
set(gca,'xtick',[], 'ytick',[]);

guidata(hObject, handles);
return


% --- SELECT & DISPLAY GROUPS
function SDGrp_Callback(hObject, eventdata, handles)

if handles.colorbar ~= 1
    CleanA1_Callback(hObject, eventdata, handles);
end

% New version
Data = handles.Data;

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');

[X,Y,Z,xDisp,yDisp,zDisp] = MenDerChoice_Callback(hObject, eventdata, handles);

HideThisPlot(1,hObject,handles);
drawnow

% normalisation
% h = waitbar(0,'Please wait...');
% Compt = 0;

x = zeros(size(X));
y = zeros(size(X));
z = zeros(size(X));
% 
% for i=1:length(X)
%     Compt = Compt+1;
%     if Compt == 1000
%         Compt = 0;
%         waitbar(i/length(X),h)
%     end
%     LaSum = X(i) + Y(i) + Z(i);
%     x(i) = X(i) / LaSum;
%     y(i) = Y(i) / LaSum;
%     z(i) = Z(i) / LaSum;
% end
% close(h)

% End new version

% Version 1.5
x = X./(X+Y+Z);
y = Y./(X+Y+Z);
z = Z./(X+Y+Z);


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
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',8)
    
end

% On passe au bon format: 
E1 = z+(1-(z+x))./2;
E2 = y;

LeMask = zeros(Data(OnPlot(1)).reshape);
SelectedPx = ones(Data(OnPlot(1)).reshape);

h = waitbar(0,'Please wait...');
for iM=1:length(XXmin) %grps
    waitbar(iM/length(XXmin),h)
    for i=1:length(x)
        if E1(i) <= XXmax(iM) && E1(i) >= XXmin(iM) && E2(i) <= YYmax(iM) && E2(i) >= YYmin(iM)
            LeMask(i) = iM;
            SelectedPx(i) = iM+1;
        end
    end
end
close(h)

% Save pour exporter le graph
handles.export_MG.LeMask = LeMask;
handles.export_MG.GrName = GrName;

set(handles.axesCarto,'Visible','on')
axes(handles.axesCarto), 
imagesc(LeMask)
axis image,
colormap([0,0,0;jet(length(XXmin))])
hcb = colorbar('YTickLabel',GrName); caxis([0 length(XXmin)+1]);
set(hcb,'YTickMode','manual','YTick',[0.5:1:length(XXmin)+0.5]);
set(hcb,'FontName','Times New Roman');

handles.colorbar = hcb;
set(handles.axesCarto,'XTick',[],'YTick',[]);

set(handles.CleanA1,'Visible','on');

handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Mise a jour 1.5 Affichage du module "Chemical groups"
set(handles.ChemicalPanel2,'Visible','on');


% Affichage des proportions (new 1.5)
for i=1:max(LeMask(:))
    NbPx(i) = length(find(LeMask == i));
end
NbTot = length(LeMask(:));
NbSel = sum(NbPx);
NbRest = NbTot-NbSel;

Chaine = 'Map proportions: ';
for i=1:length(NbPx)
    Chaine = [Chaine,'G',char(num2str(i)),': ',char(num2str(NbPx(i)/NbTot*100)),'% ; '];
end
Chaine = [Chaine,'NaM: ',char(num2str(NbRest/NbTot*100)),'%'];
    
set(handles.AffProp,'String',Chaine);



guidata(hObject, handles);
return


% --- MAKE A MASK FILE
function SDMasks_Callback(hObject, eventdata, handles)
Data = handles.Data;

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');

Add1a = get(handles.PoPD1a,'Value');
Add1b = get(handles.PoPD1b,'Value');
Add2a = get(handles.PoPD2a,'Value');
Add2b = get(handles.PoPD2b,'Value');
Add3a = get(handles.PoPD3a,'Value');
Add3b = get(handles.PoPD3b,'Value');

% D1
x = Data(OnPlot(1)).values;
xDisp = Data(OnPlot(1)).label;
if Add1a > 1
    x = x + Data(Add1a-1).values;
    xDisp = strcat(xDisp,' + ',Data(Add1a-1).label);
end
if Add1b > 1
    x = x + Data(Add1b-1).values;
    xDisp = strcat(xDisp,' + ',Data(Add1b-1).label);
end

% D2 
y = Data(OnPlot(2)).values;
yDisp = Data(OnPlot(2)).label;
if Add2a > 1
    y = y + Data(Add2a-1).values;
    yDisp = strcat(yDisp,' + ',Data(Add2a-1).label);
end
if Add2b > 1
    y = y + Data(Add2b-1).values;
    yDisp = strcat(yDisp,' + ',Data(Add2b-1).label);
end

% D3
z = Data(OnPlot(3)).values;
zDisp = Data(OnPlot(3)).label;
if Add3a > 1
    z = z + Data(Add3a-1).values;
    zDisp = strcat(zDisp,' + ',Data(Add3a-1).label);
end
if Add3b > 1
    z = z + Data(Add3b-1).values;
    zDisp = strcat(zDisp,' + ',Data(Add3b-1).label);
end

% Reshape
ForReshape = Data(1).reshape;
x = reshape(x,ForReshape(1),ForReshape(2));
y = reshape(y,ForReshape(1),ForReshape(2));
z = reshape(z,ForReshape(1),ForReshape(2));

figure,
imagesc(x), axis image, colorbar horizontal, 

clique = 1; ComptMask = 1;
while clique < 2
	[SelPixel(1),SelPixel(2),clique] = ginput(1); % we select the pixel
	if clique < 2
        CenterPixels(ComptMask,:) = round(SelPixel);
        hold on
        plot(CenterPixels(:,1),CenterPixels(:,2), 'mo','linewidth', 2)
        ComptMask = ComptMask+1;
	end
end
NbMask = ComptMask-1;

Chemic(:,1) = x(:);
Chemic(:,2) = y(:);
Chemic(:,3) = z(:);

SizeMap = ForReshape;

nPixH = SizeMap(1,2); nPixV = SizeMap(1,1);
NumPixCenter = (CenterPixels(:,1)-1).*nPixV + CenterPixels(:,2);

moyChem = mean(Chemic);
stdChem = std(Chemic);
ChemicNorm = (Chemic - ones(nPixV*nPixH,1)*moyChem) ./ (ones(nPixH*nPixV,1)*stdChem);
  
Groups = XkmeansX(ChemicNorm, NbMask, 'start', ChemicNorm(NumPixCenter,:)); 
Groups = reshape(Groups, nPixV, nPixH);

figure
imagesc(Groups), axis image
for i=1:NbMask
	NameMask{i} = num2str(i);
end
colormap(jet(NbMask));
colorbar vertical
%hcb = colorbar('YTickLabel',NameMask(:)); caxis([1 NbMask+1]);
%set(hcb,'YTickMode','manual','YTick',[1.5:1:NbMask+1]);

figure
whitebg(gcf,'k')
hold on
ColorP = {'.b','.g','.r','.c','.m','.y','.w'};
Compt = 0;
for i=1:NbMask
    Compt = Compt+1;
    if Compt > length(ColorP)
        Compt = 1;
    end
    DisplayTriPlotColor([x(find(Groups == i)),y(find(Groups == i)),z(find(Groups == i))],xDisp,yDisp,zDisp,ColorP(Compt),char([char(ColorP(Compt)),'-> groupe ',num2str(i)]),i);
    set(gca,'xtick',[], 'ytick',[]);
end


[Success,Message,MessageID] = mkdir('Maskfiles');

cd Maskfiles
    [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export maskfile as');
cd ..

if Directory
	%save([char(pathname),'/',char(Directory)],'Groups','-ASCII');
    
    NbGroups = max(Groups(:));
    
    Options = questdlg('Do you want to export only the selected pixels?', 'Maskfile','Yes', 'No', 'Yes');
    
    Selected = ones(1,NbGroups);
    
    switch Options
        case 'Yes'
            Selected(1) = 0;
    end
    
    Titles = {'Mask'};
    Names = {'Mineral'};
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


% --- IDENTIFY PIXELS
function IdentifyPx_Callback(hObject, eventdata, handles)
Data = handles.Data;

if handles.colorbar ~= 1
    CleanA1_Callback(hObject, eventdata, handles);
end

% Mise a jour 1.5 Cacher le module "Chemical groups"
set(handles.ChemicalPanel,'Visible','off');
set(handles.ChemicalPanel2,'Visible','off');

OnPlot(1) = get(handles.PoPD1,'Value');
OnPlot(2) = get(handles.PoPD2,'Value');
OnPlot(3) = get(handles.PoPD3,'Value');

[X,Y,Z,xDisp,yDisp,zDisp] = MenDerChoice_Callback(hObject, eventdata, handles);

HideThisPlot(1,hObject,handles);
drawnow

% normalisation
% h = waitbar(0,'Please wait...');
% Compt = 0;

x = zeros(size(X));
y = zeros(size(X));
z = zeros(size(X));

% for i=1:length(X)
%     Compt = Compt+1;
%     if Compt == 1000
%         Compt = 0;
%         waitbar(i/length(X),h)
%     end
%     LaSum = X(i) + Y(i) + Z(i);
%     x(i) = X(i) / LaSum;
%     y(i) = Y(i) / LaSum;
%     z(i) = Z(i) / LaSum;
% end

% Version 5.1
x = X./(X+Y+Z);
y = Y./(X+Y+Z);
z = Z./(X+Y+Z);

%close(h)

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

XXmin = min(P1(1,1),P2(1,1));
XXmax = max(P1(1,1),P2(1,1));
YYmin = min(P1(1,2),P2(1,2));
YYmax = max(P1(1,2),P2(1,2));
    
set(handles.CleanA1,'Visible','on');

% Good format
E1 = z+(1-(z+x))./2;
E2 = y;

LeMask = zeros(Data(OnPlot(1)).reshape);
SelectedPx = ones(Data(OnPlot(1)).reshape);
OuiMask = 0;

h = waitbar(0,'Please wait...');
for iM=1:length(XXmin) %grps
    waitbar(iM/length(XXmin),h)
    for i=1:length(x)
        if E1(i) <= XXmax(iM) && E1(i) >= XXmin(iM) && E2(i) <= YYmax(iM) && E2(i) >= YYmin(iM)
            LeMask(i) = 2.5;
            SelectedPx(i) = 2; % Grp2
        elseif E1(i) > 0 && E2(i) > 0
            LeMask(i) = 1.5;
            %OuiMask = 1;
        else
            OuiMask = 1;
        end
    end
end
close(h);

set(handles.axesCarto,'Visible','on')
axes(handles.axesCarto)
imagesc(LeMask), axis image
set(handles.axesCarto,'XTick',[],'YTick',[]);

% Save pour exporter le graph
handles.export_iP.OuiMask = OuiMask;
handles.export_iP.LeMask = LeMask;

% Fonctionnalit? 1.5
if OuiMask == 1
    colormap([0,0,0;0.2,0.3,1;1,0,0])
    hcb = colorbar('YTickLabel',{'...','Mineral','Selected'}); caxis([0 3]);
	set(hcb,'YTickMode','manual','YTick',[0.5,1.5,2.5]);
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
else
    colormap([0.2,0.3,1;1,0,0])
    hcb = colorbar('YTickLabel',{'...','Selected'}); caxis([1 3]);
	set(hcb,'YTickMode','manual','YTick',[1.5,2.5]);
    handles.colorbar = hcb;
    set(hcb,'FontName','Times New Roman');
end


axes(handles.axes1)
hold on, plot(E1(find(LeMask(:) == 2.5)),E2(find(LeMask(:) == 2.5)),'.r','markersize',1)
hold off


handles.SelectedPx = SelectedPx;    % IMPORTANT Pour pouvoir exporter un maskfile V1.5

% Mise a jour 1.5 Affichage du module "Chemical groups"
set(handles.ChemicalPanel,'Visible','on');
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

guidata(hObject, handles);

return


% --- BUILD A MASK FILE FROM IDENTIFY PIXELS
function BuildMF(hObject, eventdata, handles)

Groups = handles.SelectedPx;

[Success,Message,MessageID] = mkdir('Maskfiles');

cd Maskfiles
    [Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export maskfile as');
cd ..

if Directory
	%save([char(pathname),'/',char(Directory)],'Groups','-ASCII');
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


function BuildMF1_Callback(hObject, eventdata, handles)
BuildMF(hObject, eventdata, handles);
return

function BuildMF2_Callback(hObject, eventdata, handles)
BuildMF(hObject, eventdata, handles);
return



% --- Executes on button press in Export3.
function Export3_Callback(hObject, eventdata, handles)

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
    %handles.colorbar = hcb;
else
    colormap([0,0,0;1,0,0])
    hcb = colorbar('YTickLabel',{'...','Selected'}); caxis([1 3]);
	set(hcb,'YTickMode','manual','YTick',[1.5,2.5]);
    %handles.colorbar = hcb;
end

return


% --- Executes on button press in Export4.
function Export4_Callback(hObject, eventdata, handles)

LeMask = handles.export_MG.LeMask;
GrName = handles.export_MG.GrName;

figure, 
imagesc(LeMask)
axis image,
colormap([0,0,0;jet(max(LeMask(:)))])
hcb = colorbar('YTickLabel',GrName); caxis([0 max(LeMask(:))+1]);
set(hcb,'YTickMode','manual','YTick',[0.5:1:max(LeMask(:))+0.5]);

set(gca,'XTick',[],'YTick',[]);

return


% --- CLEAN AXES 1
function CleanA1_Callback(hObject, eventdata, handles)
cla(handles.axes1);
MenDerChoice_Callback(hObject, eventdata, handles);

cla(handles.axesCarto);
set(handles.axesCarto,'Visible','off');

hcb = handles.colorbar; % 1.5
set(hcb,'Visible','off'); % 1.5

% Mise a jour 1.5 Cacher le module "Chemical groups"
set(handles.ChemicalPanel,'Visible','off');
set(handles.ChemicalPanel2,'Visible','off');
return


% #########################################################################
%     P L O T      F U N C T I O N S
% #########################################################################



function [] = DisplayTriPlot(Data,nameA,nameB,nameC)
% Fonction qui trace un diagrame triangulaire a partir des donn??es Data
% La fonction effectue la transformation : (a,b,c) --> (Xa,Xb,Xc). 
%
% Organisation du diagramme : 
%                    B
%                  /   \
%                 /     \
%                A- - - -C 
%
% Syntaxe : [] = TriPlot(Data,nameA,nameB,nameC)
% nameA-B-C : noms des trois p??les (indiquer en chaine de caract??re) :
%
% Exemple : DisplayTriPlot([1,1,1;1,2,1],'Fe','Mg','Al')
%
% Cree par P. Lanari (08/02/10)
var=[];

a=nameA; b=nameB; c=nameC;

% On re-normalise (m??me si c'est d??j?? fait avant)
% for i= 1:length(Data(:,1))
%     Xa(i) = Data(i,1)/sum(Data(i,:));
%     Xb(i) = Data(i,2)/sum(Data(i,:));
%     Xc(i) = Data(i,3)/sum(Data(i,:));
% end

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

% disp(length(find(Xa > 0)))

% affichage des donn??es :
plot([0,0.5,1,0],[0,1,0,0],'-k'), hold on
axis([-0.12 1.12 -0.12 1.12])

% trace la grille
plot([0.4,0.8],[0.8,0],'--k')
plot([0.3,0.6],[0.6,0],'--k')
plot([0.2,0.4],[0.4,0],'--k')
plot([0.1,0.2],[0.2,0],'--k')

plot([0.8,0.9],[0,0.2],'--k')
plot([0.6,0.8],[0,0.4],'--k')
plot([0.4,0.7],[0,0.6],'--k')
plot([0.2,0.6],[0,0.8],'--k')

plot([0.4,0.6],[0.8,0.8],'--k')
plot([0.3,0.7],[0.6,0.6],'--k')
plot([0.2,0.8],[0.4,0.4],'--k')
plot([0.1,0.9],[0.2,0.2],'--k')

text(0-(length(char(a))/2)*0.018,-0.05,char(a))
text(0.5-(length(char(b))/2)*0.018,1.05,char(b))
text(1-(length(char(c))/2)*0.018,-0.05,char(c))

% for i = 1:length(Data(:,1))
%     plot(Xc(i)+(1-(Xc(i)+Xa(i)))/2,Xb(i),'*','markersize',10)
% end

plot(Xc+(1-(Xc+Xa))./2,Xb,'.k','markersize',1),
hold off

return

function [] = DisplayTriPlotColor(Data,nameA,nameB,nameC,ColorP,Leg,i)
% Fonction qui trace un diagrame triangulaire a partir des donn??es Data
% La fonction effectue la transformation : (a,b,c) --> (Xa,Xb,Xc). 
%
% Organisation du diagramme : 
%                    B
%                  /   \
%                 /     \
%                A- - - -C 
%
% Syntaxe : [] = TriPlot(Data,nameA,nameB,nameC)
% nameA-B-C : noms des trois p??les (indiquer en chaine de caract??re) :
%
% Exemple : DisplayTriPlot([1,1,1;1,2,1],'Fe','Mg','Al')
%
% Cree par P. Lanari (08/02/10)
var=[];

a=nameA; b=nameB; c=nameC;

% On re-normalise (m??me si c'est d??j?? fait avant)
% for i= 1:length(Data(:,1))
%     Xa(i) = Data(i,1)/sum(Data(i,:));
%     Xb(i) = Data(i,2)/sum(Data(i,:));
%     Xc(i) = Data(i,3)/sum(Data(i,:));
% end

Xa = Data(:,1)./(Data(:,1)+Data(:,2)+Data(:,3));
Xb = Data(:,2)./(Data(:,1)+Data(:,2)+Data(:,3));
Xc = Data(:,3)./(Data(:,1)+Data(:,2)+Data(:,3));


% affichage des donn??es :
plot([0,0.5,1,0],[0,1,0,0],'-w'), hold on
axis([-0.12 1.12 -0.12 1.12])

% trace la grille
plot([0.4,0.8],[0.8,0],'--w')
plot([0.3,0.6],[0.6,0],'--w')
plot([0.2,0.4],[0.4,0],'--w')
plot([0.1,0.2],[0.2,0],'--w')

plot([0.8,0.9],[0,0.2],'--w')
plot([0.6,0.8],[0,0.4],'--w')
plot([0.4,0.7],[0,0.6],'--w')
plot([0.2,0.6],[0,0.8],'--w')

plot([0.4,0.6],[0.8,0.8],'--w')
plot([0.3,0.7],[0.6,0.6],'--w')
plot([0.2,0.8],[0.4,0.4],'--w')
plot([0.1,0.9],[0.2,0.2],'--w')

text(0-(length(char(a))/2)*0.018,-0.05,char(a))
text(0.5-(length(char(b))/2)*0.018,1.05,char(b))
text(1-(length(char(c))/2)*0.018,-0.05,char(c))

% for i = 1:length(Data(:,1))
%     plot(Xc(i)+(1-(Xc(i)+Xa(i)))/2,Xb(i),'*','markersize',10)
% end

plot(Xc+(1-(Xc+Xa))./2,Xb,char(ColorP),'markersize',1)
text(0,1-(i-1)*0.06,Leg);


 
return


% #########################################################################
%     P L O T      F U N C T I O N S
% #########################################################################


% --- Executes on selection change in PoPD1.
function PoPD1_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD1a.
function PoPD1a_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD1a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD1b.
function PoPD1b_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function PoPD1b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD2.
function PoPD2_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD2_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD3.
function PoPD3_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD2a.
function PoPD2a_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD2a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD2b.
function PoPD2b_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD2b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD3a.
function PoPD3a_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD3a_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PoPD3b.
function PoPD3b_Callback(hObject, eventdata, handles)
MenDerChoice_Callback(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function PoPD3b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end








function Patterns_Callback(hObject, eventdata, handles)
% hObject    handle to Patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Patterns as text
%        str2double(get(hObject,'String')) returns contents of Patterns as a double


% --- Executes during object creation, after setting all properties.
function Patterns_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Patterns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Grids_Callback(hObject, eventdata, handles)
%
[x,y,z,xDisp,yDisp,zDisp] = MenDerChoice_Callback(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Grids_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Grids (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function MedianF_Callback(hObject, eventdata, handles)
% hObject    handle to MedianF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MedianF as text
%        str2double(get(hObject,'String')) returns contents of MedianF as a double


% --- Executes during object creation, after setting all properties.
function MedianF_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MedianF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% hObject    handle to Export3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in SDGrp.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to SDGrp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








% --- Executes on button press in BuildMF2.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to BuildMF2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)










% #########################################################################
%       XkmeansX function  (V1.6.2)
function [idx, C, sumD, D] = XkmeansX(X, k, varargin)
%
% k-means for XMapTools
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


% --- Executes on button press in IsLogColorbar.
function IsLogColorbar_Callback(hObject, eventdata, handles)
% hObject    handle to IsLogColorbar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of IsLogColorbar


% --- Executes on selection change in popupmenu10.
function popupmenu10_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu10 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu10


% --- Executes during object creation, after setting all properties.
function popupmenu10_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu11.
function popupmenu11_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu11 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu11


% --- Executes during object creation, after setting all properties.
function popupmenu11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu12.
function popupmenu12_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu12 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu12


% --- Executes during object creation, after setting all properties.
function popupmenu12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu13.
function popupmenu13_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu13 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu13


% --- Executes during object creation, after setting all properties.
function popupmenu13_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu14.
function popupmenu14_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu14 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu14


% --- Executes during object creation, after setting all properties.
function popupmenu14_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu15.
function popupmenu15_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu15 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu15


% --- Executes during object creation, after setting all properties.
function popupmenu15_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu16.
function popupmenu16_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu16 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu16


% --- Executes during object creation, after setting all properties.
function popupmenu16_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu17.
function popupmenu17_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu17 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu17


% --- Executes during object creation, after setting all properties.
function popupmenu17_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu18.
function popupmenu18_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu18 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu18


% --- Executes during object creation, after setting all properties.
function popupmenu18_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
