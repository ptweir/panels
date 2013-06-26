% 5/30/2013 based on runSweepingOneTwoStripeExperimentBettinaRig.m
% 2/15/2013 based on runSweepingOneTwoStripeExperiment.m for behavior rig
% 2/1/2013 based on runSweepingStripeExperiment.m
% 1/31/2013 based on runSweepingStripeBlobExperiment.mTRIAL_TIME_SEC = 12;
%
% for use with the pattern from make_many_starfields.m
% y=1: x=1, same as x=1 for other patterns. Otherwise all off.
% y=2: progression through starfield
% y=3: regression through starfield
% y=4: side slip to right
% y=5: side slip to left

BEFORE_TRIAL_TIME_SEC = 1;
AFTER_TRIAL_TIME_SEC = 3;
TRIAL_DURATION_SEC = 4;

PATTERN_ID = 1;

OPEN_MODE = 0;

DEG_PER_STEP = 90/(5*8);
DESIRED_X_GAINS = [20, 40, 80, 20, 40, 80, 20, 40, 80, 20, 40, 80];
DESIRED_TRIAL_Y_POSITIONS = [2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5];
DESIRED_START_X_POSITION = 1;

blockTimeSec = numel(DESIRED_X_GAINS)*(BEFORE_TRIAL_TIME_SEC+TRIAL_DURATION_SEC+AFTER_TRIAL_TIME_SEC)
numConditions = numel(DESIRED_X_GAINS);

condInd = 1;
% encode the pattern and function identifiers
for j = 1:numConditions
    condition(condInd).xGain = DESIRED_X_GAINS(j);
    condition(condInd).yPos = DESIRED_TRIAL_Y_POSITIONS(j);
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
    randInd = randperm(numConditions); %permute the pattern and function conditions
    for j = 1:numConditions
        jout = num2str(numConditions - j);
        conditionNum = randInd(j); %select j-th condition
        xGainThisTrial = condition(conditionNum).xGain;
        yPosThisTrial = condition(conditionNum).yPos;
        %sweepGainAoCodeThisTrial = condition(conditionNum).xGainAoCode;
        % print status:
        fprintf(['block ' num2str(i) ' of ' num2str(NUM_REPEATS) ', num cond left = ' jout ', x gain = ' num2str(xGainThisTrial) ', y pos = ' num2str(yPosThisTrial) '\n']);
        % closed loop stripe fixation:
        Panel_com('set_position',[DESIRED_START_X_POSITION, 1]);
        pause(BEFORE_TRIAL_TIME_SEC - PANEL_COM_PAUSE)
        Panel_com('set_position',[DESIRED_START_X_POSITION, yPosThisTrial]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[xGainThisTrial,0,0,0]); pause(PANEL_COM_PAUSE);
        Panel_com('start');
        pause(TRIAL_DURATION_SEC)
        Panel_com('stop');
        pause(AFTER_TRIAL_TIME_SEC)
    end
end

Panel_com('set_position',[DESIRED_START_X_POSITION, 1]);
