% PTW annotated 6/11/2012

UPDATE_RATE_FPS = 300;
OSC_DURATION_SEC = 4.5;
BLANK_DURATION_SEC = 3;
CENTER_DURATION_SEC = .5;

OSC_AMP_FRAMES = 10; % 20 frames (pixels) = 45 degrees
OSC_FREQ_HZ = 1;

CENTER_POS_OFFSET = 104; % center position is x=1 (or x=105)
MAX_POS = 104; % maximum pattern position
RIGHT_OSC_OFFSET = 20; % right position is x=21
LEFT_OSC_OFFSET = 84; % 85
BLANK_POS_OFFSET = 52; %53

constVelDur = RIGHT_OSC_OFFSET/(2*pi*OSC_AMP_FRAMES);

step_size = 1/UPDATE_RATE_FPS;

tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
funcBlank = 0*tBlank+BLANK_POS_OFFSET;

tOsc = 0:step_size:OSC_DURATION_SEC;
funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);

funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);

tConstVel = 0:step_size:constVelDur-step_size;
funcRightConstVel = round(-2*pi*OSC_AMP_FRAMES*tConstVel + RIGHT_OSC_OFFSET);
funcLeftConstVel = round(2*pi*OSC_AMP_FRAMES*tConstVel + LEFT_OSC_OFFSET);

tCenter = 0:step_size:CENTER_DURATION_SEC-step_size;
funcCenter = 0*tCenter+CENTER_POS_OFFSET;

func = [funcBlank, funcRightOsc, funcRightConstVel, funcCenter, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcLeftConstVel, funcCenter, funcBlank(1:end-1)];
func = mod(func, MAX_POS);

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileName = [thisDirectoryName '\position_function_full_experiment_center.mat'];
save(fullOutFileName, 'func');