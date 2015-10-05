% this demo shows how to convert from spherical coordinates to ...
% cartesian which can be plotted with traditional methods

% set up domain vectors
thMin = 0;
thMax = 120;
phiMin = -15;
phiMax = 45;
thVec = thMin:1:thMax; % angle leftwards [deg]
phiVec = phiMin:1:phiMax; % angle upwards [deg]

% convert domain vectors into matrices which are needed for mesh plotting
[Th, Phi] = meshgrid(thVec, phiVec);
Rho = 30 + 10*cosd(5*Th).*sind(5*Phi); % distance value [cm]
Rho(Rho > 37) = NaN; % pretend our sensor has limited range

% plot the distance data
figure('units', 'normalized', 'outerposition', [0 0 1 1]);
subplot(2,2,1);
h = pcolor(-Th, Phi, Rho);
set(h, 'EdgeColor', 'none');
shading(gca, 'interp');
xlabel('-theta');
ylabel('phi');
title('spherical 2D pcolor');

% plot this mesh in 3D
subplot(2,2,2);
surf(-Th, Phi, Rho, 'EdgeColor', 'none', 'FaceColor', 'interp');
title('spherical 3D surf');
xlabel('-theta');
ylabel('phi');
zlabel('rho');

% calculate cartesian coodinates of all points
X = Rho.*cosd(Phi).*cosd(Th);
Y = Rho.*cosd(Phi).*sind(Th);
Z = Rho.*sind(Phi);

% plot cartesian surface, with default coloring
subplot(2,2,3);
surf(X, Y, Z, 'EdgeColor', 'none', 'FaceColor', 'interp');
title('cartesian 3D surf, z-colored');
xlabel('x');
ylabel('y');
zlabel('z');

% plot cartesian surface, colored by distance
subplot(2,2,4);
surf(X, Y, Z, Rho, 'EdgeColor', 'none', 'FaceColor', 'interp');
title('cartesian 3D surf, rho-colored');
xlabel('x');
ylabel('y');
zlabel('z');