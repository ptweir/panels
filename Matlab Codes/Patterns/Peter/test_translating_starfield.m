%figure
for frameInd = 1:numFrames
    imshow(kron(allPats(:,:,frameInd,5),ones(10,10)))
    drawnow
end