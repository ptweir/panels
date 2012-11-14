% PTW 6/11/2012 modified from makeFullFunctionCenter.m for use with
% Pattern_8pxWavelength_grating_48.mat

UPDATE_RATE_FPS = 300;
OSC_DURATION_SEC = 5;
STATIONARY_DURATION_SEC = 3;

OSC_AMP_FRAMES = 150; % 15 frames = 1 pixel (20px = 45 degrees)
OSC_FREQ_HZ = 1;

CENTER_POS_OFFSET = 90; % center position is x = 91 (or x = 31 for light in center)
MAX_POS = 120;
step_size = 1/UPDATE_RATE_FPS;

tStationary = 0:step_size:STATIONARY_DURATION_SEC/2-step_size;
funcStationary = 0*tStationary+CENTER_POS_OFFSET;

tOsc = 0:step_size:OSC_DURATION_SEC;
funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);

funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);

func = [funcStationary, funcRightOsc, funcStationary(1:end-1), funcStationary, funcLeftOsc, funcStationary(1:end-1)];
func = mod(func, MAX_POS);

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileName = [thisDirectoryName '\position_function_full_experiment_grating.mat'];
save(fullOutFileName, 'func');