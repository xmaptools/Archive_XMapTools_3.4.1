function varargout = StackMaps(varargin)
% StackMaps runs the program VER_StackMaps
%      StackMaps is a MATLAB-based graphic user interface for
%      stacking maps
%
%      StackMaps launches the inteface
%
%      StackMaps software has been created by Julien Reynes
%
%      Find out more at http://www.xmaptools.com
%


% Read the variables ...
Infos = varargin{1};
RawData = varargin{2};
MaskFile = varargin{3};
Quanti = varargin{4};
Results = varargin{5};
ColorBar = varargin{6};


% Check if StackMaps can be called...
if ~isequal(Infos.Mode,1)
    warndlg('StackMaps is only available from the workspace "Xray" ...','Warning');
    return
end

if ~iscell(Infos.Xray.ListMaps) || length(Infos.Xray.ListMaps) < 1 
    
    Text{1} = 'StackMaps can not be called because there is no map';
    warndlg(Text,'Warning');
    return
        
end

% RawData
VER_StackMaps(RawData);

return

