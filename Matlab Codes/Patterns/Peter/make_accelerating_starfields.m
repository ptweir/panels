% make_accelerating_starfields.m
% 6/4/2013 based on make_many_starfields.m
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
% constant speed:
XVELOCITY_METERSPERSEC = 1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
CONSTANTMOTIONDURATION_SEC = 2;
% constant acceleration:
XACCELERATION_METERSPERSECSQRD = 0.5;
YACCELERATION_METERSPERSECSQRD = 0;
ZACCELERATION_METERSPERSECSQRD = 0;
CONSTANTACCELERATIONDURATION_SEC = 2;

TIMEBUFFER_SEC = 0.1;
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
acceleration_metersPerSecSqrd = sqrt(XACCELERATION_METERSPERSECSQRD^2 + YACCELERATION_METERSPERSECSQRD^2 + ZACCELERATION_METERSPERSECSQRD^2);
maxDist_meters = MAXSENSORYRADIUS_METERS + (CONSTANTMOTIONDURATION_SEC + CONSTANTACCELERATIONDURATION_SEC + TIMEBUFFER_SEC)*speed_metersPerSec + 0.5*acceleration_metersPerSecSqrd*(CONSTANTACCELERATIONDURATION_SEC+TIMEBUFFER_SEC)^2;
numPoints = round(DENSITYOFPOINTS_PERCUBICMETER*(2*maxDist_meters)^3);
xyz_meters = (rand(numPoints,3)*2 - 1)*maxDist_meters;

%% Calculate frames

t_sec = [0:1/FRAMERATE_FRAMESPERSEC:CONSTANTMOTIONDURATION_SEC+CONSTANTACCELERATIONDURATION_SEC+TIMEBUFFER_SEC];
numFrames = length(t_sec);

allPats = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames, 5);
allxyzLocations = zeros(numFrames,3,5);

frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    if tThisFrame_sec <= CONSTANTMOTIONDURATION_SEC
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    else
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec + 0.5*[XACCELERATION_METERSPERSECSQRD,YACCELERATION_METERSPERSECSQRD,ZACCELERATION_METERSPERSECSQRD]*(tThisFrame_sec-CONSTANTMOTIONDURATION_SEC)^2;
    end
    allxyzLocations(frameInd,:,2) = xyzFlyLocation_meters;
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*xyzFlyLocation_meters;
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
    %imshow(frames(:,:,frameInd))
    %drawnow
    disp(['t = ',  num2str(tThisFrame_sec), '; xyz = ',  num2str(xyzFlyLocation_meters)])
end

allPats(:,:,:,2) = frames;

%%
% constant speed:
XVELOCITY_METERSPERSEC = 1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
% constant acceleration:
XACCELERATION_METERSPERSECSQRD = -0.5;
YACCELERATION_METERSPERSECSQRD = 0;
ZACCELERATION_METERSPERSECSQRD = 0;

frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    if tThisFrame_sec <= CONSTANTMOTIONDURATION_SEC
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    else
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec + 0.5*[XACCELERATION_METERSPERSECSQRD,YACCELERATION_METERSPERSECSQRD,ZACCELERATION_METERSPERSECSQRD]*(tThisFrame_sec-CONSTANTMOTIONDURATION_SEC)^2;
    end
    allxyzLocations(frameInd,:,3) = xyzFlyLocation_meters;
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*xyzFlyLocation_meters;
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
    %imshow(frames(:,:,frameInd))
    %drawnow
    disp(['t = ',  num2str(tThisFrame_sec), '; xyz = ',  num2str(xyzFlyLocation_meters)])
end

allPats(:,:,:,3) = frames;
%%
% constant speed:
XVELOCITY_METERSPERSEC = -1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
% constant acceleration:
XACCELERATION_METERSPERSECSQRD = 0.5;
YACCELERATION_METERSPERSECSQRD = 0;
ZACCELERATION_METERSPERSECSQRD = 0;

frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    if tThisFrame_sec <= CONSTANTMOTIONDURATION_SEC
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    else
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec + 0.5*[XACCELERATION_METERSPERSECSQRD,YACCELERATION_METERSPERSECSQRD,ZACCELERATION_METERSPERSECSQRD]*(tThisFrame_sec-CONSTANTMOTIONDURATION_SEC)^2;
    end
    allxyzLocations(frameInd,:,4) = xyzFlyLocation_meters;
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*xyzFlyLocation_meters;
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
    %imshow(frames(:,:,frameInd))
    %drawnow
    disp(['t = ',  num2str(tThisFrame_sec), '; xyz = ',  num2str(xyzFlyLocation_meters)])
end

allPats(:,:,:,4) = frames;
%%
% constant speed:
XVELOCITY_METERSPERSEC = -1;
YVELOCITY_METERSPERSEC = 0;
ZVELOCITY_METERSPERSEC = 0;
% constant acceleration:
XACCELERATION_METERSPERSECSQRD = -0.5;
YACCELERATION_METERSPERSECSQRD = 0;
ZACCELERATION_METERSPERSECSQRD = 0;

frames = zeros(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    if tThisFrame_sec <= CONSTANTMOTIONDURATION_SEC
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec;
    else
        xyzFlyLocation_meters = [XVELOCITY_METERSPERSEC,YVELOCITY_METERSPERSEC,ZVELOCITY_METERSPERSEC]*tThisFrame_sec + 0.5*[XACCELERATION_METERSPERSECSQRD,YACCELERATION_METERSPERSECSQRD,ZACCELERATION_METERSPERSECSQRD]*(tThisFrame_sec-CONSTANTMOTIONDURATION_SEC)^2;
    end
    allxyzLocations(frameInd,:,5) = xyzFlyLocation_meters;
    xyzThisFrame_meters = xyz_meters - ones(numPoints,1)*xyzFlyLocation_meters;
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
    %imshow(frames(:,:,frameInd))
    %drawnow
    disp(['t = ',  num2str(tThisFrame_sec), '; xyz = ',  num2str(xyzFlyLocation_meters)])
end

allPats(:,:,:,5) = frames;

allPats(:,:,1,1) = allPats(:,:,1,5);
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

str = [directory_name '\Pattern_accelerating_starfields'];
save(str, 'pattern');



