function testTangentOverlap(dem, safe)
%%   n = 5
%%   i = 3
%%   j = 2
  n = 1;
  i = 1;
  j = 1;

  [px, py] = getInterestPoints(dem)
  data = zeros(size(dem));
  for p = 1:length(px)
	data(py(p), px(p)) = 1;
  end
  figure;
  showMesh(dem, data, n, i, j)
  title('interest points')

  figure;
  showMesh(dem, safe, n, i, j)

  theta = 0
  [nx, ny, nz, nw, valid] = getTangents(dem, 16, theta);
  overlap = getTangentOverlap(dem, 16, nx, ny, nz, nw, px, py);
  figure;
  showMesh(overlap, safe, n, i, j);

end
