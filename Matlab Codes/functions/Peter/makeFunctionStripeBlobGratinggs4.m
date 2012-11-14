% PTW 8/29/2012 hack for gs=4, modified from
% makeFunctionStripeBlobGratinggs3.m

UPDATE_RATE_FPS = 100;
OSC_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tOsc = 0:step_size:OSC_DURATION_SEC;
%% make stripe and blob functions
OSC_AMP_FRAMES = 10; % 20 frames (pixels) = 45 degrees

CENTER_POS_OFFSET = 121; % center position is x=1 (or x=122)
MAX_POS = 120; % maximum pattern position
RIGHT_OSC_OFFSET = 20; % right position is x=21
LEFT_OSC_OFFSET = 84; % 85
BLANK_POS_OFFSET = 120; %could also use 52; % 53, but nice to have it the same as grating...

funcBlank = 0*tBlank+BLANK_POS_OFFSET;

funcRightOsc = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);
funcLeftOsc = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);

funcRightOsc = mod(funcRightOsc, MAX_POS);
funcLeftOsc = mod(funcLeftOsc, MAX_POS);

funcxStripe = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcyStripe = funcxStripe*0;

funcxBlob = [funcBlank, funcRightOsc, funcBlank(1:end-1), funcBlank, funcLeftOsc, funcBlank(1:end-1)];
funcyBlob = funcxBlob*0+1;
%% make grating function
OSC_AMP_FRAMES = 150; % 15 frames = 1 pixel (20px = 45 degrees)
CENTER_POS_OFFSET = 90; % center position is x = 91 (or x = 31 for light in center)
MAX_POS = 120;
BLANK_POS_OFFSET = 120; % x = 121 is blank

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
fullOutFileNameX = [thisDirectoryName '\position_function_stripe_blob_grating_xgs4.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_stripe_blob_grating_ygs4.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');

%% plot to check
plot(funcx,'.')
hold on
plot(funcy*10,'.r')