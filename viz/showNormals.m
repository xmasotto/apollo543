function showNormals(dem, valid, nx, ny, nz, k, i, j)
  b = length(dem) / k;
  xrange = ((i-1)*b+1:i*b);
  yrange = ((j-1)*b+1:j*b);

  subvalid = valid(yrange, xrange);
  subdem = dem(yrange, xrange);
  subnx = nx(yrange, xrange);
  subny = ny(yrange, xrange);
  subnz = nz(yrange, xrange);

  [Ix, Iy] = meshgrid(1:length(xrange), 1:length(yrange));
  ind = subvalid & (mod(Ix, 3) == 0 & mod(Iy, 3) == 0);
  quiver3(Ix(ind), Iy(ind), subdem(ind), subnx(ind), subny(ind), subnz(ind));
end
