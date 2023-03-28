%% reset
clc, clear, close all;

%% init
r = 1737.4;     % km, moon radius
sats = importdata("../data/const_eph/7_MoonOrb.txt");
sats = sats.data;
n = size(sats, 2) / 3;

%% plot
figure(1);
for i = 1:n
    j = (i-1)*3;    % set of coords
    plot3(sats(:,j+1), sats(:,j+2), sats(:,j+3), '--', 'LineWidth', 2);
    hold on;
end
% plot3(x(1,1), x(2,1), x(3,1), 'go', 'LineWidth', 2);

% moon
[I, map] = imread("lroc_color_poles_1k.jpg");
[xx, yy, zz] = ellipsoid(0, 0, 0, r, r, r);
globe = surf(xx, yy, -zz);
set(globe, 'FaceColor', 'texturemap', 'CData', I, 'FaceAlpha', 1, ...
    'EdgeColor', 'none');

hold off; grid on; axis equal;
xlabel("x (km)"); ylabel("y (km)"); zlabel("z (km)");