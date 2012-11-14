numVerticalPixels = 32;
numHorizontalPixels = 96;

blueStripe = zeros(numVerticalPixels,numHorizontalPixels,3);
blueStripe(:,:,3) = 1;
blueStripe(:,30:37,3) = 0;
figure

imagesc(blueStripe)
axis image
set(gca,'XTick',[8.5 16.5])
set(gca,'YTick',[])
%axis off