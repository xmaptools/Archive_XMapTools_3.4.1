function varargout = VER_StackMaps(varargin)
% VER_STACKMAPS MATLAB code for VER_StackMaps.fig
%      VER_STACKMAPS, by itself, creates a new VER_STACKMAPS or raises the existing
%      singleton*.
%
%      H = VER_STACKMAPS returns the handle to a new VER_STACKMAPS or the handle to
%      the existing singleton*.
%
%      VER_STACKMAPS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_STACKMAPS.M with the given input arguments.
%
%      VER_STACKMAPS('Property','Value',...) creates a new VER_STACKMAPS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_StackMaps_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_StackMaps_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_StackMaps

% Last Modified by GUIDE v2.5 04-Dec-2019 15:49:26

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_StackMaps_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_StackMaps_OutputFcn, ...
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


% --- Executes just before VER_StackMaps is made visible.
function VER_StackMaps_OpeningFcn(hObject, eventdata, handles, varargin)
% Opening function

movegui(hObject,'center');

%Close Unused axes
axes(handles.axes1);
cla
axis off
axes(handles.axes2);
cla
axis off
axes(handles.axes3);
cla
axis off

%-- Check if the user got the right version;
VersionOk=0;
MatLab_version=ver;
for k=1:size(MatLab_version,2);
    if isequal('Image Processing Toolbox',MatLab_version(k).Name);
       VersionOk=1;
    end
end

if VersionOk==0;
    errordlg('Please install the Image Processing Toolbox','StackMaps Fatal Error');
    figure1_CloseRequestFcn(hObject, eventdata, handles);
    return
end

%Initialise variable
handles.Current_NbMaps=0; %no map loaded yet
handles.Transform_ID=1; %no transformation saved yet
handles.popupmenu_list_transform={};
handles.ID_list3=1;
handles.popupmenu_list3={};
handles.ID_listMain=1; %(main list of maps)
handles.popupmenu_listMain={}; %main list of maps

handles.WorkingMatrixDisplayAxes1=0; %display information of working matrix
handles.WorkingMatrixDisplayAxes2=0;


VersionXMapTools = 1;

if VersionXMapTools
    
    %
    WhereIsStackMaps = which('StackMaps');
    handles.AddOnPath = WhereIsStackMaps(1:end-11);
    
    % +++ Colormap
    handles = ReadColorMaps(handles);
    
    handles.ID_listMain = 0;
    
    Maps = varargin{1};
    List = {};
    for i = 1:length(Maps.map)
        handles.ID_listMain = handles.ID_listMain + 1;
        handles.Maps(handles.ID_listMain).Data = Maps.map(i).values;
        List{i} = char(Maps.map(i).name);
    end
    
    handles.ID_listMain = handles.ID_listMain + 1; % Index is one head already
    
    handles.popupmenu_listMain = List;
    
    set(handles.popupmenu1_list1,'String',List,'Value',1);
    set(handles.popupmenu2_list2,'String',List,'Value',1);
    set(handles.popupmenu3_list3,'String',List,'Value',1);
    guidata(hObject, handles);
    
    UpdatePlot_Map_axes1(handles);  
    % ++++ HIDE UNECESSARY BUTTONS/OPTIONS
    set(handles.pushbutton_ResampleMap_axes1,'visible','off');
    set(handles.pushbutton_ResampleMap_axes2,'visible','off');
    set(handles.uipanel9,'visible','off');
    
    set(handles.pushbutton_saveFig_axes1,'visible','off');
    set(handles.pushbutton_saveFig_axes2,'visible','off');
    set(handles.pushbutton_saveFig_axes3,'visible','off');
    
    set(handles.pushbutton_savetform,'visible','off');
else
    handles.AddOnPath = '';
    % +++ Colormap
    handles = ReadColorMaps(handles);
end


for i=1:length(handles.ColorMaps);
    String{i}=handles.ColorMaps(i).Name;
end
% ColorMapCode=handles.ColorMaps.Code;

% +++ Set the list of colormaps
set(handles.popupmenu_Colormap1,'String',String,'Value',1);
set(handles.popupmenu_Colormap2,'String',String,'Value',1);
set(handles.popupmenu_Colormap3,'String',String,'Value',1);

% Hide button reset before reference points are selected
set(handles.pushbutton_resetref_axes1,'visible','off');

% Hide button for axes 2 until axes 1 is processed
set(handles.pushbutton_setreference_axes2,'visible','off');
set(handles.pushbutton_resetref_axes2,'visible','off');
set(handles.pushbutton_saveRefPoints,'visible','off');


% Choose default command line output for VER_StackMaps
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes VER_StackMaps wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_StackMaps_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = 1;%handles.output;


% --- Executes on selection change in popupmenu_Refmap.
function popupmenu_Refmap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Refmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Refmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Refmap

%Update the handles
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_Refmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Refmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Deformedmap.
function popupmenu_Deformedmap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Deformedmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Deformedmap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Deformedmap
%Update the handles
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_Deformedmap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Deformedmap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6


% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_ApplyTransform.
function pushbutton_ApplyTransform_Callback(hObject, eventdata, handles)
%When user press button apply transform
%read value of popupmenu_Refmap and popupmenu_Deformedmap
%Apply for both maps SetWorkingSpace, RemoveNaN

WorkingSpaceX=2000;
WorkingSpaceY=2000;

val = get(handles.popupmenu_Refmap, 'Value'); %get which Map is selected

dataMatrix=handles.Maps(val).Data;
WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
[ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );

% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         handles.currentMap=1;     
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 2
%         dataMatrix=handles.Map2;
%         handles.currentMap=2;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 3
%         dataMatrix=handles.Map3;
%         handles.currentMap=3;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 4
%         dataMatrix=handles.Map4;
%         handles.currentMap=4;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 5
%         dataMatrix=handles.Map5;
%         handles.currentMap=5;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 6
%         dataMatrix=handles.Map6;
%         handles.currentMap=6;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 7
%         dataMatrix=handles.Map7;
%         handles.currentMap=7;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 8
%         dataMatrix=handles.Map8;
%         handles.currentMap=8;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 9
%         dataMatrix=handles.Map9;
%         handles.currentMap=9;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 10
%         dataMatrix=handles.Map10;
%         handles.currentMap=10;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
% end

[RowRef,ColRef]=size(dataMatrix);
RefImage=WorkingMatrix_Current;

val = get(handles.popupmenu_Deformedmap, 'Value'); %get which Map is selected
str= get(handles.popupmenu_Deformedmap, 'String');
DeformedMap_string=str{val};

dataMatrix=handles.Maps(val).Data;
WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
[ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
% 
% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         handles.currentMap=1;     
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 2
%         dataMatrix=handles.Map2;
%         handles.currentMap=2;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 3
%         dataMatrix=handles.Map3;
%         handles.currentMap=3;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 4
%         dataMatrix=handles.Map4;
%         handles.currentMap=4;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 5
%         dataMatrix=handles.Map5;
%         handles.currentMap=5;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 6
%         dataMatrix=handles.Map6;
%         handles.currentMap=6;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 7
%         dataMatrix=handles.Map7;
%         handles.currentMap=7;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 8
%         dataMatrix=handles.Map8;
%         handles.currentMap=8;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 9
%         dataMatrix=handles.Map9;
%         handles.currentMap=9;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 10
%         dataMatrix=handles.Map10;
%         handles.currentMap=10;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
% end

DeformedImage=WorkingMatrix_Current;


%read value of the popupmenu_transform to get the wanted transformation,
% retrieve the transform factor.

val = get(handles.popupmenu_transform, 'Value'); %get which Map is selected
str = get(handles.popupmenu_transform, 'String');
tform_string=str{val};
tform=handles.tform(val).Data;

%Transform the map
TransformedMap = imwarp(DeformedImage,tform,'OutputView',imref2d(size(RefImage)));

WhereRef = find(RefImage > 0);

TransformedMap_reshape=reshape(TransformedMap(WhereRef),[RowRef,ColRef]);

%put the corrected image in the popupmenu of axes3
%name Deformed map x tranform chosen
newString=[DeformedMap_string,' x ',tform_string];
% handles.popupmenu_list3=[handles.popupmenu_list3,newString];
% set(handles.popupmenu3_list3,'String',handles.popupmenu_list3);

handles.popupmenu_listMain=[handles.popupmenu_listMain,newString]; %main list of maps
handles.Maps(handles.ID_listMain).Data=TransformedMap_reshape;
handles.ID_listMain=handles.ID_listMain+1;

%update the popupmenus
set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

% handles.MapCorrected(handles.ID_list3).Data=TransformedMap_reshape;
% handles.ID_list3=handles.ID_list3+1;


%Update plot
% set(handles.popupmenu3_list3,'String',newString);
set(handles.popupmenu3_list3,'Value',handles.ID_listMain-1);
UpdatePlot_Map_axes3(handles);

guidata(hObject,handles); %update handles



% --- Executes on selection change in popupmenu_transform.
function popupmenu_transform_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_transform contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_transform
%Update the handles
guidata(hObject,handles)

% --- Executes during object creation, after setting all properties.
function popupmenu_transform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_transform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_setreference_axes2.
function pushbutton_setreference_axes2_Callback(hObject, eventdata, handles)
% When user press Selec reference points button

% enable access tp reset button and save RefPoints
set(handles.pushbutton_resetref_axes2,'visible','on');
set(handles.pushbutton_saveRefPoints,'visible','on');

handles.WorkingMatrixDisplayAxes2=1;

%Check which map is displayed.
% (-Check if pixel size is same) <- later version 
% -setWorkingSpace (put matrix in a big zero matrix
% -remove NaN
% - do affine transform
WorkingSpaceX=2000;
WorkingSpaceY=2000;

val = get(handles.popupmenu2_list2, 'Value'); %get which Map is selected

dataMatrix=handles.Maps(val).Data;
WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
[ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );

prompt={'Enter window size (in pixels)'}
dlgtitle='Select window size';
dims=[1 35];
definput={'50'};
answer=inputdlg(prompt,dlgtitle,dims,definput);
WindowSize=str2num(answer{1});
handles.WindowSize_axes2=WindowSize;

% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         handles.currentMap=1;     
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 2
%         dataMatrix=handles.Map2;
%         handles.currentMap=2;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 3
%         dataMatrix=handles.Map3;
%         handles.currentMap=3;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 4
%         dataMatrix=handles.Map4;
%         handles.currentMap=4;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 5
%         dataMatrix=handles.Map5;
%         handles.currentMap=5;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 6
%         dataMatrix=handles.Map6;
%         handles.currentMap=6;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 7
%         dataMatrix=handles.Map7;
%         handles.currentMap=7;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 8
%         dataMatrix=handles.Map8;
%         handles.currentMap=8;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 9
%         dataMatrix=handles.Map9;
%         handles.currentMap=9;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 10
%         dataMatrix=handles.Map10;
%         handles.currentMap=10;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
% end

%find where start the map in the WorkingMatrix
for i=2:size(WorkingMatrix_Current,1);
    for j=2:size(WorkingMatrix_Current,2);
        if WorkingMatrix_Current(i,j)>0 & WorkingMatrix_Current(i,j-1)==0 & WorkingMatrix_Current(i-1,j)==0;
            %first border
            FirstBorderRow=i;
            FirstBorderCol=j;
        end
        if WorkingMatrix_Current(i,j)>0 & WorkingMatrix_Current(i,j+1)==0 & WorkingMatrix_Current(i+1,j)==0;
            %last border
            LastBorderRow=i;
            LastBorderCol=j;
        end
    end
end

%UpdatePlot
refPoints=[]; %no ref points selected yet
UpdatePlot_SetRef_axes2(handles,WorkingMatrix_Current,FirstBorderRow,FirstBorderCol,LastBorderRow,LastBorderCol,refPoints);

%Select points
axes(handles.axes2);
Clic=0;
Compt=0;
handles.RefDistorded=[];
Xlim_ini=get(handles.axes2,'Xlim');
Ylim_ini=get(handles.axes2,'Ylim');
j=1;
while Clic<3; %if clic right, stop asking for points
    [xtozoom,ytozoom,clic2]=ginput(1);
    if clic2==3;
        break
    end
    %modify on axes1
    set(handles.axes1,'xlim',[handles.RefOriginal(j,1)-handles.WindowSize_axes1/2 handles.RefOriginal(j,1)+handles.WindowSize_axes1/2]);
    set(handles.axes1,'ylim',[handles.RefOriginal(j,2)-handles.WindowSize_axes1/2 handles.RefOriginal(j,2)+handles.WindowSize_axes1/2]);
      
    xlim([xtozoom-WindowSize/2 xtozoom+WindowSize/2]);
    ylim([ytozoom-WindowSize/2 ytozoom+WindowSize/2]); 
    Compt=Compt+1;
    [x_input(Compt),y_input(Compt),Clic] = ginput(1); %user input
    if Clic<3; 
        hold on
        plot(x_input(Compt),y_input(Compt),'Marker','o','MarkerFaceColor','w');
        text(x_input(Compt),y_input(Compt),num2str(Compt));
    end
    xlim(Xlim_ini);
    ylim(Ylim_ini); 
    set(handles.axes1,'xlim',handles.Xlim_ini_Axes1);
    set(handles.axes1,'ylim',handles.Ylim_ini_Axes1);
    j=j+1;
    guidata(hObject,handles)
end

handles.DeformedMapCurrent.WorkingMatrix=WorkingMatrix_Current;
handles.DeformedMapCurrent.Borders=[FirstBorderRow,FirstBorderCol;LastBorderRow,LastBorderCol];

%save xy coordinate of the reference points
handles.RefDistorded(:,1)=round(x_input(1:end));
handles.RefDistorded(:,2)=round(y_input(1:end));

handles.Check_Distorded=1;

if size(handles.RefDistorded,1)<3;
    f = warndlg('not enough points selected (<3)')
    pause(2)
    close(f)
    pushbutton_resetref_axes2_Callback(hObject, eventdata, handles)
end


%Update the handle
guidata(hObject,handles)

function UpdatePlot_SetRef_axes2(handles,WorkingMatrix_Current,FirstBorderRow,FirstBorderCol,LastBorderRow,LastBorderCol,refPoints);
%UpdatePlot on axes1 when setting ref points
axes(handles.axes2);
cla 

dataMatrix=WorkingMatrix_Current;
imagesc(dataMatrix); 

%Colormap setting
Str_edit_min2=get(handles.edit_min_axes2,'String');
Str_edit_max2=get(handles.edit_max_axes2,'String');
ValMin2=str2num(get(handles.edit_min_axes2,'String'));
ValMax2=str2num(get(handles.edit_max_axes2,'String'));

if length(Str_edit_max2)==4  & Str_edit_max2=='auto';
    %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(2,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
else
    %custom scale
    [handles] = StackMapsColorbar(2,gca,handles);
    caxis([ValMin2, ValMax2]);
    h = colorbar;
end

%set xlim/ylim
xlim([FirstBorderCol-50 LastBorderCol+50])
ylim([FirstBorderRow-50 LastBorderRow+50])
set(gca,'xtick',[])
set(gca,'ytick',[])


% --- Executes on button press in pushbutton_resetref_axes2.
function pushbutton_resetref_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetref_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

refPoints=[]; %no ref points selected yet
UpdatePlot_SetRef_axes2(handles,handles.DeformedMapCurrent.WorkingMatrix,handles.DeformedMapCurrent.Borders(1,1),handles.DeformedMapCurrent.Borders(1,2),handles.DeformedMapCurrent.Borders(2,1),handles.DeformedMapCurrent.Borders(2,2),refPoints);
handles.RefDistorded=[];
guidata(hObject,handles);



% --- Executes on button press in pushbutton_saveRefPoints.
function pushbutton_saveRefPoints_Callback(hObject, eventdata, handles)
% When user press saveRefPoints
%Check if RefOriginal - RefDistorded are the same length
if size(handles.RefOriginal,1)==size(handles.RefDistorded,1);
    %Compute the affine transform
    test1=handles.RefOriginal;
    test2=handles.RefDistorded;
    tform = fitgeotrans(handles.RefDistorded, handles.RefOriginal,'affine');
    %Input dlg. Ask user to set a name for this transform
    prompt={'Enter name for this transformation'};
    dlgtitle='Save transformation';
    dims=[1 35];
    definput={'Transformation'};
    answer=inputdlg(prompt,dlgtitle,dims,definput);
    handles.tform(handles.Transform_ID).Data=tform;
    
    handles.tform(handles.Transform_ID).RefMap.WorkingMatrix=handles.RefMapCurrent.WorkingMatrix;
    handles.tform(handles.Transform_ID).RefMap.Borders=handles.RefMapCurrent.Borders;
    handles.tform(handles.Transform_ID).DeformedMapCurrent.WorkingMatrix=handles.DeformedMapCurrent.WorkingMatrix;
    handles.tform(handles.Transform_ID).DeformedMapCurrent.Borders=handles.DeformedMapCurrent.Borders;
    
    handles.Transform_ID=handles.Transform_ID+1;
    %Update the popupmenu related to transformation
    handles.popupmenu_list_transform=[handles.popupmenu_list_transform,answer];
    set(handles.popupmenu_transform,'String',handles.popupmenu_list_transform);
    
    %Save the datafile
    [Success,Message,MessageID] = mkdir('Transformations');
    save(['./Transformations/',answer{1},'.mat'],'tform');
else
    f= errordlg('Reference points does not match!');
    pause(2);
    close(f);
end

%reset selected points
handles.RefOriginal=[];
handles.RefDistorded=[];

guidata(hObject,handles);



% --- Executes on button press in pushbutton_setreference_axes1.
function pushbutton_setreference_axes1_Callback(hObject, eventdata, handles)
% When user press Selec reference points button

%Display reset button
set(handles.pushbutton_resetref_axes1,'visible','on');

handles.WorkingMatrixDisplayAxes1=1;
%Check which map is displayed.
% (-Check if pixel size is same) <- later version 
% -setWorkingSpace (put matrix in a big zero matrix
% -remove NaN
% - do affine transform
WorkingSpaceX=2000;
WorkingSpaceY=2000;

val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected

dataMatrix=handles.Maps(val).Data;
WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
[ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );

prompt={'Enter window size (in pixels)'}
dlgtitle='Select window size';
dims=[1 35];
definput={'50'};
answer=inputdlg(prompt,dlgtitle,dims,definput);
WindowSize=str2num(answer{1});
handles.WindowSize_axes1=WindowSize;

% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         handles.currentMap=1;     
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 2
%         dataMatrix=handles.Map2;
%         handles.currentMap=2;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 3
%         dataMatrix=handles.Map3;
%         handles.currentMap=3;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 4
%         dataMatrix=handles.Map4;
%         handles.currentMap=4;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 5
%         dataMatrix=handles.Map5;
%         handles.currentMap=5;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 6
%         dataMatrix=handles.Map6;
%         handles.currentMap=6;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 7
%         dataMatrix=handles.Map7;
%         handles.currentMap=7;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 8
%         dataMatrix=handles.Map8;
%         handles.currentMap=8;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 9
%         dataMatrix=handles.Map9;
%         handles.currentMap=9;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
%     case 10
%         dataMatrix=handles.Map10;
%         handles.currentMap=10;
%         WorkingMatrix_Current=SetWorkingSpace( dataMatrix , WorkingSpaceX, WorkingSpaceY, 0 );
%         [ WorkingMatrix_Current ] = RemoveNaN( WorkingMatrix_Current,0.001 );
% end

%find where start the map in the WorkingMatrix
for i=2:size(WorkingMatrix_Current,1);
    for j=2:size(WorkingMatrix_Current,2);
        if WorkingMatrix_Current(i,j)>0 & WorkingMatrix_Current(i,j-1)==0 & WorkingMatrix_Current(i-1,j)==0;
            %first border
            FirstBorderRow=i;
            FirstBorderCol=j;
        end
        if WorkingMatrix_Current(i,j)>0 & WorkingMatrix_Current(i,j+1)==0 & WorkingMatrix_Current(i+1,j)==0;
            %last border
            LastBorderRow=i;
            LastBorderCol=j;
        end
    end
end

%UpdatePlot
refPoints=[]; %no ref points selected yet
UpdatePlot_SetRef_axes1(handles,WorkingMatrix_Current,FirstBorderRow,FirstBorderCol,LastBorderRow,LastBorderCol,refPoints);

%Select points
axes(handles.axes1);
Clic=0;
Compt=0;
handles.RefOriginal=[];
handles.Xlim_ini_Axes1=get(handles.axes1,'Xlim');
handles.Ylim_ini_Axes1=get(handles.axes1,'Ylim');

while Clic<3; %if clic right, stop asking for points
    [xtozoom,ytozoom,clic2]=ginput(1);
    if clic2==3;
        break
    end
    xlim([xtozoom-WindowSize/2 xtozoom+WindowSize/2]);
    ylim([ytozoom-WindowSize/2 ytozoom+WindowSize/2]);    
    Compt=Compt+1;
    [x_input(Compt),y_input(Compt),Clic] = ginput(1); %user input
    if Clic<3; 
        hold on
        plot(x_input(Compt),y_input(Compt),'Marker','o','MarkerFaceColor','w');
        text(x_input(Compt),y_input(Compt),num2str(Compt));
    end
    xlim(handles.Xlim_ini_Axes1);
    ylim(handles.Ylim_ini_Axes1);   
end

%save xy coordinate of the reference points
handles.RefOriginal(:,1)=round(x_input(1:end));
handles.RefOriginal(:,2)=round(y_input(1:end));
handles.RefMapCurrent.WorkingMatrix=WorkingMatrix_Current;
handles.RefMapCurrent.Borders=[FirstBorderRow,FirstBorderCol;LastBorderRow,LastBorderCol];

handles.Check_RefOriginal=1;

if size(handles.RefOriginal,1)<3;
    f = warndlg('not enough points selected (<3)')
    pause(2)
    close(f)
    pushbutton_resetref_axes1_Callback(hObject, eventdata, handles)
end

%-- Authorise access to selection for reference point on figure 2
set(handles.pushbutton_setreference_axes2,'visible','on');

%Update the handle
guidata(hObject,handles)

function UpdatePlot_SetRef_axes1(handles,WorkingMatrix_Current,FirstBorderRow,FirstBorderCol,LastBorderRow,LastBorderCol,refPoints);
%UpdatePlot on axes1 when setting ref points
axes(handles.axes1);
cla 

dataMatrix=WorkingMatrix_Current;
imagesc(dataMatrix);

%Colormap setting
Str_edit_min1=get(handles.edit_min_axes1,'String');
Str_edit_max1=get(handles.edit_max_axes1,'String');
ValMin1=str2num(get(handles.edit_min_axes1,'String'));
ValMax1=str2num(get(handles.edit_max_axes1,'String'));

if length(Str_edit_max1)==4  & Str_edit_max1=='auto';
    %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(1,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
else
    %custom scale
    [handles] = StackMapsColorbar(1,gca,handles);
    caxis([ValMin1, ValMax1]);
    h = colorbar;
end

%set xlim/ylim
xlim([FirstBorderCol-50 LastBorderCol+50])
ylim([FirstBorderRow-50 LastBorderRow+50])
set(gca,'xtick',[])
set(gca,'ytick',[])





% --- Executes on button press in pushbutton_resetref_axes1.
function pushbutton_resetref_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_resetref_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
refPoints=[]; %no ref points selected yet
UpdatePlot_SetRef_axes1(handles,handles.RefMapCurrent.WorkingMatrix,handles.RefMapCurrent.Borders(1,1),handles.RefMapCurrent.Borders(1,2),handles.RefMapCurrent.Borders(2,1),handles.RefMapCurrent.Borders(2,2),refPoints);
handles.RefOriginal=[];
guidata(hObject,handles);


% --- Executes on selection change in popupmenu2_list2.
function popupmenu2_list2_Callback(hObject, eventdata, handles)
% when user select a map in the popupmenu of axes 2
handles.WorkingMatrixDisplayAxes2=0;
UpdatePlot_Map_axes2(handles)
guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function popupmenu2_list2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2_list2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_autoscale_axes2.
function pushbutton_autoscale_axes2_Callback(hObject, eventdata, handles)
%When user press autoscale on axes 2

% Set the auto string on both edit box
set(handles.edit_min_axes2,'String','auto');
set(handles.edit_max_axes2,'String','auto');
guidata(hObject, handles);   
% Update plot on axes2
UpdatePlot_Map_axes2(handles);



function edit_min_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_axes2 as text
%        str2double(get(hObject,'String')) returns contents of edit_min_axes2 as a double


% --- Executes during object creation, after setting all properties.
function edit_min_axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_axes2_Callback(hObject, eventdata, handles)
% When user press enter in the edit box
% Update plot on axes2
UpdatePlot_Map_axes2(handles)


% --- Executes during object creation, after setting all properties.
function edit_max_axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ResampleMap_axes2.
function pushbutton_ResampleMap_axes2_Callback(hObject, eventdata, handles)
% When user press the ResampleMap button on axes2
% Resample the map to the desired pixel size

%Find which map is currently displayed
%ask user for the size of the pixel

prompt={'Enter initial pixel size in m','Enter desired pixel size in m'};
dlgtitle='Input resampling settings';
dims=[1 35];

val = get(handles.popupmenu2_list2, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
test=dataMatrix;
definput={'1','1'};
answer=inputdlg(prompt,dlgtitle,dims,definput);
handles.SizePixelIni=str2num(answer{1});
handles.SizePixelFinal=str2num(answer{2});
[ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni, handles.SizePixelFinal);
% handles.Map1=ResampledMap;
% handles.popupmenu_list{1}=[handles.popupmenu_list{1},'*r',num2str(handles.SizePixelFinal_Map1),'m'];

NewString=[handles.popupmenu_listMain{val},'Xr',num2str(handles.SizePixelFinal),'m'];
handles.popupmenu_listMain=[handles.popupmenu_listMain,NewString]; %main list of maps
handles.Maps(handles.ID_listMain).Data=ResampledMap;
handles.ID_listMain=handles.ID_listMain+1;

set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

% 
% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map1=str2num(answer{1});
%         handles.SizePixelFinal_Map1=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map1, handles.SizePixelFinal_Map1 );
%         handles.Map1=ResampledMap;
%         handles.popupmenu_list{1}=[handles.popupmenu_list{1},'*r',num2str(handles.SizePixelFinal_Map1),'m'];  
%     case 2
%         dataMatrix=handles.Map2;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map2=str2num(answer{1});
%         handles.SizePixelFinal_Map2=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map2, handles.SizePixelFinal_Map2 );
%         handles.Map2=ResampledMap;
%         handles.popupmenu_list{2}=[handles.popupmenu_list{2},'*r',num2str(handles.SizePixelFinal_Map2),'m'];  
%     case 3
%         dataMatrix=handles.Map3;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map3=str2num(answer{1});
%         handles.SizePixelFinal_Map3=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map3, handles.SizePixelFinal_Map3 );
%         handles.Map3=ResampledMap;
%         handles.popupmenu_list{3}=[handles.popupmenu_list{3},'*r',num2str(handles.SizePixelFinal_Map3),'m'];   
%     case 4
%         dataMatrix=handles.Map4;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map4=str2num(answer{1});
%         handles.SizePixelFinal_Map4=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map4, handles.SizePixelFinal_Map4 );
%         handles.Map4=ResampledMap;
%         handles.popupmenu_list{4}=[handles.popupmenu_list{4},'*r',num2str(handles.SizePixelFinal_Map4),'m'];  
%     case 5
%         dataMatrix=handles.Map5;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map5=str2num(answer{1});
%         handles.SizePixelFinal_Map5=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map5, handles.SizePixelFinal_Map5 );
%         handles.Map5=ResampledMap;
%         handles.popupmenu_list{5}=[handles.popupmenu_list{5},'*r',num2str(handles.SizePixelFinal_Map5),'m'];  
%     case 6
%         dataMatrix=handles.Map6;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map6=str2num(answer{1});
%         handles.SizePixelFinal_Map6=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map6, handles.SizePixelFinal_Map6 );
%         handles.Map6=ResampledMap;
%         handles.popupmenu_list{6}=[handles.popupmenu_list{6},'*r',num2str(handles.SizePixelFinal_Map6),'m'];   
%     case 7
%         dataMatrix=handles.Map7;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map7=str2num(answer{1});
%         handles.SizePixelFinal_Map7=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map7, handles.SizePixelFinal_Map7 );
%         handles.Map7=ResampledMap;
%         handles.popupmenu_list{7}=[handles.popupmenu_list{7},'*r',num2str(handles.SizePixelFinal_Map7),'m'];   
%     case 8
%         dataMatrix=handles.Map8;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map8=str2num(answer{1});
%         handles.SizePixelFinal_Map8=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map8, handles.SizePixelFinal_Map8 );
%         handles.Map8=ResampledMap;
%         handles.popupmenu_list{8}=[handles.popupmenu_list{8},'*r',num2str(handles.SizePixelFinal_Map8),'m'];   
%     case 9
%         dataMatrix=handles.Map9;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map9=str2num(answer{1});
%         handles.SizePixelFinal_Map9=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map9, handles.SizePixelFinal_Map9 );
%         handles.Map9=ResampledMap;
%         handles.popupmenu_list{9}=[handles.popupmenu_list{9},'*r',num2str(handles.SizePixelFinal_Map9),'m'];  
%     case 10
%         dataMatrix=handles.Map10;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map10=str2num(answer{1});
%         handles.SizePixelFinal_Map10=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map10, handles.SizePixelFinal_Map10 );
%         handles.Map10=ResampledMap;
%         handles.popupmenu_list{10}=[handles.popupmenu_list{10},'*r',num2str(handles.SizePixelFinal_Map10),'m'];   
% end

% set(handles.popupmenu1_list1,'String',handles.popupmenu_list);
% set(handles.popupmenu2_list2,'String',handles.popupmenu_list);
% set(handles.popupmenu_Refmap,'String',handles.popupmenu_list);
% set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_list);

guidata(hObject, handles); %update the handles
%Update plot axes 1
UpdatePlot_Map_axes2(handles);


% --- Executes on button press in pushbutton_AddMap2.
function pushbutton_AddMap2_Callback(hObject, eventdata, handles)
% /!\ same as AddMap1
% Call AddMap 1 function
% pushbutton_AddMap1_Callback(hObject, eventdata, handles)
%Open dialog box to select the file
[filename,filepath]=uigetfile('*.txt');
%Try another method with no limit

handles.popupmenu_listMain=[handles.popupmenu_listMain,filename(1:end-4)]; %main list of maps
handles.Maps(handles.ID_listMain).Data=load([filepath filename]);
handles.ID_listMain=handles.ID_listMain+1;

set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

%

% set(handles.popupmenu1_list1,'String',handles.popupmenu_list);
% set(handles.popupmenu2_list2,'String',handles.popupmenu_list);
% set(handles.popupmenu_Refmap,'String',handles.popupmenu_list);
% set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_list);
set(handles.popupmenu2_list2,'Value',handles.ID_listMain-1);
guidata(hObject, handles); %update the handles
UpdatePlot_Map_axes2(handles);
guidata(hObject, handles); %update the handles

% --- Executes on selection change in popupmenu3_list3.
function popupmenu3_list3_Callback(hObject, eventdata, handles)
% when user select a map in the popupmenu of axes 3
UpdatePlot_Map_axes3(handles)


% --- Executes during object creation, after setting all properties.
function popupmenu3_list3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3_list3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_autoscale_axes3.
function pushbutton_autoscale_axes3_Callback(hObject, eventdata, handles)
%When user press autoscale on axes 3

% Set the auto string on both edit box
set(handles.edit_min_axes3,'String','auto');
set(handles.edit_max_axes3,'String','auto');
guidata(hObject, handles);   
% Update plot on axes1
UpdatePlot_Map_axes3(handles);



function edit_min_axes3_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_axes3 as text
%        str2double(get(hObject,'String')) returns contents of edit_min_axes3 as a double


% --- Executes during object creation, after setting all properties.
function edit_min_axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_axes3_Callback(hObject, eventdata, handles)
% When user press enter in the edit box
% Update plot on axes3
UpdatePlot_Map_axes3(handles)


% --- Executes during object creation, after setting all properties.
function edit_max_axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu1_list1.
function popupmenu1_list1_Callback(hObject, eventdata, handles)
%Popupmenu 1 related to axes1. Allow user to select map to plot or update
%the plot.
% /!\ Very similar to popupmenu2_list2 which is linked to axes 2
% Only call Update plot on axes1 (see end)
handles.WorkingMatrixDisplayAxes1=0;

UpdatePlot_Map_axes1(handles)
guidata(hObject, handles); %update the handles


% --- Executes during object creation, after setting all properties.
function popupmenu1_list1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1_list1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_autoscale_axes1.
function pushbutton_autoscale_axes1_Callback(hObject, eventdata, handles)
%When user press autoscale on axes 1

% Set the auto string on both edit box
set(handles.edit_min_axes1,'String','auto');
set(handles.edit_max_axes1,'String','auto');
guidata(hObject, handles);   
% Update plot on axes1
UpdatePlot_Map_axes1(handles);

function edit_min_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to edit_min_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_min_axes1 as text
%        str2double(get(hObject,'String')) returns contents of edit_min_axes1 as a double


% --- Executes during object creation, after setting all properties.
function edit_min_axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_min_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_max_axes1_Callback(hObject, eventdata, handles)
% When user press enter in the edit box
% Update plot on axes1
UpdatePlot_Map_axes1(handles)

% --- Executes during object creation, after setting all properties.
function edit_max_axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_max_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ResampleMap_axes1.
function pushbutton_ResampleMap_axes1_Callback(hObject, eventdata, handles)
% When user press the ResampleMap button on axes1
% Resample the map to the desired pixel size

%Find which map is currently displayed
%ask user for the size of the pixel

prompt={'Enter initial pixel size in m','Enter desired pixel size in m'};
dlgtitle='Input resampling settings';
dims=[1 35];

val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
definput={'1','1'};
answer=inputdlg(prompt,dlgtitle,dims,definput);

handles.SizePixelIni=str2num(answer{1});
handles.SizePixelFinal=str2num(answer{2});
[ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni, handles.SizePixelFinal);
% handles.Map1=ResampledMap;
% handles.popupmenu_list{1}=[handles.popupmenu_list{1},'*r',num2str(handles.SizePixelFinal_Map1),'m'];

NewString=[handles.popupmenu_listMain{val},'Xr',num2str(handles.SizePixelFinal),'m'];
handles.popupmenu_listMain=[handles.popupmenu_listMain,NewString]; %main list of maps
handles.Maps(handles.ID_listMain).Data=ResampledMap;
handles.ID_listMain=handles.ID_listMain+1;

set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

% prompt={'Enter initial pixel size in m','Enter desired pixel size in m'};
% dlgtitle='Input resampling settings';
% dims=[1 35];
% 
% val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected
% switch val
%     case 1
%         dataMatrix=handles.Map1;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map1=str2num(answer{1});
%         handles.SizePixelFinal_Map1=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map1, handles.SizePixelFinal_Map1 );
%         handles.Map1=ResampledMap;
%         handles.popupmenu_list{1}=[handles.popupmenu_list{1},'*r',num2str(handles.SizePixelFinal_Map1),'m'];  
%     case 2
%         dataMatrix=handles.Map2;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map2=str2num(answer{1});
%         handles.SizePixelFinal_Map2=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map2, handles.SizePixelFinal_Map2 );
%         handles.Map2=ResampledMap;
%         handles.popupmenu_list{2}=[handles.popupmenu_list{2},'*r',num2str(handles.SizePixelFinal_Map2),'m'];  
%     case 3
%         dataMatrix=handles.Map3;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map3=str2num(answer{1});
%         handles.SizePixelFinal_Map3=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map3, handles.SizePixelFinal_Map3 );
%         handles.Map3=ResampledMap;
%         handles.popupmenu_list{3}=[handles.popupmenu_list{3},'*r',num2str(handles.SizePixelFinal_Map3),'m'];   
%     case 4
%         dataMatrix=handles.Map4;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map4=str2num(answer{1});
%         handles.SizePixelFinal_Map4=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map4, handles.SizePixelFinal_Map4 );
%         handles.Map4=ResampledMap;
%         handles.popupmenu_list{4}=[handles.popupmenu_list{4},'*r',num2str(handles.SizePixelFinal_Map4),'m'];  
%     case 5
%         dataMatrix=handles.Map5;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map5=str2num(answer{1});
%         handles.SizePixelFinal_Map5=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map5, handles.SizePixelFinal_Map5 );
%         handles.Map5=ResampledMap;
%         handles.popupmenu_list{5}=[handles.popupmenu_list{5},'*r',num2str(handles.SizePixelFinal_Map5),'m'];  
%     case 6
%         dataMatrix=handles.Map6;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map6=str2num(answer{1});
%         handles.SizePixelFinal_Map6=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map6, handles.SizePixelFinal_Map6 );
%         handles.Map6=ResampledMap;
%         handles.popupmenu_list{6}=[handles.popupmenu_list{6},'*r',num2str(handles.SizePixelFinal_Map6),'m'];   
%     case 7
%         dataMatrix=handles.Map7;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map7=str2num(answer{1});
%         handles.SizePixelFinal_Map7=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map7, handles.SizePixelFinal_Map7 );
%         handles.Map7=ResampledMap;
%         handles.popupmenu_list{7}=[handles.popupmenu_list{7},'*r',num2str(handles.SizePixelFinal_Map7),'m'];   
%     case 8
%         dataMatrix=handles.Map8;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map8=str2num(answer{1});
%         handles.SizePixelFinal_Map8=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map8, handles.SizePixelFinal_Map8 );
%         handles.Map8=ResampledMap;
%         handles.popupmenu_list{8}=[handles.popupmenu_list{8},'*r',num2str(handles.SizePixelFinal_Map8),'m'];   
%     case 9
%         dataMatrix=handles.Map9;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map9=str2num(answer{1});
%         handles.SizePixelFinal_Map9=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map9, handles.SizePixelFinal_Map9 );
%         handles.Map9=ResampledMap;
%         handles.popupmenu_list{9}=[handles.popupmenu_list{9},'*r',num2str(handles.SizePixelFinal_Map9),'m'];  
%     case 10
%         dataMatrix=handles.Map10;
%         definput={'1','1'};
%         answer=inputdlg(prompt,dlgtitle,dims,definput);
%         handles.SizePixelIni_Map10=str2num(answer{1});
%         handles.SizePixelFinal_Map10=str2num(answer{2});
%         [ ResampledMap ] = ResampleMap( dataMatrix, handles.SizePixelIni_Map10, handles.SizePixelFinal_Map10 );
%         handles.Map10=ResampledMap;
%         handles.popupmenu_list{10}=[handles.popupmenu_list{10},'*r',num2str(handles.SizePixelFinal_Map10),'m'];   
% end
% 
% set(handles.popupmenu1_list1,'String',handles.popupmenu_list);
% set(handles.popupmenu2_list2,'String',handles.popupmenu_list);
% set(handles.popupmenu_Refmap,'String',handles.popupmenu_list);
% set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_list);

guidata(hObject, handles); %update the handles
%Update plot axes 1
UpdatePlot_Map_axes1(handles);

% --- Executes on button press in pushbutton_AddMap1.
function pushbutton_AddMap1_Callback(hObject, eventdata, handles)
% add matrix to the program using load button
% /!\ same as pushbutton_AddMap2

%Open dialog box to select the file
% [filename,filepath]=uigetfile('*.txt');
% switch handles.Current_NbMaps
%     case 0 %if no map loaded yet
%         handles.Map1=load([filepath filename]); %load map from txt tab delimited
%         handles.Current_NbMaps=handles.Current_NbMaps+1; %counter of loaded maps
%         %Update popupmenus
%         handles.popupmenu_list{1}=filename(1:end-4); %filename without .txt
%     case 1
%         handles.Map2=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{2}=filename(1:end-4);
%     case 2
%         handles.Map3=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{3}=filename(1:end-4);
%     case 3
%         handles.Map4=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{4}=filename(1:end-4);
%     case 4
%         handles.Map5=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{5}=filename(1:end-4);
%     case 5
%         handles.Map6=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{6}=filename(1:end-4);
%     case 6
%         handles.Map7=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{7}=filename(1:end-4);
%     case 7
%         handles.Map8=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{8}=filename(1:end-4);
%     case 8
%         handles.Map9=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{9}=filename(1:end-4);
%     case 9
%         handles.Map10=load([filepath filename]);
%         handles.Current_NbMaps=handles.Current_NbMaps+1;
%         handles.popupmenu_list{10}=filename(1:end-4);
%     case 10
%         f_error1 = errordlg('Number map of loaded map =10','Error type 1');
% end
%Open dialog box to select the file
[filename,filepath]=uigetfile('*.txt');
%Try another method with no limit

handles.popupmenu_listMain=[handles.popupmenu_listMain,filename(1:end-4)]; %main list of maps
handles.Maps(handles.ID_listMain).Data=load([filepath filename]);
handles.ID_listMain=handles.ID_listMain+1;

set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

%

% set(handles.popupmenu1_list1,'String',handles.popupmenu_list);
% set(handles.popupmenu2_list2,'String',handles.popupmenu_list);
% set(handles.popupmenu_Refmap,'String',handles.popupmenu_list);
% set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_list);
set(handles.popupmenu1_list1,'Value',handles.ID_listMain-1);
guidata(hObject, handles); %update the handles
UpdatePlot_Map_axes1(handles);
guidata(hObject, handles); %update the handles

%----------------------- UpdatePlot functions ----------------------------%
function UpdatePlot_Map_axes1(handles)
%Update Map on axes1
% /!\ Similar to UpdatePlot_Map_axes2 and UpdatePlot_Map_axes3

val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected

% switch val
%     case 1
%         dataMatrix=handles.Map1;
%     case 2
%         dataMatrix=handles.Map2;
%     case 3
%         dataMatrix=handles.Map3;
%     case 4
%         dataMatrix=handles.Map4;
%     case 5
%         dataMatrix=handles.Map5;
%     case 6
%         dataMatrix=handles.Map6;
%     case 7
%         dataMatrix=handles.Map7;
%     case 8
%         dataMatrix=handles.Map8;
%     case 9
%         dataMatrix=handles.Map9;
%     case 10
%         dataMatrix=handles.Map10;
% end

dataMatrix=handles.Maps(val).Data;
%select axes 1 and turn it on, erase it if something is already plotted
axes(handles.axes1);
axis on
cla

%plot the matrix
imagesc(dataMatrix)

%Colormap setting
Str_edit_min1=get(handles.edit_min_axes1,'String');
Str_edit_max1=get(handles.edit_max_axes1,'String');
ValMin1=str2num(get(handles.edit_min_axes1,'String'));
ValMax1=str2num(get(handles.edit_max_axes1,'String'));

if length(Str_edit_max1)==4  & Str_edit_max1=='auto';
    %auto scale
    if val ~=5;
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(1,gca,handles);
        dataMatrix;
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
    end
else
    %custom scale
    [handles] = StackMapsColorbar(1,gca,handles);
    caxis([ValMin1, ValMax1]);
    h = colorbar;
end

%set xlim/ylim
xlim([0 size(dataMatrix,2)])
ylim([0 size(dataMatrix,1)])
set(gca,'xtick',[])
set(gca,'ytick',[])

%-------------------------------------------------------------------------%
function UpdatePlot_Map_axes2(handles)
%Update Map on axes2
% /!\ Similar to UpdatePlot_Map_axes1 and UpdatePlot_Map_axes3

val = get(handles.popupmenu2_list2, 'Value'); %get which Map is selected

% switch val
%     case 1
%         dataMatrix=handles.Map1;
%     case 2
%         dataMatrix=handles.Map2;
%     case 3
%         dataMatrix=handles.Map3;
%     case 4
%         dataMatrix=handles.Map4;
%     case 5
%         dataMatrix=handles.Map5;
%     case 6
%         dataMatrix=handles.Map6;
%     case 7
%         dataMatrix=handles.Map7;
%     case 8
%         dataMatrix=handles.Map8;
%     case 9
%         dataMatrix=handles.Map9;
%     case 10
%         dataMatrix=handles.Map10;
% end

dataMatrix=handles.Maps(val).Data;

%select axes 2 and turn it on, erase it if something is already plotted
axes(handles.axes2);
axis on
cla

%plot the matrix
imagesc(dataMatrix)

%Colormap setting
Str_edit_min2=get(handles.edit_min_axes2,'String');
Str_edit_max2=get(handles.edit_max_axes2,'String');
ValMin2=str2num(get(handles.edit_min_axes2,'String'));
ValMax2=str2num(get(handles.edit_max_axes2,'String'));

if length(Str_edit_max2)==4  & Str_edit_max2=='auto';
    %auto scale
    if val ~=5;
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(2,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
    end
else
    %custom scale
    [handles] = StackMapsColorbar(2,gca,handles);
    caxis([ValMin2, ValMax2]);
    h = colorbar;
end

%set xlim/ylim
xlim([0 size(dataMatrix,2)])
ylim([0 size(dataMatrix,1)])
set(gca,'xtick',[])
set(gca,'ytick',[])

%-------------------------------------------------------------------------%

function UpdatePlot_Map_axes3(handles)
%Update Map on axes3
% /!\ Similar to UpdatePlot_Map_axes1 and UpdatePlot_Map_axes2

val = get(handles.popupmenu3_list3, 'Value'); %get which Map is selected

dataMatrix=handles.Maps(val).Data;

%select axes 3 and turn it on, erase it if something is already plotted
axes(handles.axes3);
axis on
cla

%plot the matrix
imagesc(dataMatrix);

%Colormap setting
Str_edit_min3=get(handles.edit_min_axes3,'String');
Str_edit_max3=get(handles.edit_max_axes3,'String');
ValMin3=str2num(get(handles.edit_min_axes3,'String'));
ValMax3=str2num(get(handles.edit_max_axes3,'String'));

if length(Str_edit_max3)==4  & Str_edit_max3=='auto';
    %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(3,gca,handles);
        dataMatrix;
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
else
    %custom scale
    [handles] = StackMapsColorbar(3,gca,handles);
    caxis([ValMin3, ValMax3]);
    h = colorbar;
end

%set xlim/ylim
xlim([0 size(dataMatrix,2)])
ylim([0 size(dataMatrix,1)])
set(gca,'xtick',[])
set(gca,'ytick',[])

%-------------------------- Accessory functions --------------------------%

function [ ResampledMap ] = ResampleMap( Matrix, SizePixelIni, SizePixelFinal )
%[ ResampledMap ] = ResampleMap( Matrix, SizePixelIni, SizePixelFinal )
%   Resample a Map of pixel size SizePixelIni in order to get a map with
%   SizePixelFinal

F = griddedInterpolant(double(Matrix));
Ratio=SizePixelIni/SizePixelFinal; %nb pixels equivalent to 1 initial pixel

[sx,sy]=size(Matrix);
xq=(0:1/Ratio:sx)';
yq=(0:1/Ratio:sy)';
vq=(F({xq,yq}));
ResampledMap=vq;

function [ WorkingMatrix ] = SetWorkingSpace( MatrixToInsert, WorkingSpaceX, WorkingSpaceY, Value )
%[ WorkingMatrix ] = SetWorkingSpace( MatrixToInsert, WorkingSpaceX, WorkingSpaceY, Value )
%   Put a matrix (MatrixToInsert) in the center of a bigger WorkingSpace
%   filled with Value. WorkingSpaceX and WorkingSpaceY have to be bigger
%   than MatrixToInsertDimensions

%Define the matrix
WorkingMatrix=ones(WorkingSpaceX,WorkingSpaceY)*Value;
%Remove zeros from inner matrix
MatrixToInsert(MatrixToInsert==0)=0.0001;

[Row,Col]=size(WorkingMatrix);
[RowS,ColS] = size(MatrixToInsert);
WorkingMatrix(floor((Row-RowS)/2):floor((Row-RowS)/2)+RowS-1,floor((Col-ColS)/2):floor((Col-ColS)/2)+ColS-1) = MatrixToInsert;

function [ MatrixOutput ] = RemoveNaN( MatrixInput,replacementValue )
%[ MatrixOutput ] = RemoveNaN( MatrixInput,replacementValue )
%   remove NaN value in a matrix by replacementValue
WhereNaN=isnan(MatrixInput);

MatrixOutput=MatrixInput;
MatrixOutput(WhereNaN)=replacementValue;

%Old version - ^ new version ^ is more efficient
% MatrixOutput=MatrixInput;
% for i=1:size(MatrixInput,1);
%     for j=1:size(MatrixInput,2);
%         if isnan(MatrixInput(i,j));
%             MatrixOutput(i,j)=replacementValue;
%         end
%     end
% end




% --- Executes during object creation, after setting all properties.
function pushbutton_ResampleMap_axes1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pushbutton_ResampleMap_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_savetform.
function pushbutton_savetform_Callback(hObject, eventdata, handles)
%When people wants to save the tform vector created

%open a list dlg and ask user to select the tform to save
[indx,tf] = listdlg('PromptString','Select a tform matrix to save:',...
                           'SelectionMode','single',...
                           'ListString',handles.popupmenu_list_transform);
                       
tform=handles.tform(indx).Data;
%Open a save dlg to save the tform 
[file,path] = uiputfile('*.mat','tform file');
% save the tform factor
save([path,file],'tform');

guidata(hObject,handles);



% --- Executes on button press in pushbutton_saveMatrix.
function pushbutton_saveMatrix_Callback(hObject, eventdata, handles)
% When user press the save image as matrix button.

%open a list dlg with the list of maps present in the software.
% Enable mutiple choice
[indx,tf] = listdlg('ListString',handles.popupmenu_listMain);

%Ask the user where to save the file(s)
 [file,path] = uiputfile('*','Project name');

%For the selected maps, save all in single txt file
for i=1:length(indx);
    test=indx;
    CurrentStr=handles.popupmenu_listMain{indx(i)};
    CurrentMatrix=handles.Maps(indx(i)).Data;
    test_Str=CurrentStr;
    %Str=[path,file,'_',CurrentStr,'.txt'];
    Str=[path,file,'.txt'];
    dlmwrite(Str,CurrentMatrix,'delimiter',' ')
    disp(['Matrix saved ...',file,'_',CurrentStr,'.txt'])
end

msgbox('All matrix saved')

% --- Executes on selection change in popupmenu_FactorCorrection.
function popupmenu_FactorCorrection_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_FactorCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_FactorCorrection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_FactorCorrection
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_FactorCorrection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_FactorCorrection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_ApplyFactor.
function pushbutton_ApplyFactor_Callback(hObject, eventdata, handles)
% When user press Apply Factor button. Apply factor to the map selected in
% linked popupmenu

%Find the value of the popupmenu popupmenu_FactorCorrection
val=get(handles.popupmenu_FactorCorrection,'Value');

%get the value entered in Edit 
Factor=str2num(get(handles.edit_Factor,'String'));
if isempty(Factor)
    errordlg('Enter a valid scalar','Wrong number')
    Factor=1;
end
%Take the map selected and multiply by factor

MapCorrected=handles.Maps(val).Data*Factor;

%ask user for the new map name
prompt={'Enter name of the new map'};
dlgtitle='Choose name';
dims=[1 35];
definput={'NewMap'};
answer=inputdlg(prompt,dlgtitle,dims,definput);

%Update the map in the list
NewString=answer;
handles.popupmenu_listMain=[handles.popupmenu_listMain,NewString]; %main list of maps
handles.Maps(handles.ID_listMain).Data=MapCorrected;
handles.ID_listMain=handles.ID_listMain+1;

%Update all popupmenu
set(handles.popupmenu1_list1,'String',handles.popupmenu_listMain);
set(handles.popupmenu2_list2,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Refmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Deformedmap,'String',handles.popupmenu_listMain);
set(handles.popupmenu3_list3,'String',handles.popupmenu_listMain);
set(handles.popupmenu_FactorCorrection,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Xplot,'String',handles.popupmenu_listMain);
set(handles.popupmenu_Yplot,'String',handles.popupmenu_listMain);

guidata(hObject,handles);


function edit_Factor_Callback(hObject, eventdata, handles)
% hObject    handle to edit_Factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_Factor as text
%        str2double(get(hObject,'String')) returns contents of edit_Factor as a double
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function edit_Factor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_Factor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Xplot.
function popupmenu_Xplot_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Xplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Xplot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Xplot
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Xplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Xplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Yplot.
function popupmenu_Yplot_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Yplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Yplot contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Yplot
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Yplot_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Yplot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_DensityPlot_Crop.
function pushbutton_DensityPlot_Crop_Callback(hObject, eventdata, handles)

%Check what is X and Y map selected
valX=get(handles.popupmenu_Xplot,'Value');
valY=get(handles.popupmenu_Yplot,'Value');

%Ask the user on which one he wants to select the crop with list dlg

indx= listdlg('PromptString','Select the map you want to select the crop area',...
                           'SelectionMode','single',...
                           'ListString',{'X','Y'});
switch indx;
    case 1
        Maptodisplay=handles.Maps(valX).Data;
        Mapnottodisplay=handles.Maps(valY).Data;
    case 2
        Maptodisplay=handles.Maps(valY).Data;
        Mapnottodisplay=handles.Maps(valX).Data;
end
                       
%Msg the user that he has to adjust the crop area, then press clic right
%(accept crop)
msgbox('Adjust crop area then clic right -> crop')

%Plot the map to select the crop area. Use information of axes3 display
%get informations
dataMatrix=Maptodisplay;
%plot on a new figure
figure

%plot the matrix
ax_crop=imagesc(dataMatrix)
axis image

%Colormap setting
Str_edit_min3=get(handles.edit_min_axes3,'String');
Str_edit_max3=get(handles.edit_max_axes3,'String');
ValMin3=str2num(get(handles.edit_min_axes3,'String'));
ValMax3=str2num(get(handles.edit_max_axes3,'String'));

if length(Str_edit_max3)==4  & Str_edit_max3=='auto';
    %auto scale
    %remove NaN
    WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
    colormap([jet(64);0,0,0]);
    dataMatrix;
    DataS = sort(dataMatrix(:));
    DataSpos = DataS(find(DataS));
    CutPos = round(length(DataSpos) * 0.065);
    
    caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
    h = colorbar;
else
    %custom scale
    colormap jet
    caxis([ValMin3, ValMax3]);
    h = colorbar;
end

%set xlim/ylim
xlim([0 size(dataMatrix,2)])
ylim([0 size(dataMatrix,1)])

%Crop
[SelectedZone1,RectangularLimits] = imcrop(ax_crop);% also returns the position of the cropping rectangle in rect2.

%Cut the same rectangular area in the other map
SelectedZone2=imcrop(Mapnottodisplay,RectangularLimits);

switch indx
    case 1
        X_map=SelectedZone1;
        Y_map=SelectedZone2;
    case 2
        X_map=SelectedZone2;
        Y_map=SelectedZone1;
end

%plot the densityplot
%density plot settings
E1=X_map(:);
E2=Y_map(:);
Xmin = min(E1); 
Xmax = max(E1);
Ymin = min(E2);
Ymax = max(E2);
patterns=0;
MapSize=150;
Lims=[0,150,0,150];
mode='log';

%Ask user for settings of the DensityPlot
prompt={'MapSize','Xmin','Xmax','Ymin','Ymax'};
dlgtitle='Density plot settings';
dims=[1 35];
definput={num2str(MapSize),num2str(Xmin),num2str(Xmax),num2str(Ymin),num2str(Ymax)}
answer=inputdlg(prompt,dlgtitle,dims,definput);

MapSize=str2num(answer{1});
Lims=[str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5})];
%plot the densityplot
figure

DensityPlotBinaryInternal(E1,E2,patterns,MapSize,Lims,mode);

% --- Executes on button press in pushbutton_DensityPlot_TotalMap.
function pushbutton_DensityPlot_TotalMap_Callback(hObject, eventdata, handles)

%Check what is X and Y map selected
valX=get(handles.popupmenu_Xplot,'Value');
valY=get(handles.popupmenu_Yplot,'Value');
X_map=handles.Maps(valX).Data;
Y_map=handles.Maps(valY).Data;

%density plot settings
E1=X_map(:);
E2=Y_map(:);
Xmin = min(E1); 
Xmax = max(E1);
Ymin = min(E2);
Ymax = max(E2);
patterns=0;
MapSize=150;
Lims=[0,150,0,150];
mode='log';

%Ask user for settings of the DensityPlot
prompt={'MapSize','Xmin','Xmax','Ymin','Ymax'};
dlgtitle='Density plot settings';
dims=[1 35];
definput={num2str(MapSize),num2str(Xmin),num2str(Xmax),num2str(Ymin),num2str(Ymax)}
answer=inputdlg(prompt,dlgtitle,dims,definput);

MapSize=str2num(answer{1});
Lims=[str2num(answer{2}),str2num(answer{3}),str2num(answer{4}),str2num(answer{5})];
%plot the densityplot
figure

DensityPlotBinaryInternal(E1,E2,patterns,MapSize,Lims,mode);

function DensityPlotBinaryInternal(E1,E2,patterns,MapSize,Lims,mode);
% New function to plot density map

 
% Xmin = min(E1); 
% Xmax = max(E1);
% Ymin = min(E2);
% Ymax = max(E2);

Xmin = Lims(1); 
Xmax = Lims(2);
Ymin = Lims(3);
Ymax = Lims(4);

% MapSize = 150;
 
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
 
switch mode
    case 'log'

        
        imagesc(Xi,Yi,log(OnTrace))

        
        Cmin = min(OnTrace(find(OnTrace)))+1; 
        Cmax = max(OnTrace(find(OnTrace)))+1;

        
        caxis([min(log(OnTrace(find(OnTrace)))),max(log(OnTrace(:)))]);
        set(gca,'YDir','normal');

        
        tk = logspace(log(Cmin),log(Cmax),5);

        
        %originalSize1 = get(gca, 'Position');
        hc = colorbar('vertical');
        colormap([1,1,1;parula(64)])
        %set(gca,'Position',originalSize1);

 
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

        
        %originalSize1 = get(gca, 'Position');
        hc = colorbar('vertical');
        colormap(parula(64))
        %set(gca,'Position',originalSize1);

        
end


% --- Executes on button press in pushbutton_addGeoTransform.
function pushbutton_addGeoTransform_Callback(hObject, eventdata, handles)
% When user press + button to add geotransforms saved

%Ask user to select the mat file to load
[filename,filepath]=uigetfile('*.mat');
%should contain a affine2d variable called tform
loadStruct=load([filepath,filename]);

handles.tform(handles.Transform_ID).Data=loadStruct.tform;
handles.Transform_ID=handles.Transform_ID+1;
%Update the popupmenu related to transformation
handles.popupmenu_list_transform=[handles.popupmenu_list_transform,filename(1:end-4)];
set(handles.popupmenu_transform,'String',handles.popupmenu_list_transform);

guidata(hObject,handles);



% --- Executes on button press in pushbutton_saveFig_axes2.
function pushbutton_saveFig_axes2_Callback(hObject, eventdata, handles)
% When user press save figure on axes 2
%Display a new figure with the copy of the plot currently displayed on axes
%1. Take care of working matrix if displayed.

%get informations
if handles.WorkingMatrixDisplayAxes2==0; %regular plot of what is listed
    val = get(handles.popupmenu2_list2, 'Value'); %get which Map is selected
    dataMatrix=handles.Maps(val).Data;
    %plot on a new figure
    figure
    
    %plot the matrix
    imagesc(dataMatrix)
    axis image
    
    %Colormap setting
    Str_edit_min2=get(handles.edit_min_axes2,'String');
    Str_edit_max2=get(handles.edit_max_axes2,'String');
    ValMin2=str2num(get(handles.edit_min_axes2,'String'));
    ValMax2=str2num(get(handles.edit_max_axes2,'String'));
    
    if length(Str_edit_max2)==4  & Str_edit_max2=='auto';
        %auto scale
        if val ~=5;
            %remove NaN
            WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
            [handles] = StackMapsColorbar(2,gca,handles);
            dataMatrix;
            DataS = sort(dataMatrix(:));
            DataSpos = DataS(find(DataS));
            CutPos = round(length(DataSpos) * 0.065);
            
            caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
            h = colorbar;
        end
    else
        %custom scale
        [handles] = StackMapsColorbar(2,gca,handles);
        caxis([ValMin2, ValMax2]);
        h = colorbar;
    end
    
    %set xlim/ylim
    xlim([0 size(dataMatrix,2)])
    ylim([0 size(dataMatrix,1)])
    
else %handles.WorkingMatrixDisplayAxes1=1; Need to plot the working matrix
    %Plot on a new figure
    figure
    
    dataMatrix=handles.DeformedMapCurrent.WorkingMatrix;
    imagesc(dataMatrix);
    axis image
    
    %plot the selected points
    hold on
    for k=1:size(handles.RefDistorded,1);
        plot(handles.RefDistorded(k,1),handles.RefDistorded(k,2),'Marker','o','MarkerFaceColor','w');
    end
    
    %Colormap setting
    Str_edit_min2=get(handles.edit_min_axes2,'String');
    Str_edit_max2=get(handles.edit_max_axes2,'String');
    ValMin2=str2num(get(handles.edit_min_axes2,'String'));
    ValMax2=str2num(get(handles.edit_max_axes2,'String'));
    
    if length(Str_edit_max2)==4  & Str_edit_max2=='auto';
        %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(2,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
    else
        %custom scale
        [handles] = StackMapsColorbar(2,gca,handles);
        caxis([ValMin2, ValMax2]);
        h = colorbar;
    end
    
    %set xlim/ylim
    xlim([handles.DeformedMapCurrent.Borders(1,1)-50 handles.DeformedMapCurrent.Borders(2,1)+50])
    ylim([handles.DeformedMapCurrent.Borders(1,2)-50 handles.DeformedMapCurrent.Borders(2,2)+50])
end


% --- Executes on button press in pushbutton_saveFig_axes3.
function pushbutton_saveFig_axes3_Callback(hObject, eventdata, handles)
% When user press save figure on axes 3
%Display a new figure with the copy of the plot currently displayed on axes
%3. Take care of working matrix if displayed.

%get informations
val = get(handles.popupmenu3_list3, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
%plot on a new figure
figure

%plot the matrix
imagesc(dataMatrix)
axis image

%Colormap setting
Str_edit_min3=get(handles.edit_min_axes3,'String');
Str_edit_max3=get(handles.edit_max_axes3,'String');
ValMin3=str2num(get(handles.edit_min_axes3,'String'));
ValMax3=str2num(get(handles.edit_max_axes3,'String'));

if length(Str_edit_max3)==4  & Str_edit_max3=='auto';
    %auto scale
    %remove NaN
    WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
    [handles] = StackMapsColorbar(3,gca,handles);
    dataMatrix;
    DataS = sort(dataMatrix(:));
    DataSpos = DataS(find(DataS));
    CutPos = round(length(DataSpos) * 0.065);
    
    caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
    h = colorbar;
else
    %custom scale
    [handles] = StackMapsColorbar(3,gca,handles);
    caxis([ValMin3, ValMax3]);
    h = colorbar;
end

%set xlim/ylim
xlim([0 size(dataMatrix,2)])
ylim([0 size(dataMatrix,1)])



% --- Executes on button press in pushbutton_saveFig_axes1.
function pushbutton_saveFig_axes1_Callback(hObject, eventdata, handles)
% When user press save figure on axes 1
%Display a new figure with the copy of the plot currently displayed on axes
%1. Take care of working matrix if displayed.

%get informations
if handles.WorkingMatrixDisplayAxes1==0; %regular plot of what is listed
    val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected
    dataMatrix=handles.Maps(val).Data;
    %plot on a new figure
    figure
    
    %plot the matrix
    imagesc(dataMatrix)
    axis image
    
    %Colormap setting
    Str_edit_min1=get(handles.edit_min_axes1,'String');
    Str_edit_max1=get(handles.edit_max_axes1,'String');
    ValMin1=str2num(get(handles.edit_min_axes1,'String'));
    ValMax1=str2num(get(handles.edit_max_axes1,'String'));
    
    if length(Str_edit_max1)==4  & Str_edit_max1=='auto';
        %auto scale
        if val ~=5;
            %remove NaN
            WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
            [handles] = StackMapsColorbar(1,gca,handles);
            dataMatrix;
            DataS = sort(dataMatrix(:));
            DataSpos = DataS(find(DataS));
            CutPos = round(length(DataSpos) * 0.065);
            
            caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
            h = colorbar;
        end
    else
        %custom scale
        [handles] = StackMapsColorbar(1,gca,handles);
        caxis([ValMin1, ValMax1]);
        h = colorbar;
    end
    
    %set xlim/ylim
    xlim([0 size(dataMatrix,2)])
    ylim([0 size(dataMatrix,1)])
    
else %handles.WorkingMatrixDisplayAxes1=1; Need to plot the working matrix
    %Plot on a new figure
    figure
    
    dataMatrix=handles.RefMapCurrent.WorkingMatrix;
    imagesc(dataMatrix);
    axis image
    
    %plot the selected points
    hold on
    for k=1:size(handles.RefOriginal,1);
        plot(handles.RefOriginal(k,1),handles.RefOriginal(k,2),'Marker','o','MarkerFaceColor','w');
    end
    
    %Colormap setting
    Str_edit_min1=get(handles.edit_min_axes1,'String');
    Str_edit_max1=get(handles.edit_max_axes1,'String');
    ValMin1=str2num(get(handles.edit_min_axes1,'String'));
    ValMax1=str2num(get(handles.edit_max_axes1,'String'));
    
    if length(Str_edit_max1)==4  & Str_edit_max1=='auto';
        %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(1,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
    else
        %custom scale
        [handles] = StackMapsColorbar(1,gca,handles);
        caxis([ValMin1, ValMax1]);
        h = colorbar;
    end
    
    %set xlim/ylim
    xlim([handles.RefMapCurrent.Borders(1,1)-50 handles.RefMapCurrent.Borders(2,1)+50])
    ylim([handles.RefMapCurrent.Borders(1,2)-50 handles.RefMapCurrent.Borders(2,2)+50])
end



% --- Executes on button press in pushbutton25.
function pushbutton25_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton25 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton_PlotSelected_Axes2.
function pushbutton_PlotSelected_Axes2_Callback(hObject, eventdata, handles)
%When user press plot selected on axes1
% Plot the windows around the selected points
if handles.WorkingMatrixDisplayAxes2==1; %Need to plot the working matrix
    %Plot on a new figure
    for k=1:size(handles.RefDistorded,1);
    figure
    
    dataMatrix=handles.DeformedMapCurrent.WorkingMatrix;
    imagesc(dataMatrix);
    axis image
    
    %plot the selected points
    hold on
    plot(handles.RefDistorded(k,1),handles.RefDistorded(k,2),'Marker','o','MarkerFaceColor','w');
    
    
    %Colormap setting
    Str_edit_min2=get(handles.edit_min_axes2,'String');
    Str_edit_max2=get(handles.edit_max_axes2,'String');
    ValMin2=str2num(get(handles.edit_min_axes2,'String'));
    ValMax2=str2num(get(handles.edit_max_axes2,'String'));
    
    if length(Str_edit_max2)==4  & Str_edit_max2=='auto';
        %auto scale
        %remove NaN
        WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
        [handles] = StackMapsColorbar(2,gca,handles);
        DataS = sort(dataMatrix(:));
        DataSpos = DataS(find(DataS));
        CutPos = round(length(DataSpos) * 0.065);
        
        caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
        h = colorbar;
    else
        %custom scale
        [handles] = StackMapsColorbar(2,gca,handles);
        caxis([ValMin2, ValMax2]);
        h = colorbar;
    end
    
    %set xlim/ylim
    xlim([handles.RefDistorded(k,1)-handles.WindowSize_axes1/2 handles.RefDistorded(k,1)+handles.WindowSize_axes1/2]);
    ylim([handles.RefDistorded(k,2)-handles.WindowSize_axes1/2 handles.RefDistorded(k,2)+handles.WindowSize_axes1/2]);
    title(['Selected point n ',num2str(k)]);
%     xlim([handles.DeformedMapCurrent.Borders(1,1)-50 handles.DeformedMapCurrent.Borders(2,1)+50])
%     ylim([handles.DeformedMapCurrent.Borders(1,2)-50 handles.DeformedMapCurrent.Borders(2,2)+50])
    end
end



% --- Executes on button press in pushbutton_PlotSelected_Axes1.
function pushbutton_PlotSelected_Axes1_Callback(hObject, eventdata, handles)
%When user press plot selected on axes1
% Plot the windows around the selected points

if handles.WorkingMatrixDisplayAxes1==1; %Need to plot the working matrix
    %Plot on a new figure
    for k=1:size(handles.RefOriginal,1);
        figure
        
        dataMatrix=handles.RefMapCurrent.WorkingMatrix;
        imagesc(dataMatrix);
        axis image
        
        %plot the selected points
        hold on
        plot(handles.RefOriginal(k,1),handles.RefOriginal(k,2),'Marker','o','MarkerFaceColor','w');
        
        
        %Colormap setting
        Str_edit_min1=get(handles.edit_min_axes1,'String');
        Str_edit_max1=get(handles.edit_max_axes1,'String');
        ValMin1=str2num(get(handles.edit_min_axes1,'String'));
        ValMax1=str2num(get(handles.edit_max_axes1,'String'));
        
        if length(Str_edit_max1)==4  & Str_edit_max1=='auto';
            %auto scale
            %remove NaN
            WhereNaN=isnan(dataMatrix); dataMatrix(WhereNaN)=0;
            [handles] = StackMapsColorbar(1,gca,handles);
            DataS = sort(dataMatrix(:));
            DataSpos = DataS(find(DataS));
            CutPos = round(length(DataSpos) * 0.065);
            
            caxis([DataSpos(CutPos), DataSpos(end-CutPos)]);
            h = colorbar;
        else
            %custom scale
            [handles] = StackMapsColorbar(1,gca,handles);
            caxis([ValMin1, ValMax1]);
            h = colorbar;
        end
        
        %set xlim/ylim
        xlim([handles.RefOriginal(k,1)-handles.WindowSize_axes1/2 handles.RefOriginal(k,1)+handles.WindowSize_axes1/2]);
        ylim([handles.RefOriginal(k,2)-handles.WindowSize_axes1/2 handles.RefOriginal(k,2)+handles.WindowSize_axes1/2]);   
        title(['Selected point n ',num2str(k)]);
%         xlim([handles.RefMapCurrent.Borders(1,1)-50 handles.RefMapCurrent.Borders(2,1)+50])
%         ylim([handles.RefMapCurrent.Borders(1,2)-50 handles.RefMapCurrent.Borders(2,2)+50])
    end
end


% --- Executes on selection change in popupmenu_Colormap2.
function popupmenu_Colormap2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Colormap2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Colormap2
UpdatePlot_Map_axes2(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Colormap2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Colormap3.
function popupmenu_Colormap3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Colormap3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Colormap3
UpdatePlot_Map_axes3(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Colormap3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Colormap.
function popupmenu_Colormap_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Colormap contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Colormap


% --- Executes during object creation, after setting all properties.
function popupmenu_Colormap_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu_Colormap1.
function popupmenu_Colormap1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu_Colormap1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu_Colormap1
UpdatePlot_Map_axes1(handles);

% --- Executes during object creation, after setting all properties.
function popupmenu_Colormap1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu_Colormap1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_Rot_axes2.
function pushbutton_Rot_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Rot_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.popupmenu2_list2, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
RotMatrix=rot90(dataMatrix);
handles.Maps(val).Data=RotMatrix;

guidata(hObject,handles);
UpdatePlot_Map_axes2(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_Rot_axes3.
function pushbutton_Rot_axes3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Rot_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.popupmenu3_list3, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
RotMatrix=rot90(dataMatrix);
handles.Maps(val).Data=RotMatrix;

guidata(hObject,handles);
UpdatePlot_Map_axes3(handles);
guidata(hObject,handles);


% --- Executes on button press in pushbutton_Rot_axes1.
function pushbutton_Rot_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_Rot_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
val = get(handles.popupmenu1_list1, 'Value'); %get which Map is selected
dataMatrix=handles.Maps(val).Data;
RotMatrix=rot90(dataMatrix);
handles.Maps(val).Data=RotMatrix;

guidata(hObject,handles);
UpdatePlot_Map_axes1(handles);
guidata(hObject,handles);


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);



function handles = ReadColorMaps(handles)
fid = fopen([handles.AddOnPath,'StackMaps_ColorMaps.txt'],'r');
Compt = 0;

 
ColorMaps(1).Name = 'None';
ColorMaps(1).Code = 0;

 
Compt = 0;
ErrorLoad = 0;
while 1
    tline = fgetl(fid);

    
    if isequal(tline,-1)
        break
    end

    
    if length(tline) >= 1
        if isequal(tline(1),'>')
            Compt = Compt+1;
            ColorMaps(Compt).Name = tline(3:end);
            Row = 0;
            while 1
                tline = fgetl(fid);
                if isequal(tline,-1) || isequal(tline,'')
                    break
                end
                NUM = strread(tline,'%f');
                Row = Row+1;
                ColorMaps(Compt).Code(Row,1:3) = NUM(1:3);
            end

            
        end
    end
end
fclose(fid);
handles.ColorMaps = ColorMaps;


% #########################################################################
%   inspired from XMAPCOLORBAR (UPDATED 3.2.2) made by Pierre Lanari
function [handles] = StackMapsColorbar(SelAxis,Ax,handles);
%
%      --------------------------------------------------------------------
%        Mode           Description
%      --------------------------------------------------------------------
%       'Auto'          The resolution is fixed by handles.EditColorDef
%       'Mask'          The resolution is determined by the number of
%                       phases in the selected mask
%       'Last'          Apply the last mode stored in handles.ColormapMode
%      --------------------------------------------------------------------
ResColorMap=256;
 
if SelAxis == 1             % Otherwise no control on the active axis
    SelectedColormap=get(handles.popupmenu_Colormap1,'Value');
elseif SelAxis == 2;
    SelectedColormap=get(handles.popupmenu_Colormap2,'Value');
elseif SelAxis == 3;
    SelectedColormap=get(handles.popupmenu_Colormap3,'Value');
end

 
ColorMaps = handles.ColorMaps;
TheSelected = SelectedColormap;
 
% Default value
%handles.activecolorbar = RdYlBu(ResColorMap);
ColorData = flipud(ColorMaps(TheSelected).Code);  % flipud added by PL

Xi = 1:ResColorMap;
Step = (ResColorMap-1)/(size(ColorData,1)-1);
X = 1:Step:ResColorMap;


ColorMap = zeros(length(Xi),size(ColorData,2));
for i = 1:size(ColorData,2)
    ColorMap(:,i) = interp1(X',ColorData(:,i),Xi);
    % = polyval(P,);
end


% New 3.2.1
AddLower=[0 0 0];
AddUpper=[1 1 1];

handles.activecolorbar = [AddLower;ColorMap];
colormap(Ax,handles.activecolorbar);


% --- Executes on button press in pushbutton_MinMax_axes2.
function pushbutton_MinMax_axes2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MinMax_axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get selected map
val=get(handles.popupmenu2_list2,'Value');

% Compute min max
Min=min(min(handles.Maps(val).Data));
Max=max(max(handles.Maps(val).Data));

%Change colorbar limits settings
set(handles.edit_min_axes2,'String',num2str(Min));
set(handles.edit_max_axes2,'String',num2str(Max));

%UpdatePlot
UpdatePlot_Map_axes2(handles)

% --- Executes on button press in pushbutton_MinMax_axes3.
function pushbutton_MinMax_axes3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MinMax_axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get selected map
val=get(handles.popupmenu3_list3,'Value');

% Compute min max
Min=min(min(handles.Maps(val).Data));
Max=max(max(handles.Maps(val).Data));

%Change colorbar limits settings
set(handles.edit_min_axes3,'String',num2str(Min));
set(handles.edit_max_axes3,'String',num2str(Max));

%UpdatePlot
UpdatePlot_Map_axes3(handles)

% --- Executes on button press in pushbutton_MinMax_axes1.
function pushbutton_MinMax_axes1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_MinMax_axes1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% get selected map
val=get(handles.popupmenu1_list1,'Value');

% Compute min max
Min=min(min(handles.Maps(val).Data));
Max=max(max(handles.Maps(val).Data));

%Change colorbar limits settings
set(handles.edit_min_axes1,'String',num2str(Min));
set(handles.edit_max_axes1,'String',num2str(Max));

%UpdatePlot
UpdatePlot_Map_axes1(handles)
