% makeIncDecSineFunctions.m
% 1/10/2013
% based on makeLeftRightSineFunctions.m
% PTW 10/23/2012

UPDATE_RATE_FPS = 100;
OSC_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

step_size = 1/UPDATE_RATE_FPS;
tOsc = 0:step_size:OSC_DURATION_SEC;
%% make stripe functions
OSC_AMP_FRAMES = 6; % 6 frames (pixels) = 22.5 degrees

CENTER_POS_OFFSET = 0; % will add to starting positions
MAX_POS = 96; % maximum pattern position

funcIncOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc));
funcDecOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc));

funcIncOsc = mod(funcIncOsc, MAX_POS);
funcDecOsc = mod(funcDecOsc, MAX_POS);

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameInc = [thisDirectoryName '\position_function_stripe_inc.mat'];
func = funcIncOsc;
save(fullOutFileNameInc, 'func');

fullOutFileNameDec = [thisDirectoryName '\position_function_stripe_dec.mat'];
func = funcDecOsc;
save(fullOutFileNameDec, 'func');
