function [overlap, pind] = getTangentOverlap(dem, r, nx, ny, nz, nw, px, py, pz)
  [height, width] = size(dem);
  overlap = zeros(size(dem));
  pind = zeros(size(dem));

  for i = 1:length(px)
	x = px(i);
	y = py(i);
	z = pz(i);
	%% z = dem(y, x);

	left = max(1, x - r);
	right = min(width, x + r);
	top = max(1, y - r);
	bottom = min(height, y + r);
	xr = left:right;
	yr = top:bottom;

	heights = z - (-nw(yr, xr) - nx(yr, xr) .* x - ny(yr, xr) .* y) ./ nz(yr, xr);
	heights = heights .* nz(yr, xr);

	[Ix2, Iy2] = meshgrid(xr-x, yr-y);
	heights(Ix2.*Ix2 + Iy2.*Iy2 > r*r) = 0;

	subdata = overlap(yr, xr);
	ind = heights > subdata;
	subdata(ind) = heights(ind);
	overlap(yr, xr) = subdata;

	subpind = pind(yr, xr);
	subpind(ind) = i;
	pind(yr, xr) = subpind;
  end
end
