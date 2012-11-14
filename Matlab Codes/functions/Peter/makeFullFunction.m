UPDATE_RATE_FPS = 300;
OSC_DURATION_SEC = 5;
BLANK_DURATION_SEC = 3;

OSC_AMP_FRAMES = 10;
OSC_FREQ_HZ = 1;

RIGHT_OSC_OFFSET = 20;
LEFT_OSC_OFFSET = 84;
BLANK_POS_OFFSET = 52;

step_size = 1/UPDATE_RATE_FPS;

t0 = 0:step_size:BLANK_DURATION_SEC/2-step_size;
func0 = 0*t0+BLANK_POS_OFFSET;

t1 = 0:step_size:OSC_DURATION_SEC;
func1 = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*t1)+RIGHT_OSC_OFFSET);
%func = round(OSC_AMP_FRAMES*make_sine_wave_function(OSC_DURATION_SEC, UPDATE_RATE_FPS, OSC_FREQ_HZ));

t2 = 0:step_size:OSC_DURATION_SEC;
func2 = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*t2)+LEFT_OSC_OFFSET);

func = [func0, func1, func0(1:end-1), func0, func2, func0(1:end-1)];

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileName = [thisDirectoryName '\position_function_full_experiment.mat'];
save(fullOutFileName, 'func');