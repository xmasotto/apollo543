function [X] = getFeatures(im, dem, featurelist)
  features = computeFeatures(im, dem, 18, 16, 2);
  features = smoothFeature(features, 'maxAngle', 2);

  n = numel(dem);
  X = zeros(n, 0);

  if includefeature('maxAngle', featurelist)
	X(:,end+1) = reshape(features.('maxAngle'), [n 1]);
  end

  if includefeature('maxOverlap', featurelist)
	X(:,end+1) = reshape(features.('maxOverlap'), [n 1]);
  end

  if includefeature('maxOverlap2', featurelist)
	X(:,end+1) = reshape(features.('maxOverlap2'), [n 1]);
  end

  for i = 0:5
	if includefeature(sprintf('surf%d', i), featurelist)
	  X(:,end+1) = reshape(features.(sprintf('surf%d', i)), [n 1]);
	end
  end

  if includefeature('roughness', featurelist)
	X(:,end+1) = reshape(features.('roughness'), [n 1]);
  end

  if includefeature('pad_roughness', featurelist)
	X(:,end+1) = reshape(features.('pad_roughness'), [n 1]);
  end
end

function [res] = includefeature(name, featurelist)
  res = isempty(featurelist) || ismember(name, featurelist);
end
