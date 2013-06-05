% make_translating_starfield.m
% PTW 5/30/2013

%% Define constants
% universe of points:
NUMPOINTS = 500.0;
MAXRADIUS_METERS = 10.0;
% motion:
SPEED_METERSPERSEC = 0.5;
MOTIONDURATION_SEC = 4.0;
FRAMERATE_FRAMESPERSEC = 40.0;
% arena:
ARENA_DEGPERPIX = 2.25;
NUMVERTPIX = 32;
ARENAINCLINATIONCENTER_PIX = 16.5;
NUMHORIZPIX = 96;
ARENAAZIMUTHCENTER_PIX = 48.5;
% constants:
DEGPERRAD = 180/pi;

arenaCircumference_pix = 360.0/ARENA_DEGPERPIX;
arenaRadius_pix = arenaCircumference_pix/(2*pi);
%arenaTopFromHoriz_rad = atan(NUMVERTPIX/(2*arenaRadius_pix));

%arenaAzimuthCoordinates_deg = [-NUMHORIZPIX*ARENA_DEGPERPIX/2:ARENA_DEGPERPIX:NUMHORIZPIX*ARENA_DEGPERPIX/2];
arenaAzimuthCoordinates_deg = ([1:NUMHORIZPIX] - ARENAAZIMUTHCENTER_PIX)*ARENA_DEGPERPIX;
arenaAzimuthCoordinates_rad = arenaAzimuthCoordinates_deg/DEGPERRAD;
arenaInclinationCoordinates_rad = pi/2 - atan(([1:NUMVERTPIX] - ARENAINCLINATIONCENTER_PIX)/arenaRadius_pix);
%arenaInclinationCoordinates_deg = arenaInclinationCoordinates_rad*DEGPERRAD;

%% Populate space with uniformly randomly distributed points
xyz_meters = (rand(NUMPOINTS,3)*2 - 1)*MAXRADIUS_METERS;

%% Calculate frames

t_sec = [0:1/FRAMERATE_FRAMESPERSEC:MOTIONDURATION_SEC];
numFrames = length(t_sec);

frames = ones(NUMVERTPIX, NUMHORIZPIX, numFrames);

for frameInd = 1:numFrames
    tThisFrame_sec = t_sec(frameInd);
    xyzThisFrame_meters = xyz_meters - ones(NUMPOINTS,1)*[1,0,0]*SPEED_METERSPERSEC*tThisFrame_sec;
    distanceThisFrame_meters =  sqrt(sum(xyzThisFrame_meters.^2,2));
    inclinationThisFrame_rad = acos(xyzThisFrame_meters(:,3)./distanceThisFrame_meters);
    azimuthThisFrame_rad = atan2(xyzThisFrame_meters(:,2),xyzThisFrame_meters(:,1));
    for pointIndex = 1:NUMPOINTS
        inclinationThisPoint_rad = inclinationThisFrame_rad(pointIndex);
        azimuthThisPoint_rad = azimuthThisFrame_rad(pointIndex);
        isInInclinationRange = ((inclinationThisPoint_rad >= min(arenaInclinationCoordinates_rad)) & (inclinationThisPoint_rad <= max(arenaInclinationCoordinates_rad)));
        isInAzimuthRange = ((azimuthThisPoint_rad >= min(arenaAzimuthCoordinates_rad)) & (azimuthThisPoint_rad <= max(arenaAzimuthCoordinates_rad)));
        if isInInclinationRange & isInAzimuthRange
            [minE, inclinationCoordinate] = min(abs(inclinationThisPoint_rad - arenaInclinationCoordinates_rad));
            [minA, azimuthCoordinate] = min(abs(azimuthThisPoint_rad - arenaAzimuthCoordinates_rad));
            frames(inclinationCoordinate,azimuthCoordinate,frameInd) = 0;
        end
    end
    imshow(frames(:,:,frameInd))
    drawnow
end






