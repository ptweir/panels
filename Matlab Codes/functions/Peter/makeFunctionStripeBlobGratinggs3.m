% PTW 8/15/2012 hack for gs=3, modified from
% makeFunctionStripeBlobGrating2.m

UPDATE_RATE_FPS = 40;
OSC_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tOsc = 0:step_size:OSC_DURATION_SEC;
%% make stripe and blob functions
OSC_AMP_FRAMES = 10; % 20 frames (pixels) = 45 degrees

CENTER_POS_OFFSET = 104; % center position is x=1 (or x=105)
MAX_POS = 104; % maximum pattern position
RIGHT_OSC_OFFSET = 20; % right position is x=21
LEFT_OSC_OFFSET = 84; % 85
BLANK_POS_OFFSET = 52; % 53

funcBlank = 0*tBlank+BLANK_POS_OFFSET;

funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);
funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);

funcxStripe = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcxStripe = mod(funcxStripe, MAX_POS);
funcyStripe = funcxStripe*0;

funcxBlob = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcxBlob = mod(funcxBlob, MAX_POS);
funcyBlob = funcxBlob*0+1;
%% make grating function
OSC_AMP_FRAMES = 70; % 7 frames = 1 pixel (20px = 45 degrees)
CENTER_POS_OFFSET = 28; % center position is x = 29
MAX_POS = 56;
BLANK_POS_OFFSET = 80; % arbitrary, greater than 56...

funcBlank = 0*tBlank+BLANK_POS_OFFSET;

funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);
funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);

funcRightOsc = mod(funcRightOsc, MAX_POS);
funcLeftOsc = mod(funcLeftOsc, MAX_POS);

funcxGrating = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcyGrating = funcxGrating*0+2;
%% put all together
funcx = [funcxStripe, funcxBlob, funcxGrating];
funcy = [funcyStripe, funcyBlob, funcyGrating];

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameX = [thisDirectoryName '\position_function_stripe_blob_grating_xgs3.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_stripe_blob_grating_ygs3.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');