function [dataFileName dataFileDir dataFileNumber] = BuildFileName_CP(subjName,dataFileNumber,viewingDist,combinedORraw,expType)
 
% function dataFileName = BuildFileName_CP(subjName,dataFileNumber,viewingDist,gazeAngle, ...
%                                          headAngle,combinedORraw,expType,bCycloOnly)
%
%   example call: BuildFileName_CP('RXJ',1)
%
% Builds data file name. If dataFileNumber does not exist or equals zero,
% the function avoids overwriting existing files... it creates the next
% data file. If dataFileNumber contains two or more numbers, it creates a
% new data file name (for use with a metaDataStruct) and saves it to that
% name
%
% subjName: duh!
% dataFileNumber: [] -> create next file number with other options
%                 integer value -> create data file number with specified
%                 value
% viewingDist:    duh
% combinedORraw:  'combined'  -> add 'C' to end of filename indicating that two
%                  data files have been combined
%                 'raw' or [] -> do nothing to file name
% expType:        'MainExp', 'VertLine', 'VertHorz', 'MonoCross', or 'Pointing'


if (~exist('dataFileNumber') | isempty(dataFileNumber) | dataFileNumber == 0)
    dataFileNumber = 0;
end
if ~exist('combinedORraw') | isempty(combinedORraw)
    combinedORraw = [];
end
if ~exist('expType') | isempty(expType) | strcmp(expType,'MainExp')
    expType = 'MainExp';
end
if ~isempty(expType)
    if ~strcmp(expType,'MainExp') & ~strcmp(expType,'FrontoP') & ~strcmp(expType,'VertHorz') & ~strcmp(expType,'BGExp') & ~strcmp(expType,'NoniusLine') & ~strcmp(expType,'MonoCross') & ~strcmp(expType,'VertLine') & ~strcmp(expType,'Pointing') & ~strcmp(expType,'RandDot') & ~strcmp(expType,'CycloLines') & ~strcmp(expType,'CycloNoLines') & ~strcmp(expType,'CycloRand') & ~strcmp(expType,'CycloMeas') & ~strcmp(expType,'MainExpGround') & ~strcmp(expType,'NearExp')
        error(['BuildFileName_CP: WARNING! invalid expType ' expType '. Must equal MainExp, MonoCross, Vertline, Pointing, RandDot']);
    end
end

if ~strcmp(combinedORraw,'C') & ~isempty(combinedORraw)
    error(['BuildFileName_CP: WARNING! invalid combinedORraw input parameter value ' combinedORraw ]);
end

% FUNCTION TO FIND DATA DIRECTORY ON CURRENT COMPUTER
dataFileDir = locateDataDirCP(subjName);

fid = 1;
if (length(dataFileNumber) == 1 & dataFileNumber == 0)
    while (fid ~= -1)
        dataFileNumber = dataFileNumber + 1;
        if     (dataFileNumber >= 1 & dataFileNumber  < 10)     dataFileNumberStr = ['-00' num2str(dataFileNumber)];
        elseif (dataFileNumber >= 10 & dataFileNumber  < 100)   dataFileNumberStr = ['-0'  num2str(dataFileNumber)];
        elseif (dataFileNumber >= 100 & dataFileNumber < 1000) dataFileNumberStr = ['-'   num2str(dataFileNumber)];
        else error(['WARNING! NUMBER OF DATA FILES FOR SUBJECT ' subjName ' DIRECTORY EXCEEDS 1000'])
        end
        if strcmp(expType,'MainExp')
            dataFileName = [ subjName '-' expType '-VD' num2str(viewingDist) dataFileNumberStr  combinedORraw '.mat'];
        else
            dataFileName = [ subjName '-' expType dataFileNumberStr  combinedORraw '.mat'];
        end
        fid = fopen([dataFileDir dataFileName],'r');
            if (fid ~= -1) 
                fclose(fid); 
            end
        
    end
elseif (length(dataFileNumber) == 1 & dataFileNumber ~= 0)
        if     (dataFileNumber >= 1 &  dataFileNumber < 10)     dataFileNumberStr = ['-00' num2str(dataFileNumber)];
        elseif (dataFileNumber >= 10 &  dataFileNumber < 100)   dataFileNumberStr = ['-0'  num2str(dataFileNumber)];
        elseif (dataFileNumber >= 100 & dataFileNumber < 1000) dataFileNumberStr = ['-'   num2str(dataFileNumber)];
        else error(['WARNING! NUMBER OF DATA FILES FOR SUBJECT ' subjName ' DIRECTORY EXCEEDS 1000'])
        end
        if strcmp(expType,'MainExp')
            dataFileName = [ subjName '-' expType '-VD' num2str(viewingDist) dataFileNumberStr  combinedORraw '.mat'];
        else
            dataFileName = [ subjName '-' expType dataFileNumberStr  combinedORraw '.mat'];
        end
elseif (length(dataFileNumber) > 1)
        dataFileNumberStr = [];
        for (n = 1:length(dataFileNumber))
            if     (dataFileNumber(n) >= 1 & dataFileNumber(n) < 10)     dataFileNumberStr = [dataFileNumberStr '-00' num2str(dataFileNumber(n))];
            elseif (dataFileNumber(n) >= 10 & dataFileNumber(n) < 100)   dataFileNumberStr = [dataFileNumberStr '-0'  num2str(dataFileNumber(n))];
            elseif (dataFileNumber(n) >= 100 & dataFileNumber(n) < 1000) dataFileNumberStr = [dataFileNumberStr '-'   num2str(dataFileNumber(n))];
            else error(['WARNING! NUMBER OF DATA FILES FOR SUBJECT ' subjName ' DIRECTORY EXCEEDS 1000'])
            end
        end
        if strcmp(expType,'MainExp')
            dataFileName = [ subjName '-' expType '-VD' num2str(viewingDist) dataFileNumberStr  combinedORraw '.mat'];
        else
            dataFileName = [ subjName '-' expType dataFileNumberStr  combinedORraw '.mat'];
        end
else
    disp('BuildFileName_CP: WARNING! file does not currently support dataFileNumber inputs of length < 1');
    dataFileName = [];
end
killer = 1;