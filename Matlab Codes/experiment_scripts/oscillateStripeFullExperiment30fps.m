STRIPE_PATTERN_ID = 1;
FUNC_ID = 1;

X_MODE_FUNC = 4;
Y_MODE_FUNCDEBUG = 5;
FUNC_UPDATE_FREQ = 300;

X_START_POS = 1;
Y_POS = 1;

Panel_com('stop');
Panel_com('set_pattern_id', STRIPE_PATTERN_ID);
Panel_com('set_mode', [X_MODE_FUNC, Y_MODE_FUNCDEBUG]);
Panel_com('set_posfunc_id',[FUNC_ID, FUNC_ID]);
Panel_com('set_funcx_freq', FUNC_UPDATE_FREQ);
Panel_com('set_funcy_freq', FUNC_UPDATE_FREQ);
Panel_com('set_position',[X_START_POS, Y_POS]);
Panel_com('start');

reply = 'N';

while reply ~= 'Y'
    reply = input('Stop panels? Y/N [N]: ', 's');
    if isempty(reply)
        reply = 'N';
    end
end

Panel_com('stop');
Panel_com('all_off');
