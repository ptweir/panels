% make_8px_expanding_stripe_48_gs4_eq.m
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
NUM_GS_BITS = 4; % number of greenscale bits to use
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

%background = repmat([floor(maxGSValue/2),ceil(maxGSValue/2);ceil(maxGSValue/2),floor(maxGSValue/2)],[NUM_VERT_PIX/2,NUM_HORIZ_PIX/2]);
%background = ones(NUM_VERT_PIX, NUM_HORIZ_PIX)*floor(maxGSValue/2);
background = (rand(NUM_VERT_PIX, NUM_HORIZ_PIX)>.6)+floor(maxGSValue/2);

%% make stripe
NUM_PIX_TO_EXPAND = 16;
numSubSteps = round(numGSValues/2);
numExpansionSteps = NUM_PIX_TO_EXPAND*numSubSteps+1;

PatsWithInvisibleColumn = ones(NUM_VERT_PIX, 104, 104,numExpansionSteps);
PatsWithInvisibleColumn(:, 45:52, 1, 1) = 0; % dark stripe in center
for i = 2:104
    PatsWithInvisibleColumn(:,:,i,1) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,1),1,'r','y');
end

for pixStep = 1:NUM_PIX_TO_EXPAND
    for subStep = 1:numSubSteps
        j = (pixStep-1)*numSubSteps+subStep+1;
        PatsWithInvisibleColumn(:, 45-pixStep:52+pixStep, 1, j) = max(PatsWithInvisibleColumn(:, 45-pixStep:52+pixStep, 1, j-1)-1/numSubSteps,0);
        for i = 2:104
            PatsWithInvisibleColumn(:,:,i,j) = ShiftMatrix(PatsWithInvisibleColumn(:,:,i-1,j),1,'r','y');
        end
    end
end
%PatsWithInvisibleColumn = round(PatsWithInvisibleColumn*maxGSValue)/maxGSValue;
%PatsWithInvisibleColumn = round(PatsWithInvisibleColumn); %FIX

stripePat = zeros(NUM_VERT_PIX,NUM_HORIZ_PIX,104,numExpansionSteps);
randInds = randperm(NUM_VERT_PIX*NUM_HORIZ_PIX);
for j = 1:numExpansionSteps
    fprintf([num2str(j),' of numExpansionSteps\n'])
    for i = 1:104
        ind = 0;
        stripePatThisX = round(PatsWithInvisibleColumn(:,1:NUM_HORIZ_PIX,i,j).*background);
        %stripePatThisX = PatsWithInvisibleColumn(:,1:NUM_HORIZ_PIX,i,j).*background;
        while sum(stripePatThisX(:)) < NUM_HORIZ_PIX*NUM_VERT_PIX*maxGSValue/2
            ind = ind + 1;
            if ind > length(randInds)
                randInd = randInds(mod(ind-1,length(randInds))+1);
                if stripePatThisX(randInd) >= ceil(maxGSValue/2)
                    stripePatThisX(randInd) = stripePatThisX(randInd)+1;
                    if stripePatThisX(randInd) > maxGSValue
                        error('background too bright')
                    end
                end
            else
                randInd = randInds(ind);
                if stripePatThisX(randInd) == floor(maxGSValue/2)
                    stripePatThisX(randInd) = ceil(maxGSValue/2);
                end
            end
        end
        stripePat(:,:,i,j) = stripePatThisX;
    end
end
%% put all together
%allPats = repmat([floor(maxGSValue/2),ceil(maxGSValue/2);ceil(maxGSValue/2),floor(maxGSValue/2)],[NUM_VERT_PIX/2,NUM_HORIZ_PIX/2,121,3]);
allPats = stripePat;

%% put in language of panels
pattern.x_num = 104;
pattern.y_num = numExpansionSteps; 		% 3 Y positions
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

str = [directory_name '\Pattern_8px_expanding_stripe_48_gs4_eq'];
save(str, 'pattern');

%% test to make sure all x values are equiluminant
patternShape = size(allPats);
if patternShape(3) ~= pattern.x_num
    fprintf('incorrect pattern.x_num\n')
end
if patternShape(4) ~= pattern.y_num
    fprintf('incorrect pattern.x_num\n')
end
for x = 1:pattern.x_num
    for y = 1:pattern.y_num
        if sum(sum(allPats(:,:,x,y))) ~= NUM_HORIZ_PIX*NUM_VERT_PIX*maxGSValue/2
            fprintf(['problem in x = ', num2str(x), ', y = ', num2str(y), '\n'])
        end
        %fprintf(['x = ', num2str(x), ', y = ', num2str(y), ', sum = ', num2str(sum(sum(allPats(:,:,x,y)))), '\n'])
    end
end

