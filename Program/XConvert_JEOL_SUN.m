function [ output_args ] = XConvert_JEOL_SUN( input_args )
%XCONVERT_JEOL_SUN converts the outputfiles of JEOL to XMapTools input
% files
%
% This functions requires
%    -> cnd files (including 0.cnd)
%    -> summary.txt
%    -> stage.txt
%
% Created by Pierre Lanari Aug. 2016 - Last change: 01.05.2019
clc

GenerateFiles = 1;

if exist('input_args')
    switch input_args 
        case '-s'
            GenerateFiles = 0;
    end
end


WhereSource = cd;
WhereDest = [WhereSource,'/Project_XMapTools'];

if exist(WhereDest)
    ButtonName = questdlg({'There already is a directory /Project_XMapTools?', ...
        'Do you want to overwrite it?'}, ...
        'XConvert', ...
        'Yes', 'No', 'Yes');
                     
                     
    if isequal(ButtonName,'No') || ~length(ButtonName)
        disp('bye')
        return
    end
    
    [Success,Message,MessageID] = rmdir(WhereDest);
    
end

[Success,Message,MessageID] = mkdir('Project_XMapTools');
    

% - - - - - - - - - - - - - - - - - - - - - - - - - - 
% [1] cnd and txt files
disp('  '); disp('  ');

for i = 1:100
    FileName = num2str(i);
    
    if exist([FileName,'.cnd']) && exist([FileName,'_map.txt'])
        
        [Name] = ReadCndFileMap([FileName,'.cnd']);
        
        [Success,Message,MessageID] = copyfile([WhereSource,'/',FileName,'_map.txt'],[WhereDest,'/',Name,'.txt']);
    
        if Success
            disp(['>> Copying ',FileName,'_map.txt  ->  Project_XMapTools/',Name,'.txt   -  Done']);
        else
            disp('  ')
            disp(['** WARNING ** ',FileName,'_map.txt  not found']);
            disp('  ')
        end
        %keyboard
    else
        break
    end

end


if ~GenerateFiles
    disp(' ')
    disp(' ')
    disp(' MODE [-s]  **  File creation skiped ...')
    disp(' ')
    return
end


% - - - - - - - - - - - - - - - - - - - - - - - - - -
% [2] Classification.txt
disp('  '); disp('  ');

fid = fopen([WhereDest,'/Classification.txt'],'w');
fprintf(fid,'\n\n%s\n','! Below define the input pixels for the classification function');
fprintf(fid,'%s\n','! Format: MINERAL_NAME_(no blank!)   X   Y');
fprintf(fid,'%s\n','>1');
fprintf(fid,'\n\n\n%s\n','! Below define the density of mineral phases (same order as >1)');
fprintf(fid,'%s\n','! Format: DENSITY');
fprintf(fid,'%s\n','>2');
fprintf(fid,'\n\n\n');
fclose(fid);

disp('>> Classification.txt has been created ');

% - - - - - - - - - - - - - - - - - - - - - - - - - - 
% [3] Standard.txt
disp('  '); disp('  ');

[MapCoord] = ReadZeroCndFile('0.cnd');
 
% New 3.3.1 (08.11.19)
if exist('summary.txt')
    [Data] = ReadSummaryFile('summary.txt');
else 
    return
end

[Coord] = ReadStageFile('stage.txt');


if ~isequal(size(Data.Data,1),size(Coord,1))
    disp('** WARNING **  summary.txt and stage.txt do not match !!! ')
    return
end

% Select the analyses 
[Selection,Ok] = listdlg('ListString',Data.Comments,'ListSize',[300,300]);


fid = fopen([WhereDest,'/Standards.txt'],'w');
fprintf(fid,'\n\n%s\n','>1');
fprintf(fid,'%f\t%f\t%f\t%f\n',MapCoord);
fprintf(fid,'\n\n%s\n','>2');
for i=1:length(Data.Labels)
    fprintf(fid,'%s\t',Data.Labels{i});
end
fprintf(fid,'\n\n\n%s\n','>3');

DataMat = Data.Data(Selection,:);
CoordMat = Coord(Selection,:);

XRefCoord = MapCoord(1:2);
YRefCoord = MapCoord(3:4);

ComptRejected = 0;
ComptOk = 0;
for iL = 1:size(DataMat,1)
    if CoordMat(iL,2) < max(XRefCoord) && CoordMat(iL,2) > min(XRefCoord) && CoordMat(iL,1) < max(YRefCoord) && CoordMat(iL,1) > min(YRefCoord)
        ComptOk = ComptOk + 1;
        for iC = 1:size(DataMat,2)
            fprintf(fid,'%f\t',DataMat(iL,iC));
        end
        fprintf(fid,'%f\t',CoordMat(iL,2));
        fprintf(fid,'%f\n',CoordMat(iL,1));
    else
        ComptRejected = ComptRejected + 1;
    end
end

fclose(fid);

disp(['>> Standards.txt has been created  (rejected analses: ',num2str(ComptRejected),'/',num2str(ComptRejected+ComptOk),')']);


% COPY o.cnd (new 2019)
ParentDir = [cd,'/Project_XMapTools'];
[Success,Message,MessageID] = mkdir(ParentDir,'Info');
DestinationPath = [ParentDir,'/Info'];

[SUCCESS,MESSAGE,MESSAGEID] = copyfile([cd,'/0.cnd'],[DestinationPath,'/0.cnd']);

disp(' '),disp(' ')
disp(['>> O.cnd has been copied']);


disp('  '); disp('  ');
return



function [Coord] = ReadStageFile(FileName);
% Subroutine to reand 0.cnd file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr)

            if isequal(TheStr{1},'No.')
                Labels = TheStr;
                WhereX = find(ismember(Labels,'X'));
                WhereY = find(ismember(Labels,'Y'));
                
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    if length(TheLine) > 10
                        Compt = Compt+1;
                        TheStr = strread(TheLine,'%s','delimiter','\t');
                        Coord(Compt,1) = str2double(TheStr(WhereX));
                        Coord(Compt,2) = str2double(TheStr(WhereY));
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end
return





function [Data] = ReadSummaryFile(FileName);
% Subroutine to reand Summary file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr)

            if isequal(TheStr{1},'No.')
                Data.Labels = TheStr(2:end-2);
                
                Compt = 0;
                while 1
                    TheLine = fgetl(fid);
                    if length(TheLine) > 10
                        Compt = Compt+1;
                        TheStr = strread(TheLine,'%s','delimiter','\t');
                        Data.Data(Compt,:) = str2double(TheStr(2:end-2));
                        Data.Comments{Compt} = TheStr{end};
                    else
                        break
                    end
                    
                    
                end
            end
        end
    end
end

Data.Labels{end+1} = 'X';
Data.Labels{end+1} = 'Y';

return


function [MapCoord] = ReadZeroCndFile(FileName)
% Subroutine to reand 0.cnd file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s','delimiter','\t');

        switch char(TheStr{end})
            case 'Measurement Center Position X [mm]'
                CenterPosition(1) = str2num(TheStr{1});
                
            case 'Measurement Center Position Y [mm]'
                CenterPosition(2) = str2num(TheStr{1});
                
            case 'X-axis Step Number [1~1024]'
                MapSize(1) = str2num(TheStr{1});
                
            case 'Y-axis Step Number [1~1024]'
                MapSize(2) = str2num(TheStr{1});
                
            case 'X Step Size [um], or Beam Dots Width'
                StepSize(1) = str2num(TheStr{1})/1000;
            
            case 'Y Step Size [um], or Beam Dots Width'
                StepSize(2) = str2num(TheStr{1})/1000;    
        end
    end
end

MapCoord(1) = CenterPosition(2) - MapSize(2)*StepSize(2)/2;
MapCoord(2) = CenterPosition(2) + MapSize(2)*StepSize(2)/2;

MapCoord(3) = CenterPosition(1) + MapSize(1)*StepSize(1)/2;
MapCoord(4) = CenterPosition(1) - MapSize(1)*StepSize(1)/2;

return


function [Name] = ReadCndFileMap(FileName)
% Subroutine to reand a cnd map file.
%

fid = fopen(FileName);

while 1
    TheLine = fgetl(fid);
    
    if isequal(TheLine,-1)
        fclose(fid);
        break
    end
    
    if length(TheLine)
        TheStr = strread(TheLine,'%s');

        if iscell(TheStr) && length(TheStr) > 1

            if isequal(TheStr{1},'$XM_ELEMENT')
                Name = TheStr{2};
            end

            if isequal(TheStr{1},'$XM_CRYSTAL')
                Cryst = TheStr{2};

                switch Cryst(1:3)
                    case 'ROI'
                        Name = ['_',Name];
                    case 'TOP'
                        Name = 'TOPO';
                    case 'SEI'
                        Name = 'SEI';
                end
                          
            end


        end
    end
end

return





