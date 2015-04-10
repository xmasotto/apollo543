function testGetTangents(dem, safe, theta)
  n = 5
  i = 3
  j = 2

  [nx, ny, nz, nw, valid] = getTangents(dem, 16, theta);

  figure;
  showMesh(dem, safe, n, i, j)
  ylabel('y')
  xlabel('x')
  title('Gold Standard')

  figure;
  showMesh(dem, safe, n, i, j);
  hold on;
  quiver3([50], [50], dem(50, 50) + 10, 16, 0, 1), hold on
  quiver3([50], [50], dem(50, 50) + 10, 0, -16, 1), hold on
  quiver3([50], [50], dem(50, 50) + 10, -16, 0, 1), hold on
  ylabel('y')
  xlabel('x')
  title('Debug 3 directions')

  figure;
  showMesh(dem, valid, n, i, j);
  hold on;
  showNormals(dem, valid, nx, ny, nz, n, i, j);
  ylabel('y')
  xlabel('x')
  title('Debug valid normals')

  figure;
  showMesh(dem, ~valid, n, i, j);
  hold on;
  showNormals(dem, ~valid, nx, ny, nz, n, i, j);
  ylabel('y')
  xlabel('x')
  title('Debug invalid normals')

  figure;
  showMesh(abs(nz), valid, n, i, j)
  ylabel('y')
  xlabel('x')
  title('Debug angles')

  safeAngle = n
  figure;
  showMesh(dem, abs(nz) > cos(safeAngle * pi / 180), n, i, j)
  ylabel('y')
  xlabel('x')
  title('Debug hazards')

end
