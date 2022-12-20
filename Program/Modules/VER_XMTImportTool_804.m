function varargout = VER_XMTImportTool_804(varargin)
% VER_XMTIMPORTTOOL_804 MATLAB code for VER_XMTImportTool_804.fig
%      VER_XMTIMPORTTOOL_804, by itself, creates a new VER_XMTIMPORTTOOL_804 or raises the existing
%      singleton*.
%
%      H = VER_XMTIMPORTTOOL_804 returns the handle to a new VER_XMTIMPORTTOOL_804 or the handle to
%      the existing singleton*.
%
%      VER_XMTIMPORTTOOL_804('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_XMTIMPORTTOOL_804.M with the given input arguments.
%
%      VER_XMTIMPORTTOOL_804('Property','Value',...) creates a new VER_XMTIMPORTTOOL_804 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_XMTImportTool_804_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_XMTImportTool_804_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_XMTImportTool_804

% Last Modified by GUIDE v2.5 27-Sep-2019 15:45:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_XMTImportTool_804_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_XMTImportTool_804_OutputFcn, ...
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


% --- Executes just before VER_XMTImportTool_804 is made visible.
function VER_XMTImportTool_804_OpeningFcn(hObject, eventdata, handles, varargin)
% 

DataTempNMap = varargin{1};
LocBase = varargin{2};
handles.ColorMap = varargin{3};
PositionXMapTools = varargin{4};

handles.DataTempNMap = DataTempNMap;
handles.LocBase = LocBase;

guidata(hObject, handles);

axes(handles.LOGO);
img = imread([LocBase,'/Dev/logo/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');


PositionGuiDef = get(gcf,'Position');
PositionGui = GetGuiPosition_XMT(PositionXMapTools,PositionGuiDef,[0.8,0.92]);

set(gcf,'Position',PositionGui);


for i=1:length(DataTempNMap)
    ListMap{i} = char(DataTempNMap(i).NewName);
end

handles.ListMap = ListMap;
set(handles.LISTMAP,'String',ListMap,'Value',1);

NbLinOri = size(DataTempNMap(1).NewMapCorr,1);
NbColOri = size(DataTempNMap(1).NewMapCorr,2);

set(handles.NbLinOri,'String',num2str(NbLinOri));
set(handles.NbColOri,'String',num2str(NbColOri));
set(handles.NbLinMod,'String',num2str(NbLinOri));
set(handles.NbColMod,'String',num2str(NbColOri));


% Read the last settings (if available)
if isequal(exist('Import.txt'),2)
    fid =fopen('Import.txt','r');
    
    while 1
        TheLin = fgetl(fid);
        
        if isequal(TheLin,-1) || isequal(TheLin,'')
            break
        end
        
        TheStr = strread(TheLin,'%s');
        
        if iscell(TheStr)
            switch TheStr{1}
                case 'DT_correction:'
                    set(handles.DeadTimeOn,'Value',str2num(char(TheStr{2})));                    
                
                case 'DT_param(DwellTime,DeadTime):'                
                    set(handles.DwellTime,'String',char(TheStr{2}));
                    set(handles.DeadTime,'String',char(TheStr{3}));
                
                case 'Fact(Col,Lin):'
                    set(handles.FactCol,'String',char(TheStr{2}));
                    set(handles.FactLin,'String',char(TheStr{3}));
                    
                case 'Rotation:'
                    set(handles.Rotation,'String',char(TheStr{2}));
                    
                case 'Replace_Negative_Values:'
                    set(handles.NegValues,'Value',str2num(char(TheStr{2})));                    
                
                case 'Replace_NaN_Values:'
                    set(handles.NaNValues,'Value',str2num(char(TheStr{2})));
                    
            end
        end
    end
else
    set(handles.FactCol,'String','1');
    set(handles.FactLin,'String','1');
end

guidata(hObject, handles);

UPDATE_Plot(hObject, eventdata, handles);

handles.gcf = gcf;
handles.output1 = DataTempNMap;% DataTempNMap;

handles.output = 0;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_XMTImportTool_804 wait for user response (see UIRESUME)
uiwait(hObject);


% --- Outputs from this function are returned to the command line.
function varargout = VER_XMTImportTool_804_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output1;

 
delete(hObject);


function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
    
return


function figure1_CloseRequestFcn(hObject, eventdata, handles)
if isequal(get(hObject, 'waitstatus'),'waiting')
    uiresume(hObject);
else
    delete(hObject);
end
return 


% --- Executes on button press in DONE.
function DONE_Callback(hObject, eventdata, handles)
% 

disp('Import Tool ... (apply corrections) ...')

DataTempNMap = handles.DataTempNMap;
DeadTimeOn = get(handles.DeadTimeOn,'Value');

FactCol = str2num(get(handles.FactCol,'String'));
FactLin = str2num(get(handles.FactLin,'String'));

Rotation = str2num(get(handles.Rotation,'String'));

IsDeadTimeCorrection = get(handles.DeadTimeOn,'Value');
DwellTime = str2num(get(handles.DwellTime,'String')); % ms
DeadTime = str2num(get(handles.DeadTime,'String'));  % ns

for i=1:length(DataTempNMap) 
    fprintf('\t%s\t%s\t%s\n','- Map: ',char(DataTempNMap(i).NewName),['[type: ',num2str(DataTempNMap(i).NewTYPE),']'])
    
    Data2Plot_UNCOR = DataTempNMap(i).NewMap;
    if DeadTimeOn  
    	Data2Plot_UNCOR = DataTempNMap(i).NewMapCorr;
    end

    Data2Plot_CORR = XimrotateX(CorrectMap(Data2Plot_UNCOR,FactCol,FactLin),Rotation);
    
    if ~isequal([FactCol,FactLin],[1,1]) || ~isequal(Rotation,0)
        fprintf('\t%s\n',['  * Map corrections applied: SF_col(',num2str(FactCol),'); SF_lin(',num2str(FactLin),'); Rotation(',num2str(Rotation),')'])
    end
    
    if get(handles.NegValues,'Value')
        WhereNeg = find(Data2Plot_CORR <= 0);
        Data2Plot_CORR(WhereNeg) = zeros(size(WhereNeg));
        if length(WhereNeg)
            fprintf('\t%s\n',['  * ',num2str(length(WhereNeg)),' negative values replaced by zero'])
        end
    end
    
    if get(handles.NaNValues,'Value')
        WhereNaN = find(isnan(Data2Plot_CORR));
        Data2Plot_CORR(WhereNaN) = zeros(size(WhereNaN));
        if length(WhereNaN)
            fprintf('\t%s\n',['  * ',num2str(length(WhereNaN)),' NaN replaced by zero'])
        end
    end

    if isequal(IsDeadTimeCorrection,1) && isequal(DataTempNMap(i).NewTYPE,1)
        % with dwell time correction
        MapCps = Data2Plot_CORR/(DwellTime/1000);
        MapCpsCorr = MapCps./(1 - (DeadTime*10^-9) .* MapCps);

        DTcorrection1 = MapCpsCorr-MapCps;

        Data2Plot_CORR = Data2Plot_CORR + DTcorrection1*(DwellTime/1000);
        
        fprintf('\t%s\n',['  * Dead time correction applied: DwellT(',num2str(DwellTime),'); DeadT(',num2str(DeadTime),')'])
    end
    
    DataTempNMap(i).SelMap = Data2Plot_CORR;
end

% Save the parameters ...
fid = fopen('Import.txt','w');
fprintf(fid,'%s\n','#######################################################');
fprintf(fid,'%s\n','#     XMapTools Last Import Settings (DO NOT EDIT)    #');
fprintf(fid,'%s\n','#######################################################');
fprintf(fid,'%s\n','...');
fprintf(fid,'%s\t\t\t\t\t\t%.0f\n','DT_correction:',IsDeadTimeCorrection);
fprintf(fid,'%s\t\t%.3f\t\t%.3f\n','DT_param(DwellTime,DeadTime):',DwellTime,DeadTime);
fprintf(fid,'%s\t\t\t\t\t\t%.0f\t\t\t%.0f\n','Fact(Col,Lin):',FactCol,FactLin);
fprintf(fid,'%s\t\t\t\t\t\t\t%.0f\n','Rotation:',Rotation);
fprintf(fid,'%s\t\t\t%.0f\n','Replace_Negative_Values:',get(handles.NegValues,'Value'));
fprintf(fid,'%s\t\t\t\t\t%.0f\n','Replace_NaN_Values:',get(handles.NaNValues,'Value'));
fclose(fid);

disp('Import Tool ... (Saving Import.txt) ... OK')
disp(' '),disp(' ')

handles.output1 = DataTempNMap;

guidata(hObject, handles);
close(handles.gcf);
return



function UPDATE_Plot(hObject, eventdata, handles)
%

DataTempNMap = handles.DataTempNMap;

SelectedMap = get(handles.LISTMAP,'Value');
DeadTimeOn = get(handles.DeadTimeOn,'Value');

FactCol = str2num(get(handles.FactCol,'String'));
FactLin = str2num(get(handles.FactLin,'String'));

Rotation = str2num(get(handles.Rotation,'String'));

IsDeadTimeCorrection = get(handles.DeadTimeOn,'Value');
DwellTime = str2num(get(handles.DwellTime,'String')); % ms
DeadTime = str2num(get(handles.DeadTime,'String'));  % ns

if DeadTimeOn
    % Not used in XMapTools NewMapCorr = NewMap
    Data2Plot_UNCOR = DataTempNMap(SelectedMap).NewMapCorr;
else
    Data2Plot_UNCOR = DataTempNMap(SelectedMap).NewMap;
end

Data2Plot_CORR = XimrotateX(CorrectMap(Data2Plot_UNCOR,FactCol,FactLin),Rotation);

if get(handles.NegValues,'Value')
    WhereNeg = find(Data2Plot_CORR <= 0);
    Data2Plot_CORR(WhereNeg) = zeros(size(WhereNeg));
end

if isequal(IsDeadTimeCorrection,1)
    % with dwell time correction
    MapCps = Data2Plot_CORR/(DwellTime/1000);
    MapCpsCorr = MapCps./(1 - (DeadTime*10^-9) .* MapCps);
    
    DTcorrection1 = MapCpsCorr-MapCps;

    Data2Plot_CORR = Data2Plot_CORR + DTcorrection1*(DwellTime/1000);
    
    set(handles.Axe_DT,'Visible','on')
    axes(handles.Axe_DT)
    imagesc(DTcorrection1*(DwellTime/1000)), axis image, colorbar 
    
    set(handles.Axe_DT,'xtick',[], 'ytick',[]); 
else
    axes(handles.Axe_DT)
    colorbar('delete')
    cla
    set(handles.Axe_DT,'Visible','off')
    drawnow
end

axes(handles.Axe_UNCOR)
imagesc(Data2Plot_UNCOR), axis image, colorbar, colormap(handles.ColorMap)

axes(handles.Axe_CORR)
imagesc(Data2Plot_CORR), axis image, colorbar, colormap(handles.ColorMap)

set(handles.EditMax,'String',num2str(max(Data2Plot_CORR(:))));
set(handles.EditMin,'String',num2str(min(Data2Plot_CORR(:))));

set(handles.Axe_UNCOR,'xtick',[], 'ytick',[]); 
set(handles.Axe_CORR,'xtick',[], 'ytick',[]); 

guidata(hObject, handles);
return


% #########################################################################
%    XimrotateX (NEW 1.6.3)
function [b] = XimrotateX(A,phi)
   
if phi == 0
    b = A;
elseif phi == 90
    b = rot90(A,1);
elseif phi == 180
    b = rot90(A,2);
elseif phi == 270
    b = rot90(A,3);
elseif phi == -90
    b = rot90(A,-1);
elseif phi == -180
    b = rot90(A,-2);
elseif phi == -270
    b = rot90(A,-3);
end




function UPDATE_fields(hObject, eventdata, handles, Where);
% 
Update = 0;

FactCol = str2num(get(handles.FactCol,'String'));
FactLin = str2num(get(handles.FactLin,'String'));

NbColOri = str2num(get(handles.NbColOri,'String'));
NbLinOri = str2num(get(handles.NbLinOri,'String'));

NbColMod = str2num(get(handles.NbColMod,'String'));
NbLinMod = str2num(get(handles.NbLinMod,'String'));

if isequal(Where,1)
    % Update size
    FactCol = NbColOri/NbColMod;
    FactLin = NbLinOri/NbLinMod;
    
    integerTest1 =~ mod(FactCol,1);
    integerTest2 =~ mod(FactLin,1);
    
    if integerTest1 && integerTest2
        Update = 1;
    end
    
else
    % Update FAC
    integerTest1 =~ mod(FactCol,1);
    integerTest2 =~ mod(FactLin,1);
    
    if integerTest1 && FactCol < 0    
        NbColMod = NbColOri*abs(FactCol);
    else
        NbColMod = NbColOri/FactCol;
    end
    
    if integerTest2 && NbLinMod < 0    
        NbLinMod = NbLinOri*abs(FactLin);
    else
        NbLinMod = NbLinOri/FactLin;
    end
    
    if integerTest1 && integerTest2
        Update = 1;
    end
    
    
end

if Update 
    set(handles.NbLinOri,'String',num2str(NbLinOri));
    set(handles.NbColOri,'String',num2str(NbColOri));
    set(handles.NbLinMod,'String',num2str(NbLinMod));
    set(handles.NbColMod,'String',num2str(NbColMod));

    set(handles.FactCol,'String',num2str(FactCol));
    set(handles.FactLin,'String',num2str(FactLin));
    
else
    set(handles.NbLinMod,'String',num2str(NbLinOri));
    set(handles.NbColMod,'String',num2str(NbColOri));
    
    set(handles.FactCol,'String','1');
    set(handles.FactLin,'String','1');
end

UPDATE_Plot(hObject, eventdata, handles);
    
return



function Data2Plot_CORR = CorrectMap(Data2Plot_UNCOR,FactCol,FactLin)
%

SizeOri = size(Data2Plot_UNCOR);

if FactCol >0 && FactLin > 0
    Data2Plot_CORR = Data2Plot_UNCOR(1:FactLin:end,1:FactCol:end);
end

% The following seems to work fine to expend the map ...         (10.05.16)

if FactCol >0 && FactLin < 0
    
    SizeModi = SizeOri;
    SizeModi(1) = SizeOri(1)*abs(FactLin);
    
    Data2Plot_CORR = zeros(SizeModi);
    
    for i = 1:abs(FactLin)
        Data2Plot_CORR(i:abs(FactLin):end-(abs(FactLin)-i),:) = Data2Plot_UNCOR;
    end
    
end

if FactCol <0 && FactLin > 0 
    
    SizeModi = SizeOri;
    SizeModi(2) = SizeOri(2)*abs(FactCol);
    
    Data2Plot_CORR = zeros(SizeModi);
    
    for i = 1:abs(FactCol)
        Data2Plot_CORR(:,i:abs(FactCol):end-(abs(FactCol)-i)) = Data2Plot_UNCOR;
    end
    
end

if FactCol <0 && FactLin < 0 
    
    SizeModi = SizeOri;
    SizeModi(1) = SizeOri(1)*abs(FactLin);
    SizeModi(2) = SizeOri(2)*abs(FactCol);
    
    Data2Plot_CORR = zeros(SizeModi);
    
    for i = 1:abs(FactCol)
        Data2Plot_CORR(1:abs(FactLin):end-1,i:abs(FactCol):end-(abs(FactCol)-i)) = Data2Plot_UNCOR;
    end

    % Then duplicate the rows
    for i = 1:abs(FactLin)
        Data2Plot_CORR(i:abs(FactLin):end-(abs(FactLin)-i),:) = Data2Plot_CORR(1:abs(FactLin):end-(abs(FactLin)-1),:);
    end
end



return



% --- Executes on selection change in LISTMAP.
function LISTMAP_Callback(hObject, eventdata, handles)

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



function NbColOri_Callback(hObject, eventdata, handles)
% hObject    handle to NbColOri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbColOri as text
%        str2double(get(hObject,'String')) returns contents of NbColOri as a double


% --- Executes during object creation, after setting all properties.
function NbColOri_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbColOri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbLinOri_Callback(hObject, eventdata, handles)
% hObject    handle to NbLinOri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NbLinOri as text
%        str2double(get(hObject,'String')) returns contents of NbLinOri as a double


% --- Executes during object creation, after setting all properties.
function NbLinOri_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbLinOri (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbColMod_Callback(hObject, eventdata, handles)

UPDATE_fields(hObject, eventdata, handles, 1);
return


% --- Executes during object creation, after setting all properties.
function NbColMod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbColMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NbLinMod_Callback(hObject, eventdata, handles)

UPDATE_fields(hObject, eventdata, handles, 1);
return

% --- Executes during object creation, after setting all properties.
function NbLinMod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NbLinMod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FactCol_Callback(hObject, eventdata, handles)

UPDATE_fields(hObject, eventdata, handles, 2);
return

% --- Executes during object creation, after setting all properties.
function FactCol_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FactCol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FactLin_Callback(hObject, eventdata, handles)

UPDATE_fields(hObject, eventdata, handles, 2);
return

% --- Executes during object creation, after setting all properties.
function FactLin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FactLin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in DeadTimeOn.
function DeadTimeOn_Callback(hObject, eventdata, handles)

UPDATE_Plot(hObject, eventdata, handles);
return


function Rotation_Callback(hObject, eventdata, handles)

Rotation = str2num(get(hObject,'String'));

if ~isequal(sum(ismember([0,90,180,270],Rotation)),1) 
    set(hObject,'String','0');
end
UPDATE_Plot(hObject, eventdata, handles);
return


% --- Executes during object creation, after setting all properties.
function Rotation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Rotation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function DwellTime_Callback(hObject, eventdata, handles)

UPDATE_Plot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function DwellTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DwellTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function EditMin_Callback(hObject, eventdata, handles)
%
CMin = str2num(get(handles.EditMin,'String'));
CMax = str2num(get(handles.EditMax,'String'));
if CMin < CMax
    axes(handles.Axe_UNCOR)
    caxis([CMin,CMax]);
    drawnow
    
    axes(handles.Axe_CORR)
    caxis([CMin,CMax]);
    drawnow
end
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
lesInd = get(handles.Axe_CORR,'child');
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

axes(handles.Axe_CORR)
if Val > 1
    if NTriee(Val) < NTriee(length(NTriee)-Val)
        % V1.4.2 sans caxis
        set(handles.Axe_CORR,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        set(handles.Axe_UNCOR,'CLim',[NTriee(Val),NTriee(length(NTriee)-Val)])
        %caxis([NTriee(Val),NTriee(length(NTriee)-Val)]);
    end
else
    return % no posibility to update (size  = 0)
end

set(handles.EditMax,'String',num2str(NTriee(length(NTriee)-Val)));
set(handles.EditMin,'String',num2str(NTriee(Val)));

guidata(hObject,handles);
return



function DeadTime_Callback(hObject, eventdata, handles)

UPDATE_Plot(hObject, eventdata, handles);
return

% --- Executes during object creation, after setting all properties.
function DeadTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to DeadTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in NegValues.
function NegValues_Callback(hObject, eventdata, handles)

UPDATE_Plot(hObject, eventdata, handles);
return


% --- Executes on button press in NaNValues.
function NaNValues_Callback(hObject, eventdata, handles)
% hObject    handle to NaNValues (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of NaNValues
