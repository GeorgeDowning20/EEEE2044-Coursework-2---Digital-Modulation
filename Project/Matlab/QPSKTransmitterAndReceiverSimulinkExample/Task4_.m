%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                       PSK rx tx vs PSK sim
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;  % clear all variables
close all; % close all figures

idx = 0; % index for the number of simulations
stop_time = 5000 % simulation time
phaseOffset = 0 % phase offset
m_ary = 4 % m-ary PSK
max_EBN = 35 % maximum Eb/No
resulution = 200 % number of points in the plot

figure; % figure
hold on; % hold on for multiple plots

Eb_N = linspace(-12, 35, resulution); % Eb/No vector

for i = 1:length(Eb_N) % loop over Eb/No
    Eb_No_db = Eb_N(i); % set Eb/No
    res = sim('../Simlink/PSK.slx'); % run simulation
    BER(i) = res.yout{1}.Values.Data(end, 1) % save BER
end

plot(Eb_N(:), BER(:), 'r-*'); % plot BER vs Eb/No

for i = 1:length(Eb_N) % loop over Eb/No
    Eb_No_db = Eb_N(i); % set Eb/No
    res = sim('commqpsktxrx.slx'); % run simulation
    BER(i) = out.Data(end, 1) % save BER
end

plot(Eb_N(:), BER(:), 'k-*'); % plot BER vs Eb/No

hold off; % hold off for multiple plots
set(gca, 'YScale', 'log') % set y-axis to log scale
legend('QPSK', 'QPSK Rx-Tx', Location = 'southwest') % legend
xlabel('Eb/No [dB]') % x-axis label
ylabel('BER [arb]') % y-axis label
grid on; % grid on
xlim([-15 20]); % x-axis limits
ylim([10 ^ -3 1]); % y-axis limits

cleanfigure; % clean figure
matlab2tikz('../Figures/fig4.tex'); % save figure as tex file
