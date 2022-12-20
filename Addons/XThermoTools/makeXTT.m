function [] = makeXTT(Instruction)
% function make to compile XThermoTools
% >> makeXTT Instructions
% 
% -t        test the files
% all       compile and delete the m-files
%

rehash; 
path(path);

if ~exist('Instruction','var')
    return
end

Dir_1=cd;
List_1={'XThermoTools','VER_XThermoTools_804','XThermoTools_Install','XThermoTools_Update'};

Dir_2=[cd,'/XTT_Dev'];
List_2={'Generate_MinimOptions'};

Dir_3=[cd,'/XTT_Modules'];
List_3 = makeListMfiles(Dir_3);
% List_3={'XTTselectCompInAntidote' ...
%     ,'XTTdisplayCompositions' ...
%     ,'XTTminimOptions' ...
%     ,'XTTselectAssemblage' ...
%     ,'XTTselectCompositions' ...
%     ,'XTTselectElem' ...
%     ,'XTTselectFluidsGasesBuffers' ...
%     ,'XTTselectMinerals20' ...
%     ,'XTTsetElMap' ...
%     ,'XTTsetOptionXTT' ...
%     };

Dir_4=[cd,'/XTT_Core'];
List_4 = makeListMfiles(Dir_4);


switch Instruction
    
    case '-t'
        
        TestFiles(Dir_1,List_1);
        TestFiles(Dir_2,List_2);
        TestFiles(Dir_3,List_3);
        TestFiles(Dir_4,List_4);


    case 'all'
        
        p = input('Are you sure you want to generate p-files and delete the m-files? (y/n) ','s');
        
        [statut,msg] = copyfile(Dir_1,[Dir_1(1:end-12),'BACKUP-COMPIL/']);
        
        if isequal(p,'y') || isequal(p,'yes') ||isequal(p,'Y')

            MakePFiles(Dir_1,List_1);
            MakePFiles(Dir_2,List_2);
            MakePFiles(Dir_3,List_3);
            MakePFiles(Dir_4,List_4);
            
        end
        
end
            
cd(Dir_1)



return




% function [] = MakePFiles(Dir,List)
% cd(Dir)
% for i=1:length(List)
%     pcode([Dir,'/',List{i},'.m']);
%     delete([Dir,'/',List{i},'.m']);
% end
% return

function [] = MakePFiles(Dir,List)
cd(Dir)
for i=1:length(List)
    pcode([List{i},'.m']);
    delete([List{i},'.m']);
end
return


function [] = TestFiles(Dir,List)
cd(Dir)
for i=1:length(List)
    if exist(List{i},'file')
    	disp(['VALID file: ',List{i}])
    else
        disp(' ')
        disp(['### WARNING ### ',List{i},' file not found!'])
        disp(' ')
    end
end
return



function [List] = makeListMfiles(Dir2chek)
%
DIR = dir(Dir2chek);
DIR_Flags = [DIR.isdir];
Compt = 0;
for i = 1:length(DIR_Flags)
    if ~DIR_Flags(i)
        if isequal(DIR(i).name(end-1:end),'.m')
            Compt = Compt+1;
            List{Compt} = DIR(i).name(1:end-2);
        end
    end
end
return

