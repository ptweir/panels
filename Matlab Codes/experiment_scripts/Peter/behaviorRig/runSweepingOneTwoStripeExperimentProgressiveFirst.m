% runSweepingOneTwoStripeExperiment.m
% 2/1/2013 based on runSweepingStripeExperiment.m
% 1/31/2013 based on runSweepingStripeBlobExperiment.mTRIAL_TIME_SEC = 12;
%
% for use with the pattern from make_4px_two_stripes_48.m
% y=1: a single stripe 4px (15 degrees) wide, x encodes horizontal position, x=1 is centered in front
% y=2: two stripes moving together
% y=3: two stripes moving opposite, overlap in front (at x=1)

BETWEEN_TRIAL_TIME_SEC = 5;

PATTERN_ID = 1;

OPEN_MODE = 0;
CLOSED_MODE = 1;
CLOSED_LOOP_GAIN_X = -15;

IN_FRONT_X_POS = 1; % directly in front of fly
IN_BACK_X_POS = 49; % directly behind fly
ONE_STRIPE_Y_POS = 1; % 1 stripe
TWO_STRIPE_Y_POS = 3; % 2 stripes

Ao = analogoutput('mcc',0);
ch = addchannel(Ao, [0 1]); %build a two-channel DAC
Ao_range = ch(1).OutputRange;
AoMin = Ao_range(1);
AoMax = Ao_range(2);
putsample(Ao, [0 0]); % send 0 Volts to both DAC channels

DEG_PER_STEP = 360/(12*8);
DESIRED_SWEEP_VELS_DEG_PER_SEC = [-240, -30, 30, 240, 30, 240];
DESIRED_TRIAL_Y_POSITIONS = [ONE_STRIPE_Y_POS, ONE_STRIPE_Y_POS, ONE_STRIPE_Y_POS, ONE_STRIPE_Y_POS, TWO_STRIPE_Y_POS, TWO_STRIPE_Y_POS];
sweepGainsStepsPerSec = round(DESIRED_SWEEP_VELS_DEG_PER_SEC/DEG_PER_STEP);
if sum(sweepGainsStepsPerSec*DEG_PER_STEP ~= DESIRED_SWEEP_VELS_DEG_PER_SEC)>0
    sprintf('desired and actual velocities do not match!')
end

durationsSec = 360./abs(DESIRED_SWEEP_VELS_DEG_PER_SEC);
sweepGainAoCodes = linspace(AoMin,AoMax,1+numel(DESIRED_SWEEP_VELS_DEG_PER_SEC));

%exp_time = numel(y_positions)*numel(sweep_gains)*(TRIAL_TIME_SEC + BETWEEN_TRIAL_TIME_SEC);
blockTimeSec = sum(durationsSec)+numel(sweepGainsStepsPerSec)*BETWEEN_TRIAL_TIME_SEC
numConditions = numel(sweepGainsStepsPerSec);

condInd = 1;
% encode the pattern and function identifiers
for j = 1:length(sweepGainsStepsPerSec)
    condition(condInd).duration = durationsSec(j);
    condition(condInd).sweepGain = sweepGainsStepsPerSec(j);
    condition(condInd).yPos = DESIRED_TRIAL_Y_POSITIONS(j);
    condition(condInd).sweepGainAoCode = sweepGainAoCodes(j+1);
    condInd = condInd + 1;
end

PANEL_COM_PAUSE = .05;
Panel_com('set_pattern_id', PATTERN_ID); pause(PANEL_COM_PAUSE);
Panel_com('stop'); pause(PANEL_COM_PAUSE);

NUM_REPEATS = 15; %how many times to repeat the whole sequence
experimentTimeSec = blockTimeSec*NUM_REPEATS;
experimentTimeMin = experimentTimeSec/60
for i = 1:NUM_REPEATS
    randInd = randperm(numConditions); %permute the pattern and function conditions
    for j = 1:numConditions
        jout = num2str(numConditions - j);
        conditionNum = randInd(j); %select j-th condition
        durationThisTrial = condition(conditionNum).duration;
        sweepGainThisTrial = condition(conditionNum).sweepGain;
        yPosThisTrial = condition(conditionNum).yPos;
        sweepGainAoCodeThisTrial = condition(conditionNum).sweepGainAoCode;
        % print status:
        fprintf(['block ' num2str(i) ' of ' num2str(NUM_REPEATS) ', num cond left = ' jout ', sweep gain = ' num2str(sweepGainThisTrial) ', y pos = ' num2str(yPosThisTrial) '\n']);
        % closed loop stripe fixation:
        Panel_com('set_position',[IN_FRONT_X_POS, ONE_STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[CLOSED_LOOP_GAIN_X,0,0,0]); pause(PANEL_COM_PAUSE);
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC)
        Panel_com('stop'); pause(PANEL_COM_PAUSE);
        Panel_com('set_position',[IN_FRONT_X_POS, yPosThisTrial]);  pause(PANEL_COM_PAUSE);
        Panel_com('send_gain_bias',[sweepGainThisTrial,0,0,0]);  pause(PANEL_COM_PAUSE);
        Panel_com('set_mode', [OPEN_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);

        putsample(Ao, [sweepGainAoCodeThisTrial AoMax]);
        Panel_com('start');
        pause(durationThisTrial)
        Panel_com('stop');
        putsample(Ao, [AoMin AoMin]);  pause(PANEL_COM_PAUSE);
    end
end

Panel_com('set_position',[IN_FRONT_X_POS, ONE_STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
Panel_com('send_gain_bias',[CLOSED_LOOP_GAIN_X,0,0,0]); pause(PANEL_COM_PAUSE);
Panel_com('start'); pause(PANEL_COM_PAUSE);