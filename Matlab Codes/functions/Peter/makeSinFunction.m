UPDATE_RATE_FPS = 200;
DURATION_SEC = 5;

AMP = 10;
FREQ = 1;

%numFrames = UPDATE_RATE_FPS*DURATION_SEC+1;
%times = [0:numFrames-1]/UPDATE_RATE_FPS;
%func = AMP*sin(2*pi*times*FREQ);

% make a 20 position peak to peak 1 Hz position sine wave
func = round(AMP*make_sine_wave_function(DURATION_SEC, UPDATE_RATE_FPS, FREQ));


thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileName = [thisDirectoryName '\position_function_1hz_20p2pAmp_sin.mat'];
save(fullOutFileName, 'func');