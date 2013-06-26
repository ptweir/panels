% runXYBlobExperiment.m
% 6/25/2013 based on runManyStarfieldsExperiment.m
% 5/30/2013 based on runSweepingOneTwoStripeExperimentBettinaRig.m
% 2/15/2013 based on runSweepingOneTwoStripeExperiment.m for behavior rig
% 2/1/2013 based on runSweepingStripeExperiment.m
% 1/31/2013 based on runSweepingStripeBlobExperiment.mTRIAL_TIME_SEC = 12;
%
% for use with the pattern from make_8px_xyBlob_48.m
% x, y position of 8x8 pixel light square on black background

BETWEEN_TRIAL_TIME_SEC = 2;

PATTERN_ID = 1;

OPEN_MODE = 0;

BLANK_X_POS = 97;
BLANK_Y_POS = 33;

DEG_PER_STEP = 90/(5*8);
%horizontal motion:
DESIRED_X_GAINS_H             = [ 40,  40,  40,  40, -40, -40, -40, -40];
DESIRED_Y_GAINS_H             = [  0,   0,   0,   0,   0,   0,   0,   0];
DESIRED_START_X_POSITIONS_H   = [  1,   1,   1,   1,  89,  89,  89,  89];
DESIRED_START_Y_POSITIONS_H   = [  1,   9,  17,  25,   1,   9,  17,  25];
DESIRED_TRIAL_DURATIONS_SEC_H = [2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2, 2.2];

%vertical motion:
DESIRED_X_GAINS_V             = [  0,  0,  0,  0,  0,   0,   0,   0,   0,   0];
DESIRED_Y_GAINS_V             = [ 40, 40, 40, 40, 40, -40, -40, -40, -40, -40];
DESIRED_START_X_POSITIONS_V   = [  5, 25, 45, 65, 85,   5,  25,  45,  65,  85];
DESIRED_START_Y_POSITIONS_V   = [  1,  1,  1,  1,  1,  25,  25,  25,  25,  25];
DESIRED_TRIAL_DURATIONS_SEC_V = [ .6, .6, .6, .6, .6,  .6,  .6,  .6,  .6,  .6];

DESIRED_X_GAINS             = [DESIRED_X_GAINS_H, DESIRED_X_GAINS_V];
DESIRED_Y_GAINS             = [DESIRED_Y_GAINS_H, DESIRED_Y_GAINS_V];
DESIRED_START_X_POSITIONS   = [DESIRED_START_X_POSITIONS_H, DESIRED_START_X_POSITIONS_V];
DESIRED_START_Y_POSITIONS   = [DESIRED_START_Y_POSITIONS_H, DESIRED_START_Y_POSITIONS_V];
DESIRED_TRIAL_DURATIONS_SEC = [DESIRED_TRIAL_DURATIONS_SEC_H, DESIRED_TRIAL_DURATIONS_SEC_V];

blockTimeSec = numel(DESIRED_TRIAL_DURATIONS_SEC)*BETWEEN_TRIAL_TIME_SEC + sum(DESIRED_TRIAL_DURATIONS_SEC) 
numConditions = numel(DESIRED_X_GAINS);

condInd = 1;
% encode the pattern and function identifiers
for j = 1:numConditions
    condition(condInd).xGain = DESIRED_X_GAINS(j);
    condition(condInd).yGain = DESIRED_Y_GAINS(j);
    condition(condInd).xPos = DESIRED_START_X_POSITIONS(j);
    condition(condInd).yPos = DESIRED_START_Y_POSITIONS(j);
    condition(condInd).durationSec = DESIRED_TRIAL_DURATIONS_SEC(j);
    condInd = condInd + 1;
end

PANEL_COM_PAUSE = .05;
Panel_com('set_pattern_id', PATTERN_ID); pause(PANEL_COM_PAUSE);
Panel_com('stop'); pause(PANEL_COM_PAUSE);
Panel_com('set_mode', [OPEN_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);

NUM_REPEATS = 15; %how many times to repeat the whole sequence
experimentTimeSec = blockTimeSec*NUM_REPEATS;
experimentTimeMin = experimentTimeSec/60
for i = 1:NUM_REPEATS
    %randInd = randperm(numConditions); %permute the pattern and function conditions
    randInd = [1:numConditions];
    for j = 1:numConditions
        conditionNum = randInd(j); %select j-th condition
        xGainThisTrial = condition(conditionNum).xGain;
        yGainThisTrial = condition(conditionNum).yGain;
        xPosThisTrial = condition(conditionNum).xPos;
        yPosThisTrial = condition(conditionNum).yPos;
        durationSecThisTrial = condition(conditionNum).durationSec;
        Panel_com('set_position',[BLANK_X_POS, BLANK_Y_POS]);
        pause(BETWEEN_TRIAL_TIME_SEC);
        % print status:
        fprintf(['block ' num2str(i) ' of ' num2str(NUM_REPEATS) ', trial ' num2str(j) ' of ' num2str(numConditions) ', xgain=' num2str(xGainThisTrial) ', ygain=' num2str(yGainThisTrial) ', x=' num2str(xPosThisTrial) ', y=' num2str(yPosThisTrial) ', t=' num2str(durationSecThisTrial) '\n']);
        Panel_com('set_position',[xPosThisTrial, yPosThisTrial]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[xGainThisTrial,0,yGainThisTrial,0]); pause(PANEL_COM_PAUSE);
        Panel_com('start');
        pause(durationSecThisTrial)
        Panel_com('stop'); pause(PANEL_COM_PAUSE);
    end
end

Panel_com('set_position',[BLANK_X_POS, BLANK_Y_POS]);
