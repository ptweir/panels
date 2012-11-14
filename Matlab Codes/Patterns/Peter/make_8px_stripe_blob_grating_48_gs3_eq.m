% make_8px_stripe_blob_grating_48_gs3_eq.m
% PTW 8/20/2012
% changed so that all positions are same total luminance
% hacked version to deal with only 3 gs bits: beware anywhere '104', 'numTimes', '112', or '120' is written

NUM_VERT_PIX = 32;
NUM_HORIZ_PIX = 96;
NUM_GS_BITS = 3; % number of greenscale bits to use
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

background = repmat([floor(maxGSValue/2),ceil(maxGSValue/2);ceil(maxGSValue/2),floor(maxGSValue/2)],[NUM_VERT_PIX/2,NUM_HORIZ_PIX/2]);
PatsWithInvisibleColumn = ones(32, 104, 104,2);

%% make stripe
PatsWithInvisibleColumn(:, 45:52, 1, 1) = 0;
for i = 2:104
    PatsWithInvisibleColumn(:,:,i,1) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,1),1,'r','y');
end
stripePat = zeros(NUM_VERT_PIX,NUM_HORIZ_PIX,104);
randInds = randperm(NUM_VERT_PIX*NUM_HORIZ_PIX);
for i = 1:104
    stripePatThisX = PatsWithInvisibleColumn(:,1:NUM_HORIZ_PIX,i,1).*background;
    for randInd = randInds
        if sum(stripePatThisX(:)) == NUM_HORIZ_PIX*NUM_VERT_PIX*maxGSValue/2
            break
        elseif stripePatThisX(randInd) == floor(maxGSValue/2)
            stripePatThisX(randInd) = ceil(maxGSValue/2);
        end
    end
    stripePat(:,:,i) = stripePatThisX;
end
%% make blob
PatsWithInvisibleColumn(13:20, 45:52, 1, 2) = 0;
for i = 2:104
    PatsWithInvisibleColumn(:,:,i,2) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,2),1,'r','y');
end
blobPat = zeros(NUM_VERT_PIX,NUM_HORIZ_PIX,104);
for i = 1:104
    blobPatThisX = PatsWithInvisibleColumn(:,1:NUM_HORIZ_PIX,i,2).*background;
    for randInd = randInds
        if sum(blobPatThisX(:)) == NUM_HORIZ_PIX*NUM_VERT_PIX*maxGSValue/2
            break
        elseif blobPatThisX(randInd) == floor(maxGSValue/2)
            blobPatThisX(randInd) = ceil(maxGSValue/2);
        end
    end
    blobPat(:,:,i) = blobPatThisX;
end
%% make grating
WAVELENGTH_PIXELS = 8; % spatial wavelength of pattern in pixels
k = 2*pi/WAVELENGTH_PIXELS; % wave number

numTimes = WAVELENGTH_PIXELS*(numGSValues-1);
frequency = 1/numTimes;
omega = 2*pi*frequency;

X = [0:NUM_HORIZ_PIX];
TIMES = [1:numTimes]-1;

gratingPat = ones(NUM_VERT_PIX, NUM_HORIZ_PIX, numTimes, 1);

for tInd = 1:length(TIMES)
    t = TIMES(tInd);
    for xInd = 1:(length(X)-1)
        x0 = X(xInd)-90;
        x1 = X(xInd+1)-90;
        gratingPat(:,xInd,tInd,1) = ones(NUM_VERT_PIX,1)*round(maxGSValue*(cos(omega*t - k*x1)/k - cos(omega*t - k*x0)/k + x1 - x0)/2);
        % these values come by integrating a sinusoid of range 0 to
        % maxGSValue over each pixel's domain, [x0,x1].
    end
end

%% put all together
allPats = repmat([floor(maxGSValue/2),ceil(maxGSValue/2);ceil(maxGSValue/2),floor(maxGSValue/2)],[NUM_VERT_PIX/2,NUM_HORIZ_PIX/2,104,3]);
%allPats = maxGSValue*ones(NUM_VERT_PIX, NUM_HORIZ_PIX, 104, 3);
allPats(:,:,:,1) = stripePat;
allPats(:,:,:,2) = blobPat;
allPats(:,:,1:numTimes,3) = gratingPat;

%% put in language of panels
pattern.x_num = 104;
pattern.y_num = 3; 		% 3 Y positions
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.row_compression = 0;
pattern.gs_val = NUM_GS_BITS; 
pattern.Pats = allPats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_8px_stripe_blob_grating_48_gs3_eq'];
save(str, 'pattern');
