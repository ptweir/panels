% make_test.m

pattern.x_num = 104; 	% There are 96 pixel around the display (12x8) plus 8px-wide stripe invisible region for wrapping
pattern.y_num = 1; 		% only one Y position
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 4; 	% This pattern will use 2 intensity levels
pattern.row_compression = 0;

PatsWithInvisibleColumn = 15*ones(32, 104, pattern.x_num, pattern.y_num);


PatsWithInvisibleColumn(:, 45:52, 1, 1) = 0;
for i = 2:104
    PatsWithInvisibleColumn(:,:,i,1) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,1),1,'r','y');
end

pattern.Pats = PatsWithInvisibleColumn(:,1:96,:,:);
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_test'];
save(str, 'pattern');
