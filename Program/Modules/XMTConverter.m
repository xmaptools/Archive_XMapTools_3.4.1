function varargout = XMTConverter(varargin)
% XMTAddOnDownload call the GUI VER_XMTAddOnDownload_XXX
%

TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

if TheCodeVersion >= 8040
    disp(['Compatible version: VER_XMTConverter_804']);
    disp(' ')
    % WANING UNIWAIT IS THERE!!!!!!!!!!!!
    VER_XMTConverter_804(1,varargin{1},varargin{2}); 
else
    disp(['Compatible version: VER_XMTConverter_750']);
    disp(' ')
    VER_XMTConverter_750(1,varargin{1},varargin{2});
end

varargout = {0};

return

