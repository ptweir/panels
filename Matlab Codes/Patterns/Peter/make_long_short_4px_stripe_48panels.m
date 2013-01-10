% make_long_short_4px_stripe_48panels

pattern.x_num = 96; % There are 96 pixel around the display (12x8)
pattern.y_num = 17; % frames of Y, number of different stripe heights
pattern.num_panels = 48; % This is the number of unique Panel IDs required.
pattern.gs_val = 1; % This pattern will use 2 intensity levels
pattern.row_compression = 0;

STRIPEWIDTH = 4;
Pats = ones(32, 96, pattern.x_num, pattern.y_num);
InitPat = [ones(32,96 - STRIPEWIDTH) zeros(32,STRIPEWIDTH)];
Pats(:,:,1,1) = InitPat;
for j = 2:96
    Pats(:,:,j,1) = ShiftMatrix(Pats(:,:,j-1,1),1,'r','y');
end
for y = 2:pattern.y_num
    IP = InitPat;
    IP(1:y-1,:) = 1;
    IP(end-y+2:end,:) = 1;
    Pats(:,:,1,y) = IP;
    for j = 2:96
        Pats(:,:,j,y) = ShiftMatrix(Pats(:,:,j-1,y),1,'r','y');
    end
end

pattern.Pats = Pats;

pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
str = [directory_name '\Pattern_long_short_4px_stripe_48panels'];
save(str, 'pattern');
