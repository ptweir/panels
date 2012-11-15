% makeFunctionExpandingStripe4.m
% 11/14/2012, modified from
% makeFunctionSpinningStripe4.m
% 10/16/2012, modified from
% makeFunctionStripeBlobGratinggs4.m
% PTW 8/29/2012 hack for gs=4, modified from
% makeFunctionStripeBlobGratinggs3.m

UPDATE_RATE_FPS = 100;
EXPANSION_DURATION_SEC = 4;
BLANK_DURATION_SEC = 4;

step_size = 1/UPDATE_RATE_FPS;
tBlank = 0:step_size:BLANK_DURATION_SEC/2-step_size;
tExpand = 0:step_size:EXPANSION_DURATION_SEC;
%% make stripe and blob functions
MAX_POS_X = 104; % maximum pattern position
MAX_POS_Y = 129;

%Patter position starts at x=1, y=1, so all of these are intentionally one
%value less than that desired...
CENTER_POS_OFFSET_X = 104; % center position is x=1 (or x=105)
RIGHT_OFFSET_X = 20; % right position is x=21
LEFT_OFFSET_X = 84; % 85
BLANK_POS_OFFSET_X = 52; % 53

BLANK_POS_OFFSET_Y = 129; % blank position is y=1 (or y=91)

SPEED_M_PER_SEC = .5;

THETA_START_DEG = 9;
THETA_END_DEG = 45;

thetaStartRad = THETA_START_DEG*(pi/180); %starts 9 degrees half angle
thetaEndRad = THETA_END_DEG*(pi/180); %ends 45 degrees half angle

width = EXPANSION_DURATION_SEC*SPEED_M_PER_SEC/(1/tan(thetaStartRad)-1/tan(thetaEndRad));
distanceStart = width/tan(thetaStartRad);
thetaDeg = (180/pi)*atan(width./(distanceStart - SPEED_M_PER_SEC*tExpand));

funcExpandy = round((thetaDeg-THETA_START_DEG)*(128/(THETA_END_DEG-THETA_START_DEG)));
funcExpandy = mod(funcExpandy, MAX_POS_Y);

funcBlankx = 0*tBlank+BLANK_POS_OFFSET_X;
funcBlanky = 0*tBlank+BLANK_POS_OFFSET_Y;

funcRightExpandx = tExpand*0 + RIGHT_OFFSET_X;
funcLeftExpandx = tExpand*0 + LEFT_OFFSET_X;

funcRightExpandx = mod(funcRightExpandx, MAX_POS_X);
funcLeftExpandx = mod(funcLeftExpandx, MAX_POS_X);

funcx = [funcBlankx, funcRightExpandx, funcBlankx(1:end-1), funcBlankx, funcLeftExpandx, funcBlankx(1:end-1)];
funcy = [funcBlanky, funcExpandy, funcBlanky(1:end-1), funcBlanky, funcExpandy, funcBlanky(1:end-1)];

%% save file

thisFullFileName =  mfilename('fullpath');
[thisDirectoryName,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%thisDirectoryName = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\functions\Peter';
fullOutFileNameX = [thisDirectoryName '\position_function_expanding_stripe_xgs4.mat'];
fullOutFileNameY = [thisDirectoryName '\position_function_expanding_stripe_ygs4.mat'];
func = funcx;
save(fullOutFileNameX, 'func');
func = funcy;
save(fullOutFileNameY, 'func');

%% plot to check
plot(funcx,'.')
hold on
plot(funcy,'.r')