addpath('viz')
addpath('tests')

terrain1 = 'data/terrain1';
terrain2 = 'data/terrain2';
terrain3 = 'data/terrain3';
terrain4 = 'data/terrain4';
terrain_name = terrain3;

[im, dem, safe] = loadTerrain(terrain_name);

% Widen the DEM with a ordfilt2
k = 4
[Ix, Iy] = meshgrid(-k:k, -k:k);
(Ix.*Ix + Iy.*Iy)
domain = (Ix.*Ix + Iy.*Iy) < k*k;
%%dem = ordfilt2(dem, sum(domain(:)), domain);

%%testGetTangents(dem, safe, 0)
%%testTangentOverlap(dem, safe)
%%return;

[px, py] = getInterestPoints(dem)

safe2 = ones(size(dem));
safe3 = ones(size(dem));
safe4 = ones(size(dem));

k = 32
for i = 1:k
  theta = i * 2 * pi / k;
  [nx, ny, nz, nw, valid] = getTangents(dem, 16, theta);
  overlap = getTangentOverlap(dem, 16, nx, ny, nz, nw, px, py);

  safeOverlap = 3.9;
  overlapHazard = valid & overlap < -safeOverlap;

  safeAngle = 10;
  angleHazard = abs(nz) < cos(safeAngle * pi / 180) & valid;

  safe2 = safe2 & ~angleHazard;
  safe3 = safe3 & ~overlapHazard;
  safe4 = safe4 & ~angleHazard & ~overlapHazard;
end

n = 1;
i = 1;
j = 1;

figure;
showMesh(dem, safe2, n, i, j)
title('slope hazard')

figure;
showMesh(dem, safe3, n, i, j)
title('overlap hazard')

figure;
showMesh(dem, safe4, n, i, j)
title('combined')

figure;
showMesh(dem, safe, n, i, j)
title('gold standard')
