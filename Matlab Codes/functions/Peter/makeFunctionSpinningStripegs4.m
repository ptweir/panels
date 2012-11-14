% 10/16/2012, modified from
% makeFunctionStripeBlobGratinggs4.m
% PTW 8/29/2012 hack for gs=4, modified from
% makeFunctionStripeBlobGratinggs3.m

UPDATE_RATE_FPS = 100;
SPIN_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tSpin = 0:step_size:SPIN_DURATION_SEC;
%% make stripe and blob functions
SPIN_GAIN_FRAMES = 45; % 90 frames = 180 degrees
MAX_POS_Y = 90;
BLANK_POS_OFFSET_Y = 90; % blank position is y=1 (or y=91)

CENTER_POS_OFFSET_X = 104; % center position is x=1 (or x=105)
MAX_POS_X = 104; % maximum pattern position
RIGHT_OSC_OFFSET_X = 20; % right position is x=21
LEFT_OSC_OFFSET_X = 84; % 85
BLANK_POS_OFFSET_X = 52; % 53

funcBlankx = 0*tBlank+BLANK_POS_OFFSET_X;
funcBlanky = 0*tBlank+BLANK_POS_OFFSET_Y;

funcCounterSpiny = round(SPIN_GAIN_FRAMES*tSpin);
funcClockSpiny = round(-SPIN_GAIN_FRAMES*tSpin);

funcCounterSpiny = mod(funcCounterSpiny, MAX_POS_Y);
funcClockSpiny = mod(funcClockSpiny, MAX_POS_Y);

funcRightSpinx = tSpin*0 + RIGHT_OSC_OFFSET_X;
funcLeftSpinx = tSpin*0 + LEFT_OSC_OFFSET_X;

funcRightSpinx = mod(funcRightSpinx, MAX_POS_X);
funcLeftSpinx = mod(funcLeftSpinx, MAX_POS_X);

funcCounterx = [funcBlankx, funcRightSpinx, funcBlankx(1:end-1), funcBlankx, funcLeftSpinx, funcBlankx(1:end-1)];
funcCountery = [funcBlanky, funcCounterSpiny, funcBlanky(1:end-1), funcBlanky, funcCounterSpiny, funcBlanky(1:end-1)];

funcClockx = [funcBlankx, funcRightSpinx, funcBlankx(1:end-1), funcBlankx, funcLeftSpinx, funcBlankx(1:end-1)];
funcClocky = [funcBlanky, funcClockSpiny, funcBlanky(1:end-1), funcBlanky, funcClockSpiny, funcBlanky(1:end-1)];

%% put all together
funcx = [funcCounterx, funcClockx];
funcy = [funcCountery, funcClocky];

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameX = [thisDirectoryName '\position_function_spinning_stripe_xgs4.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_spinning_stripe_ygs4.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');

%% plot to check
plot(funcx,'.')
hold on
plot(funcy,'.r')