function [features] = computeFeatures(im, dem, radius, numRotations, sigma)
  features.('maxAngle') = zeros(size(dem));
  features.('maxOverlap') = zeros(size(dem));
  features.('maxOverlap2') = zeros(size(dem));
  indOverlap = zeros(size(dem));
  maxTheta = zeros(size(dem));

  [px, py] = getInterestPoints(dem, sigma);

  n = length(px);
  pz = zeros(n, 1);
  for i = 1:n
	pz(i) = dem(py(i), px(i));
  end

  %% use shadow information to estimate peak heights
  [px2, py2, pz2] = getPeakFromShadow(im, dem, px, py);

  disp('computing basic features');

  for i = 1:numRotations
	theta = i * 2 * pi / numRotations;

	[nx, ny, nz, nw, valid] = getTangents(dem, radius, theta);
	angles = acos(nz) * 180 / pi;
	ind = valid & angles > features.('maxAngle');
	features.('maxAngle')(ind) = angles(ind);
	maxTheta(ind) = theta;

	[overlap, pind] = getTangentOverlap(dem, radius, nx, ny, nz, nw, px, py, pz);
	ind = valid & overlap > features.('maxOverlap');
	features.('maxOverlap')(ind) = overlap(ind);
	indOverlap(ind) = pind(ind);

	[overlap, pind] = getTangentOverlap(dem, radius, nx, ny, nz, nw, px2, py2, pz2);
	ind = valid & overlap > features.('maxOverlap2');
	features.('maxOverlap2')(ind) = overlap(ind);
  end

  disp('computing surface features');

  %% Get z-component of the tangent vector at each point
  for i = 0:5
  	sigma = 2^i;
  	h = fspecial('gaussian', 3*sigma+1, sigma);
  	dem2 = imfilter(dem, h);

  	ddx = imfilter(dem2, [-1 0 1]);
  	ddy = imfilter(dem2, [-1; 0; 1]);
  	features.(sprintf('surf%d', i)) = 1 ./ sqrt(ddx .* ddx + ddy .* ddy);
  	surf = features.(sprintf('surf%d', i));
  end

  %% roughness (smoothed magnitude of second derivative)
  sigma = 1;
  ddxx = imfilter(imfilter(dem, [-1 0 1]), [-1 0 1]);
  ddyy = imfilter(imfilter(dem, [-1; 0; 1]), [-1; 0; 1]);
  roughness = ddxx .* ddxx + ddyy .* ddyy;
  roughness = imfilter(roughness, fspecial('gaussian', 3*sigma*1, sigma));
  features.('roughness') = roughness;

  disp('computing pad features')

  features.('pad_roughness') = zeros(size(dem));

  for i = 1:numRotations
	theta = i * 2 * pi / numRotations;
	ind = (maxTheta == theta);

	feat = landerPadFeature(radius, theta, features.('roughness'), @max);
	features.('pad_roughness')(ind) = feat(ind);
  end
end

function [result] = landerPadFeature(radius, theta, feature, agg)
  u = radius * cos(theta);
  v = radius * sin(theta);
  feature(isinf(feature)) = 0;
  a = imtranslate(feature, -[u, v]);
  b = imtranslate(feature, -[v, -u]);
  c = imtranslate(feature, -[-u, -v]);
  d = imtranslate(feature, -[-v, u]);
  result = agg(agg(a, b), agg(c, d));
end
