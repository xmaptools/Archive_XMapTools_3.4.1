function varargout = XMTImportTool(varargin)
% XMTFunctionsInfos call the GUI VER_XMTMod2DTreatment_XXX
% with XXX the compatible version depending on your MATLAB version ...

Instruction = '';
for i=1:length(varargin)
    Instruction = [Instruction,'varargin{',num2str(i),'},'];
end
Instruction = Instruction(1:end-1);

TheVersion = strread(version,'%s','delimiter','.');
TheCodeVersion = 1000*str2num(TheVersion{1}) + 10*str2num(TheVersion{2}) + str2num(TheVersion{3});

if TheCodeVersion >= 8040
    disp(['Compatible version: VER_XMTImportTool_804']);
    disp(' ')
    eval(['varar = VER_XMTImportTool_804(',char(Instruction),');']);
else
    disp(['Compatible version: VER_XMTImportTool_750']);
    disp(' ')
    eval(['varar = VER_XMTImportTool_750(',char(Instruction),');']);
end

varargout{1} = varar;

return

