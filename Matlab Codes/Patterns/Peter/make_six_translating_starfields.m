% make_six_translating_starfields.m
% 6/18/2013 based on make_many_starfields.m
% based on make_starfield.m
% based on make_translating_starfield.m
% PTW 5/30/2013
% NOTES: could make more efficient by fixing some for loops
%       could make the starfield repeat by concatenating xyz coordinates
%       with translated ones...

%% Define constants
% universe of points:
DENSITYOFPOINTS_PERCUBICMETER = 20;
MAXSENSORYRADIUS_METERS = 2.0;
% motion:
XVELOCITY_METERSPERSEC = 1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
MOTIONDURATION_SEC = 9;
FRAMERATE_FRAMESPERSEC = 40.0;
% arena:
ARENA_DEGPERPIX = 2.25;
NUMVERTPIX = 32;
ARENAINCLINATIONCENTER_PIX = 16.5;
NUMHORIZPIX = 96;
ARENAAZIMUTHCENTER_PIX = 48.5;
% constants:
DEGPERRAD = 180/pi;

%% Calculate arena coordinates
arenaCircumference_pix = 360.0/ARENA_DEGPERPIX;
arenaRadius_pix = arenaCircumference_pix/(2*pi);

arenaAzimuthCoordinates_deg = ([1:NUMHORIZPIX] - ARENAAZIMUTHCENTER_PIX)*ARENA_DEGPERPIX;
arenaAzimuthCoordinates_rad = arenaAzimuthCoordinates_deg/DEGPERRAD;
arenaInclinationCoordinates_rad = pi/2 - atan(([1:NUMVERTPIX] - ARENAINCLINATIONCENTER_PIX)/arenaRadius_pix);

%% Populate space with uniformly randomly distributed points
speed_metersPerSec = sqrt(XVELOCITY_METERSPERSEC^2 + YVELOCITY_METERSPERSEC^2 + ZVELOCITY_METERSPERSEC^2);
maxDistMeters = MAXSENSORYRADIUS_METERS + MOTIONDURATION_SEC*speed_metersPerSec;
numPoints = round(DENSITYOFPOINTS_PERCUBICMETER*(2*maxDistMeters)^3);
xyz_meters = (rand(numPoints,3)*2 - 1)*maxDistMeters;

%% Calculate frames

t_sec = [0:1/FRAMERATE_FRAMESPERSEC:MOTIONDURATION_SEC];
numFrames = length(t_sec);

allPats = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames, 7);

frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,2) = frames;
%%
XVELOCITY_METERSPERSEC = -1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,3) = frames;
%%
XVELOCITY_METERSPERSEC = 0;
YVELOCITY_METERSPERSEC = 1;
ZVELOCITY_METERSPERSEC = 0;
frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,4) = frames;
%%
XVELOCITY_METERSPERSEC = 0;
YVELOCITY_METERSPERSEC = -1;
ZVELOCITY_METERSPERSEC = 0;
frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,5) = frames;
%%
XVELOCITY_METERSPERSEC = 0;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 1;
frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,6) = frames;
%%
XVELOCITY_METERSPERSEC = 0;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = -1;
frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*[XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:numPoints
        distanceThisPoint_meters = distanceThisFrame_meters(pointIndex);
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInSensoryRange = (distanceThisPoint_meters <= MAXSENSORYRADIUS_METERS);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInSensoryRange & isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 1;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end

allPats(:,:,:,7) = frames;
%%
allPats(:,:,1,1) = allPats(:,:,1,7);
%% put in language of panels


pattern.x_num = numFrames;
pattern.y_num = size(allPats,4);
pattern.num_panels = 48; 	% This is the number of unique Panel IDs required.
pattern.row_compression = 0;
pattern.gs_val = 1;
pattern.Pats = allPats;
pattern.Panel_map = [12 8 4 11 7 3 10 6 2  9 5 1; 24 20 16 23 19 15 22 18 14 21 17 13; 36 32 28 35 31 27 34 30 26 33 29 25; 48 44 40 47 43 39 46 42 38 45 41 37];

thisFullFileName =  mfilename('fullpath');
[directory_name,thisFileName,thisFileExtension] = fileparts(thisFullFileName);
%directory_name = 'C:\Users\nebulosa\Documents\panels\Matlab Codes\Patterns\Peter';
%%
pattern.BitMapIndex = process_panel_map(pattern);
pattern.data = Make_pattern_vector(pattern);

str = [directory_name '\Pattern_six_translating_starfields'];
save(str, 'pattern');



