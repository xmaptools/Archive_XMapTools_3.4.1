function XmapWaitBar(Percent,handles)
%
BlackCoor = get(handles.WaitBar1,'Position');
WhiteCoor = get(handles.WaitBar2,'Position');

dw = BlackCoor(3)-WhiteCoor(3);
dh = BlackCoor(4)-WhiteCoor(4);

LesValues = WhiteCoor;
LesValues(1) = BlackCoor(1)+dw/2;
LesValues(2) = BlackCoor(2)+dh/2;

set(handles.WaitBar2,'Position',LesValues)

%LesValues = get(handles.WaitBar2,'Position'); %[0.03654485048338874 0.34090909090909094 0.7375415282392027 0.1818181818181818];
LaLong = LesValues(3) * (Percent + 0.0001);

LesValues(3) = LaLong;

set(handles.WaitBar1,'Visible','on');
set(handles.WaitBar2,'Visible','on');
set(handles.WaitBar3,'Visible','on');

set(handles.UiPanelScrollBar,'visible','on');

% Trace
set(handles.WaitBar3,'Position',LesValues)

if Percent == 0 % we display the image
    
%     iconsFolder = fullfile(get(handles.PRAffichage0,'String'),'/Dev/img/');
%     iconUrl = strrep([handles.FileDirCode, iconsFolder 'spinner.gif'],'\','/');
% 
%     str = ['<html><img src="' iconUrl '"/></html>'];
%     
%     set(handles.DispWait,'string',str,'visible','on');
    %jDispWait = findjobj(handles.DispWait);
    %handles.jDispWait.setContentAreaFilled(0);
    %handles.jDispWait.setBorder([]);
    
    delay_length = handles.DataGifImage.delay;

    %gif_image = [handles.LocBase,'/Dev/media/spinner2.gif'];
    %[handles.GifImage.im,hand.GifImage.map] = imread(gif_image,'frames','all');
    
    handles.GifImage.im = handles.DataGifImage.im;
    hand.GifImage.map = handles.DataGifImage.map;
    
    handles.GifImage.len = size(handles.GifImage.im,4);
    axes(handles.GifWait)
    handles.GifImage.count = 1;
    handles.GifImage.h1 = imshow(handles.GifImage.im(:,:,:,1),handles.activecolorbar); %handles.activecolorbar);
    colormap(handles.GifWait,handles.DataGifImage.colortable);
    handles.GifImage.tmr = timer('TimerFcn', {@TmrFcn,handles.GifWait},'BusyMode','Queue',...
        'ExecutionMode','FixedRate','Period',delay_length);
    guidata(handles.GifWait,handles);
    start(handles.GifImage.tmr); %starts Timer
    
    % Note that handles.GifImage remains trapped in this instance and never
    % comes back to the GUI. It means that the timer has the update but it
    % should not affect the main GUI. Weired but I haven't find any other
    % solution.
    
end


if Percent == 1 % on cache
    
    set(handles.UiPanelScrollBar,'visible','off');
    
    set(handles.WaitBar1,'Visible','off');
    set(handles.WaitBar2,'Visible','off');
    set(handles.WaitBar3,'Visible','off');
    
    out = timerfindall;
    for i = 1:length(out)
        stop(out(i));
        delete(out(i));
    end
    

%     if isfield(handles,'tmr')
%         if isobject(handles.GifImage.tmr)
%             disp('Timer will stop')
%             stop(handles.GifImage.tmr);
%             disp('Timer will be deleted')
%             delete(handles.GifImage.tmr);
%             handles.GifImage.tmr = [];
%             disp('Timer is stoped & deleted')
%         end
%     end
    
    %str = [''];
    %set(handles.DispWait,'string',str,'visible','off');
    
end

%guidata(hObject, handles);
drawnow
return

function TmrFcn(src,event,handles)
%Timer Function to animate the GIF
handles = guidata(handles);

if ~isfield(handles,'GifImage')
    return
end

set(handles.GifImage.h1,'CData',handles.GifImage.im(:,:,:,handles.GifImage.count)); %update the frame in the axis
%drawnow    % removed in 3.3.1 (was apparently causing issues and crashes)
handles.GifImage.count = handles.GifImage.count + 1; %increment to next frame
if handles.GifImage.count > handles.GifImage.len %if the last frame is achieved intialise to first frame
    handles.GifImage.count = 1;
end
guidata(handles.GifWait, handles);
return

