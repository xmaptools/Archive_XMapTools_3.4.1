function varargout = VER_XMTModHistTool_804(varargin)
% VER_XMTMODHISTTOOL_804 MATLAB code for VER_XMTModHistTool_804.fig
%      VER_XMTMODHISTTOOL_804, by itself, creates a new VER_XMTMODHISTTOOL_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTMODHISTTOOL_804 returns the handle to a new VER_XMTMODHISTTOOL_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTMODHISTTOOL_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTMODHISTTOOL_804.M with the given input arguments.
%
%      VER_XMTMODHISTTOOL_804('Property','Value',...) creates a new VER_XMTMODHISTTOOL_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTModHistTool_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTModHistTool_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTModHistTool_804

% Last Modified by GUIDE v2.5 16-Apr-2020 17:55:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTModHistTool_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTModHistTool_804_OutputFcn, ...
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


% --- Executes just before VER_XMTModHistTool_804 is made visible.
function VER_XMTModHistTool_804_OpeningFcn(hObject, eventdata, handles, varargin)
%

LocBase4Logo = which('XMapTools');
LocBase4Logo = LocBase4Logo (1:end-11);

axes(handles.LOGO);
img = imread([LocBase4Logo,'Dev/logo/logo_xmap_final.png']); axis image;
image(img);
set(gca,'visible','off');

img2 = imread([LocBase4Logo,'/Dev/logo/logo_xmap_final_white.png']);
handles.LogoXMapToolsWhite = img2;


% - - - Data organisation - - -
for i=1:length(varargin)-4
    Data(i).values = varargin{i}(:);
    Data(i).label = varargin{end-3}(i);
    Labels(i) = Data(i).label;
    Data(i).reshape = varargin{end-2};
end

PositionXMapTools = varargin{end};
handles.activecolorbar = varargin{end-1};

PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.95,0.9]);

set(gcf,'Position',PositionGui);

% - - - Variable save - - -
handles.Data = Data;
guidata(hObject, handles);

set(handles.ElemList,'String',Labels);

ElemList_Callback(hObject, eventdata, handles);

FctUpdateTable(0,hObject, eventdata, handles);

% Choose default command line output for VER_XMTModHistTool_804
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTModHistTool_804 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTModHistTool_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


function [] = UpdateParam(Case, hObject, eventdata, handles)
%
%   Case        1       Nb was changed
%   Case        2       Step was changed
%   Case        3       Range was changed
%   

set(handles.GaussianModel,'Value',0);

NbT = str2num(get(handles.Input_NbT,'String'));

if NbT > 65536
    NbT = 65536;
end

Min = str2num(get(handles.Input_Min,'String'));
Max = str2num(get(handles.Input_Max,'String'));
Step = str2num(get(handles.Input_Step,'String'));

switch Case
    case 1
        % we recalculate the Step:
        Step = (Max-Min)/(NbT-1);
        set(handles.Input_Step,'String',num2str(Step));
        
    case 2
        % we recalculate the NbT:
        NbT = length([Min:Step:Max]);
        set(handles.Input_NbT,'String',num2str(NbT));
        
    case 3
        % we keep Nb in this case and recalculate Step
        Step = (Max-Min)/(NbT-1); 
        set(handles.Input_Step,'String',num2str(Step));
        
end



UpdatePlots(hObject, eventdata, handles);

return



function [] = UpdatePlots(hObject, eventdata, handles)
%

Data = handles.Data;

ListElem = get(handles.ElemList,'String');
Where = get(handles.ElemList,'Value');

Min = str2num(get(handles.Input_Min,'String'));
Max = str2num(get(handles.Input_Max,'String'));

X = Data(Where).values;

SelPx = find(X > Min & X < Max);
X = X(SelPx);

Input_NbT = str2num(get(handles.Input_NbT,'String'));

% Histogram
axes(handles.axes_hist); hold off 
Methods = get(handles.Input_HistStyle,'String');
ValM = get(handles.Input_HistStyle,'Value');
histogram(X,Input_NbT,'Normalization',Methods{ValM});

xlabel(ListElem{Where})
ylabel(Methods{ValM})

% Update table
[N,EDGES] = histcounts(X,Input_NbT,'Normalization',Methods{ValM});
CENT = EDGES(1:end-1)+((EDGES(2)-EDGES(1))/2);
BinMode = get(handles.BinMode,'Value');
PrevUnits = get(handles.uitable1,'Units');
set(handles.uitable1,'Units','pixels');
PosTable = get(handles.uitable1,'Position');
set(handles.uitable1,'Units',PrevUnits);
switch BinMode
    case 1
        set(handles.uitable1,'Data',[CENT',N'],'ColumnName',{'center', Methods{ValM}},'ColumnWidth',{round(0.33*PosTable(end)) round(0.33*PosTable(end))});
    case 2
        set(handles.uitable1,'Data',[EDGES(1:end-1)',N'],'ColumnName',{'lower', Methods{ValM}},'ColumnWidth',{round(0.33*PosTable(end)) round(0.33*PosTable(end))});
    case 3
        set(handles.uitable1,'Data',[EDGES(2:end)',N'],'ColumnName',{'upper', Methods{ValM}},'ColumnWidth',{round(0.33*PosTable(end)) round(0.33*PosTable(end))});
end

% Update Map
axes(handles.axes_map)
Map = zeros(size(Data(Where).values));
Map = reshape(Map,Data(Where).reshape);
Map(SelPx) = X;
imagesc(Map), axis image, colorbar vertical
set(handles.axes_map,'xtick',[], 'ytick',[]);
colormap(handles.activecolorbar)
caxis([Min Max])

% GAUSSIAN
Calc_Mean = mean(X);
Calc_Median = median(X);
Calc_Std = std(X);

set(handles.Gaus_infos,'String',{['Mean: ',num2str(Calc_Mean),' | Median: ',num2str(Calc_Median)],['Std: ',num2str(Calc_Std),' | HWHM: ',num2str(Calc_Std*sqrt(2*log(2)))]})

if isequal(get(handles.GaussianModel,'Value'),0)
    
    % Spline interpolation for the peak
    Npeak = spline(CENT,N,Calc_Median);
    
    
    set(handles.Gaus_peak,'String',num2str(Calc_Median));
    set(handles.Gaus_Amp,'String',num2str(Npeak));
    set(handles.Gaus_1s,'String',num2str(Calc_Std));
    
    
else
    Gaus_peak = str2num(get(handles.Gaus_peak,'String'));
    Gaus_1s = str2num(get(handles.Gaus_1s,'String'));
    Gaus_Amp = str2num(get(handles.Gaus_Amp,'String'));
    
    [Gx,Gd,Ld] = CurveFit1peak(Gaus_peak,Gaus_1s,Gaus_Amp,Min,Max);
    
    
    axes(handles.axes_hist), hold on
    plot(Gx,Gd,'-r','LineWidth',2)
    hold off 
    
    %keyboard
    
end



% SIMULATION:
Steps = [round(Input_NbT/3),round(2*Input_NbT/3),Input_NbT,round(Input_NbT*2),round(Input_NbT*3)];
Steps = [round(Input_NbT/2),Input_NbT,round(Input_NbT*2)];

Mtx_X = nan(10000,numel(Steps));
Mtx_Y = nan(10000,numel(Steps));

for i = 1:numel(Steps)
    Lb{i} = num2str(Steps(i));
    [N,EDGES] = histcounts(X,Steps(i),'Normalization',Methods{ValM});
    CENT = EDGES(1:end-1)+((EDGES(2)-EDGES(1))/2);
    Mtx_X(1:numel(CENT),i) = CENT;
    Mtx_Y(1:numel(N),i) = N;
end

axes(handles.axes_sim);
plot(Mtx_X,Mtx_Y,'-o')

legend(Lb,'Location','Best')

% adjust axes
set(handles.axes_sim,'Xlim',[Min Max]);
set(handles.axes_hist,'Xlim',[Min Max]);






return


function FctUpdateTable(Mode,hObject, eventdata, handles)
%

set(handles.Mode_Tab,'Value',0)
set(handles.Mode_Map,'Value',0)
set(handles.Mode_Options,'Value',0)

set(handles.Panel_Tab,'Visible','off');
set(handles.Panel_Map,'Visible','off');
set(handles.Panel_Options,'Visible','off');

switch Mode
    case 1
        set(handles.Mode_Tab,'Value',1)
        set(handles.Panel_Tab,'Visible','on');
        
    case 2
        set(handles.Mode_Map,'Value',1)
        set(handles.Panel_Map,'Visible','on');
        
    case 3
        set(handles.Mode_Options,'Value',1)
        set(handles.Panel_Options,'Visible','on');
end



return


function [X,Gd,Ld] = CurveFit1peak(Peak,Std,Amp,Min,Max)
%

X = [Min:((Max-Min)/(1e4-1)):Max];

% Spline interpolation for the peak
%Npeak = spline(CENT,N,Peak);

% Gaussian equation (https://magicplot.com/wiki/fit_equations)
dx = Std*sqrt(2*log(2));    % half width at half maximum (HWHM)
X0 = Peak;                  % max position

Gd = Amp.*exp(-log(2)*((X-X0)./dx).^2);
Ld = Amp.*1./(1+((X-X0)./dx).^2);


return

% --- Executes on selection change in ElemList.
function ElemList_Callback(hObject, eventdata, handles)
%

set(handles.GaussianModel,'Value',0);

Where = get(handles.ElemList,'Value');
X = handles.Data(Where).values;

% Recalculate and update 
Input_NbT = str2num(get(handles.Input_NbT,'String'));

Min = min(X(:));
Max = max(X(:));

set(handles.Input_Min,'String',num2str(Min));
set(handles.Input_Max,'String',num2str(Max));

Step = (Max-Min)/(Input_NbT-1);

set(handles.Input_Step,'String',num2str(Step));

UpdatePlots(hObject, eventdata, handles);
return





% --- Executes during object creation, after setting all properties.
function ElemList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElemList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Input_NbT_Callback(hObject, eventdata, handles)
%
UpdateParam(1, hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Input_NbT_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_NbT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Input_Min_Callback(hObject, eventdata, handles)
%
UpdateParam(3, hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Input_Min_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Input_Step_Callback(hObject, eventdata, handles)
%
UpdateParam(2, hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Input_Step_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Input_Max_Callback(hObject, eventdata, handles)
%
UpdateParam(3, hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function Input_Max_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in ElemList.
function ListElem_Callback(hObject, eventdata, handles)
% hObject    handle to ElemList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns ElemList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ElemList


% --- Executes during object creation, after setting all properties.
function ListElem_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ElemList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to Input_NbT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_NbT as text
%        str2double(get(hObject,'String')) returns contents of Input_NbT as a double


% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_NbT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_Min as text
%        str2double(get(hObject,'String')) returns contents of Input_Min as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_Step as text
%        str2double(get(hObject,'String')) returns contents of Input_Step as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Step (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to Input_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Input_Max as text
%        str2double(get(hObject,'String')) returns contents of Input_Max as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_Max (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Input_HistStyle.
function Input_HistStyle_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Input_HistStyle_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Input_HistStyle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Mode_Tab.
function Mode_Tab_Callback(hObject, eventdata, handles)
%
if isequal(get(hObject,'Value'),1)
    FctUpdateTable(1,hObject, eventdata, handles);
else
    FctUpdateTable(0,hObject, eventdata, handles);
end
return

% --- Executes on button press in Mode_Map.
function Mode_Map_Callback(hObject, eventdata, handles)
%
if isequal(get(hObject,'Value'),1)
    FctUpdateTable(2,hObject, eventdata, handles);
else
    FctUpdateTable(0,hObject, eventdata, handles);
end
return

% --- Executes on button press in Mode_Options.
function Mode_Options_Callback(hObject, eventdata, handles)
%
if isequal(get(hObject,'Value'),1)
    FctUpdateTable(3,hObject, eventdata, handles);
else
    FctUpdateTable(0,hObject, eventdata, handles);
end
return


% --- Executes on button press in Table_Copy.
function Table_Copy_Callback(hObject, eventdata, handles)
%
Data = get(handles.uitable1,'Data');
Labels = get(handles.uitable1,'ColumnName');
Str = sprintf('%s\t%s',Labels{1},Labels{2});
for i=1:size(Data,1)
    Str = sprintf('%s\n%s\t%s',Str,num2str(Data(i,1)),num2str(Data(i,2)));
end
clipboard('copy',Str);
warndlg('The data have been copied to the clipboard');
return


% --- Executes on button press in Table_Save.
function Table_Save_Callback(hObject, eventdata, handles)
%
[Success,Message,MessageID] = mkdir('Exported-HistData');

cd Exported-HistData
[Directory, pathname] = uiputfile({'*.txt', 'TXT Files (*.txt)'}, 'Export results as');
cd ..

if ~Directory
    return
end

ListElem = get(handles.ElemList,'String');
Where = get(handles.ElemList,'Value');

fid = fopen(strcat(pathname,Directory),'w');
fprintf(fid,'%s\n','Histogram data exported from XMapTools');
fprintf(fid,'%s\n\n',datestr(now));
fprintf(fid,'%s\n%s\n','Settings:','------------');
fprintf(fid,'%s\n',['Map: ',ListElem{Where}]);
fprintf(fid,'%s\n',['Nb bins: ',num2str(get(handles.Input_NbT,'String'))]);
fprintf(fid,'%s\n',['Min: ',num2str(get(handles.Input_Min,'String'))]);
fprintf(fid,'%s\n',['Width: ',num2str(get(handles.Input_Step,'String'))]);
fprintf(fid,'%s\n',['Max: ',num2str(get(handles.Input_Max,'String'))]);
fprintf(fid,'%s\n','------------');

Data = get(handles.uitable1,'Data');
Labels = get(handles.uitable1,'ColumnName');

fprintf(fid,'\n\n%s\t%s\n',Labels{1},Labels{2});
for i=1:size(Data,1)
    fprintf(fid,'%f\t%f\n',Data(i,1),Data(i,2));
end
fclose(fid);
return


% --- Executes on selection change in BinMode.
function BinMode_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function BinMode_CreateFcn(hObject, eventdata, handles)
% hObject    handle to BinMode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in GaussianModel.
function GaussianModel_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

function Gaus_peak_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Gaus_peak_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gaus_peak (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gaus_Amp_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Gaus_Amp_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gaus_Amp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Gaus_1s_Callback(hObject, eventdata, handles)
%
UpdatePlots(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function Gaus_1s_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Gaus_1s (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ButtonAutoStep.
function ButtonAutoStep_Callback(hObject, eventdata, handles)
%
Data = handles.Data;
Where = get(handles.ElemList,'Value');

Min = str2num(get(handles.Input_Min,'String'));
Max = str2num(get(handles.Input_Max,'String'));

X = Data(Where).values;

SelPx = find(X > Min & X < Max);
X = X(SelPx);

Methods = get(handles.MenuBinningAlgo,'String');
WhereMethods = get(handles.MenuBinningAlgo,'Value');
Method = Methods{WhereMethods};

switch Method
    case 'Scott'
        % Optimal step (based on the Scott's rule)
        Step = 3.49*std(X(:))*numel(X)^(-1/3);

    case 'Freedman-Diaconis'
        % Optimal step (based on the Freedman-Diaconis rule)
        Step = 2*iqr(X(:))*numel(X)^(-1/3);
        
    case 'Sturges'
        Step = ceil(1 + log2(numel(X)));
        
    case 'Sqrt'
        Step = ceil(sqrt(numel(X)));
end

Input_NbT = round((Max-Min)/Step + 1);

if Input_NbT < 2
    Input_NbT = 2;
end

if Input_NbT > 65536
    Input_NbT = 65536;
end

set(handles.Input_NbT,'String',num2str(Input_NbT));

UpdatePlots(hObject, eventdata, handles);


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7


% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox3


% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox4


% --- Executes on button press in GeneralOptions.
function GeneralOptions_Callback(hObject, eventdata, handles)
% hObject    handle to GeneralOptions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of GeneralOptions


% --- Executes on selection change in MenuBinningAlgo.
function MenuBinningAlgo_Callback(hObject, eventdata, handles)
%
ButtonAutoStep_Callback(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function MenuBinningAlgo_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MenuBinningAlgo (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ExporFigures.
function ExporFigures_Callback(hObject, eventdata, handles)
%

ListElem = get(handles.ElemList,'String');
Where = get(handles.ElemList,'Value');

ax1Chil = handles.axes_hist.Children; 

figure;
ax2 = axes;

copyobj(ax1Chil, ax2); 
box on

xlabel(ListElem{Where})

Methods = get(handles.Input_HistStyle,'String');
ValM = get(handles.Input_HistStyle,'Value');
ylabel(Methods{ValM})

return
