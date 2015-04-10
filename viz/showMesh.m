function showMesh(dem, safe, k, i, j)
  b = length(dem) / k;
  xrange = ((i-1)*b+1:i*b);
  yrange = ((j-1)*b+1:j*b);

  subdem = dem(yrange, xrange);
  subsafe = safe(yrange, xrange);
  mesh(subdem, double(subsafe));
end
