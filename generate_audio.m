%% MATLAB script to generate noise signal (.wav) at required sampling frequency 
% Date: 09/01/2022
% Author: Pramod Kachare
% Noise data url: http://spib.linse.ufsc.br/noise.html

%% CONSTANTS
MAT_DIR = 'Mat_files';    % Path to .mat files
Fs  = 19.48e3;            % Original sampling frequency(Hz) of noise signal

%% Desired output parameters
OUT_DIR = 'Audio_files';  % Path to write audio files
EXT = '.wav';            % DESIRED AUDIO FORMAT (.wav, .flac, .ogg, etc)
fs  = 16e3;               % DESIRED SAMPLING FREQUENCY

% Calculate resampling factors
[up, down] = rat(fs/Fs);

%%
files = dir(MAT_DIR);   % List of noise files
files = files(3:end);   % Removing unix paths

for i = 1:length(files)
    [~, name, ~] = fileparts(files(i).name);      % Generate noise name
    var = load(fullfile(MAT_DIR, files(i).name)); % Load mat file 
    x = var.(name);                % Get audio data
    x = resample(x, up, down);     % Resample to desired frequency
    x = x/max(abs(x))*0.75;        % Fix amplitude range to avoid clipping
    
    % Write audio data with respective sampling frequency and format
    mkdir(fullfile(OUT_DIR, name))
    audiowrite(fullfile(OUT_DIR, name, [name, EXT]), x, fs)
    fprintf('Generated %s noise signal.\n', name);
end

%% END OF generate_aduio.m