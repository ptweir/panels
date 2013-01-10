% PTW 10/23/2012

UPDATE_RATE_FPS = 100;
OSC_DURATION_SEC = 10;
OSC_FREQ_HZ = 1;

step_size = 1/UPDATE_RATE_FPS;
tOsc = 0:step_size:OSC_DURATION_SEC;
%% make stripe functions
OSC_AMP_FRAMES = 6; % 6 frames (pixels) = 22.5 degrees

CENTER_POS_OFFSET = 46; % center position is x=47
MAX_POS = 96; % maximum pattern position
%RIGHT_OSC_OFFSET = 58; % right position is x=59 for 45 degrees
RIGHT_OSC_OFFSET = 62; % right position is x=63 for 60 degrees
%LEFT_OSC_OFFSET = 34; % left position is x=35 for 45 degrees
LEFT_OSC_OFFSET = 30; % left position is x=31 for 60 degrees


funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);
funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);

funcRightOsc = mod(funcRightOsc, MAX_POS);
thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameRight = [thisDirectoryName '\position_function_stripe_right.mat'];
func = funcRightOsc;
save(fullOutFileNameRight, 'func');

fullOutFileNameLeft = [thisDirectoryName '\position_function_stripe_left.mat'];
func = funcLeftOsc;
save(fullOutFileNameLeft, 'func');
