% make_single_stripe_48.m

pattern.x_num = 96; 	% There are 96 pixel around the display (12x8)
pattern.y_num = 97; 		% two frames of Y, at 2 different spatial frequencies
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.gs_val = 1; 	% This pattern will use 8 intensity levels
pattern.row_compression = 1;

Pats = ones(4, 96, pattern.x_num, pattern.y_num);

for j = 2:97
    Pats(:, 1:j-1, 1, j) = 0;
    for i = 2:96
        Pats(:,:,i,j) = ShiftMatrix(Pats(:,:,i-1,j),1,'r','y');
    end
end
pattern.Pats = Pats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_single_stripe_48'];
save(str, 'pattern');
