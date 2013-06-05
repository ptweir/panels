% make_8px_one_two_stripes_48_BettinaRig.m
% 2/15/2013
% based on make_8px_multi_stripes_48_gs4_eq.m
% 12/4/2012
% based on make_8px_expanding_stripe_48_gs4_eq.m
% 11/14/2012 
% based on make_8px_spinning_stripe_48_gs4_eq.m
% 10/15/2012 
% based on make_8px_stripe_blob_grating_48_gs4_eq.m
% based on make_8px_stripe_blob_grating_48_gs3_eq.m
% PTW 8/29/2012
% changed so that all positions are same total luminance
% hacked version to deal with only 3 gs bits: beware anywhere '104', 'numTimes', '112', or '120' is written

NUM_VERT_PIX = 32;
NUM_HORIZ_PIX = 96;
NUM_GS_BITS = 1; % number of greenscale bits to use
NUM_Y_POS = 2; % 1 stripe, 2 stripes moving opposite directions
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

%% make single stripe

PatsWithInvisibleColumn = ones(NUM_VERT_PIX, 104, 104,NUM_Y_POS);
PatsWithInvisibleColumn(:, 41:48, 1, 1) = 0; % dark stripe in center -- note offset due to Bettina's rig position
for i = 2:104
    PatsWithInvisibleColumn(:,:,i,1) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,1),1,'r','y');
end

%% make two stripes moving opposite directions
PatsWithInvisibleColumn(:, 41:48, 1, 2) = 0; % dark stripe in center
Pstripe1 = PatsWithInvisibleColumn(:, :, :, 2);
Pstripe2 = PatsWithInvisibleColumn(:, :, :, 2);
for i = 2:104
    Pstripe1(:,:,i) = ShiftMatrix(Pstripe1(:,:,i-1),1,'r','y');
    Pstripe2(:,:,i) = ShiftMatrix(Pstripe2(:,:,i-1),1,'l','y');
    PatsWithInvisibleColumn(:,:,i,2) = Pstripe1(:,:,i).*Pstripe2(:,:,i);
end

%% put all together
allPats = PatsWithInvisibleColumn(:,1:NUM_HORIZ_PIX,:,:);

%% put in language of panels
pattern.x_num = 104;
pattern.y_num = NUM_Y_POS; 		% 3 Y positions
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.row_compression = 0;
pattern.gs_val = NUM_GS_BITS;
pattern.Pats = allPats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
%%
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_8px_one_two_stripes_48_BettinaRig'];
save(str, 'pattern');

