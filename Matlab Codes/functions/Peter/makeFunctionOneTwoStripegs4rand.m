% makeFunctionOneTwoStripegs4rand.m
% 1/29/2013, modified from
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
MOVE_DURATION_SEC = 1;
STOP_DURATION_SEC = 1.5;
BLANK_DURATION_SEC = 4;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tStop = 0:step_size:STOP_DURATION_SEC;
tMove = 0:step_size:MOVE_DURATION_SEC;
%% make moving stripe(s) functions
CENTER_POS_OFFSET = 104; % center position is x=1 (or x=105)
MAX_POS_X = 104; % maximum pattern position
MAX_POS_Y = 4;
RIGHT_OFFSET = 44; %right position is x=45, corresponding to leading edge at 90degrees on right
LEFT_OFFSET = 60; %left position is x=61, corresponding to leading edge at 90degrees on left
CENTER_RIGHT_OFFSET = 4; %at x=5 leading edge is at center, stripe to right of it
CENTER_LEFT_OFFSET = 100; %at x=101 leading edge is at center, stripe to left of it
% for stripe centered on 90 degrees we would use:
%RIGHT_OFFSET = 40; right position is x=41, corresponding to 90degrees on right
%LEFT_OFFSET = 64; % left position is x=65, corresponding to 90degrees on left
BLANK_POS_OFFSET_X = 52; % 53
BLANK_POS_OFFSET_Y = 0; % blank position is y=1
ONE_STRIPE_OFFSET_Y = 0;
TWO_STRIPE_OFFSET_Y = 1;
THREE_STRIPE_OFFSET_Y = 2;
TWO_OPP_STRIPE_OFFSET_Y = 3;
MOVEMENT_GAIN_FRAMES = 40; % 40 frames = 90 degrees

funcBlankx = 0*tBlank+BLANK_POS_OFFSET_X;
funcBlanky = 0*tBlank+BLANK_POS_OFFSET_Y;

funcPosDirx = round(MOVEMENT_GAIN_FRAMES*tMove);
funcNegDirx = round(-MOVEMENT_GAIN_FRAMES*tMove);

%%%%%%%%%what we want%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% code  stripe(s) starting position   x   y   direction
% 1     left side                     61  1   +
% 2     right side                    45  1   -
% 3     center left                   101 1   -
% 4     center right                  5   1   +
% 5     center both left and right    5   4   +      (alternative: 101,2,-)
% 6     left and right sides          45  4   -      (alternative: 61,4,+)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

allFuncx(1,:) = [funcBlankx, tStop*0 + LEFT_OFFSET, funcPosDirx + LEFT_OFFSET, tStop*0 + CENTER_LEFT_OFFSET, funcBlankx(1:end-1)];
allFuncx(2,:) = [funcBlankx, tStop*0 + RIGHT_OFFSET, funcNegDirx + RIGHT_OFFSET, tStop*0 + CENTER_RIGHT_OFFSET, funcBlankx(1:end-1)];
allFuncx(3,:) = [funcBlankx, tStop*0 + CENTER_LEFT_OFFSET, funcNegDirx + CENTER_LEFT_OFFSET, tStop*0 + LEFT_OFFSET, funcBlankx(1:end-1)];
allFuncx(4,:) = [funcBlankx, tStop*0 + CENTER_RIGHT_OFFSET, funcPosDirx + CENTER_RIGHT_OFFSET, tStop*0 + RIGHT_OFFSET, funcBlankx(1:end-1)];
allFuncx(5,:) = [funcBlankx, tStop*0 + CENTER_RIGHT_OFFSET, funcPosDirx + CENTER_RIGHT_OFFSET, tStop*0 + RIGHT_OFFSET, funcBlankx(1:end-1)];
allFuncx(6,:) = [funcBlankx, tStop*0 + RIGHT_OFFSET, funcNegDirx + RIGHT_OFFSET, tStop*0 + CENTER_RIGHT_OFFSET, funcBlankx(1:end-1)];

allFuncy(1,:) = [funcBlanky, tStop*0 + ONE_STRIPE_OFFSET_Y, tMove*0 + ONE_STRIPE_OFFSET_Y, tStop*0 + ONE_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];
allFuncy(2,:) = [funcBlanky, tStop*0 + ONE_STRIPE_OFFSET_Y, tMove*0 + ONE_STRIPE_OFFSET_Y, tStop*0 + ONE_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];
allFuncy(3,:) = [funcBlanky, tStop*0 + ONE_STRIPE_OFFSET_Y, tMove*0 + ONE_STRIPE_OFFSET_Y, tStop*0 + ONE_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];
allFuncy(4,:) = [funcBlanky, tStop*0 + ONE_STRIPE_OFFSET_Y, tMove*0 + ONE_STRIPE_OFFSET_Y, tStop*0 + ONE_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];
allFuncy(5,:) = [funcBlanky, tStop*0 + TWO_OPP_STRIPE_OFFSET_Y, tMove*0 + TWO_OPP_STRIPE_OFFSET_Y, tStop*0 + TWO_OPP_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];
allFuncy(6,:) = [funcBlanky, tStop*0 + TWO_OPP_STRIPE_OFFSET_Y, tMove*0 + TWO_OPP_STRIPE_OFFSET_Y, tStop*0 + TWO_OPP_STRIPE_OFFSET_Y, funcBlanky(1:end-1)];

allPerms = perms([1,2,3,4,5,6]);
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
fullOutFileNameX = [thisDirectoryName '\position_function_one_two_stripe_xgs4rand.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_one_two_stripe_ygs4rand.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');

%% plot to check
figure
plot(funcx,'.')
hold on
plot(funcy,'.r')