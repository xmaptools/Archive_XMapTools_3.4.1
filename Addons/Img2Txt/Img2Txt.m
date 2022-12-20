function varargout = Img2Txt(varargin)
% Img2Txt runs the program VER_Img2Txts
%      Img2Txt is a MATLAB-based graphic user interface for
%      transforming image files into txt files
%
%      Img2Txt launches the inteface
%
%      Img2Txt software has been created by Pierre Lanari
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


% Check if Img2Txt can be called...
if ~isequal(Infos.Mode,1)
    warndlg('Img2Txt is only available from the workspace "Xray" ...','Warning');
    return
end

% RawData
VER_Img2Txt(ColorBar);

return

