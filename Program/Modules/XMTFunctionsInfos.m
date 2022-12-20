function varargout = XMTFunctionsInfos(varargin)
% XMTFunctionsInfos call the GUI VER_XMTFunctionsInfos_XXX
%

TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

if TheCodeVersion >= 8040
    disp(['Compatible version: VER_XMTFunctionsInfos_804']);
    disp(' ')
    VER_XMTFunctionsInfos_804(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5});
else
    disp(['Compatible version: VER_XMTFunctionsInfos_750']);
    disp(' ')
    VER_XMTFunctionsInfos_750(varargin{1},varargin{2},varargin{3},varargin{4},varargin{5});
end

return

