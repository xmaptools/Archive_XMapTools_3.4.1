function varargout = XMTAddOnDownload(varargin)
% XMTAddOnDownload call the GUI VER_XMTAddOnDownload_XXX
%

TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

if TheCodeVersion >= 8040
    disp(['Compatible version: VER_XMTAddOnDownload_804']);
    disp(' ')
    % WANING UNIWAIT IS THERE!!!!!!!!!!!!
    uiwait(VER_XMTAddOnDownload_804(varargin{1},varargin{2},varargin{3})); 
else
    disp(['Compatible version: VER_XMTAddOnDownload_750']);
    disp(' ')
    uiwait(VER_XMTAddOnDownload_750(varargin{1},varargin{2},varargin{3}));
end



return

