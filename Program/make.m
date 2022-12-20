function [] = make(Instruction)
% function make to compile XMapTools
% >> make Instructions
% 
% -t        test the files
% all       compile and delete the m-files
%

if ~exist('Instruction','var')
    return
end


Dir_1=cd;
List_1={'Install_XMapTools','VER_XMapTools_804','XMapTools','XConvert_JEOL_SUN','XConvert_Laser_Csv2Txt'};

Dir_2=[cd,'/Dev'];
List_2={'DensityPlot','DensityTriPlot','XmapWaitBar','GetGuiPosition_XMT','DensityPlotBinary'};

Dir_3=[cd,'/Modules'];
List_3={'VER_XMTAddOnDownload_804' ...
    ,'VER_XMTConverter_804' ...
    ,'VER_XMTFunctionsInfos_804' ...
    ,'VER_XMTImportTool_804' ...
    ,'VER_XMTModBinary_804' ...
    ,'VER_XMTModGenerator_804' ...
    ,'VER_XMTModHistTool_804' ...
    ,'VER_XMTModIDC_804' ...
    ,'VER_XMTModRGB_804' ...
    ,'VER_XMTModSpider_804' ...
    ,'VER_XMTModTRC_804' ...
    ,'VER_XMTModTriPlot_804' ...
    ,'VER_XMTStandardizationTool_804' ...
    ,'VER_XMTTutorialDownload_804' ...
    ,'XMTAddOnDownload','XMTConverter','XMTFunctionsInfos','XMTImportTool','XMTModBinary' ...
    ,'XMTModGenerator','XMTModHistTool','XMTModIDC','XMTModRGB','XMTModSpider' ...
    ,'XMTModTRC','XMTModTriPlot','XMTStandardizationTool','XMTTutorialDownload' ...
    };


switch Instruction
    
    case '-t'
        
        TestFiles(Dir_1,List_1);
        TestFiles(Dir_2,List_2);
        TestFiles(Dir_3,List_3);
        
        
    case 'all'
        
        p = input('Are you sure you want to generate p-files and delete the m-files? (y/n) ','s');
        
        [statut,msg] = copyfile(Dir_1,[Dir_1(1:end-7),'BACKUP-COMPIL/']);
        
        if isequal(p,'y') || isequal(p,'yes') ||isequal(p,'Y')

            MakePFiles(Dir_1,List_1);
            MakePFiles(Dir_2,List_2);
            MakePFiles(Dir_3,List_3);
 
            
        end
        
end
            
cd(Dir_1)

disp('REMEMBER TO UPLOAD THE NEW USER-GUIDE IN A ZIP FILE (HELP)');
disp('REMEMBER TO ACTIVATE THE UPDATE MESSAGE XMT_Msg');


return



function [] = MakePFiles(Dir,List)
cd(Dir)
for i=1:length(List)
    pcode(List{i});
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




