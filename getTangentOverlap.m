function [overlap] = getTangentOverlap(dem, r, nx, ny, nz, nw, px, py)
  [height, width] = size(dem);
  overlap = zeros(size(dem));

  for i = 1:length(px)
	x = px(i);
	y = py(i);
	z = dem(y, x);

	left = max(1, x - r);
	right = min(width, x + r);
	top = max(1, y - r);
	bottom = min(height, y + r);
	xr = left:right;
	yr = top:bottom;

	heights = (-nw(yr, xr) - nx(yr, xr) .* x - ny(yr, xr) .* y) ./ nz(yr, xr) - z;
	[Ix2, Iy2] = meshgrid(xr-x, yr-y);
	heights(Ix2.*Ix2 + Iy2.*Iy2 > r*r) = 0;

	subdata = overlap(yr, xr);
	ind = heights < subdata;
	subdata(ind) = heights(ind);
	overlap(yr, xr) = subdata;
  end
end
