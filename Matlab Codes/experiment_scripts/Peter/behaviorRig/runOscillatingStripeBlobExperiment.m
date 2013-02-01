% runOscillatingStripeBlobExperiment.m
% PTW Nov. or Dec. 2012

TRIAL_TIME_SEC = 10;
BETWEEN_TRIAL_TIME_SEC = 5;

PATTERN_ID = 1;
LEFT_FUNC_ID = 1;
RIGHT_FUNC_ID = 2;

X_MODE_FUNC = 4;
Y_MODE = 0;
FUNC_UPDATE_FREQ = 100;

X_START_POS = 1;
Y_POS = 1;

AO = analogoutput('mcc',0);
ch = addchannel(AO, [0 1]); %build a two-channel DAC
AO_range = ch(1).OutputRange;
AO_max = AO_range(2);
putsample(AO, [0 0]); % send 0 Volts to both DAC channels

y_positions = [1 15];
function_ids = [LEFT_FUNC_ID RIGHT_FUNC_ID];

exp_time = numel(y_positions)*numel(function_ids)*(TRIAL_TIME_SEC + BETWEEN_TRIAL_TIME_SEC);
num_conditions = length(y_positions)*length(function_ids);

cond_num = 1;
for i = 1:length(y_positions) % encode the pattern and function identifiers
    for j = 1:length(function_ids)
        condition(cond_num).y_position = y_positions(i);
        condition(cond_num).function_id = function_ids(j);
        cond_num = cond_num + 1;
    end
end

Panel_com('set_pattern_id', PATTERN_ID);
Panel_com('set_funcx_freq', FUNC_UPDATE_FREQ);
Panel_com('stop');
%Panel_com('quiet_mode_off')
NUM_REPEATS = 15; %how many times to repeat the whole sequence
for i = 1:NUM_REPEATS
    rand_ind = randperm(num_conditions); %permute the pattern and function conditions
    for j = 1:num_conditions
        jout = num2str(num_conditions - j);
        condition_num = rand_ind(j); %select j-th condition
        y_position_this_trial = condition(condition_num).y_position;
        function_id_this_trial = condition(condition_num).function_id; % remember, different grating widths stored in Y positions
        % print status:
        fprintf(['block ', num2str(i),' of ',num2str(NUM_REPEATS), ', num cond left = ' jout ', y = ',num2str(y_position_this_trial), ', function = ', num2str(function_id_this_trial), '\n']);
        Panel_com('set_position',[47, 1]);
        Panel_com('set_mode', [1, 0]);
        Panel_com('send_gain_bias',[-50,0,0,0])
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC)
        Panel_com('stop');
        
        Panel_com('set_mode', [X_MODE_FUNC, Y_MODE]);
        Panel_com('set_posfunc_id',[1, function_id_this_trial]); % 1 for x pattern
        Panel_com('set_position',[X_START_POS, y_position_this_trial]);
        putsample(AO, [function_id_this_trial 0]);
        Panel_com('start');
        pause(TRIAL_TIME_SEC)
        Panel_com('stop');
        putsample(AO, [0 0]);
    end
end

Panel_com('set_position',[47, 1]);
Panel_com('set_mode', [1, 0]);
Panel_com('send_gain_bias',[-50,0,0,0])
Panel_com('start');