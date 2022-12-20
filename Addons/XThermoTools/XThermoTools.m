function varargout = XThermoTools(varargin)
% XThermoTools runs the program VER_XThermoTools_750
%      XThermoTools is a MATLAB-based graphic user interface for the 
%      processing of chemical images and thermodynamics modeling
%
%      XThermoTools launches the inteface
%
%      XThermoTools software has been created and is maintained by 
%      Dr. Pierre Lanari (pierre.lanari@geo.unibe.ch)
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

% Check if XThermoTools can be called...

IsDensity = 0;
if isfield(MaskFile(Infos.Xray.SelectedMaskFile),'AverageDensity')
    if MaskFile(Infos.Xray.SelectedMaskFile).AverageDensity > 0 
        IsDensity = 1;
    end
end 

if ~isequal(Infos.Mode,2)
    warndlg('XThermoTools is only available from the workspace "Quanti" ...','Warning');
    return
end

if ~iscell(Infos.Quanti.ListQuantis) || length(Infos.Quanti.ListQuantis) < 3 || ~MaskFile(1).type || ~IsDensity
    
    Text{1} = 'XThermoTools can not be called because of the following reasons:';
    if length(Infos.Quanti.ListQuantis) < 3 || ~iscell(Infos.Quanti.ListQuantis)
        Text{end+1} = '- Standardized maps required (use merge and select the merged map)';
    end
    if ~MaskFile(1).type
        Text{end+1} = '- A maskfile is required (make a classification and select a maskfile)';
    end
    if ~IsDensity
        Text{end+1} = '- There is no density map available (use the function density map in Quanti)';
    end
    warndlg(Text,'Warning');
    return
        
end

TheMaskFile = MaskFile(Infos.Xray.SelectedMaskFile);
TheQuanti = Quanti(Infos.Quanti.SelectedQuanti);

TheQuanti.listname = upper(TheQuanti.listname);   % XThermoTools use UPPERCASE


disp(' ');
disp('____________________________________________________________________')

 
TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

disp(' ');
disp(['You are using MATLAB ',char(TheVersion{1}),'.',char(TheVersion{2}),'.',char(TheVersion{3}),' release ',char(TheVersion{4})])

if TheCodeVersion >= 8040
    disp(['XThermoTools compatibility check recommands: VER_XThermoTools_804'])
    disp(' ');
    disp('... please wait XThermoTools is launching ...');
    
    VER_XThermoTools_804(TheQuanti,TheMaskFile);
    
else
    disp(['XThermoTools compatibility check recommands: VER_XThermoTools_750'])
    disp(' ');
    disp('... please wait XThermoTools is launching ...');
    
    VER_XThermoTools_750(TheQuanti,TheMaskFile);
end

return

