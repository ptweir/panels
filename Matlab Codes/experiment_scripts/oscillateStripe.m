EXPERIMENT_DURATION_SEC = 3*60;
TRIAL_DURATION_SEC = 6;
ALL_ON_DURATION_SEC = 3;
STRIPE_PATTERN_ID = 1;

X_MODE_FUNC = 4;
Y_MODE_FUNCDEBUG = 5;

FUNC_UPDATE_FREQ = 200;

X_START_POS_RIGHT = 65;
X_START_POS_LEFT = 25;

Y_POS = 9;

ALL_ON_POS = [1, 1];

FUNC_ID = 1;

Panel_com('stop');
Panel_com('set_pattern_id', STRIPE_PATTERN_ID);
Panel_com('set_mode', [X_MODE_FUNC, Y_MODE_FUNCDEBUG]);
Panel_com('set_posfunc_id',[FUNC_ID, FUNC_ID]);
Panel_com('set_funcx_freq', FUNC_UPDATE_FREQ);
Panel_com('set_funcy_freq', FUNC_UPDATE_FREQ);
Panel_com('set_position',ALL_ON_POS)
Panel_com('set_position',[X_START_POS_RIGHT, Y_POS]);
Panel_com('start');

startTime = now;

while now < startTime + EXPERIMENT_DURATION_SEC
    Panel_com('set_position',[X_START_POS_RIGHT, Y_POS]);
    pause(TRIAL_DURATION_SEC);
    Panel_com('set_position',ALL_ON_POS)
    pause(ALL_ON_DURATION_SEC)
    
    Panel_com('set_position',[X_START_POS_LEFT, Y_POS]);
    pause(TRIAL_DURATION_SEC)
    Panel_com('set_position',ALL_ON_POS)
    pause(ALL_ON_DURATION_SEC)
end
    