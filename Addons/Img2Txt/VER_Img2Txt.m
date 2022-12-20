function varargout = VER_Img2Txt(varargin)
% VER_IMG2TXT MATLAB code for VER_Img2Txt.fig
%      VER_IMG2TXT, by itself, creates a new VER_IMG2TXT or raises the existing
%      singleton*.
%
%      H = VER_IMG2TXT returns the handle to a new VER_IMG2TXT or the handle to
%      the existing singleton*.
%
%      VER_IMG2TXT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in VER_IMG2TXT.M with the given input arguments.
%
%      VER_IMG2TXT('Property','Value',...) creates a new VER_IMG2TXT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before VER_Img2Txt_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to VER_Img2Txt_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help VER_Img2Txt

% Last Modified by GUIDE v2.5 05-Dec-2019 12:56:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VER_Img2Txt_OpeningFcn, ...
                   'gui_OutputFcn',  @VER_Img2Txt_OutputFcn, ...
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


% --- Executes just before VER_Img2Txt is made visible.
function VER_Img2Txt_OpeningFcn(hObject, eventdata, handles, varargin)
% 

movegui(hObject,'center');

WhereIsImg2Txt = which('Img2Txt');
handles.AddOnPath = WhereIsImg2Txt(1:end-10);

axes(handles.LOGO);
img = imread([handles.AddOnPath,'/Img/logo_xmap_final.png']);
image(img), axis image
set(gca,'visible','off');

axes(handles.IMG1);
img = imread([handles.AddOnPath,'/Img/image.jpg']);
image(img), axis image
set(gca,'visible','off');

axes(handles.IMG2);
img = imread([handles.AddOnPath,'/Img/arrow.jpg']);
image(img), axis image
set(gca,'visible','off');

axes(handles.IMG3);
img = imread([handles.AddOnPath,'/Img/text.jpg']);
image(img), axis image
set(gca,'visible','off');


% Choose default command line output for VER_Img2Txt
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes VER_Img2Txt wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = VER_Img2Txt_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% 

[FileName,PathName,FilterIndex] = uigetfile({'*.bmp;*.tif;*.tiff;*.png;*.jpg;*.jpeg','Image (*.bmp, *.tif, *.tiff, *.png, *.jpg, *,jpeg)';'*.*',  'All Files (*.*)'},'Pick and image','MultiSelect', 'off');

if ~isequal(FileName,0) 
    %try
        info = imfinfo([PathName,FileName]);
        
        A = imread([PathName,FileName]);
        
        figure;
        title(['Original image [',FileName,']'])
        image(A);
        %colormap(gca,info.Colormap);
        axis image
        
        answer=inputdlg({'Set min value (optional)','Set max value (optional)'},'Img2Txt',1,{'0','1'});
        
        Min=str2num(answer{1});
        Max=str2num(answer{2});
        
        B = im2double(A); % Convert image to double precision:
        
        if size(B,3) > 1
            B = rgb2gray(B);
        end
        
        % Rescale
        B = Min + B.*(Max-Min);
        
        figure;
        imagesc(B); colorbar; 
        colormap(gca,parula);
        axis image
        
        NameStr = strread(FileName,'%s','delimiter','.');
        NameFileOri = char(NameStr{1});
        [FileNameOUT,PathNameOUT,FilterIndexOUT] = uiputfile([NameFileOri,'.txt'], 'Save the map as...');

        save([PathNameOUT,FileNameOUT],'B','-ASCII');
        
        title(['Exported image [',FileNameOUT,']'])
        
    %catch
    %    errordlg('An error has occured; this file cannot be converted','Img2Txt');
    %    return
    %end

    
end
