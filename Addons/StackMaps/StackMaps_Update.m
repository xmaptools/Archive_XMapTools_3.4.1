function [UpdateState] = StackMaps_Update(varargin)
%
% This is the update for the program 
%
% Output varibale "UpdateState" (from XMapTools ...):
%   [-1]        No update system                        Continue
%   [0]         Server cannot be reached                Continue
%   [1]         This add-on is up-to-date               Continue
%   [2]         An update has been installed            Continue
%   [3]         An update is available but skiped       Stop
%   [4]         An update is available but skiped       Continue
%   [5]         Abord the call                          Stop


% <------------------------------------------
Version = '1.1';            % local version
AddOnName = 'StackMaps';
% ------------------------------------------>


LocBase = varargin{1}(1:end-1);

[onlineVersion,flag] = urlread('http://www.xmaptools.com/FTP_addons/StackMaps/Program_version.php');
[onlinePackage,flag2] = urlread('http://www.xmaptools.com/FTP_addons/StackMaps/Program_package.php');


if flag && flag2 && length(onlineVersion) 
    
    
    onlineStr = strread(onlineVersion,'%s','delimiter','-');
    OLVersion = onlineStr{2};
    LOVersion = Version;
    
    ServerVersion = strread(OLVersion,'%f');
    LocalVersion = strread(LOVersion,'%f');
        
    if LocalVersion <  ServerVersion
    
        textAfficher = { ...
            'An update of this add-on is available. ',...
            ' ', ...
            ['Version: ',char(onlineVersion),'  (you have ',Version,')'],...
            ' '};

        buttonName = questdlg(textAfficher,'Ad-on Update','Update','Later (not recommended)','Cancel','Update');

        switch buttonName
                case 'Later (not recommended)'
                    UpdateState = 4; % we continue to the add-on
                    return

                case 'Cancel'
                    UpdateState = 5; % we stop
                    return

                case 'Update'

                    WhereWeAre = cd;
                    h = waitbar(0,'The add-on is being updated - Please wait...');
                    waitbar(0.2,h);

                    rmpath(LocBase);

                    % [1] Go to the add-on directory
                    cd(LocBase);
                    waitbar(0.4,h);

                    cd ..

                    % We remove the olf package:
                    rmdir(AddOnName,'s')

                    waitbar(0.6,h);

                    % Download of the new package: 
                    WebAdress = ['http://www.xmaptools.com/FTP_addons/',AddOnName,'/',char(onlinePackage)];
                    unzip(WebAdress);

                    if isdir('__MACOSX')
                        [status,msg,msgID] = rmdir('__MACOSX', 's');
                    end

                    rehash;
                    
                    waitbar(0.9,h);

                    waitbar(1,h);

                    cd(WhereWeAre);

                    % Update is done:
                    close(h);

                    UpdateState = 2;
                    return
            end
    else
        UpdateState = 1;
        return
    end
        
    
else
    UpdateState = 0;
end

return

