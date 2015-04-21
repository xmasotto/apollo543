function [safetyImage] = predictSafety(tree, dem)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here


X = getFeatures(dem);

safetyImage = predict(tree, X);
safetyImage = reshape(safetyImage, size(dem));
safetyImage = medfilt2(safetyImage, [3, 3]);

r = 21;
safetyImage(1:r,:) = 0;
safetyImage(end-r+1:end,:) = 0;
safetyImage(:,1:r) = 0;
safetyImage(:,end-r+1:end) = 0;
end

