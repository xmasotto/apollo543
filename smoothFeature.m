function [features] = smoothFeature(features, name, sigma)
  if sigma > 0
	data = features.(name);
	features.(name) = imfilter(data, fspecial('gaussian', 10*sigma+1, sigma));
  end
end
