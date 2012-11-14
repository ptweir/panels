% PTW annotated 8/14/2012

UPDATE_RATE_FPS = 50;
OSC_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

%% make stripe and blob functions
OSC_AMP_FRAMES = 10; % 20 frames (pixels) = 45 degrees

CENTER_POS_OFFSET = 120; % center position is x=1 (or x=121)
MAX_POS = 120; % maximum pattern position
RIGHT_OSC_OFFSET = 20; % right position is x=21
LEFT_OSC_OFFSET = 100; % 101
BLANK_POS_OFFSET = 60; %61

step_size = 1/UPDATE_RATE_FPS;

tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
funcBlank = 0*tBlank+BLANK_POS_OFFSET;

tOsc = 0:step_size:OSC_DURATION_SEC;
funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);

funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);

funcxStripe = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcxStripe = mod(funcxStripe, MAX_POS);
funcyStripe = funcxStripe*0;

funcxBlob = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcxBlob = mod(funcxBlob, MAX_POS);
funcyBlob = funcxBlob*0+1;
%% make grating function
OSC_AMP_FRAMES = 150; % 15 frames = 1 pixel (20px = 45 degrees)

CENTER_POS_OFFSET = 90; % center position is x = 91 (or x = 31 for light in center)
MAX_POS = 120;
step_size = 1/UPDATE_RATE_FPS;

tOsc = 0:step_size:OSC_DURATION_SEC;
funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);

funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + CENTER_POS_OFFSET);

funcxGrating = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcxGrating = mod(funcxGrating, MAX_POS);
funcyGrating = [funcBlank*0, funcRightOsc*0+2, funcBlank(1:end-1)*0, funcBlank*0, funcLeftOsc*0+2, funcBlank(1:end-1)*0];
%% put all together
funcx = [funcxStripe, funcxBlob, funcxGrating];
funcy = [funcyStripe, funcyBlob, funcyGrating];

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameX = [thisDirectoryName '\position_function_stripe_blob_grating_x.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_stripe_blob_grating_y.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');