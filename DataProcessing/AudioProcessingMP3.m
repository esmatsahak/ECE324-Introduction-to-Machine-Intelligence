% --- References ---
% https://matlab.fandom.com/wiki/FAQ#How_can_I_process_a_sequence_of_files.3F
% https://www.mathworks.com/help/audio/ref/integratedloudness.html#:~:text=loudness%20%E2%80%94%20Integrated%20loudness%20(LUFS)&text=1770%2D4%20and%20EBU%20R%20128%20standards%20define%20the%20integrated,seconds%2C%20loudness%20is%20returned%20empty.
% https://www.mathworks.com/help/signal/ref/bandpass.html#mw_4af987e6-9eef-463e-9b78-97eb8214df70

% Folder location of original audio
myFolder = 'C:\Users\amyin\OneDrive - University of Toronto\Year 3\ECE324\Assignments\Langang\Persian';
% Folder location of new audio (use different folder from original)
newFolder = 'C:\Users\amyin\OneDrive - University of Toronto\Year 3\ECE324\Assignments\Langang\Persian\';

% Type of file to be extracted
filePattern = fullfile(myFolder, '*.mp3');
% List of files in original folder
theFiles = dir(filePattern);

% Iterate through each file in original folder
for f = 1 : length(theFiles)
    % File name with extenstion
    baseFileName = theFiles(f).name;
    [filepath,name,ext] = fileparts(baseFileName)
    % Full file directory
    fullFileName = fullfile(theFiles(f).folder, baseFileName);
    fprintf(1,'Now reading %s\n', fullFileName);
    
    % New file directory
    newFile = strcat(newFolder,name,'.wav');
    
    % Read audio file
    [x, fs] = audioread(fullFileName);
    
    % Audio normalizing processing
    [loudness, LRA] = integratedLoudness(x,fs);
    fprintf('Loudness before normalization: %.1f LUFS\n',loudness)
    target = -23;
    gaindB = target - loudness;
    gain = 10^(gaindB/20);
    xn = x.*gain;
    
    % Audio bandpass processing (between 50 to 8000 Hz)
    [y,d] = bandpass(xn,[50 8000],fs,'ImpulseResponse','auto','Steepness',[0.5 0.8]);  
    
    % Write new audio to new directory location
    audiowrite(newFile,y,fs);
end