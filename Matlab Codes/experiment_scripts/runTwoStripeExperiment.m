% runTwoStripeExperiment.m
% 1/10/2013, based on
% runOscillatingStripeBlobExperiment.m
% PTW Nov. or Dec. 2012

TRIAL_TIME_SEC = 4;
BETWEEN_TRIAL_TIME_SEC = 4;

PATTERN_ID = 1;

INC_FUNC_ID = 1;
DEC_FUNC_ID = 2;
CENTER_X_POS = 1;
RIGHT_X_POS = 13;
LEFT_X_POS = 85;
ONE_STRIPE_Y_POS = 1;
TWO_STRIPE_TOG_Y_POS = 2;
TWO_STRIPE_OPP_Y_POS = 3;

X_MODE_FUNC = 4;
Y_MODE = 0;
FUNC_UPDATE_FREQ = 100;

AO = analogoutput('mcc',0);
ch = addchannel(AO, [0 1]); %build a two-channel DAC
AO_range = ch(1).OutputRange;
AO_max = AO_range(2);
putsample(AO, [0 0]); % send 0 Volts to both DAC channels

% Encode different trial conditions:
condition(1).x_position = RIGHT_X_POS;
condition(1).y_position = ONE_STRIPE_Y_POS;
condition(1).function_id = INC_FUNC_ID;

condition(2).x_position = RIGHT_X_POS;
condition(2).y_position = ONE_STRIPE_Y_POS;
condition(2).function_id = DEC_FUNC_ID;

condition(3).x_position = RIGHT_X_POS;
condition(3).y_position = TWO_STRIPE_TOG_Y_POS;
condition(3).function_id = INC_FUNC_ID;

condition(4).x_position = RIGHT_X_POS;
condition(4).y_position = TWO_STRIPE_TOG_Y_POS;
condition(4).function_id = DEC_FUNC_ID;

condition(5).x_position = RIGHT_X_POS;
condition(5).y_position = TWO_STRIPE_OPP_Y_POS;
condition(5).function_id = INC_FUNC_ID;

condition(6).x_position = RIGHT_X_POS;
condition(6).y_position = TWO_STRIPE_OPP_Y_POS;
condition(6).function_id = DEC_FUNC_ID;

condition(7).x_position = LEFT_X_POS;
condition(7).y_position = ONE_STRIPE_Y_POS;
condition(7).function_id = INC_FUNC_ID;

condition(8).x_position = LEFT_X_POS;
condition(8).y_position = ONE_STRIPE_Y_POS;
condition(8).function_id = DEC_FUNC_ID;

num_conditions = numel(condition);

Panel_com('set_pattern_id', PATTERN_ID);
pause(.1)
Panel_com('set_funcx_freq', FUNC_UPDATE_FREQ);
pause(.1)
Panel_com('stop');
%Panel_com('quiet_mode_off')
NUM_REPEATS = 20; %how many times to repeat the whole sequence
for i = 1:NUM_REPEATS
    rand_ind = randperm(num_conditions); %permute the pattern and function conditions
    for j = 1:num_conditions
        jout = num2str(num_conditions - j);
        condition_num = rand_ind(j); %select j-th condition
        x_position_this_trial = condition(condition_num).x_position;
        y_position_this_trial = condition(condition_num).y_position;
        function_id_this_trial = condition(condition_num).function_id;
        % print status:
        fprintf(['block ', num2str(i),' of ',num2str(NUM_REPEATS), ', num cond left = ' jout ', y = ',num2str(y_position_this_trial), ', function = ', num2str(function_id_this_trial), '\n']);
        Panel_com('set_position',[CENTER_X_POS, ONE_STRIPE_Y_POS]);
        Panel_com('set_mode', [1, 0]);
        Panel_com('send_gain_bias',[-50,0,0,0])
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC)
        Panel_com('stop');
        
        Panel_com('set_mode', [X_MODE_FUNC, Y_MODE]);
        Panel_com('set_posfunc_id',[1, function_id_this_trial]); % 1 for x pattern
        Panel_com('set_position',[x_position_this_trial, y_position_this_trial]);
        putsample(AO, [function_id_this_trial, x_position_this_trial]);
        Panel_com('start');
        pause(TRIAL_TIME_SEC)
        Panel_com('stop');
        putsample(AO, [0 0]);
    end
end

Panel_com('set_position',[CENTER_X_POS, ONE_STRIPE_Y_POS]);
Panel_com('set_mode', [1, 0]);
Panel_com('send_gain_bias',[-50,0,0,0])
Panel_com('start');