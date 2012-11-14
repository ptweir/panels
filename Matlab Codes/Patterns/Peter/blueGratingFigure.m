WAVELENGTH_PIXELS = 8; % spatial wavelength of pattern in pixels
k = 2*pi/WAVELENGTH_PIXELS; % wave number

NUM_GS_BITS = 4; % number of greenscale bits to use
numGSValues = 2^NUM_GS_BITS;
maxGSValue = numGSValues-1;

numTimes = WAVELENGTH_PIXELS*(numGSValues-1);
frequency = 1/numTimes;
omega = 2*pi*frequency;

%omega = 2*pi/(WAVELENGTH_PIXELS*(numGSValues-1))
%k = 2*pi/WAVELENGTH_PIXELS;

numVerticalPixels = 32;
numHorizontalPixels = 96;

X = [0:numHorizontalPixels];
TIMES = [1:numTimes]-1;

Pats = ones(numVerticalPixels, numHorizontalPixels, numTimes, 1);

for tInd = 1:length(TIMES)
    t = TIMES(tInd);
    for xInd = 1:(length(X)-1)
        x0 = X(xInd);
        x1 = X(xInd+1);
        Pats(:,xInd,tInd,1) = ones(numVerticalPixels,1)*round(maxGSValue*(cos(omega*t - k*x1)/k - cos(omega*t - k*x0)/k + x1 - x0)/2);
        % these values come by integrating a sinusoid of range 0 to
        % maxGSValue over each pixel's domain, [x0,x1].
    end
end

blueGrating = zeros(numVerticalPixels,96,3);
blueGrating(:,:,3) = Pats(:,:,31,1)/15;
figure

imagesc(blueGrating)
axis image
set(gca,'XTick',[8.5 16.5])
set(gca,'YTick',[])
%axis off