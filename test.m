addpath('viz')
addpath('tests')

terrain1 = 'data/terrain1';
terrain2 = 'data/terrain2';
terrain3 = 'data/terrain3';
terrain4 = 'data/terrain4';
terrain_name = terrain4;

[im, dem, safe] = loadTerrain(terrain_name);

%%% for k = [1, 4, 8, 16, 32]
%%%   k
%%%   features = computeFeatures(dem, 16, k);

%%%   baseOverlap = 3.9;
%%%   baseAngle = 10;
%%%   ratioOverlap = 1.2;
%%%   ratioAngle = 2;
%%%   overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
%%%   angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);

%%%   lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);
%%%   title(sprintf('numrotations=%d', k))
%%% end

%%% for r = [16, 17, 18, 19, 20, 21]
%%%   r
%%%   features = computeFeatures(dem, r, 16);

%%%   baseOverlap = 3.9;
%%%   baseAngle = 10;
%%%   ratioOverlap = 1.2;
%%%   ratioAngle = 2;
%%%   overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
%%%   angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);

%%%   lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);
%%%   title(sprintf('r=%d', r))
%%% end

%%% for r = [16, 17, 18, 19, 20, 21]
%%%   r
%%%   features = computeFeatures(dem, r, 16);

%%%   baseOverlap = 3.9;
%%%   baseAngle = 10;
%%%   ratioOverlap = 1.2;
%%%   ratioAngle = 2;
%%%   overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
%%%   angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);

%%%   lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);
%%%   title(sprintf('r=%d', r))
%%% end

%%% for sigma = [1 2 3 4 5]
%%%   sigma
%%%   features = computeFeatures(dem, 18, 16, sigma);

%%%   baseOverlap = 3.9;
%%%   baseAngle = 10;
%%%   ratioOverlap = 1.2;
%%%   ratioAngle = 2;
%%%   overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
%%%   angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);

%%%   lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);
%%%   title(sprintf('sigma=%d', sigma))
%%% end

%%% features = computeFeatures(dem, 18, 16, 2);

%%% for fsigma = [0 1 2 3 4 5]
%%%   fsigma
%%%   features2 = features;
%%%   features2 = smoothFeature(features2, 'maxAngle', fsigma);

%%%   baseOverlap = 3.9;
%%%   baseAngle = 10;
%%%   ratioOverlap = 1.2;
%%%   ratioAngle = 2;
%%%   overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
%%%   angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);

%%%   lineSearch(safe, features2, overlapSearchSpace, angleSearchSpace);
%%%   title(sprintf('fsigma=%d', fsigma))
%%% end


n = 10;
i = 7;
j = 7;
%%n = 1;
%%i = 1;
%%j = 1;

features = computeFeatures(dem, 18, 16, 2);
features = smoothFeature(features, 'maxAngle', 2);

%% evaluate!
baseOverlap = 3.9;
baseAngle = 10;
ratioOverlap = 1.2;
ratioAngle = 2;
overlapSearchSpace = linspace(baseOverlap / ratioOverlap, baseOverlap * ratioOverlap, 5);
angleSearchSpace = linspace(baseAngle / ratioAngle, baseAngle * ratioAngle, 100);
lineSearch(safe, features, overlapSearchSpace, angleSearchSpace);

safeAngle = 10.3;
safeOverlap = 3.9;
safe2 = features.('maxAngle') < safeAngle;
safe3 = features.('maxOverlap') < safeOverlap;
pred = features.('maxAngle') < safeAngle & features.('maxOverlap') < safeOverlap;

%% graph the interest points
%%% interest = ones(size(dem));
%%% [px, py] = getInterestPoints(dem, sigma);
%%% for p = 1:length(px)
%%%   interest(py(p), px(p)) = 0;
%%% end
%%% figure;
%%% showMesh(dem, interest, n, i, j);
%%% title('interest points');

figure;
showMesh(dem, safe2, n, i, j)
title('slope hazard')

figure;
showMesh(dem, safe3, n, i, j)
title('overlap hazard')

figure;
showMesh(dem, pred, n, i, j)
title('predicted')

figure;
showMesh(dem, safe, n, i, j)
title('actual')
