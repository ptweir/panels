PATTERN_ID = 1;

OPEN_MODE = 0;
CLOSED_MODE = 1;
CLOSED_LOOP_GAIN_X = -15;

IN_FRONT_X_POS = 1; % directly in front of fly
ONE_STRIPE_Y_POS = 1; % 1 stripe
TWO_STRIPE_Y_POS = 3; % 2 stripes

PANEL_COM_PAUSE = .05;
Panel_com('set_pattern_id', PATTERN_ID); pause(PANEL_COM_PAUSE);
Panel_com('stop'); pause(PANEL_COM_PAUSE);

Panel_com('set_position',[IN_FRONT_X_POS, ONE_STRIPE_Y_POS]); pause(PANEL_COM_PAUSE);
Panel_com('set_mode', [CLOSED_MODE, OPEN_MODE]); pause(PANEL_COM_PAUSE);
Panel_com('send_gain_bias',[CLOSED_LOOP_GAIN_X,0,0,0]); pause(PANEL_COM_PAUSE);
Panel_com('start'); pause(PANEL_COM_PAUSE);