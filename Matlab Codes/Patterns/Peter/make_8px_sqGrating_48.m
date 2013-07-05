% make_8px_sqGrating_48.m
% 7/5/2013 based on make_8px_xyBlob_48.m
% 6/25/2013 based on make_8px_stripe_blob_grating_48_gs4_eq.m
% based on make_8px_stripe_blob_grating_48_gs3_eq.m
% PTW 8/29/2012

NUM_VERT_PIX = 32;
NUM_HORIZ_PIX = 96;
NUM_GS_BITS = 1; % number of greenscale bits to use
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

%% make grating
background = repmat([floor(maxGSValue/2),ceil(maxGSValue/2);ceil(maxGSValue/2),floor(maxGSValue/2)],[NUM_VERT_PIX/2,NUM_HORIZ_PIX/2]);
stripePat = ones(32,96);
stripePat(:,1:8) = 0;

pats = zeros(32, 96, 96, 2);

pats(:,:,1,1) = background.*stripePat;

pats(:,ceil((mod([0:8*12-1],16)+1)/8)-1==1,1,2) = 1;
for i = 2:96
    stripePatShifted = ShiftMatrix(stripePat,i-1,'r','y');
    pats(:,:,i,1) = background.*stripePatShifted;
    pats(:,:,i,2) = ShiftMatrix(pats(:,:,i-1,2),1,'r','y');
end

%% put in language of panels
pattern.x_num = 96;
pattern.y_num = 2; 		% 3 Y positions
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.row_compression = 0;
pattern.gs_val = NUM_GS_BITS;
pattern.Pats = pats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_8px_sqGrating_48'];
save(str, 'pattern');

