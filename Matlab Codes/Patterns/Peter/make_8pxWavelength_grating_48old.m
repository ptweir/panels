% make_8pxWavelength_grating_48.m
%% construct pattern

WAVELENGTH_PIXELS = 8; % spatial wavelength of pattern in pixels
k = 2*pi/WAVELENGTH_PIXELS; % wave number

NUM_GS_BITS = 2; % number of greenscale bits to use
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

numTimes = WAVELENGTH_PIXELS*(numGSValues-1);
frequency = 1/numTimes;
omega = 2*pi*frequency;

%omega = 2*pi/(WAVELENGTH_PIXELS*(numGSValues-1))
%k = 2*pi/WAVELENGTH_PIXELS;

numVerticalPixels = 4;
numHorizontalPixels = 96;

X = [1:numHorizontalPixels]-.5;
TIMES = [1:numTimes]-1;

Pats = ones(numVerticalPixels, numHorizontalPixels, numTimes, 1);
TruePats = ones(numVerticalPixels, numHorizontalPixels, numTimes, 1);
for tInd = 1:length(TIMES)
    t = TIMES(tInd);
    Pats(:,:,tInd,1) = ones(numVerticalPixels,1)*round(maxGSValue*(sin(omega*t - k*X) + 1)/2);
    TruePats(:,:,tInd,1) = ones(numVerticalPixels,1)*maxGSValue*(sin(omega*t - k*X) + 1)/2;
end

%% put in language of panels
pattern.x_num = numTimes;
pattern.y_num = 1; 		% only one Y position
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.row_compression = 1;
pattern.gs_val = NUM_GS_BITS; 

pattern.Pats = Pats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_8pxWavelength_grating_48'];
save(str, 'pattern');
