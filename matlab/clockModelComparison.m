% clockModelComparison.m
% Author: Mark Hartigan
% Date  : November 8, 2023
% Description:
%    Compare the timing performance of a CSAC, USO, and RAFS.

%% reset
clc, clear, close all;
addpath(genpath(pwd));

%% Compute uncertainty of clock over time

dt = 1;
t = 0:dt:3600*5;                % measure once per dt for a time period

% state vector and variance of phase deviation for 3 clocks
[Xcsac, varCsac] = clockStateOverTime(t, 'CSAC');
[Xuso , varUso ] = clockStateOverTime(t, 'USO' );
[Xrafs, varRafs] = clockStateOverTime(t, 'RAFS');
varCsac = reshape(varCsac(1,1,:), size(varCsac, 3), 1);
varUso  = reshape(varUso(1,1,:) , size(varUso , 3), 1);
varRafs = reshape(varRafs(1,1,:), size(varRafs, 3), 1);


%% plot CSAC clock bias over one day

a_hi = 9e-10 / (86400 * 30);    % Hz/Hz/s, upper end of aging rate a
c = 299792458;                  % m/s, speed of light

figure();
plot(t ./ 3600, abs(Xcsac(1,:)), 'LineWidth', 1.5, 'Color', '#0072BD');
hold on;
plot(t ./ 3600, 3*sqrt(varCsac), '--', 'LineWidth', 1.5, 'Color', '#0072BD');
plot(t ./ 3600, 1/2 * a_hi * t.^2, '-.', 'LineWidth', 1.5);
hold off; grid on; xlim([0 t(end)/3600]);
xlabel('Time (hrs)');
ylabel('Phase deviation / clock bias error (s)');
legend(["Monte-Carlo run", "3\sigma bound", "Old model (only aging)"], ...
    'location', 'northwest');
title('Microsemi Space CSAC Timing Performance');

%% comparison of CSAC, USO, and RAFS
figure();
% % individual Monte-Carlo runs
% semilogy(t ./ 3600, abs(Xuso(1,:)) * c , 'LineWidth', 1.5, 'Color', '#D95319');
% hold on;
% semilogy(t ./ 3600, abs(Xcsac(1,:)) * c, 'LineWidth', 1.5, 'Color', '#0072BD');
% semilogy(t ./ 3600, abs(Xrafs(1,:)) * c, 'LineWidth', 1.5, 'Color', '#EDB120');
% % 3-sigma bounds
% semilogy(t ./ 3600, 3*sqrt(varUso) * c , '--', 'LineWidth', 2, 'Color', '#D95319');
% semilogy(t ./ 3600, 3*sqrt(varCsac) * c, '--', 'LineWidth', 2, 'Color', '#0072BD');
% semilogy(t ./ 3600, 3*sqrt(varRafs) * c, '--', 'LineWidth', 2, 'Color', '#EDB120');
% hold off; grid on; xlim([0 t(end)/3600]);
% xlabel('Time (hrs)');
% ylabel('Phase deviation / clock bias error (m)');
% legend(["USO MC run", "CSAC MC run", "RAFS MC run", "USO 3\sigma bound", ...
%         "CSAC 3\sigma bound", "RAFS 3\sigma bound"], 'location', 'best', 'NumColumns', 2);
% title('Comparison of Different Clock Timing Performances');

% 3-sigma bounds
semilogy(t ./ 3600, 3*sqrt(varUso) * c , '-', 'LineWidth', 2, 'Color', '#D95319');
hold on
semilogy(t ./ 3600, 3*sqrt(varCsac) * c, '--', 'LineWidth', 2, 'Color', '#0072BD');
semilogy(t ./ 3600, 3*sqrt(varRafs) * c, '-.', 'LineWidth', 2, 'Color', '#EDB120');
hold off; grid on; xlim([0 t(end)/3600]);
xlabel('Time (hrs)');
ylabel(' 3\sigma clock bias error (m)');
legend(["USO", "CSAC", "RAFS"], 'location', 'southeast');
title('Comparison of Clock Timing Performances');
