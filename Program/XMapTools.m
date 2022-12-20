function varargout = XMapTools(varargin)
% XMAPTOOLS runs the program VER_XMapTools_750
%      XMAPTOOLS is a MATLAB-based graphic user interface for the 
%      processing of maps and chemical images 
%
%      XMAPTOOLS opens the inteface
%
%      XMAPTOOLS software has been created and is maintained by 
%      Dr. Pierre Lanari (pierre.lanari@geo.unibe.ch)
%
%      Find out more at https://www.xmaptools.com



clc,
disp(' ');
disp(' ');

SkipWarning = 0;


% NEW UPDATE SYSTEM OF XMAPTOOLS (from version 2.6 and more recent versions)

% Step 1 - Read MATLAB Version (to check for updates...)
TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

disp(['You are using MATLAB ',char(TheVersion{1}),'.',char(TheVersion{2}),'.',char(TheVersion{3}),' release ',char(TheVersion{4})])
disp(' ')

fid = fopen('XMT_Config.txt');
LocBase = char(fgetl(fid)); % main directory of XMapTools
fclose(fid);


% Step 2 - Read XMapTools' version
disp('XMapTools update ... (connecting to the update server) ...')

  
fid = fopen('XMT_Local_version.txt','r'); 
localVersion =fgetl(fid); 
fclose(fid);

localStr = strread(localVersion,'%s','delimiter','-');

Version = localStr{2};
ReleaseDate = localStr{3};
ProgramState = localStr{4}; 


% Here we cannot used a permanent redirection to https! 
[onlineVersion,flag] = urlread('http://www.xmaptools.com/FTP_public2/Online_version.php');

[onlinePackage,flag] = urlread('http://www.xmaptools.com/FTP_public2/Online_package.php');


if flag && length(onlineVersion) 
    % internet connection, we check for updates ...
    onlineStr = strread(onlineVersion,'%s','delimiter','-');
    
    OLVersion = onlineStr{2};
    
    LOVersion = Version;
    
    % Check if update is required
    lesOLversions = strread(OLVersion,'%f','delimiter','.');
    lesLOversions = strread(LOVersion,'%f','delimiter','.');
    
    ServerVersion = (lesOLversions(1)+lesOLversions(2)*0.01);
    LocalVersion = (lesLOversions(1)+lesLOversions(2)*0.01);
    
    disp(['XMapTools update ... (connected to the update server) ...'])
    disp(['XMapTools update ... (Local version: ',num2str(LOVersion),')'])
    disp(['XMapTools update ... (Online version: ',num2str(OLVersion),')'])
    
    if LocalVersion <  ServerVersion    % update available
        
        
        % New update module only compatible with the more recent version of
        % MATLAB (from 2.7 on). 
        
        
        if lesLOversions(1) >= 2.7 && TheCodeVersion < 8040
            
            uiwait(warndlg({'A new version of XMapTools is available for download; however this', ...
             'update is no longer compatible with your version of MATLAB. ', ...
             ' ', ...
             'MATLAB 2014b or a more recent version is required', ...
             'to use the latest XMapTools releases!'},'WARNING','modal'));
            
            UpdateMessagePrint = '(More recent updates of XMapTools cannot be used with this version of MATLAB) ... Done';
         
            % but you can still run this version...
            SkipWarning = 1;
        else
            
            
            
            while 1
                
                textAfficher = { ...
                    'XMapTools new updates are available... ',...
                    ' ', ...
                    'Press the button [Update now] to automatically download and install the new release (recommended)',...
                    ' ', ...
                    'Press [Info] to get details about the new release', ...
                    ' ', ...
                    ['Version: ',char(onlineVersion)],...
                    ['File: ',char(onlinePackage)], ...
                    ' '};
                
                
                buttonName = questdlg(textAfficher,'XMapTools updates are available','Update now','Remind me later','Info','Update now');
                
                switch buttonName
                    
                    case 'Info'
                        % Check for update (New 1.6.2)
                        [onlineUpdates,flagUpdates] = urlread('http://www.xmaptools.com/FTP_public2/Online_ListUpdates.php');
                        
                        questdlg(onlineUpdates,'XMapTools_Updates','OK','OK');
                        
                        
                        
                    case 'Remind me later'
                        
                        UpdateMessagePrint = '(XMapTools update available!) ... Not applied!';
                        break
                        
                        
                        
                    case 'Update now'
                        
                        %close all
                        
                        buttonName = questdlg({'XMapTools update consist of:', ...
                            '(1) deleting the old files (/program)', ...
                            '(2) downloading the new files', ...
                            '(3) running the setup', ...
                            ' ',...
                            'Would you like to proceed (recommended)?'},'Warning','OK','CANCEL','OK');
                        
                        if isequal(buttonName,'CANCEL')
                            UpdateMessagePrint = '(User cancellation) ... Done';
         
                            break
                        end
                        
                        % WARNING This is only compatible with the new VER_XMAPTOOLS_750
                        % 2.1.1 settings...
                        
                        WhereWeAre = cd;
                        
                        h = waitbar(0,'XMapTools is updating - Please wait...');
                        
                        %handles.update = 1;
                        %guidata(hObject, handles);
                        
                        waitbar(0.2,h);
                        
                        %keyboard % before a public release...
                        
                        % [1] Go to the VER_XMapTools_750 'program/' directory
                        cd(LocBase)
                        
                        waitbar(0.3,h);
                        
                        rmpath(LocBase);
                        
                        waitbar(0.4,h);
                        
                        cd ..
                        
                        rmdir('Program','s')
                        
                        waitbar(0.6,h);
                        
                        WebAdress = ['http://www.xmaptools.com/FTP_public2/',char(onlinePackage)];
                        
                        unzip(WebAdress);
                        
                        % new 3.2.1 to clean after updating...
                        if isdir('__MACOSX')
                            [status,msg,msgID] = rmdir('__MACOSX', 's');
                        end
                        
                        waitbar(0.9,h);
                        
                        cd Program/
                        
                        waitbar(1,h);
                        
                        close(h);
                        
                        % New 2.3.1 (30.08.2016)
                        rehash                  % to update the Install program
                        
                        Name = ['Update_XMapTools_Core_',OLVersion(1),OLVersion(3),OLVersion(5)];
                        
                        if exist(Name)
                            % In case we need in the future to run a special
                            % update program...
                            eval(Name);
                        else
                            % Normal procedure
                            Install_XMapTools;
                        end
                        
                        cd(WhereWeAre);
                        
                        close all
                        
                        % New 2.6.2
                        path(path);               % to update the Install program and not restart MATLAB
                        
                        
                        % New XMapTools 2.5.2
                        % It is important to restart MATLAB to update the GUI -
                        %
%                         buttonName = questdlg({'You need to restart MATLAB to apply XMapTools'' update', ...
%                             ' ',...
%                             'Do you want to end your MATLAB session now (strongly recommended)?'},'Warning','Yes','No (manual restart)','Yes');
%                         
%                         if isequal(buttonName,'Yes')
%                             exit
%                         end
                        
                        
                        
                        
                        return
                        
                end
            end
            
        end
        
    else
        if (lesLOversions(1)+lesLOversions(2)*0.01) > (lesOLversions(1)+lesOLversions(2)*0.01)
            %disp(' ')
            %disp('Warning ... (This is an unofficial version of XMapTools) ... ')
            
            UpdateMessagePrint = '(This is an unofficial pre-release) ... Done';
        else
            UpdateMessagePrint = '(XMapTools is up to date) ... Done';
        end

    end
else
    UpdateMessagePrint = '(The update server cannot be reached) ... Aborted';
end

disp(['XMapTools update ... ',UpdateMessagePrint])

disp(' ')
if isequal(ProgramState,'Dev')
    disp('Developer message ... You''re using a developer version, which needs  ')
    disp('Developer message ... to be udpated via the private Github account') 
    disp('Developer message ... https://github.com/lanari/xmaptools_private');
end


% #########################################################################
% #########################################################################

% XMapTools patches

% #########################################################################
% #########################################################################

% Patch 2.3.1 to correct for Config.txt  (30.08.16)
if exist('Config.txt')
       
    WhereConfig = which('Config.txt');
    WhereLocalVersion = which('Local_version.txt');
    
    LocBaseTemp = WhereConfig(1:end-10);
    
    delete(WhereConfig);
    delete(WhereLocalVersion);
    
    WhereWeAre = cd;
    
    cd(LocBaseTemp)
    ButtonName = questdlg({'Somethings went wrong and XMapTools requires an additional setup ... '}, ...
                             'Install_XMapTools', ...
                             'Continue', 'Continue');
        %
    Install_XMapTools;
    cd(WhereWeAre)
    return
end


% #########################################################################
% #########################################################################







Instructions = '';

for i=1:length(varargin)
    Instructions = [Instructions,char(varargin{i}),' '];
end
Instructions = Instructions(1:end-1);
 

TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

%disp(' ');
%disp(['You are using MATLAB ',char(TheVersion{1}),'.',char(TheVersion{2}),'.',char(TheVersion{3}),' release ',char(TheVersion{4})])

if TheCodeVersion >= 8040
    %disp(['XMapTools compatibility check recommands: VER_XMapTools_804'])
    disp(' '); disp(' ');
    disp('... XMapTools is starting, please wait ...');
    
    eval(['VER_XMapTools_804 ',char(Instructions)]);
else
    
    if lesLOversions(1) >= 2.7
        uiwait(warndlg({'This version of XMapTools is not compatible with your', ...
            ' version of MATLAB. ', ...
            ' ', ...
            'MATLAB 2014b or a more recent version is required to ' ...
            ['run XMapTools ',Version]},'WARNING','modal'));
        
        return
    end
    
    
    if ~SkipWarning
        uiwait(warndlg({'Further releases of XMapTools will no longer be ', ...
                 'compatible with your version of MATLAB. ', ...
                 ' ', ...
                 'MATLAB 2014b or a more recent version will be ', ...
                 'required to run XMapTools 2.7'},'WARNING','modal'));
    end
         
    
    %disp(['XMapTools compatibility check recommands: VER_XMapTools_750'])
    disp(' '); disp(' ');
    disp('... XMapTools is starting, please wait ...');
    
    eval(['VER_XMapTools_750 ',char(Instructions)]);
end

return

