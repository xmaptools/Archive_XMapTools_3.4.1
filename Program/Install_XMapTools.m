function [] = Install_XMapTools(varargin)
%
%

clc


% New 2.7   -- IMPORTANT TO PREVENT INSTALING XMAPTOOLS ON OLD MATLAB

fid = fopen('XMT_Local_version.txt');
localVersion =fgetl(fid);
fclose(fid); 

localStr = strread(localVersion,'%s','delimiter','-');

Version = localStr{2};  
ReleaseDate = localStr{3};               
ProgramState = localStr{4};

lesLOversions = strread(Version,'%f','delimiter','.');

if lesLOversions(1) >= 2.7
    % We cannot use a old version of MATLAB
    
    TheVersion = strread(version,'%s','delimiter','.');
    TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});
    
    if TheCodeVersion < 8040
        
        uiwait(warndlg({'This version of XMapTools is not compatible with your', ...
            ' version of MATLAB. ', ...
            ' ', ...
            'MATLAB 2014b or a more recent version is required to ' ...
            'use XMapTools'},'WARNING','modal'));
        
        return
    end
    
end

% - - - - - - - - - - - - - 
% New 2.1.8 TEST to see if some critical files are available
Files4TestTxt = {'XMT_Config','ListFunctions','XMT_Local_version','Dev/XMap_Help'};
Files4TestM = {'XMapTools','Dev/DensityPlot','Functions/StructFctChlorite','Modules/XMTFunctionsInfos','Modules/XMTModBinary','Modules/XMTModTRC','Modules/XMTModTriPlot'};

if exist('Install_XMapTools')
    WhereIsSetup = which('Install_XMapTools');
    WhereIsSetup = WhereIsSetup(1:end-(length('Install_XMapTools')+3));
else
    f = warndlg({'XMapTools cannot be installed', ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        '###  Critical error [ES0666]  ###', ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        'Please repport the error at http://www.xmaptools.com the error ',...
        'description printed out in the MATLAB command window'});
    
    disp(' ')
    disp('---------------------------------------------------------------')
    disp(' ')
    disp('### Critical error [ES0666] ###')
    disp('Problem to find where is the program Install_XMapTools.p')
    cd
    ls
    disp('---------------------------------------------------------------')
    disp(' ')
    
    return
end

disp(' ')
disp('TEST of XMapTools setup path -> DONE')


% TEST 1
WhereWeAre = cd;
if ~isequal(WhereWeAre,WhereIsSetup)
    f = warndlg({'XMapTools cannot be installed', ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        '###  Error [ES0601]  ###', ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        'You are not running Install_XMapTools.p from the right directory' ...
        '   (1) go to the right directory using the MATLAB Current Folder tool' ...
        '   (2) run again the setup' ...
        ' ' ...
        'Details are printed out in the MATLAB Command Window'});
    
    disp(' ')
    disp('---------------------------------------------------------------')
    disp(' ')
    disp('### Critical error [ES0601] ###')
    disp('Where you are:')
    WhereWeAre
    disp('Where is Install_XMapTools.p:')
    WhereIsSetup
    disp(' ')
    disp('---------------------------------------------------------------')
    disp(' ')
    
    return
else
    disp(' ')
    disp(['Directory: ',char(WhereWeAre)]);
    disp(' ')
end


% TEST 2
for i=1:length(Files4TestTxt)
    FileForTest = Files4TestTxt{i};
    
    if exist([WhereWeAre,'/',FileForTest,'.txt'])
        disp(['TEST: ',FileForTest,'.txt -> DONE'])
    else
        f = warndlg({'The setup package seems to be corrupted', ...
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            '###  Error [ES0604]  ###', ...
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            'At least one critical file is missing. Try getting a new copy' ...
            ' ' ...
            'Details are printed out in the MATLAB Command Window'});
        
        disp(' ')
        disp('---------------------------------------------------------------')
        disp(' ')
        disp('### Critical error [ES0604] ###')
        disp(['Setup package corrupted: ',char(FileForTest),'.txt is missing ...'])
        cd
        ls
        disp('---------------------------------------------------------------')
        disp(' ')
        
        return
    end
    
end
disp(' ')

% TEST 3
for i=1:length(Files4TestM)
    FileForTest = Files4TestM{i};
    
    if exist([WhereWeAre,'/',FileForTest,'.m']) || exist([WhereWeAre,'/',FileForTest,'.p'])
        disp(['TEST: ',FileForTest,'.p -> DONE'])
    else
        f = warndlg({'The setup package seems to be corrupted', ...
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            '###  Error [ES0604]  ###', ...
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            'At least one critical file is missing. Try getting a new copy' ...
            ' ' ...
            'Details are printed out in the MATLAB Command Window'});
        
        disp(' ')
        disp('---------------------------------------------------------------')
        disp(' ')
        disp('### Critical error [ES0604] ###')
        disp(['Setup package corrupted: ',char(FileForTest),'.p is missing ...'])
        cd
        ls
        disp('---------------------------------------------------------------')
        disp(' ')
        
        return
    end
end
disp(' ')
disp('TEST of the package -> DONE')



% TEST 4   -  New 2.3.1 (26.08.2016)

if ~isdir([WhereIsSetup(1:end-7),'Addons'])
    ButtonName = questdlg({'The add-on directory does not exist ... ','It will be automatically created during the setup'}, ...
                         'Install_XMapTools', ...
                         'Continue', 'Continue');
    
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(WhereIsSetup(1:end-7),'Addons');
    
end

disp(' ')
disp('TEST of the add-on directory -> DONE')


% TEST 5   -  New 2.3.1 (26.08.2016)

if ~isdir([WhereIsSetup(1:end-7),'UserFiles'])
    ButtonName = questdlg({'The UserFiles directory does not exist ... ','It will be automatically created during the setup'}, ...
                         'Install_XMapTools', ...
                         'Continue', 'Continue');
    
    [SUCCESS,MESSAGE,MESSAGEID] = mkdir(WhereIsSetup(1:end-7),'UserFiles');
    
end

disp(' ')
disp('TEST of the UserFiles directory -> DONE')


% - - - - - - - - - - - - - 
% New 2.1.6 TEST to see if the user has the permissions to write in
% Config.txt

WhereSetupWillBe = cd;
[stat,struc] = fileattrib('XMT_Local_version.txt');
[stat,struc2] = fileattrib('XMT_Config.txt');

if ~struc.UserWrite || ~struc2.UserWrite
    f = warndlg({'XMapTools cannot be installed here', ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        '###  permission denied to write in:   ###', ...
        char(WhereSetupWillBe), ...
        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
        'Paste both Program/ and UserFiles/ to /Documents/MATLAB/XMapTools/', ...
        'and run again Install_XMapTools'}, 'XMapTools setup not completed ...');
    return
end

for i=1:length(WhereSetupWillBe)
    if isequal(WhereSetupWillBe(i),' ')
        f = warndlg({'The setup folder path includes space(s)', ... 
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            '###  You could have problems installating and running the program  ###', ...
            char(WhereSetupWillBe), ...
            '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
            'It is strongly recommended to install XMapTools in /Documents/MATLAB/XMapTools/'}, 'Warning ...');

    end
end

disp(' ')
disp('TEST of file permisssions -> DONE')
disp(' ')

% - - - - - - - - - - - - - 




TexteVersion = ['Version: ',char(Version),' - ',char(ProgramState),' - ',char(ReleaseDate)];
Ltv = length(TexteVersion);
NbBlanc = round((67-Ltv)/2);
for i=1:NbBlanc
    TexteVersion = [' ',TexteVersion];
end

disp('                               * * *  ');
disp(' ')
disp('      ------------------------------------------------------- ');
disp('       #   # #   # ##### ##### ##### ##### ##### #     #####  ');
disp('        # #  ## ## #   # #   #   #   #   # #   # #     #      ');
disp('         #   # # # ##### #####   #   #   # #   # #     #####  ');
disp('        # #  #   # #   # #       #   #   # #   # #         #  ');
disp('       #   # #   # #   # #       #   ##### ##### ##### #####  ');
disp('      ------------------------------------------------------- ');
disp(' ');
disp(TexteVersion);
disp(' ');
disp('                               * * *  ');
disp(' ');
disp(' ');


ButtonName = questdlg({['This program will install XMapTools ',char(Version),' in your computer'],'Would you like to continue?'}, ...
                         'Install_XMapTools', ...
                         'Yes', 'No', 'Cancel', 'Yes');

                     
if isequal(ButtonName,'Yes')
    
    % Setup...
    
    % (1) Update conbfig.txt
    OuOnEst = cd;
    fid = fopen([OuOnEst,'/XMT_Config.txt'],'w');
    fprintf(fid,'%s',char(OuOnEst));
    fclose(fid);
    
    
    
    % Update the Paths
    eval(['addpath ''',char(OuOnEst),'''']);
    resultMod = savepath;
    if resultMod == 0
        textAfficher = { ...
                        'The setup is completed', ...
                        ' ', ...
                        ' ', ...
                        'XMapTools can be run from X-ray maps directory using the command:', ...
                        '     >> XMapTools', ...
                        ' ', ...
                        'Use the MATLAB? window to change the current folder. ', ...
                        ' ', ...
                        ' ', ...
                        'Press OK to exit',};

        uiwait(msgbox(textAfficher,'Install_XMapTools','help'));

    else
        textAfficher = { ...
                        'The setup was not completed ',...
                        '  ', ...
                        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
                        '###  Error [ES0616]  ###', ...
                        '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
                        'XMapTools can not save the Path ...', ...
                        'This error could occur if the file pathdef.m is locked for the user. ', ...
                        ' ', ...
                        'Optimal solution: Change the user permissions for pathdef.m' ...
                        '         [1] Find the file using the command >> which pathdef.m' ...
                        '         [2] Change the permission of this file to read/write' ...
                        ' ',...
                        'Alternative solution: You need to add the XMapTools folder to the favorite path of MATLAB?: ', ...
                        '         [1] In the MATLAB? main GUI, use the menu: "File >> Set Path..." ', ...
                        '         [2] Add the path of XMapTools using the button "Add Folder..." ', ...
                        '         [4] Save the path (in a new file), Close the Set Path GUI. ', ...
                        ' ', ...
                        'After this change, XMapTools can be run from X-ray maps directory using the command:', ...
                        '     >> XMapTools', ...
                        ' ', ...
                        'Use the MATLAB? GUI window to change the current folder. ', ...
                        ' ', ...
                        ' ', ...
                        'Press OK to exit',};

         uiwait(msgbox(textAfficher,'Install_XMapTools','warn'));

    end
    
else
    
    textAfficher = { ...
                    'The setup was not completed ',...
                    '  ', ...
                    '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
                    '###  Error [ES0611]  ###', ...
                    '- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -', ...
                    'User pressed ''cancel'' or ''no''', ...
                    ' ', ...
                    'WARNING: XMapTools should not be used without correct setup', ...
                    ' ', ...
                    ' ', ...
                    'Press OK to exit'};
    
    uiwait(msgbox(textAfficher,'Install_XMapTools','warn'));
    
end 


    
return
    
    
    