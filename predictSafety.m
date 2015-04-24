function [safetyImage, score] = predictSafety(tree, im, dem, featurelist)
%UNTITLED8 Summary of this function goes here
%   Detailed explanation goes here

  if nargin < 4
	featurelist = [];
  end

  X = getFeatures(im, dem, featurelist);

[safetyImage, scores] = predict(tree, X);
safetyImage = reshape(safetyImage, size(dem));
safetyImage = medfilt2(safetyImage, [3, 3]);
score = reshape(scores(:, 2), size(dem));

r = 21;
safetyImage(1:r,:) = 0;
safetyImage(end-r+1:end,:) = 0;
safetyImage(:,1:r) = 0;
safetyImage(:,end-r+1:end) = 0;
end
