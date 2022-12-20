function varargout = VER_XMTModSpider_804(varargin)
% VER_XMTMODSPIDER_804 MATLAB code for VER_XMTModSpider_804.fig
%      VER_XMTMODSPIDER_804, by itself, creates a new VER_XMTMODSPIDER_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODSPIDER_804 returns the handle to a new VER_XMTMODSPIDER_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODSPIDER_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODSPIDER_804.M with the given input arguments.
%
%      VER_XMTMODSPIDER_804('Property','Value',...) creates a new VER_XMTMODSPIDER_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModSpider_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModSpider_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModSpider_804

% Last Modified by GUIDE v2.5 24-Feb-2019 08:34:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModSpider_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModSpider_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModSpider_804 is made visible.
function VER_XMTModSpider_804_OpeningFcn(hObject, eventdata, handles, varargin)
%

% - - - Data organisation - - -
for i=1:length(varargin)-7
    Data(i).values = varargin{i}(:);
    Data(i).label = varargin{end-6}(i);
    Labels(i) = Data(i).label;
    Data(i).reshape = varargin{end-5};
end

% - - - Variable save - - -
handles.Data = Data;
handles.LocBase = char(varargin{end-4});

for i=1:length(Data)
    TheMaps(:,:,i) = reshape(Data(i).values,Data(i).reshape);
end
handles.TheMaps = TheMaps;

handles.ColorMap = varargin{end-1};

PositionXMapTools = varargin{end};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.9,0.9]);

set(gcf,'Position',PositionGui);

% - - - Update Spider Colors - - -
SpiderColorData = varargin{end-2};
for i=1:length(SpiderColorData)
    ListNameColorBars{i} = SpiderColorData(i).Name;
end
set(handles.LISTCOLOR,'String',ListNameColorBars,'Value',1);
handles.SpiderColorData = SpiderColorData;


% - - - Update Spider Methods - - - 
SpiderData = varargin{end-3};

for i=1:length(SpiderData)
    ListNameMethods{i} = SpiderData(i).Name;
end
set(handles.NormalizationMethode,'String',ListNameMethods,'Value',1);
handles.SpiderData = SpiderData;

guidata(hObject, handles);

% - - - Update GUI - - -
axes(handles.LOGO);
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img); axis image
set(gca,'visible','off');

for i=1:length(Data)
    ListName{i} = char(Data(i).label);
end
set(handles.LISTMAP,'String',ListName,'Value',1);

Ind = 1;
WherePos = find(Data(Ind).values>0);

set(handles.EditMin,'String',num2str(min(Data(Ind).values(WherePos))));
set(handles.EditMax,'String',num2str(max(Data(Ind).values(WherePos))));

guidata(hObject, handles);

UPDATE_Plot(hObject, eventdata, handles)
NormalizationMethode_Callback(hObject, eventdata, handles);

handles.LastSelectedPixelsArea = [];

% Choose default command line output for VER_XMTModSpider_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTModSpider_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModSpider_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function Clean_Axes(hObject, eventdata, handles)
%
lesInd = get(handles.Axe_Map,'child');
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if ~isequal(leType,'image');
        delete(lesInd(i));
    end   
end

axes(handles.Axe_Spider);
cla

return


function UPDATE_Plot(hObject, eventdata, handles)
%

Data = handles.Data;
TheMaps = handles.TheMaps;
Ind = get(handles.LISTMAP,'Value');

EditMin = str2num(get(handles.EditMin,'String'));
EditMax = str2num(get(handles.EditMax,'String'));

Data2Plot = TheMaps(:,:,Ind);
% reshape(Data(Ind).values,Data(Ind).reshape);

axes(handles.Axe_Map)
imagesc(Data2Plot), axis image, colorbar
colormap([0,0,0;handles.ColorMap])

caxis([EditMin,EditMax])

set(handles.Axe_Map,'xtick',[], 'ytick',[]);

guidata(hObject, handles);
return


function PLOT_SPIDER_ALL(hObject, eventdata, handles)
%

PlotAll = 0;

if get(handles.ButtonSelAll,'Value')
    PlotAll = 1;
end

DataMETH = get(handles.TABLE,'Data');
for i=1:length(DataMETH(:,1))
    Labels{i} = DataMETH{i,1};
    Norm(i) = str2num(DataMETH{i,2});
    Where(i) = str2num(DataMETH{i,4});
end

Data = handles.Data;
TheMaps = handles.TheMaps;


if PlotAll 
    
    SumMap = sum(TheMaps,3);
    SelectedPixels = find(SumMap > 0);
    
    PercStr = str2num(get(handles.EditPercentage,'String'));
    NbPx = length(SelectedPixels);
    
    ToSelect = round(NbPx*(PercStr/100));
    out1 = randperm(NbPx);
    SelPixelsFinal = out1(1:ToSelect); 
    
    axes(handles.Axe_Spider)
    cla
    
    SpiderData = GenerateSpiderData(TheMaps,Norm,Where,SelPixelsFinal);
    
    axes(handles.Axe_Spider)
    semilogy(SpiderData','-','Color',[0.5 0.5 0.5]);
    
    set(gca,'XTick',[1:length(Labels)],'XTickLabel',Labels);
     
    drawnow
else
    axes(handles.Axe_Spider)
    cla
end



guidata(hObject, handles);
return


function PLOT_SPIDER(hObject, eventdata, handles, Method, SelectedPixels)
%

PlotAll = 0;
PlotArea = 0;
PlotLineSpot = 0;

% Always start with cleaning the axes
if ~get(handles.CheckHOLD,'Value')
    axes(handles.Axe_Spider)
	cla
else
    hold on
end

if get(handles.ButtonSelAll,'Value')
    PlotAll = 1;
end
if isequal(Method,1)
    PlotLineSpot = 1;
end
if isequal(Method,2)
    PlotArea = 1;
end
if isequal(Method,3)
    PlotLineSpot = 1;
end

DataMETH = get(handles.TABLE,'Data');
for i=1:length(DataMETH(:,1))
    Labels{i} = DataMETH{i,1};
    Norm(i) = str2num(DataMETH{i,2});
    Where(i) = str2num(DataMETH{i,4});
end

Data = handles.Data;
TheMaps = handles.TheMaps;


if PlotAll
    PLOT_SPIDER_ALL(hObject, eventdata, handles)
end

    
if PlotLineSpot
    
    SpiderData = GenerateSpiderData(TheMaps,Norm,Where,SelectedPixels);
    
    ColorCodes = GenerateColorCodes(length(SelectedPixels),handles);
        
    axes(handles.Axe_Spider), hold on
    
    for i=1:length(SelectedPixels)
        semilogy(SpiderData(i,:),'-','Color',ColorCodes(i,:));
    end
    
    set(gca,'YScale','Log','XTick',[1:length(Labels)],'XTickLabel',Labels);
    
    drawnow
    
    if get(handles.IsMOVIE,'Value')
        MakesMovieAndSaveIt(SpiderData,ColorCodes,SelectedPixels,TheMaps,Labels,handles);
    end
    
end

if PlotArea
    
    NbPx = size(SelectedPixels,2);
    Step = 1/(NbPx-1);

    ColorCodes = 0.3*ones(NbPx,3);
    ColorCodes2 = 0.9*ones(NbPx,3);
    if NbPx > 1
        ColorCodes(:,2) = [0:Step:1]';
        ColorCodes2(:,2) = [0:Step:1]';
    else
        ColorCodes(1,2) = 0;
        ColorCodes2(1,2) = 0;
    end
    
    for i=1:size(SelectedPixels,2)
        
        TheSelPx = find(SelectedPixels(:,i));
        
        SpiderData = GenerateSpiderData(TheMaps,Norm,Where,SelectedPixels(TheSelPx,i));
    
        TheMean = nan(1,size(SpiderData,2));
        TheStd = nan(1,size(SpiderData,2));
        
        for j = 1:size(SpiderData,2)
            TheValues = SpiderData(:,j);
            WherePositive = find(TheValues>0);
            NbOk = length(WherePositive);
            disp(NbOk/numel(TheValues))
            if NbOk/numel(TheValues) > 0.05
                TheMean(j) = mean(TheValues(WherePositive),1);
                TheStd(j) = std(TheValues(WherePositive),1);
            end
        end
        
        TheMean = mean(SpiderData,1);
        TheStd = std(SpiderData,1);
        
        TheMax = TheMean+TheStd;
        TheMin = TheMean-TheStd;
        TheMin(find(TheMin<0)) = zeros(size(find(TheMin<0)));
        
        axes(handles.Axe_Spider), hold on

        if get(handles.PlotEnveloppe,'Value')
            for j=2:size(SpiderData,2)
                if ~isnan(TheMax(j-1)) && ~isnan(TheMax(j)) && ~isnan(TheMin(j-1)) && ~isnan(TheMin(j))
                    h= fill([j-1,j,j,j-1],[TheMax(j-1),TheMax(j),TheMin(j),TheMin(j-1)],ColorCodes2(i,:));
                    set(h,'EdgeColor','None');
                end
            end
        end
        
        semilogy(TheMean,'-','Color',ColorCodes(i,:));
        
        set(gca,'YScale','Log','XLim',[1,length(Labels)],'XTick',[1:length(Labels)],'XTickLabel',Labels);
    
    end
    
    %keyboard
    
    
end



guidata(hObject, handles);
return


guidata(hObject, handles);
return


function [ColorCodes] = GenerateColorCodes(NbPx,handles);
%

IdxCB =  get(handles.LISTCOLOR,'Value');
SpiderColorData = handles.SpiderColorData(IdxCB);
RefCC = SpiderColorData.Code;

StepRef = 1/(size(RefCC,1)-1);
X = [0:StepRef:1];

ColorCodes = zeros(NbPx,3);

Step = 1/(NbPx-1);
Xi = [0:Step:1];

ColorCodes(:,1) = interp1(X,RefCC(:,1),Xi,'linear');
ColorCodes(:,2) = interp1(X,RefCC(:,2),Xi,'linear');
ColorCodes(:,3) = interp1(X,RefCC(:,3),Xi,'linear');

return


function [SpiderData] = GenerateSpiderData(TheMaps,Norm,Where,SelectedPixels);
%

SpiderData = nan(length(SelectedPixels),length(Norm));

for i=1:length(Norm)
    if Where(i)
        TempMap = TheMaps(:,:,Where(i));
        SpiderData(:,i) = TempMap(SelectedPixels)./Norm(i);
    end
end

return


% --- Executes on selection change in NormalizationMethode.
function NormalizationMethode_Callback(hObject, eventdata, handles)
%

Clean_Axes(hObject, eventdata, handles)

IndMeth = get(handles.NormalizationMethode,'Value');
SpiderData = handles.SpiderData;


Elems = SpiderData(IndMeth).Elements;
Comp = SpiderData(IndMeth).Concentration;

ElemsMap = get(handles.LISTMAP,'String');

[WhereOK,CoordOK] = ismember(Elems,ElemsMap);

% Check the additional list of isotopes ...
Isotopes = SpiderData(1).Isotopes;
IsotopeList = Isotopes.IsoList;
for i=1:length(WhereOK)
    if ~WhereOK(i) % this guy is not in the list ...
        [WOK,COK] = ismember(Elems(i),IsotopeList);
        if WOK
            % Check if there is a map
            [AlterOK,AlCooOK] = ismember(Isotopes.Iso(Isotopes.RefList(COK)).Names,ElemsMap);
            if length(find(AlterOK))
                % We have as solution
                WhereOK(i) = 1;
                CoordOK(i) = AlCooOK(find(AlterOK));
            end
        end
    end
end

for i=1:length(Elems)
    Table2Display{i,1} = char(Elems{i});
    Table2Display{i,2} = num2str(Comp(i));
    if WhereOK(i)
        Table2Display{i,3} = 'Yes';
    else
        Table2Display{i,3} = 'No';
    end
    Table2Display{i,4} = num2str(CoordOK(i));
end

set(handles.TABLE,'Data',Table2Display)
drawnow 
return

% --- Executes during object creation, after setting all properties.
function NormalizationMethode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NormalizationMethode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in LISTMAP.
function LISTMAP_Callback(hObject, eventdata, handles)
%

Clean_Axes(hObject, eventdata, handles)

Data = handles.Data;
Ind = get(handles.LISTMAP,'Value');

WherePos = find(Data(Ind).values>0);

set(handles.EditMin,'String',num2str(min(Data(Ind).values(WherePos))));
set(handles.EditMax,'String',num2str(max(Data(Ind).values(WherePos))));

guidata(hObject, handles);
UPDATE_Plot(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function LISTMAP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LISTMAP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMin_Callback(hObject, eventdata, handles)
%
CMin = str2num(get(handles.EditMin,'String'));
CMax = str2num(get(handles.EditMax,'String'));
if CMin < CMax
    axes(handles.Axe_Map)
    caxis([CMin,CMax]);
    drawnow
end
return



function MakesMovieAndSaveIt(SpiderData,ColorCodes,SelectedPixels,TheMaps,Labels,handles)
% 

MapLin = size(TheMaps,1);
MapCol = size(TheMaps,2);

X = floor(SelectedPixels/MapLin);
Y = SelectedPixels - MapLin.*X;

axes(handles.Axe_Map)
CLim = get(handles.Axe_Map,'CLim');
YDir = get(handles.Axe_Map,'YDir');
CMap = colormap;
lesInd = get(handles.Axe_Map,'child'); 

h1 = figure(123); cla;
set(gcf, 'Position', get(0, 'Screensize'));


subplot(2,2,2)
img = imread([handles.LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');
PositionLogo = get(gca,'Position');


subplot(2,2,1)
for i=1:length(lesInd)
    leType = get(lesInd(i),'Type');
    if length(leType) == 5
        if leType == 'image';
            imagesc(get(lesInd(i),'CData')), axis image
            break
        end
    end    
end
set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)
colormap(CMap)
colorbar vertical

hold on,
if length(SelectedPixels) > 50
    plot(X,Y,'.k','MarkerSize',1)
else
    plot(X,Y,'.k','MarkerSize',6)
end
plot(X(1),Y(1),'o','MarkerFaceColor',ColorCodes(1,:),'MarkerEdgeColor','k');
plot(X(end),Y(end),'o','MarkerFaceColor',ColorCodes(end,:),'MarkerEdgeColor','k');

subplot(2,2,[3,4])
set(gca,'YScale','Log','XTick',[1:length(Labels)],'XTickLabel',Labels,'XLim',[1,length(Labels)]);

set(gcf,'Color',[0.945 0.945 0.945])

drawnow 

Position = PositionLogo + [0,+0.26,0,-0.3];
ButtonH=uicontrol('Parent',gcf,'Style','pushbutton','String','RESIZE THE FIGURE AND CLICK HERE','Units','normalized','Position',Position,'Visible','on');

waitforbuttonpress

set(ButtonH,'Visible','off')
drawnow

MovieCompt = 1;
F(MovieCompt) = getframe(gcf);

for i=1:length(SelectedPixels)
    
    
    subplot(2,2,1), hold on
    
    if i>1
        lesIndMap = get(gca,'child');
        leType = get(lesIndMap,'Type');
        if isequal(leType{1},'line')
            delete(lesIndMap(1));
        end
    end
    
    plot(X(i),Y(i),'o','MarkerFaceColor',ColorCodes(i,:),'MarkerEdgeColor','k');
    
    subplot(2,2,[3,4]), hold on
    semilogy(SpiderData(i,:),'-','Color',ColorCodes(i,:));
    set(gca,'YScale','Log','XTick',[1:length(Labels)],'XTickLabel',Labels);
    
    MovieCompt = MovieCompt+1;
    F(MovieCompt) = getframe(gcf);
    
    drawnow
end

subplot(2,2,1),

for i = 1;length(X)
    plot(X(i),Y(i),'o','MarkerFaceColor',ColorCodes(i,:),'MarkerEdgeColor','k');
end
drawnow

for i =1:round(length(X)/10) % add 10% of the last figure...
    MovieCompt = MovieCompt+1;
    F(MovieCompt) = getframe(gcf);
end

close(h1)

myVideo = VideoWriter('myfile.avi');
myVideo.FrameRate = round(length(SelectedPixels)/str2num(get(handles.VideoLENGTH,'String')));  % Default 30
myVideo.Quality = str2num(get(handles.VideoQUAL,'String'));    % Default 75
open(myVideo);
writeVideo(myVideo, F);
close(myVideo);

return



% --- Executes during object creation, after setting all properties.
function EditMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMax_Callback(hObject, eventdata, handles)
%
EditMin_Callback(hObject, eventdata, handles)
return


% --- Executes during object creation, after setting all properties.
function EditMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonAuto.
function ButtonAuto_Callback(hObject, eventdata, handles)
%
lesInd = get(handles.Axe_Map,'child');
for i=1:length(lesInd)
    if length(get(lesInd(i),'type')) == 5 % image 
        AADonnees = get(lesInd(i),'CData');
        break
    else
        AADonnees = [];
    end
end

Triee = sort(AADonnees(:));
for i=1:length(Triee)
	if Triee(i) > 0 % defined
    	break 
    end
end
NTriee = Triee(i:end);

Val = round(length(NTriee) * 0.065); 

axes(handles.Axe_Map)
if Val > 1
    if NTriee(Val) < NTriee(length(NTriee)-Val)
        % V1.4.2 sans caxis
        set(handles.Axe_Map,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %set(handles.Axe_Map,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %caxis([NTriee(Val),NTriee(length(NTriee)-Val)]);
    end
else
    return % no posibility to update (size  = 0)
end

set(handles.EditMax,'String',num2str(NTriee(length(NTriee)-Val)));
set(handles.EditMin,'String',num2str(NTriee(Val)));

guidata(hObject,handles);
return


% --- Executes on button press in ButtonSelSpots.
function ButtonSelSpots_Callback(hObject, eventdata, handles)
%

% Always start with cleaning the axes
if ~get(handles.CheckHOLD,'Value')
    Clean_Axes(hObject, eventdata, handles);
    handles.LastSelectedPixelsArea = [];
end

handles.LastSelectedPixelsArea = [];

Ind = get(handles.LISTMAP,'Value');

TheMaps = handles.TheMaps;
if length(TheMaps(1,:,Ind)) > 700
    Decal(1) = 20;
elseif length(TheMaps(1,:,Ind)) > 400
    Decal(1) = 10;
else
    Decal(1) = 6;
end

if length(TheMaps(:,1,Ind)) > 700
    Decal(2) = 20;
elseif length(TheMaps(:,1,Ind)) > 400
    Decal(2) = 10;
else
    Decal(2) = 6;
end

axes(handles.Axe_Map);
hold on
zoom off

Compt = 0;
while 1
    Compt = Compt+1;
    [x,y,Click] = ginput(1);
    if Click < 2
        X(Compt) = round(x);
        Y(Compt) = round(y);
        
        plot(X(Compt),Y(Compt),'o','MarkerFaceColor','k','MarkerEdgeColor','k','Markersize',5);
        
    else
        break
    end
end

XCoo = 1:1:length(TheMaps(1,:,Ind));
YCoo = 1:1:length(TheMaps(:,1,Ind));

SelectedPixels = (X(:)-1).*length(YCoo)+Y(:);

NbPx = length(SelectedPixels);
ColorCodes = GenerateColorCodes(NbPx,handles);

for i=1:NbPx
    plot(X(i),Y(i),'o','MarkerFaceColor',ColorCodes(i,:),'MarkerEdgeColor','k');
end

for i=1:NbPx-1:NbPx
    leTxt = text(X(i)+Decal(1),Y(i)+Decal(2),num2str(i));
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)   
end

guidata(hObject, handles);

% Here we use 3 and it should work out...
PLOT_SPIDER(hObject, eventdata, handles, 3, SelectedPixels);
return


% --- Executes on button press in ButtonSelAreas.
function ButtonSelAreas_Callback(hObject, eventdata, handles)
%

Clean_Axes(hObject, eventdata, handles);
handles.LastSelectedPixelsArea = [];

Ind = get(handles.LISTMAP,'Value');

TheMaps = handles.TheMaps;
if length(TheMaps(1,:,Ind)) > 700
    Decal(1) = 20;
elseif length(TheMaps(1,:,Ind)) > 400
    Decal(1) = 10;
else
    Decal(1) = 6;
end

if length(TheMaps(:,1,Ind)) > 700
    Decal(2) = 20;
elseif length(TheMaps(:,1,Ind)) > 400
    Decal(2) = 10;
else
    Decal(2) = 6;
end

axes(handles.Axe_Map);
hold on
zoom off

ComptAreas = 0;

while 1
    
    ComptAreas = ComptAreas+1;
    Compt = 0;
    while 1
        Compt = Compt+1;
        [x,y,Click] = ginput(1);
        if Click < 2
            X(Compt,ComptAreas) = round(x);
            Y(Compt,ComptAreas) = round(y);

            plot(X(Compt,ComptAreas),Y(Compt,ComptAreas),'o','MarkerFaceColor','k','MarkerEdgeColor','k','Markersize',5);
            if length(X(find(X(:,ComptAreas)),ComptAreas)) > 1
                plot([X(Compt-1,ComptAreas),X(Compt,ComptAreas)],[Y(Compt-1,ComptAreas),Y(Compt,ComptAreas)],'-k');
            end
        else
            break
        end
     
    end
        
    plot([X(Compt-1,ComptAreas),X(1,ComptAreas)],[Y(Compt-1,ComptAreas),Y(1,ComptAreas)],'-k');
    
    WhereX = find(X(:,ComptAreas));
    WhereY = find(Y(:,ComptAreas));
    
    PosX = min(X(WhereX,ComptAreas)) + round((max(X(WhereX,ComptAreas))-min(X(WhereX,ComptAreas)))/2);
    PosY = min(Y(WhereY,ComptAreas)) + round((max(Y(WhereY,ComptAreas))-min(Y(WhereY,ComptAreas)))/2);
    
    leTxt = text(PosX,PosY,num2str(ComptAreas));
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)
    
    Quest = questdlg('Would you like to add one more area?','Spider Tool','No');
    
    switch Quest
        case 'No'
            break
        case 'Cancel'
            return
    end
        
end


NbPx = size(X,2);
Step = 1/(NbPx-1);

ColorCodes = 0.3*ones(NbPx,3);
if NbPx > 1
    ColorCodes(:,2) = [0:Step:1]';
else
    ColorCodes(1,2) = 0;
end

for i=1:NbPx
    plot(X(find(X(:,i)),i),Y(find(X(:,i)),i),'o','MarkerFaceColor',ColorCodes(i,:),'MarkerEdgeColor','k');
end

[LinS,ColS] = size(TheMaps(:,:,Ind));
for i=1:NbPx
    SelPx = find(X(:,i));
    MaskSel = Xpoly2maskX(X(SelPx,i),Y(SelPx,i),LinS,ColS);
    
    %figure, imagesc(MaskSel), axis image, colorbar
    
    TheSelPx = find(MaskSel(:)); 
    
    SelectedPixels(1:length(TheSelPx),i) = TheSelPx;
end

handles.LastSelectedPixelsArea = SelectedPixels;

guidata(hObject, handles);

PLOT_SPIDER(hObject, eventdata, handles, 2, SelectedPixels);
return

% --- Executes on button press in ButtonSelAll.
function ButtonSelAll_Callback(hObject, eventdata, handles)
% 
PLOT_SPIDER_ALL(hObject, eventdata, handles)
return



function EditPercentage_Callback(hObject, eventdata, handles)
%
Value = str2num(get(handles.EditPercentage,'String'));
if Value > 100 
    set(handles.EditPercentage,'String','100');
end
if Value < 0 
    set(handles.EditPercentage,'String','1');
end

guidata(hObject, handles);

PLOT_SPIDER_ALL(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function EditPercentage_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EditPercentage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonSelLine.
function ButtonSelLine_Callback(hObject, eventdata, handles)
%

if get(handles.IsMOVIE,'Value')
    set(handles.CheckHOLD,'Value',0)
end

% Always start with cleaning the axes
if ~get(handles.CheckHOLD,'Value')
    Clean_Axes(hObject, eventdata, handles);
    handles.LastSelectedPixelsArea = [];
end

Ind = get(handles.LISTMAP,'Value');

TheMaps = handles.TheMaps;
if length(TheMaps(1,:,Ind)) > 700
    Decal(1) = 20;
elseif length(TheMaps(1,:,Ind)) > 400
    Decal(1) = 10;
else
    Decal(1) = 6;
end

if length(TheMaps(:,1,Ind)) > 700
    Decal(2) = 20;
elseif length(TheMaps(:,1,Ind)) > 400
    Decal(2) = 10;
else
    Decal(2) = 6;
end

axes(handles.Axe_Map);
hold on
zoom off

ColorCodes = GenerateColorCodes(2,handles);

%keyboard

for i=1:2
    [x,y,Click] = ginput(1);
    if Click < 2
        X(i) = round(x);
        Y(i) = round(y);
        
        axes(handles.Axe_Map);
        hold on
        plot(X,Y,'-k','linewidth',1)
        plot(X(1),Y(1),'o','MarkerFaceColor',ColorCodes(1,:),'MarkerEdgeColor','k');
%         if isequal(i,2)
%             plot(X(2),Y(2),'o','MarkerFaceColor',[0.3,1,0.3],'MarkerEdgeColor','k');
%         end
        
        
    else
        return
    end
end

LX = max(X) - min(X);
LY = max(Y) - min(Y);

LZ = round(sqrt(LX^2 + LY^2));

if X(2) > X(1)
    LesX = X(1):(X(2)-X(1))/(LZ-1):X(2);
elseif X(2) < X(1)
    LesX = X(1):-(X(1)-X(2))/(LZ-1):X(2);
else
    LesX = ones(LZ,1) * X(1);
end

if Y(2) > Y(1)
    LesY = Y(1):(Y(2)-Y(1))/(LZ-1):Y(2);
elseif Y(2) < Y(1)
    LesY = Y(1):-(Y(1)-Y(2))/(LZ-1):Y(2);
else
    LesY = ones(LZ,1) * Y(1);
end

% Indexation 
XCoo = 1:1:length(TheMaps(1,:,Ind));
YCoo = 1:1:length(TheMaps(:,1,Ind));

for i = 1 : length(LesX)
    [V(i,1), IdxAll(i,1)] = min(abs(XCoo-LesX(i))); % Index X
    [V(i,2), IdxAll(i,2)] = min(abs(YCoo-LesY(i))); % Index Y
end

SelectedPixels = (IdxAll(:,1)-1).*length(YCoo)+IdxAll(:,2);

% Plot the line...
% NbPx = length(SelectedPixels)
% Step = 1/(NbPx-1);
%     
% ColorCodes = 0.3*ones(NbPx,3);
% ColorCodes(:,2) = [0:Step:1]';
% 
% for i=1:4:NbPx-1
%     plot(IdxAll(i:i+1,1),IdxAll(i:i+1,2),'-','Color',ColorCodes(i,:));
% end

%plot(X(1),Y(1),'o','MarkerFaceColor',[0.3,0,0.3],'MarkerEdgeColor','k');
plot(X(2),Y(2),'o','MarkerFaceColor',ColorCodes(2,:),'MarkerEdgeColor','k');

dX = X(2)-X(1);
dY = Y(2)-Y(1);

if dX > 0 && dY > 0
    Decal(1) = -Decal(1);
end
if dX < 0 && dY < 0
    Decal(1) = -Decal(1);
end

for i=1:2
    leTxt = text(X(i)+Decal(1),Y(i)+Decal(2),num2str(i));
    set(leTxt,'backgroundcolor',[1,1,1],'Color',[0,0,0],'FontName','Times New Roman','FontSize',10)   
end

% TheSelMap = TheMaps(:,:,Ind);
% figure, plot(TheSelMap(SelectedPixels));
% 
% for i=1:length(IdxAll(:,1)) % Quanti
%     LesData(i,1) = i;
%     LesData(i,2) = TheSelMap(IdxAll(i,2),IdxAll(i,1));
%     if LesData(i,2) == 0
%         LesData(i,2) = NaN;
%     end
% end
% 
% figure, plot(LesData(:,1),LesData(:,2))

guidata(hObject, handles);

PLOT_SPIDER(hObject, eventdata, handles, 3, SelectedPixels);
return



%       Xpoly2maskX function  (V1.6.2)
function BW = Xpoly2maskX(x,y,M,N)
%POLY2MASK-like function for VER_XMAPTOOLS_750 that 
%   Convert region-of-interest polygon to mask.


%narginchk(4,4);

% This function narginchk to validate the number of arguments is not
% compatible with the old version of Matlab. 
% Removed 1.6.5 (We don't need to check this here). 


validateattributes(x,{'double'},{},mfilename,'X',1);
validateattributes(y,{'double'},{},mfilename,'Y',2);
if length(x) ~= length(y)
    error(message('images:poly2mask:vectorSizeMismatch'));
end
if isempty(x)
    BW = false(M,N);
    return;
end
validateattributes(x,{'double'},{'real','vector','finite'},mfilename,'X',1);
validateattributes(y,{'double'},{'real','vector','finite'},mfilename,'Y',2);
validateattributes(M,{'double'},{'real','integer','nonnegative'},mfilename,'M',3);
validateattributes(N,{'double'},{'real','integer','nonnegative'},mfilename,'N',4);

if (x(end) ~= x(1)) || (y(end) ~= y(1))
    x(end+1) = x(1);
    y(end+1) = y(1);
end

[xe,ye] = Xpoly2edgelistX(x,y);
BW = Xedgelist2maskX(M,N,xe,ye);

return

function [xe, ye] = Xpoly2edgelistX(x,y,scale)

if nargin < 3
    scale = 5;
end

% Scale and quantize (x,y) locations to the higher resolution grid.
x = round(scale*(x - 0.5) + 1);
y = round(scale*(y - 0.5) + 1);

num_segments = length(x) - 1;
x_segments = cell(num_segments,1);
y_segments = cell(num_segments,1);
for k = 1:num_segments
    [x_segments{k},y_segments{k}] = XintlineX(x(k),x(k+1),y(k),y(k+1));
end

% Concatenate segment vertices.
x = cat(1,x_segments{:});
y = cat(1,y_segments{:});

% Horizontal edges are located where the x-value changes.
d = diff(x);
edge_indices = find(d);
xe = x(edge_indices);

% Wherever the diff is negative, the x-coordinate should be x-1 instead of
% x.
shift = find(d(edge_indices) < 0);
xe(shift) = xe(shift) - 1;

% In order for the result to be the same no matter which direction we are
% tracing the polynomial, the y-value for a diagonal transition has to be
% biased the same way no matter what.  We'll always chooser the smaller
% y-value associated with diagonal transitions.
ye = min(y(edge_indices), y(edge_indices+1));


return

function BW = Xedgelist2maskX(M,N,xe,ye,scale)

if nargin < 5
    scale = 5;
end

shift = (scale - 1)/2;

% Scale x values, throwing away edgelist points that aren't on a pixel's
% center column. 
xe = (xe+shift)/5;
idx = xe == floor(xe);
xe = xe(idx);
ye = ye(idx);

% Scale y values.
ye = ceil((ye + shift)/scale);

% Throw away horizontal edges that are too far left, too far right, or below the image.
bad_indices = find((xe < 1) | (xe > N) | (ye > M));
xe(bad_indices) = [];
ye(bad_indices) = [];

% Treat horizontal edges above the top of the image as they are along the
% upper edge.
ye = max(1,ye);

% Insert the edge list locations into a sparse matrix, taking
% advantage of the accumulation behavior of the SPARSE function.
S = sparse(ye,xe,1,M,N);

% We reduce the memory consumption of edgelist2mask by processing only a
% group of columns at a time (g274577); this does not compromise speed.
BW = false(size(S));
numCols = size(S,2);
columnChunk = 50;
for k = 1:columnChunk:numCols
  firstColumn = k;
  lastColumn = min(k + columnChunk - 1, numCols);
  columns = full(S(:, firstColumn:lastColumn));
  BW(:, firstColumn:lastColumn) = parityscan(columns); 
end

function [BW] = parityscan(F)
% F is a two-dimensional matrix containing nonnegative integers

nR = size(F,1);
nC = size(F,2);

BW = false(nR,nC);

for c=1:nC    
    
    somme = 0;
    for r=1:nR
        somme = somme+F(r,c);
        if mod(somme,2) == 1
            
            BW(r,c) = 1;
        end
    end
    
    
    %if length(find(F(:,c))) > 0
    %    keyboard
    %end
    
end


return

function [x,y] = XintlineX(x1, x2, y1, y2)
dx = abs(x2 - x1);
dy = abs(y2 - y1);

% Check for degenerate case.
if ((dx == 0) && (dy == 0))
  x = x1;
  y = y1;
  return;
end

flip = 0;
if (dx >= dy)
  if (x1 > x2)
    % Always "draw" from left to right.
    t = x1; x1 = x2; x2 = t;
    t = y1; y1 = y2; y2 = t;
    flip = 1;
  end
  m = (y2 - y1)/(x2 - x1);
  x = (x1:x2).';
  y = round(y1 + m*(x - x1));
else
  if (y1 > y2)
    % Always "draw" from bottom to top.
    t = x1; x1 = x2; x2 = t;
    t = y1; y1 = y2; y2 = t;
    flip = 1;
  end
  m = (x2 - x1)/(y2 - y1);
  y = (y1:y2).';
  x = round(x1 + m*(y - y1));
end
  
if (flip)
  x = flipud(x);
  y = flipud(y);
end

return


% --- Executes on button press in PlotEnveloppe.
function PlotEnveloppe_Callback(hObject, eventdata, handles)
%
SelectedPixels = handles.LastSelectedPixelsArea;

if size(SelectedPixels)

    guidata(hObject, handles);

    PLOT_SPIDER(hObject, eventdata, handles, 2, SelectedPixels);
end


% --- Executes on button press in ExportFigures.
function ExportFigures_Callback(hObject, eventdata, handles)
% 

axes(handles.Axe_Map)

lesInd = get(handles.Axe_Map,'child');

CLim = get(handles.Axe_Map,'CLim');
YDir = get(handles.Axe_Map,'YDir');

axes(handles.Axe_Spider)

lesInd2 = get(handles.Axe_Spider,'child');

CLim2 = get(handles.Axe_Spider,'CLim');
YDir2 = get(handles.Axe_Spider,'YDir');

Labels = get(handles.Axe_Spider,'XTickLabel'); 


figure;
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

set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)

% Scale bar VER_XMapTools_750 2.1.1
LimitsMap = axis;

if LimitsMap(2) > 170

    plot([20 120],[LimitsMap(4)+40 LimitsMap(4)+40],'-k','linewidth',4);

    text(40,LimitsMap(4)+20,'100 px')

    if LimitsMap(2) > 350
        text(140,LimitsMap(4)+18,'XMapTools')
        text(140,LimitsMap(4)+42,datestr(clock))
    else
        %text(140,LimitsMap(4)+30,'VER_XMapTools_750')
    end

    plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(4),LimitsMap(4)],'k','linewidth',1);
    plot([LimitsMap(1),LimitsMap(2)],[LimitsMap(3),LimitsMap(3)],'k','linewidth',1);

    axis([LimitsMap(1) LimitsMap(2) LimitsMap(3) LimitsMap(4)+60]);
end

colormap([0,0,0;handles.ColorMap])

figure,
hold on 

% % On trace d'abord les images...
% for i=1:length(lesInd2)
%     leType = get(lesInd2(i),'Type');
%     if length(leType) == 5
%         if leType == 'image';
%             imagesc(get(lesInd2(i),'CData')), axis image
%         end
%     end
%     
% end


% ensuite les lignes
for i=1:length(lesInd2)
    leType = get(lesInd2(i),'Type');
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd2(i),'XData'),get(lesInd2(i),'YData'),'Marker',get(lesInd2(i),'Marker'),'Color',get(lesInd2(i),'Color'),'LineStyle',get(lesInd2(i),'LineStyle'),'LineWidth',get(lesInd2(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd2(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd2(i),'MarkerFaceColor'),'Markersize',get(lesInd2(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end

% % puis les textes
% for i=1:length(lesInd2)
%     leType = get(lesInd2(i),'Type');
%     if length(leType) == 4
%         if leType == 'text'
%             LaPosition = get(lesInd2(i),'Position');
%             LeTxt = text(LaPosition(1),LaPosition(2),get(lesInd2(i),'String'));
%             set(LeTxt,'Color',get(lesInd2(i),'Color'),'BackgroundColor',get(lesInd2(i),'BackgroundColor'), ...
%                 'FontName',get(lesInd2(i),'FontName'),'FontSize',get(lesInd2(i),'FontSize'));
%         end
%     end
% end

set(gca,'CLim',CLim2);
set(gca,'YDir',YDir2);
% set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on','YScale','Log','XTick',[1:length(Labels)],'XTickLabel',Labels)
% set(gca,'LineStyleOrder','-')
% set(gca,'LineWidth',0.5)

return


% --- Executes on selection change in LISTCOLOR.
function LISTCOLOR_Callback(hObject, eventdata, handles)
% hObject    handle to LISTCOLOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LISTCOLOR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LISTCOLOR


% --- Executes during object creation, after setting all properties.
function LISTCOLOR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LISTCOLOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in CheckHOLD.
function CheckHOLD_Callback(hObject, eventdata, handles)
%
if get(handles.IsMOVIE,'Value')
    set(handles.CheckHOLD,'Value',0)
end

% --- Executes on button press in IsMOVIE.
function IsMOVIE_Callback(hObject, eventdata, handles)
%
if get(handles.IsMOVIE,'Value')
    set(handles.CheckHOLD,'Value',0)
    
    set(handles.VideoQUAL,'Visible','On')
    set(handles.VideoQUAL_text,'Visible','On')
    set(handles.VideoLENGTH,'Visible','On')
    set(handles.VideoLENGTH_text,'Visible','On')
else
    set(handles.VideoQUAL,'Visible','Off')
    set(handles.VideoQUAL_text,'Visible','Off')
    set(handles.VideoLENGTH,'Visible','Off')
    set(handles.VideoLENGTH_text,'Visible','Off')
end
return



function VideoQUAL_Callback(hObject, eventdata, handles)
% hObject    handle to VideoQUAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoQUAL as text
%        str2double(get(hObject,'String')) returns contents of VideoQUAL as a double


% --- Executes during object creation, after setting all properties.
function VideoQUAL_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoQUAL (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function VideoLENGTH_Callback(hObject, eventdata, handles)
% hObject    handle to VideoLENGTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of VideoLENGTH as text
%        str2double(get(hObject,'String')) returns contents of VideoLENGTH as a double


% --- Executes during object creation, after setting all properties.
function VideoLENGTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to VideoLENGTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
