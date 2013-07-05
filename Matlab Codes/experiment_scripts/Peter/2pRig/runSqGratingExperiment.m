% runSqGratingExperiment.m
% 7/5/2013 based on runXYBlobExperiment.m
% 6/25/2013 based on runManyStarfieldsExperiment.m
% 5/30/2013 based on runSweepingOneTwoStripeExperimentBettinaRig.m
% 2/15/2013 based on runSweepingOneTwoStripeExperiment.m for behavior rig
% 2/1/2013 based on runSweepingStripeExperiment.m
% 1/31/2013 based on runSweepingStripeBlobExperiment.mTRIAL_TIME_SEC = 12;
%
% for use with the pattern from make_8px_xyBlob_48.m
% x, y position of 8x8 pixel light square on black background

BETWEEN_TRIAL_TIME_SEC = 3;

PATTERN_ID = 1;

OPEN_MODE = 0;
CLOSED_MODE = 1;

STRIPE_X_POS = 45;
STRIPE_Y_POS = 1;

CLOSED_X_GAIN = 30;

DEG_PER_STEP = 90/(5*8);

DESIRED_X_GAINS             = [112, 112, 112, 112, 112, 112, 112, 112];
DESIRED_Y_GAINS             = [0, 0, 0, 0, 0, 0, 0, 0];
DESIRED_TRIAL_DURATIONS_SEC = [0, .1, .2, .3, .5, .7, 1, 2];
STATIONARY_TIME_SEC = 3;

blockTimeSec = numel(DESIRED_TRIAL_DURATIONS_SEC)*(BETWEEN_TRIAL_TIME_SEC+STATIONARY_TIME_SEC) + sum(DESIRED_TRIAL_DURATIONS_SEC) 
numConditions = numel(DESIRED_X_GAINS);

condInd = 1;
% encode the pattern and function identifiers
for j = 1:numConditions
    condition(condInd).xGain = DESIRED_X_GAINS(j);
    condition(condInd).yGain = DESIRED_Y_GAINS(j);
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
        durationSecThisTrial = condition(conditionNum).durationSec;
        Panel_com('set_position',[STRIPE_X_POS, STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[CLOSED_X_GAIN,0,0,0]); pause(PANEL_COM_PAUSE);
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC);
        % print status:
        fprintf(['block ' num2str(i) ' of ' num2str(NUM_REPEATS) ', trial ' num2str(j) ' of ' num2str(numConditions) ', xgain=' num2str(xGainThisTrial) ', ygain=' num2str(yGainThisTrial) ', t=' num2str(durationSecThisTrial) '\n']);
        Panel_com('stop'); pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [OPEN_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
        Panel_com('set_position',[xPosThisTrial, yPosThisTrial]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[xGainThisTrial,0,yGainThisTrial,0]); pause(PANEL_COM_PAUSE);
        if durationSecThisTrial>0
            Panel_com('start');
            pause(durationSecThisTrial)
            Panel_com('stop');
        end
        pause(STATIONARY_TIME_SEC)
        
        Panel_com('set_position',[STRIPE_X_POS, STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[CLOSED_X_GAIN,0,0,0]); pause(PANEL_COM_PAUSE);
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC);
        % print status:
        fprintf(['block ' num2str(i) ' of ' num2str(NUM_REPEATS) ', trial ' num2str(j) ' of ' num2str(numConditions) ', xgain=' num2str(xGainThisTrial) ', ygain=' num2str(yGainThisTrial) ', t=' num2str(durationSecThisTrial) '\n']);
        Panel_com('stop'); pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [OPEN_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
        Panel_com('set_position',[xPosThisTrial, yPosThisTrial]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[-xGainThisTrial,0,yGainThisTrial,0]); pause(PANEL_COM_PAUSE);
        if durationSecThisTrial>0
            Panel_com('start');
            pause(durationSecThisTrial)
            Panel_com('stop');
        end
        pause(STATIONARY_TIME_SEC)
        
    end
end

Panel_com('set_position',[STRIPE_X_POS, STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
Panel_com('send_gain_bias',[CLOSED_X_GAIN,0,0,0]); pause(PANEL_COM_PAUSE);
Panel_com('start');
