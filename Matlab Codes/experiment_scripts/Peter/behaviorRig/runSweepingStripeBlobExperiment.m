TRIAL_TIME_SEC = 12;
BETWEEN_TRIAL_TIME_SEC = 5;

PATTERN_ID = 1;

X_MODE_OPEN = 0;
Y_MODE = 0;

X_START_POS = 95;
Y_POS = 1;

AO = analogoutput('mcc',0);
ch = addchannel(AO, [0 1]); %build a two-channel DAC
AO_range = ch(1).OutputRange;
AO_max = AO_range(2);
putsample(AO, [0 0]); % send 0 Volts to both DAC channels

y_positions = [1 15];
sweep_gains = [-3 3];

sweep_gain_codes = [1 2];

exp_time = numel(y_positions)*numel(sweep_gains)*(TRIAL_TIME_SEC + BETWEEN_TRIAL_TIME_SEC);
num_conditions = length(y_positions)*length(sweep_gains);

cond_num = 1;
for i = 1:length(y_positions) % encode the pattern and function identifiers
    for j = 1:length(sweep_gains)
        condition(cond_num).y_position = y_positions(i);
        condition(cond_num).sweep_gain = sweep_gains(j);
        condition(cond_num).sweep_gain_code = sweep_gain_codes(j);
        cond_num = cond_num + 1;
    end
end

Panel_com('set_pattern_id', PATTERN_ID);
Panel_com('stop');
%Panel_com('quiet_mode_off')
NUM_REPEATS = 12; %how many times to repeat the whole sequence
for i = 1:NUM_REPEATS
    rand_ind = randperm(num_conditions); %permute the pattern and function conditions
    for j = 1:num_conditions
        jout = num2str(num_conditions - j);
        condition_num = rand_ind(j); %select j-th condition
        y_position_this_trial = condition(condition_num).y_position;
        sweep_gain_this_trial = condition(condition_num).sweep_gain; % remember, different grating widths stored in Y positions
        sweep_gain_code_this_trial = condition(condition_num).sweep_gain_code;
        % print status:
        fprintf(['block ', num2str(i),' of ',num2str(NUM_REPEATS), ', num cond left = ' jout ', y = ',num2str(y_position_this_trial), ', sweep gain = ', num2str(sweep_gain_this_trial), '\n']);
        Panel_com('set_position',[47, 1]);
        Panel_com('set_mode', [1, Y_MODE]);
        Panel_com('send_gain_bias',[-15,0,0,0])
        Panel_com('start');
        pause(BETWEEN_TRIAL_TIME_SEC)
        Panel_com('stop');
        
        Panel_com('send_gain_bias',[sweep_gain_this_trial,0,0,0])
        Panel_com('set_mode', [X_MODE_OPEN, Y_MODE]);
        Panel_com('set_position',[X_START_POS, y_position_this_trial]);
        putsample(AO, [sweep_gain_code_this_trial 0]);
        Panel_com('start');
        pause(TRIAL_TIME_SEC)
        Panel_com('stop');
        putsample(AO, [0 0]);
    end
end

Panel_com('set_position',[47, 1]);
Panel_com('set_mode', [1, 0]);
Panel_com('send_gain_bias',[-15,0,0,0])
Panel_com('start');