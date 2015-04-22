function [X] = getFeatures(dem)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

features = computeFeatures(dem, 18, 16, 2);
features = smoothFeature(features, 'maxAngle', 2);

n = numel(dem);
X = zeros(n, 0);

winsize = 1;
for y = -winsize:winsize
    for x = -winsize:winsize
        X(:,end+1) = reshape(imtranslate(features.('maxAngle'), [y, x]), [n 1]);
        X(:,end+1) = reshape(imtranslate(features.('maxOverlap'), [y, x]), [n 1]);
    end
end

heightFeatures = getHeightFeatures(dem);
X = [X heightFeatures];

end

