function dataFileDir = locateDataDirCP(subjName)
dataFileDirs = {['C:\Documents and Settings\Banks Lab\Desktop\CPoints\Data\' subjName '\']; ...
                ['/Users/johannesburge/My Documents/VisionScience/Project_VerticalHoropter/Data/' subjName '/'];
                ['/Users/emily/Documents/CPoints/Data/' subjName '/'];
                ['/Users/emily/Documents/CPointsExpData2/Data/' subjName '/'];
                ['./Data/' subjName '/']};

for i=1:length(dataFileDirs),
    if length(dir(dataFileDirs{i})),
        % found data directory
        dataFileDir = dataFileDirs{i};
    end
end
if isempty(dataFileDir)
    fprintf('locateDataDirCP: WARNING! cannot find vertical horopter directory.  Please enter it into locateDataDirCP.m\n');
end
