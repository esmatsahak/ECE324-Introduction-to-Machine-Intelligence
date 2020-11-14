%Converts audio samples into mel spectrograms

myFolder = '';
newFolder = '';

imgFolder = strcat(newFolder,'\Spectrogram\');
dataFolder = strcat(newFolder,'\Data\');
mkdir(imgFolder);
mkdir(dataFolder);

% Type of file to be extracted
filePattern = fullfile(myFolder, '*.wav');
% List of files in original folder
theFiles = dir(filePattern);

% Iterate through each file in original folder
for f = 1 : length(theFiles)
    % File name with extenstion
    baseFileName = theFiles(f).name;
    % Full file directory
    fullFileName = fullfile(theFiles(f).folder, baseFileName);
    fprintf(1,'Now reading %s\n', fullFileName);
    
    % New file directory
    baseFileName = baseFileName(1:end-3);
    imgFile = strcat(imgFolder,baseFileName,'jpg');
    dataFile = strcat(dataFolder,baseFileName,'csv');
    
    % Read audio file
    [x, fs] = audioread(fullFileName);
    %x = x(1:3*fs);
    
    %produce mel spectrogram
    S = melSpectrogram(x,fs);
    [bands, frames] = size(S);
    fprintf('number of bands: %3d, number of frames: %4d\n', bands, frames);
    
    % Write new audio to new directory location
    melSpectrogram(x,fs);
    saveas(gcf, imgFile);
    writematrix(S, dataFile);
end