% makeFunctionTwoStripegs4rand.m
% 1/9/2012, modified from
% makeFunctionMultiStripegs4rand.m
% 12/4/2012, modified from
% makeFunctionMultiStripegs4.m
% 12/4/2012, modified from
% makeFunctionExpandingOscillatingStripe4.m
% 11/14/2012 modified from
% % makeFunctionExpandingStripe4.m and makeFunctionStripeBlobGrating3.m
% 11/14/2012, modified from
% makeFunctionSpinningStripe4.m
% 10/16/2012, modified from
% makeFunctionStripeBlobGratinggs4.m
% PTW 8/29/2012 hack for gs=4, modified from
% makeFunctionStripeBlobGratinggs3.m

UPDATE_RATE_FPS = 100;
OSC_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;
OSC_FREQ_HZ = .5;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tOsc = 0:step_size:OSC_DURATION_SEC;
%% make oscillating stripe functions
OSC_AMP_FRAMES = 10; % 20 frames (pixels) = 45 degrees

CENTER_POS_OFFSET = 104; % center position is x=1 (or x=105)
MAX_POS_X = 104; % maximum pattern position
MAX_POS_Y = 4;
RIGHT_OSC_OFFSET = 20; % right position is x=21
LEFT_OSC_OFFSET = 84; % 85
BLANK_POS_OFFSET_X = 52; % 53
BLANK_POS_OFFSET_Y = 0; % blank position is y=1
ONE_STRIPE_OFFSET_Y = 0;
TWO_STRIPE_OFFSET_Y = 1;
THREE_STRIPE_OFFSET_Y = 2;
TWO_OPP_STRIPE_OFFSET_Y = 3;

funcBlankx = 0*tBlank+BLANK_POS_OFFSET_X;
funcOscPosDirx = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);
funcOscNegDirx = round(OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + LEFT_OSC_OFFSET);
% I think this would be equivalent: funcOscNegDirx = round(-OSC_AMP_FRAMES*sin(2*pi*OSC_FREQ_HZ*tOsc) + RIGHT_OSC_OFFSET);

funcBlanky = 0*tBlank+BLANK_POS_OFFSET_Y;

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FROM FUTURE: noticed bug, these should be [funcBlanky, tOsc*0 +
% ONE_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];, etc but got lucky because
% mod(52, 4)=0, so mod(funcy, MAX_POS_Y) corrects mistake
%%%%%%%%%%%%%%%%%%%%%%%%%
allFuncy(1,:) = [funcBlanky, tOsc*0 + ONE_STRIPE_OFFSET_Y, funcBlankx(1:end-1)];
allFuncy(2,:) = [funcBlanky, tOsc*0 + TWO_STRIPE_OFFSET_Y, funcBlankx(1:end-1)];
allFuncy(3,:) = [funcBlanky, tOsc*0 + TWO_OPP_STRIPE_OFFSET_Y, funcBlankx(1:end-1)];
allFuncy(4,:) = [funcBlanky, tOsc*0 + TWO_OPP_STRIPE_OFFSET_Y, funcBlankx(1:end-1)];

allFuncx(1,:) = [funcBlankx,funcOscPosDirx, funcBlankx(1:end-1)];
allFuncx(2,:) = [funcBlankx,funcOscPosDirx, funcBlankx(1:end-1)];
allFuncx(3,:) = [funcBlankx,funcOscPosDirx, funcBlankx(1:end-1)];
allFuncx(4,:) = [funcBlankx,funcOscNegDirx, funcBlankx(1:end-1)];

allPerms = perms([1,2,3,4]);
allPerms = allPerms(randperm(size(allPerms,1))',:);
allPerms = reshape(allPerms',1,[]);

funcy = allFuncy(allPerms,:);
funcy = reshape(funcy',1,[]);
funcy = mod(funcy, MAX_POS_Y);

funcx = allFuncx(allPerms,:);
funcx = reshape(funcx',1,[]);
funcx = mod(funcx, MAX_POS_X);
%% save file

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameX = [thisDirectoryName '\position_function_two_stripe_xgs4rand.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_two_stripe_ygs4rand.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');

%% plot to check
figure
plot(funcx,'.')
hold on
plot(funcy,'.r')