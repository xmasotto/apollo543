function [nx, ny, nz, nw, valid] = getTangents(dem, r, theta)
  [height, width] = size(dem);
  [Ix, Iy] = meshgrid(1:width, 1:height);

  u = r * cos(theta);
  v = r * sin(theta);

  a = imtranslate(dem, -[u, v]);
  b = imtranslate(dem, -[v, -u]);
  c = imtranslate(dem, -[-u, -v]);
  d = imtranslate(dem, -[-v, u]);

  nx = (u+v)*(c-b) - (u-v)*(a-b);
  ny = (a-b)*(-u-v) - (c-b)*(u-v);
  nz = (u-v)*(u-v) - (u+v)*(-u-v);
  norm = sqrt(nx.*nx + ny.*ny + nz.*nz);

  nx = nx ./ norm;
  ny = ny ./ norm;
  nz = nz ./ norm;
  nw = -(Ix .* nx + Iy .* ny + (a/2 + c/2) .* nz);

  diff = (-nw - nx .* (Ix - v) - ny .* (Iy + u)) ./ nz - d;
  valid = diff > -1;
end
