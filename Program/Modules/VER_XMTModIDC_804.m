function varargout = VER_XMTModIDC_804(varargin)
% VER_XMTMODIDC_804 MATLAB code for VER_XMTModIDC_804.fig
%      VER_XMTMODIDC_804, by itself, creates a new VER_XMTMODIDC_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODIDC_804 returns the handle to a new VER_XMTMODIDC_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODIDC_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODIDC_804.M with the given input arguments.
%
%      VER_XMTMODIDC_804('Property','Value',...) creates a new VER_XMTMODIDC_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModIDC_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModIDC_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModIDC_804

% Last Modified by GUIDE v2.5 25-Mar-2019 10:42:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModIDC_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModIDC_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModIDC_804 is made visible.
function VER_XMTModIDC_804_OpeningFcn(hObject, eventdata, handles, varargin)

if ispc
    handles.FileDirCode = 'file:/';
else
    handles.FileDirCode = 'file://';
end

handles.WeClose = 0;

LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

Data = varargin{1};
MaskFile = varargin{2};
PositionXMapTools = varargin{3};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.95,0.95]);

set(gcf,'Position',PositionGui);

ListName = '';
for i=1:length(Data)
    ListName{i} = char(Data(i).name);
end

set(handles.PopUpMenu_XRAY,'String',ListName,'Value',1);
set(handles.PopUpMenu_MIN,'String',MaskFile.NameMinerals,'Value',1);

handles.Correction = zeros(length(Data),1);

handles.Data = Data;
handles.MaskFile = MaskFile;

handles.CorrScheme = [];

guidata(hObject, handles);

handles.BRC = CalculateBRC(hObject, eventdata, handles);

PlotImages(hObject, eventdata, handles);

% set(handles.ButtonCopy,'visible','off');
% set(handles.ButtonApply,'visible','off');
% 
% set(handles.ButtonReset,'visible','off');
% set(handles.ButtonCloseApply,'visible','off');
% set(handles.ButtonCloseCancel,'visible','off');

% Choose default command line output for VER_XMTModIDC_804
handles.output1 = handles.Data;
handles.output2 = handles.Correction;

handles.gcf = gcf;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTModIDC_804 wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModIDC_804_OutputFcn(hObject, eventdata, handles) 

if isempty(handles)
    varargout{1} = 0;
    varargout{2} = 0;
else
    varargout{1} = handles.output1;
    varargout{2} = handles.output2;
    
    delete(hObject);
end
return



function PlotImages(hObject, eventdata, handles)
%

axes(handles.Axes_MAP); cla
axes(handles.Axes_Corr); cla
axes(handles.Axes_CorrMap); cla
axes(handles.Axes_CorrDrift); cla

Data = handles.Data;
MaskFile = handles.MaskFile;

Correction = handles.Correction;
CorrScheme = handles.CorrScheme;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

if Correction(TheSelEl) >= 1
    WhereCorr = Data(TheSelEl).SelectedCorrectionScheme;
    AAfficher = Data(TheSelEl).corrvalues;
    set(handles.TEXT_CORR,'String',[CorrScheme(WhereCorr).Name],'ForegroundColor',[0,0,1]);
    
    set(handles.ButtonEdit,'Enable','On');
    set(handles.ButtonReset,'Enable','On');
    
else
    AAfficher = Data(TheSelEl).values;
    set(handles.TEXT_CORR,'String','uncorrected map; add/apply a correction scheme','ForegroundColor',[1,0,0]);
    
    set(handles.ButtonEdit,'Enable','Inactive');
    set(handles.ButtonReset,'Enable','Inactive');
    
end

if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

if isequal(get(handles.Box_BRC,'Value'),1)
    BRC_mask = handles.BRC;
else
    BRC_mask = ones(size(TheMask));
end

AAfficher = AAfficher .* BRC_mask;

if TheSelMin
    AAfficher = AAfficher .* TheMask;
end

axes(handles.Axes_MAP) 
imagesc(AAfficher), axis image, colorbar horizontal
set(gca,'XTick',[],'YTick',[]);

CMin = min(AAfficher(find(AAfficher(:))));
CMax = max(AAfficher(find(AAfficher(:))));

caxis([CMin,CMax]);

set(handles.EditMin,'String',num2str(CMin));
set(handles.EditMax,'String',num2str(CMax));

colormap([0,0,0;jet(64)]);


% Plot Drift
MapMode = get(handles.MapMode,'Value');
switch MapMode
    
    case 0
        
        set(handles.Axes_Corr,'Visible','on');
        Xray = Data(TheSelEl).values.*TheMask;
        Xray = Xray .* BRC_mask;

        if isequal(get(handles.Box_Verti,'Value'),1)
            TheMeans = nan(size(Xray,1),1);
            TheStd = nan(size(Xray,1),1);

            for i=1:size(Xray,1)
                TheSelected = find(Xray(i,:) > 0);
                if length(TheSelected) > 0
                    TheMeans(i) = mean(Xray(i,TheSelected));
                    TheStd(i) = std(Xray(i,TheSelected));
                end
            end

        else
            TheMeans = nan(size(Xray,2),1);
            TheStd = nan(size(Xray,2),1);

            for i=1:size(Xray,2)
                TheSelected = find(Xray(:,i) > 0);
                if length(TheSelected) > 0
                    TheMeans(i) = mean(Xray(TheSelected,i));
                    TheStd(i) = std(Xray(TheSelected,i));
                end
            end

        end

        Xi = [1:1:length(TheMeans)];

        axes(handles.Axes_Corr), hold on 
        % for i=1:length(Xi)
        %     plot([Xi(i),Xi(i)],[TheMeans(i)-2*TheStd(i),TheMeans(i)+2*TheStd(i)],'-','Color',[0.8,0,0]);
        % end
        plot([Xi;Xi],[TheMeans'-2.*TheStd';TheMeans'+2.*TheStd'],'-','Color',[1,.4,0.4]);
        plot([Xi',Xi'],[TheMeans-2.*TheStd,TheMeans+2.*TheStd],'-k');

        plot(Xi,TheMeans,'.r','Markersize',6);

    case 1
        set(handles.Axes_Corr,'Visible','off')
        
end

% CORRECTIONS 


if Correction(TheSelEl) >= 1

    if isequal(Correction(TheSelEl),666)    % Mode map
    
        set(handles.Axes_CorrMap,'Visible','On');
        
        axes(handles.Axes_CorrMap), cla, hold on
        imagesc(CorrScheme(WhereCorr).CorrectionMatrixPer), axis image, colorbar vertical
        set(gca,'YDir','Reverse','YTick',[],'XTick',[],'Box','On');
        
        %keyboard
    else

        set(handles.Axes_CorrDrift,'Visible','On');
        set(handles.Axes_CorrMap,'Visible','On');

        if isequal(Data(TheSelEl).TheSelMin,TheSelMin) % we have a correction for this element
            axes(handles.Axes_Corr)
            plot(Data(TheSelEl).InterpolPixels(:,1),Data(TheSelEl).InterpolPixels(:,2), '-o','linewidth', 2,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,0]);

            Method = get(handles.PopUpMenu_INTERP,'Value');

            switch Method
                case 1
                    plot(CorrScheme(WhereCorr).XX,CorrScheme(WhereCorr).YYlinear,'-g'); 
                case 2
                    plot(CorrScheme(WhereCorr).XX,CorrScheme(WhereCorr).YYpchip,'-g');
                case 3
                    plot(CorrScheme(WhereCorr).XX,CorrScheme(WhereCorr).YYspline,'-g');
                case 4
                    plot(CorrScheme(WhereCorr).XX,CorrScheme(WhereCorr).YYnearest,'-g');
            end

            axes(handles.Axes_CorrDrift), cla, hold on
            plot(Data(TheSelEl).XX,Data(TheSelEl).CorrectedMeans,'.-b')

    %         axes(handles.Axes_CorrMap), cla, hold on
    %         imagesc(Data(TheSelEl).CorrectionMatrix), axis image, colorbar vertical
    %         set(gca,'YDir','Reverse','YTick',[],'XTick',[],'Box','On');
        else


            %keyboard

            CorrectedMeans2 = TheMeans' + (CorrScheme(WhereCorr).CorrectionFunctionPer .* TheMeans');

            axes(handles.Axes_CorrDrift), cla, hold on
            plot(CorrectedMeans2,'.-b')


            %keyboard


        end

        axes(handles.Axes_CorrMap), cla, hold on
        imagesc(CorrScheme(WhereCorr).CorrectionMatrixPer), axis image, colorbar vertical
        set(gca,'YDir','Reverse','YTick',[],'XTick',[],'Box','On');
    end
        
    
else
    axes(handles.Axes_CorrDrift), cla
    axes(handles.Axes_CorrMap), colorbar('off'), cla
    
    set(handles.Axes_CorrDrift,'Visible','Off');
    set(handles.Axes_CorrMap,'Visible','Off');
end


% Adjust interface for Map mode
Value = get(handles.MapMode,'Value');
switch Value
    case 1
        set(handles.Box_Verti,'Enable','off');
        set(handles.Box_Hori,'Enable','off');
        %set(handles.Axes_Corr,'Visible','off');
        set(handles.ButtonEdit,'Enable','off');
        set(handles.ButtonReset,'Enable','off');
          
end


 
return




function EditMin_Callback(hObject, eventdata, handles)
CorrMatrix = handles.CorrMatrix;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

CMin = str2num(get(handles.EditMin,'String'));
CMax = str2num(get(handles.EditMax,'String'));
if CMin < CMax
    axes(handles.Axes_MAP)
    caxis([CMin,CMax]);
    if CorrMatrix(TheSelEl,TheSelMin+1)
        axes(handles.axes4)
        caxis([CMin,CMax]);
    end
    drawnow
end
return


function [BRC] = CalculateBRC(hObject, eventdata, handles)
%
        
MaskFile = handles.MaskFile;

TheNbPx = str2num(get(handles.BRC_1,'String'));
TheNbPxOnGarde = str2num(get(handles.BRC_2,'String'));

% Proceed to the correction
TheLin = size(MaskFile.Mask,1);
TheCol = size(MaskFile.Mask,2);
%CoordMatrice = reshape([1:TheLin*TheCol],TheLin,TheCol);

TheMaskFinal = zeros(size(MaskFile.Mask));

Position = round(TheNbPx/2);
TheNbPxInSel = TheNbPx^2;
TheCriterion = TheNbPxInSel*TheNbPxOnGarde/100;

for i=1:MaskFile.Nb                % for each phase
    
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == i);
    
    TheMask(VectorOk) = ones(size(VectorOk));
    
    TheWorkingMat = zeros(size(TheMask,1)*size(TheMask,2),TheNbPxInSel+1);
    
    VectMask = TheMask(:);
    TheWorkingMat(find(VectMask)) = 1000*ones(size(find(VectMask)));
    
    Compt = 1;
    for iLin = 1:TheNbPx
        
        
        for iCol = 1:TheNbPx
            
            % SCAN
            TheTempMat = zeros(size(TheMask));
            TheTempMat(Position:end-(Position-1),Position:end-(Position-1)) = TheMask(iLin:end-(TheNbPx-iLin),iCol:end-(TheNbPx-iCol));
            Compt = Compt+1;
            TheWorkingMat(:,Compt) = TheTempMat(:);
            
        end
    end
    
    TheSum = sum(TheWorkingMat,2);
    OnVire1 = find(TheSum < 1000+TheCriterion & TheSum > 1000);
    TheMaskFinal(OnVire1) = ones(size(OnVire1));
    
end

BRC = ones(size(TheMaskFinal));
BRC(find(TheMaskFinal(:) == 1)) = zeros(length(find(TheMaskFinal(:) == 1)),1);

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


% --- Executes on selection change in popupmenu_xray.
function PopUpMenu_MIN_Callback(hObject, eventdata, handles)
PlotImages(hObject, eventdata, handles)
return



% --- Executes during object creation, after setting all properties.
function PopUpMenu_MIN_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_xray (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in PopUpMenu_XRAY.
function PopUpMenu_XRAY_Callback(hObject, eventdata, handles)
PlotImages(hObject, eventdata, handles)
return


% --- Executes during object creation, after setting all properties.
function PopUpMenu_XRAY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpMenu_XRAY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonAuto.
function ButtonAuto_Callback(hObject, eventdata, handles)

Data = handles.Data;
MaskFile = handles.MaskFile;

Correction = handles.Correction;
CorrScheme = handles.CorrScheme;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

if Correction(TheSelEl) >= 1
    AAfficher = Data(TheSelEl).corrvalues;
else
    AAfficher = Data(TheSelEl).values;
end

if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

if isequal(get(handles.Box_BRC,'Value'),1)
    BRC_mask = handles.BRC;
else
    BRC_mask = ones(size(TheMask));
end

AAfficher = AAfficher .* BRC_mask;

if TheSelMin
    AAfficher = AAfficher .* TheMask;
end

CMin = min(AAfficher(find(AAfficher(:))));
CMax = max(AAfficher(find(AAfficher(:))));

CMinDisp = str2num(get(handles.EditMin,'String'));
CMaxDisp = str2num(get(handles.EditMax,'String'));

if isequal(round(CMin),round(CMinDisp)) && isequal(round(CMax),round(CMaxDisp))

    lesInd = get(handles.Axes_MAP,'child');
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

    axes(handles.Axes_MAP)
    if Val > 1
        if NTriee(Val) < NTriee(length(NTriee)-Val)
            % V1.4.2 sans caxis
            set(handles.Axes_MAP,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
            %caxis([NTriee(Val),NTriee(length(NTriee)-Val)]);
        end
    else
        return % no posibility to update (size  = 0)
    end

    set(handles.EditMax,'String',num2str(NTriee(length(NTriee)-Val)));
    set(handles.EditMin,'String',num2str(NTriee(Val)));
    
else
    
    axes(handles.Axes_MAP)
    
    set(handles.Axes_MAP,'CLim',[CMin,CMax]);
    
    set(handles.EditMin,'String',num2str(CMin));
    set(handles.EditMax,'String',num2str(CMax));

end
     
drawnow
guidata(hObject,handles);
return





function [] = FunctionAddCorrectionSchemeMAPmode(Mode, hObject, eventdata, handles);

CorrScheme = handles.CorrScheme;

switch Mode
    case 1
        WhereCorr = length(CorrScheme)+1;
    case 2
        WhereCorr = get(handles.PopUpMenu_CORR,'Value');
    case 3
        WhereCorr = get(handles.PopUpMenu_CORR,'Value');
        WeSkipSelect = 1;
end


Data = handles.Data;
MaskFile = handles.MaskFile;
CorrScheme = handles.CorrScheme;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

if isequal(get(handles.Box_BRC,'Value'),1)
    BRC_mask = handles.BRC;
else
    BRC_mask = ones(size(TheMask));
end

Xray = Data(TheSelEl).values.*TheMask;
Xray = Xray .* BRC_mask;


% We start building a correction matrix

Value = inputdlg('Resolution (Px)','IDC',1,{'50'});
dX = str2num(char(Value));
%dX = 100;

GridX = [1+dX/2:dX:size(Xray,2)-dX/2];
GridY = [1+dX/2:dX:size(Xray,1)-dX/2];

Grid = nan(numel(GridY),numel(GridX));

for i = 1:numel(GridX)
    for j = 1:numel(GridY)
        PxSel1 = Xray(GridY(j)-dX/2:GridY(j)+dX/2,GridX(i)-dX/2:GridX(i)+dX/2);
        PxSel = find(PxSel1 > 0.0001);
        if length(PxSel) > 0.05*dX^2   % at least 5 % of the pixels
            Grid(j,i) = median(PxSel1(PxSel));
        end
    end
end

Xq = [1:size(Xray,2)];
Yq = [1:size(Xray,1)];

[X,Y] = meshgrid(GridX,GridY);

Where = find(Grid > 0001);
F = scatteredInterpolant(X(Where), Y(Where), Grid(Where));

[xq,yq] = meshgrid(Xq,Yq);
Vq = F(xq,yq);

figure, imagesc(Vq), axis image, colorbar, colormap(jet(64)), caxis([6300 7000])
figure, imagesc(Grid), axis image, colorbar, colormap(jet(64)), caxis([6300 7000])


[Value,IndinInd] =  max(Vq(:));

CorrectionMatrix = Value-Vq;
CorrectionMatrixPer = CorrectionMatrix./Vq;


% Save everything...

Data(TheSelEl).corrvalues = Data(TheSelEl).values + (CorrectionMatrixPer .* Data(TheSelEl).values);
Data(TheSelEl).TheSelMin = TheSelMin;
Data(TheSelEl).SelectedCorrectionScheme = WhereCorr;
Data(TheSelEl).InterpolPixels = [];
Data(TheSelEl).XX = [];
Data(TheSelEl).YY = [];
Data(TheSelEl).CorrectedMeans = Value;
Data(TheSelEl).CorrectionMatrix = CorrectionMatrix;

CorrScheme(WhereCorr).Name = ['Correction MAP #',num2str(WhereCorr),' | Set for: ',char(Data(TheSelEl).name),' & ',char(MaskFile.NameMinerals(TheSelMin+1))];
CorrScheme(WhereCorr).DefinedWith = TheSelMin;
CorrScheme(WhereCorr).XX = [];
CorrScheme(WhereCorr).MaxX = Value;
CorrScheme(WhereCorr).Method = 666;               % map
CorrScheme(WhereCorr).YYlinear =[];
CorrScheme(WhereCorr).YYpchip = [];
CorrScheme(WhereCorr).YYspline = [];
CorrScheme(WhereCorr).YYnearest = [];
CorrScheme(WhereCorr).XCorPoint = [];
CorrScheme(WhereCorr).CorrectionFunctionPer = [];
CorrScheme(WhereCorr).CorrectionMatrixPer = CorrectionMatrixPer;


handles.Correction(TheSelEl) = 666;               % Map
handles.Data = Data;
handles.CorrScheme = CorrScheme;

for i=1:length(CorrScheme)
    ListCorrSchemes{i} = CorrScheme(i).Name;
end

set(handles.PopUpMenu_CORR,'String',ListCorrSchemes,'Value',WhereCorr);

guidata(hObject,handles);

% Here we should update the plot...
PlotImages(hObject, eventdata, handles);






return


function FunctionAddEditCorrectionScheme(hObject, eventdata, handles, Mode)

MapMode = get(handles.MapMode,'Value');
if isequal(MapMode,1)
    FunctionAddCorrectionSchemeMAPmode(1,hObject, eventdata, handles);
    return
end

Data = handles.Data;
MaskFile = handles.MaskFile;
CorrScheme = handles.CorrScheme;

WeSkipSelect = 0;

switch Mode
    case 1
        WhereCorr = length(CorrScheme)+1;
    case 2
        WhereCorr = get(handles.PopUpMenu_CORR,'Value');
    case 3
        WhereCorr = get(handles.PopUpMenu_CORR,'Value');
        WeSkipSelect = 1;
end

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

if isequal(get(handles.Box_BRC,'Value'),1)
    BRC_mask = handles.BRC;
else
    BRC_mask = ones(size(TheMask));
end

Xray = Data(TheSelEl).values.*TheMask;
Xray = Xray .* BRC_mask;

if isequal(get(handles.Box_Verti,'Value'),1)
    MaxVal = size(Xray,1);
    MaxX = size(Xray,2);
else
    MaxVal = size(Xray,2);
    MaxX = size(Xray,1);
end

if isequal(get(handles.Box_Verti,'Value'),1)
    TheMeans = nan(size(Xray,1),1);
    TheStd = nan(size(Xray,1),1);
    
    for i=1:size(Xray,1)
        TheSelected = find(Xray(i,:) > 0);
        if length(TheSelected) > 0
            TheMeans(i) = mean(Xray(i,TheSelected));
            TheStd(i) = std(Xray(i,TheSelected));
        end
    end

else
    TheMeans = nan(size(Xray,2),1);
    TheStd = nan(size(Xray,2),1);
    
    for i=1:size(Xray,2)
        TheSelected = find(Xray(:,i) > 0);
        if length(TheSelected) > 0
            TheMeans(i) = mean(Xray(TheSelected,i));
            TheStd(i) = std(Xray(TheSelected,i));
        end
    end

end

if isequal(WeSkipSelect,1)
    
    InterpolPixels = Data(TheSelEl).InterpolPixels;
    
else

    % Define the correction !!!

    axes(handles.Axes_Corr), hold on
    InterpolPixels = [];
    clique = 1; ComptPts = 1; LastXVal = 0;
    while clique < 2
        [SelPixel(1),SelPixel(2),clique] = ginput(1); % On selectionne le pixel
        if clique < 2
            if SelPixel(1) > 0 && SelPixel(1) < MaxVal && SelPixel(1) > LastXVal
                InterpolPixels(ComptPts,:) = round(SelPixel);
                plot(InterpolPixels(:,1),InterpolPixels(:,2), '-o','linewidth', 2,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,0]);
                LastXVal = InterpolPixels(ComptPts,1);
                ComptPts = ComptPts+1;
            end
        else
            break
        end
    end

    if size(InterpolPixels,1) < 2
        warndlg('Select at least two points to define a correction curve','Warning')
        return
    end



    if InterpolPixels(end,1) < MaxVal
        A = (InterpolPixels(end,2)-InterpolPixels(end-1,2))/(InterpolPixels(end,1)-InterpolPixels(end-1,1));
        B = InterpolPixels(end,2) - A * InterpolPixels(end,1);

        InterpolPixels(end+1,1) = MaxVal;
        InterpolPixels(end,2) = A*MaxVal + B;
        plot(InterpolPixels(end,1),InterpolPixels(end,2),'or','linewidth', 2,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,1])
    end

    if InterpolPixels(1,1) > 1
        A = (InterpolPixels(2,2)-InterpolPixels(1,2))/(InterpolPixels(2,1)-InterpolPixels(1,1));
        B = InterpolPixels(2,2) - A * InterpolPixels(2,1);

        InterpolPixels = [[1;InterpolPixels(:,1)],[A+B;InterpolPixels(:,2)]];
        plot(InterpolPixels(1,1),InterpolPixels(1,2),'or','linewidth', 2,'MarkerFaceColor',[1,1,1],'MarkerEdgeColor',[0,0,1])
    
    end
end


XX = [1:MaxVal];

YYlinear = interp1(InterpolPixels(:,1),InterpolPixels(:,2),XX,'linear');
YYpchip = interp1(InterpolPixels(:,1),InterpolPixels(:,2),XX,'pchip');
YYspline = interp1(InterpolPixels(:,1),InterpolPixels(:,2),XX,'spline');
YYnearest = interp1(InterpolPixels(:,1),InterpolPixels(:,2),XX,'nearest');

Method = get(handles.PopUpMenu_INTERP,'Value');

switch Method
    case 1
        plot(XX,YYlinear,'-g'); 
        YY = YYlinear;
        DispMethod = 'linear'; 
    case 2
        plot(XX,YYpchip,'-g');
        YY = YYpchip;
        DispMethod = 'Pchip'; 
    case 3
        plot(XX,YYspline,'-g');
        YY = YYspline;
        DispMethod = 'Spline';
    case 4
        plot(XX,YYnearest,'-g');
        YY = YYnearest;
        DispMethod = 'Nearest';
end


% Define the rotation point !!!

IndOk = find(~isnan(TheMeans)); 
MaskNoNaN = zeros(size(TheMeans));
MaskNoNaN(IndOk) = ones(size(IndOk));

[Value,IndinInd] = max(YY.*MaskNoNaN');

RotationPoint = [XX(IndinInd),YY(IndinInd)];
% DeltaPoint = TheMeans(IndinInd)-YY(IndinInd);

CorrectionFunction = Value - YY; % - DeltaPoint;
CorrectionFunctionPer = CorrectionFunction./YY;

if isequal(get(handles.Box_Verti,'Value'),1)
    CorrectionMatrix = repmat(CorrectionFunction',1,MaxX);
    CorrectionMatrixPer = repmat(CorrectionFunctionPer',1,MaxX);
else
    CorrectionMatrix = repmat(CorrectionFunction,MaxX,1);
    CorrectionMatrixPer = repmat(CorrectionFunctionPer,MaxX,1);
end

CorrectedMeans = TheMeans' + CorrectionFunction;
CorrectedMeans2 = TheMeans' + (CorrectionFunctionPer .* YY);


% % Define the rotation point !!!
% 
% [Value,IndinInd] = max(TheMeans);
% 
% RotationPoint = [XX(IndinInd),YY(IndinInd)];
% DeltaPoint = TheMeans(IndinInd)-YY(IndinInd);
% 
% CorrectionFunction = Value - YY - DeltaPoint;
% CorrectionFunctionPer = CorrectionFunction./YY;
% 
% CorrectionMatrix = repmat(CorrectionFunction',1,MaxX);
% CorrectionMatrixPer = repmat(CorrectionFunctionPer',1,MaxX);
% 
% CorrectedMeans = TheMeans' + CorrectionFunction;
% CorrectedMeans2 = TheMeans' + (CorrectionFunctionPer .* YY);


% Save everythings...


Data(TheSelEl).corrvalues = Data(TheSelEl).values + (CorrectionMatrixPer .* Data(TheSelEl).values);
Data(TheSelEl).TheSelMin = TheSelMin;
Data(TheSelEl).SelectedCorrectionScheme = WhereCorr;
Data(TheSelEl).InterpolPixels = InterpolPixels;
Data(TheSelEl).XX = XX;
Data(TheSelEl).YY = YY;
Data(TheSelEl).CorrectedMeans = CorrectedMeans;
Data(TheSelEl).CorrectionMatrix = CorrectionMatrix;

CorrScheme(WhereCorr).Name = ['Correction #',num2str(WhereCorr),' | Set for: ',char(Data(TheSelEl).name),' & ',char(MaskFile.NameMinerals(TheSelMin+1)),' | ',DispMethod,' '];
CorrScheme(WhereCorr).DefinedWith = TheSelMin;
CorrScheme(WhereCorr).XX = XX;
CorrScheme(WhereCorr).MaxX = MaxX;
CorrScheme(WhereCorr).Method = Method;
CorrScheme(WhereCorr).YYlinear =YYlinear;
CorrScheme(WhereCorr).YYpchip = YYpchip;
CorrScheme(WhereCorr).YYspline = YYspline;
CorrScheme(WhereCorr).YYnearest = YYnearest;
CorrScheme(WhereCorr).XCorPoint = IndinInd;
CorrScheme(WhereCorr).CorrectionFunctionPer = CorrectionFunctionPer;
CorrScheme(WhereCorr).CorrectionMatrixPer = CorrectionMatrixPer;

handles.Correction(TheSelEl) = Method;
handles.Data = Data;
handles.CorrScheme = CorrScheme;

for i=1:length(CorrScheme)
    ListCorrSchemes{i} = CorrScheme(i).Name;
end

set(handles.PopUpMenu_CORR,'String',ListCorrSchemes,'Value',WhereCorr);

guidata(hObject,handles);

% Here we should update the plot...
PlotImages(hObject, eventdata, handles);


return



% --- Executes on button press in ButtonDefine.
function ButtonDefine_Callback(hObject, eventdata, handles)

%

FunctionAddEditCorrectionScheme(hObject, eventdata, handles, 1);



return




% --- Executes on button press in ButtonApply.
function ButtonApply_Callback(hObject, eventdata, handles)
Data = handles.Data;
MaskFile = handles.MaskFile;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;


if TheSelMin
    TheMask = zeros(size(MaskFile.Mask));
    VectorOk = find(MaskFile.Mask == TheSelMin);
    TheMask(VectorOk) = ones(size(VectorOk));
else
    TheMask = ones(size(MaskFile.Mask));
end

Xray = Data(TheSelEl).values .* TheMask;
Topo = Data(handles.WhereIsTopo).values .* TheMask;

Xall = Topo(find(Topo));
Yall = Xray(find(Topo));

a = handles.copy;

Ycorr = Yall - a*Xall;

axes(handles.axes2); cla
plot(Xall,Ycorr,'.k','markersize',1)

axes(handles.axes4); cla
imagesc(Xray - a*Topo), axis image, colorbar horizontal

% We save the results...
handles.CorrMatrix(TheSelEl,TheSelMin+1) = a;
handles.OrdoMatrix(TheSelEl,TheSelMin+1) = 1;

set(handles.TextA,'visible','on','String',num2str(a));

%set(handles.ButtonCopy,'visible','on');

guidata(hObject,handles);
PlotImages(hObject, eventdata, handles);
return





% --- Executes on button press in ButtonReset.
function ButtonReset_Callback(hObject, eventdata, handles)
Data = handles.Data;
MaskFile = handles.MaskFile;

Correction = handles.Correction;
CorrScheme = handles.CorrScheme;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

Correction(TheSelEl) = 0;
Data(TheSelEl).SelectedCorrectionScheme = 0;

handles.Correction = Correction;
handles.CorrScheme = CorrScheme;

guidata(hObject,handles);
PlotImages(hObject, eventdata, handles);
return


% --- Executes on button press in ButtonCloseApply.
function ButtonCloseApply_Callback(hObject, eventdata, handles)


ButtonName = questdlg({'Would you like to apply the corrections to X-ray maps','This is an irreversible process'}, 'IDC', 'Yes');


handles.output1 = handles.Data;
handles.output2 = handles.Correction;


switch ButtonName
    
    case 'Yes'
        handles.output1 = handles.Data;
        handles.output2 = handles.Correction;
        handles.WeClose = 1;
        
        guidata(hObject, handles);
        close(handles.gcf);
        
    case 'No'
        handles.output1 = 0;
        handles.output2 = 0;
        handles.WeClose = 1;
        
        guidata(hObject, handles);
        close(handles.gcf);

    case 'Cancel'
        return
end

return


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)

if isequal(handles.WeClose,0)
    if isequal(get(hObject, 'waitstatus'),'waiting')
    
        handles.output1 = 0;
        handles.output2 = 0;

        guidata(hObject, handles);

        uiresume(hObject);
        delete(hObject);
    else
        delete(hObject);
    end
else
    if isequal(get(hObject, 'waitstatus'),'waiting')
        uiresume(hObject);
    else
        delete(hObject);
    end
end

return


% --- Executes on button press in ButtonCloseCancel.
function ButtonCloseCancel_Callback(hObject, eventdata, handles)

handles.output1 = handles.Data;
handles.output2 = handles.Correction;

guidata(hObject, handles);
close(handles.gcf);
return


% --- Executes on selection change in PopUpMenu_CORR.
function PopUpMenu_CORR_Callback(hObject, eventdata, handles)
% hObject    handle to PopUpMenu_CORR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns PopUpMenu_CORR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from PopUpMenu_CORR


% --- Executes during object creation, after setting all properties.
function PopUpMenu_CORR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpMenu_CORR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Box_Hori.
function Box_Hori_Callback(hObject, eventdata, handles)
% 
if get(handles.Box_Hori,'Value')
    SelectModeVertiHori(2, hObject, eventdata, handles);
else
    SelectModeVertiHori(1, hObject, eventdata, handles);
end

return



% --- Executes on button press in Box_Verti.
function Box_Verti_Callback(hObject, eventdata, handles)
% 
if get(handles.Box_Verti,'Value')
    SelectModeVertiHori(1, hObject, eventdata, handles);
else
    SelectModeVertiHori(2, hObject, eventdata, handles);
end

return


function SelectModeVertiHori(Mode, hObject, eventdata, handles)
%

switch Mode
    case 1
        set(handles.Box_Verti,'Value',1);
        set(handles.Box_Hori,'Value',0);
    case 2
        set(handles.Box_Verti,'Value',0);
        set(handles.Box_Hori,'Value',1);
end

PlotImages(hObject, eventdata, handles);

return



% --- Executes on button press in Box_BRC.
function Box_BRC_Callback(hObject, eventdata, handles)
%

PlotImages(hObject, eventdata, handles);
return


% --- Executes on selection change in PopUpMenu_INTERP.
function PopUpMenu_INTERP_Callback(hObject, eventdata, handles)
%

if handles.Correction(get(handles.PopUpMenu_XRAY,'Value')) >= 1
    FunctionAddEditCorrectionScheme(hObject, eventdata, handles, 3);
end

return

% --- Executes during object creation, after setting all properties.
function PopUpMenu_INTERP_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PopUpMenu_INTERP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BRC_1_Callback(hObject, eventdata, handles)
% 

TheNbPx = str2num(get(handles.BRC_1,'String'));

% TEST for parity THIS SHOULD GO ELSEWERE ...
if ~mod(TheNbPx,2)
    warndlg('The first BRC parameter must be an odd number','Warning')
    set(handles.BRC_1,'String','3')
    return
end

handles.BRC = CalculateBRC(hObject, eventdata, handles);
guidata(hObject, handles);
PlotImages(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function BRC_1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BRC_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function BRC_2_Callback(hObject, eventdata, handles)
% 
TheNbPxOnGarde = str2num(get(handles.BRC_2,'String'));

% TEST for parity THIS SHOULD GO ELSEWERE ...
if TheNbPxOnGarde > 100 || TheNbPxOnGarde < 1
    warndlg('The second BRC parameter must be comprise between 1 and 100','Warning')
    set(handles.BRC_1,'String','100')
    return
end

handles.BRC = CalculateBRC(hObject, eventdata, handles);
guidata(hObject, handles);
PlotImages(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function BRC_2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BRC_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonEdit.
function ButtonEdit_Callback(hObject, eventdata, handles)
%

FunctionAddEditCorrectionScheme(hObject, eventdata, handles, 2);



% --- Executes on button press in ButtonApplyCorr.
function ButtonApplyCorr_Callback(hObject, eventdata, handles)
% 

Data = handles.Data;
MaskFile = handles.MaskFile;
CorrScheme = handles.CorrScheme;

TheSelEl = get(handles.PopUpMenu_XRAY,'Value');
TheSelMin = get(handles.PopUpMenu_MIN,'Value')-1;

WhereCorr = get(handles.PopUpMenu_CORR,'Value');

Data(TheSelEl).corrvalues = Data(TheSelEl).values + (CorrScheme(WhereCorr).CorrectionMatrixPer .* Data(TheSelEl).values);
Data(TheSelEl).TheSelMin = 0;
Data(TheSelEl).SelectedCorrectionScheme = WhereCorr;
Data(TheSelEl).InterpolPixels = [];
Data(TheSelEl).XX = CorrScheme(WhereCorr).XX;
Data(TheSelEl).YY = [];
Data(TheSelEl).CorrectedMeans = [];
Data(TheSelEl).CorrectionMatrix = [];

handles.Correction(TheSelEl) = CorrScheme(WhereCorr).Method;

handles.Data = Data;
guidata(hObject,handles);

% Here we should update the plot...
PlotImages(hObject, eventdata, handles);


return


% --- Executes on button press in ButtonExport.
function ButtonExport_Callback(hObject, eventdata, handles)
%

axes(handles.Axes_MAP)

lesInd = get(handles.Axes_MAP,'child');

CLim = get(handles.Axes_MAP,'CLim');
YDir = get(handles.Axes_MAP,'YDir');

figure(666);
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

set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')

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

colorbar vertical

colormap([0,0,0;jet(64)])


% Figure 2

NameAxes = handles.Axes_Corr;

axes(NameAxes);

lesInd = get(NameAxes,'child');

CLim = get(NameAxes,'CLim');
YDir = get(NameAxes,'YDir');

Labels = get(NameAxes,'XTickLabel');

figure(667);
hold on
 
% ensuite les lignes
for j=1:length(lesInd)
    i = length(lesInd) - (j-1);
    leType = get(lesInd(i),'Type');
    %leType
    if length(leType) == 4
        if leType == 'line';
            plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
        end
    end
    
end


%set(gca,'CLim',CLim);
set(gca,'YDir',YDir);
%set(gca,'xtick',[], 'ytick',[]);
set(gca,'box','on')
set(gca,'LineStyleOrder','-')
set(gca,'LineWidth',0.5)


Correction = handles.Correction;
TheSelEl = get(handles.PopUpMenu_XRAY,'Value');

if Correction(TheSelEl) >= 1
    axes(handles.Axes_CorrMap)

    lesInd = get(handles.Axes_CorrMap,'child');

    CLim = get(handles.Axes_CorrMap,'CLim');
    YDir = get(handles.Axes_CorrMap,'YDir');

    figure(668);
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

    set(gca,'CLim',CLim);
    set(gca,'YDir',YDir);
    set(gca,'xtick',[], 'ytick',[]);
    set(gca,'box','on')

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

    colormap([0,0,0;jet(64)])

    colorbar vertical
    
    
    % Figure 2

    NameAxes = handles.Axes_CorrDrift;

    axes(NameAxes);

    lesInd = get(NameAxes,'child');

    CLim = get(NameAxes,'CLim');
    YDir = get(NameAxes,'YDir');

    Labels = get(NameAxes,'XTickLabel');

    figure(669);
    hold on

    % ensuite les lignes
    for j=1:length(lesInd)
        i = length(lesInd) - (j-1);
        leType = get(lesInd(i),'Type');
        %leType
        if length(leType) == 4
            if leType == 'line';
                plot(get(lesInd(i),'XData'),get(lesInd(i),'YData'),'Marker',get(lesInd(i),'Marker'),'Color',get(lesInd(i),'Color'),'LineStyle',get(lesInd(i),'LineStyle'),'LineWidth',get(lesInd(i),'LineWidth'), ...
                    'MarkerEdgeColor',get(lesInd(i),'MarkerEdgeColor'),'MarkerFaceColor',get(lesInd(i),'MarkerFaceColor'),'Markersize',get(lesInd(i),'MarkerSize')) % prpopriet?s ici
            end
        end

    end


    %set(gca,'CLim',CLim);
    set(gca,'YDir',YDir);
    %set(gca,'xtick',[], 'ytick',[]);
    set(gca,'box','on')
    set(gca,'LineStyleOrder','-')
    set(gca,'LineWidth',0.5)

    figure(666);
    figure(667);
    figure(668);
    figure(669);
    
else
    
    figure(666);
    figure(667);
    
end

return


% --- Executes on button press in MapMode.
function MapMode_Callback(hObject, eventdata, handles)
%
PlotImages(hObject, eventdata, handles);
return
