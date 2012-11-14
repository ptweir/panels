PATTERN_ID = 1;
XFUNC_ID = 1;
YFUNC_ID = 2;

X_MODE_FUNC = 4;
Y_MODE_FUNC = 4;
FUNC_UPDATE_FREQ = 100;

X_START_POS = 1;
Y_POS = 1;

%Panel_com('quiet_mode_off')

Panel_com('stop');
Panel_com('set_pattern_id', PATTERN_ID);
Panel_com('set_mode', [X_MODE_FUNC, Y_MODE_FUNC]);
Panel_com('set_posfunc_id',[1, XFUNC_ID]); % 1 for x pattern
Panel_com('set_posfunc_id',[2, YFUNC_ID]); % 2 for y pattern
Panel_com('set_funcx_freq', FUNC_UPDATE_FREQ);
Panel_com('set_funcy_freq', FUNC_UPDATE_FREQ);
Panel_com('set_position',[X_START_POS, Y_POS]);
Panel_com('start');

fprintf('to stop and turn off panels, press ENTER>')
pause

Panel_com('stop');
Panel_com('all_off');
