function [features] = computeFeatures(dem, radius, numRotations, sigma)
  features.('maxAngle') = zeros(size(dem));
  features.('maxOverlap') = zeros(size(dem));

  [px, py] = getInterestPoints(dem, sigma);

  for i = 1:numRotations
	theta = i * 2 * pi / numRotations;

	[nx, ny, nz, nw, valid] = getTangents(dem, radius, theta);
	angles = acos(nz) * 180 / pi;
	ind = valid & angles > features.('maxAngle');
	features.('maxAngle')(ind) = angles(ind);

	overlap = getTangentOverlap(dem, radius, nx, ny, nz, nw, px, py);
	ind = valid & overlap > features.('maxOverlap');
	features.('maxOverlap')(ind) = overlap(ind);
  end
end
