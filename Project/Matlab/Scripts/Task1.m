%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Matlab script to generate BER vs Simulation Stop Time plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;
close all;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      % Define Constants
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stop_time = 100000 % simulation stop time
Eb_No_db = 1 % Eb/No in dB
phaseOffset = 0 % phase offset in radians

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       % Run simulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

m_ary = 4 % M-ary number
out1 = sim('../Simlink/PSK.slx') % run simulation

m_ary = 16 % M-ary number
out2 = sim('../Simlink/PSK.slx') % run simulation

m_ary = 16 % M-ary number
out3 = sim('../Simlink/QAM.slx') % run simulation

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                      % Create Plot
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hold on;
plot(out1.yout{1}.Values.Time(:), out1.yout{1}.Values.Data(:, 1) * 100) %plot simulation results QPSK
plot(out2.yout{1}.Values.Time(:), out2.yout{1}.Values.Data(:, 1) * 100) %plot simulation results 16-PSK
plot(out3.yout{1}.Values.Time(:), out3.yout{1}.Values.Data(:, 1) * 100) %plot simulation results 16-QAM
hold off;

legend('PSK 4', 'PSK 16', 'QAM 16') % add legend to plot
ylabel('BER [%]') % add y-axis label
xlabel('Simulation Stop Time [s]') % add x-axis label

set(gca, 'XScale', 'log') % set x-axis to logarithmic scale

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                  % Convert to text format
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cleanfigure; % remove unnecessary lines from plot
matlab2tikz('../Figures/fig1.tex'); % export plot to LaTeX
