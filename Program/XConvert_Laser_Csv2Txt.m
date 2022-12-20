clear all


Files = dir('*.csv');

mkdir(cd,'EXPORT')

for iFile = 1:length(Files)

    Data = [];
    
    FileName = Files(iFile).name;
    
    Name = FileName(1:end-4);
    
    NamePart1 = regexp(Name,'\d');
    NamePart2 = regexp(Name,'\D');
    
    NewName = [Name(NamePart1),Name(NamePart2),'.txt'];
    disp(NewName)
    
    Fid = fopen(FileName,'r');


    count = 0;
    while 1
        Lin = fgetl(Fid);

        if isequal(Lin,-1)
            break
        end

        count = count+1;

        TheLineConvert = strread(Lin,'%f','delimiter',';');
        Data(count,1:length(TheLineConvert)) = TheLineConvert; 
        % flipud(TheLineConvert)
        
%         if isequal(Lin(1:3),';;;')
%             keyboard
%         end
        
        
    end

    Data = flipud(Data);
    
    save([cd,'/EXPORT/',NewName],'Data','-ASCII');
    
    disp([FileName,' done'])
end
    
    

%keyboard 
