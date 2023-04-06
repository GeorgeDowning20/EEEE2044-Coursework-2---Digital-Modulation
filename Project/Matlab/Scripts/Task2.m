%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%         Script to run the simulation and plot BER vs Signal Strengh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;  % Clear all variables
close all; % Close all figures

global stop_time; % Simulation time gobal to use in functions
global Eb_No_db; % Eb/No in dB global to use in functions
global phaseOffset; % Phase offset global to use in functions
global m_ary; % M-ary global to use in functions
global idx; % Index for color and line style

idx = 0; % Index for color and line style
stop_time = 2000 % Simulation time
phaseOffset = 0 % Phase offset
max_EBN = 35 % Max Eb/No in dB
resulution = 50 % Resolution of the plot

figure; % Create a new figure
hold on; % Hold the plot

BER = EbNo_BER('../Simlink/PSK.slx', 4, -12, max_EBN, resulution, '-*') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/PSK.slx', 8, -12, max_EBN, resulution, '-o') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/PSK.slx', 16, -12, max_EBN, resulution, '-x') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/PSK.slx', 64, -12, max_EBN, resulution, '-+') % Run the simulation and plot the BER

BER = EbNo_BER('../Simlink/QAM.slx', 4, -12, max_EBN, resulution, '-*') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/QAM.slx', 8, -12, max_EBN, resulution, '-o') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/QAM.slx', 16, -12, max_EBN, resulution, '-x') % Run the simulation and plot the BER
BER = EbNo_BER('../Simlink/QAM.slx', 64, -12, max_EBN, resulution, '-+') % Run the simulation and plot the BER

hold off; % Release the plot
set(gca, 'YScale', 'log') % Set the Y axis to log scale
legend('QPSK', '8-PSK', '16-PSK', '64-PSK', '4-QAM', '8-QAM', '16-QAM', '64-QAM', Location = 'southwest') % Add a legend
xlabel('Eb/No [dB]') % Add a label to the X axis
ylabel('BER [arb]') % Add a label to the Y axis
grid on; % Add a grid to the plot
xlim([-20 40]); % Set the X axis limits
ylim([10 ^ -3 1]); % Set the Y axis limits

cleanfigure; % Clean the figure
matlab2tikz('../Figures/fig2.tex'); % Export the figure to LaTeX

function BER = EbNo_BER(model, m, start, stop, resolution, line)
    global m_ary; % M-ary global to use in functions
    global Eb_No_db; % Eb/No in dB global to use in functions
    global idx; % Index for color and line style
    m_ary = m % M-ary global to use in functions
    idx = idx + 1; % Index for color and line style

    col = {'k-*', 'g-*', 'b-*', 'r-*', 'k-o', 'g-o', 'b-o', 'r-o'}; % Colors and line styles

    Eb_N = linspace(start, stop, resolution); % Eb/No in dB

    for i = 1:length(Eb_N) % Loop over all Eb/No values
        Eb_No_db = Eb_N(i); % Eb/No in dB global to use in functions
        res = sim(model) % Run the simulation
        BER(i) = res.yout{1}.Values.Data(end, 1) % Get the BER from the simulation
    end

    plot(Eb_N(:), BER(:), char(col(idx))); % Plot the BER vs Eb/No
end
