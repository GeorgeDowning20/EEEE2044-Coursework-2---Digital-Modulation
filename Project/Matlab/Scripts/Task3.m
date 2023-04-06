%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Script to run the simulation and plot theoretical BER vs Signal Strengh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;  % Clear all variables
close all; % Close all figures

global stop_time; % Simulation time global to use in funciton
global Eb_No_db; % Eb/No in dB global to use in funciton
global phaseOffset; % Phase offset global to use in funciton
global m_ary; % M-ary global to use in funciton
global idx; % Index global to use in funciton

idx = 0; % Index global to use in funciton
stop_time = 1000 % Simulation time
phaseOffset = 0 % Phase offset
max_EBN = 35 % Max Eb/No
resulution = 30 % Resulution of Eb/No

figure; % Create new figure
hold on; % Hold figure

if (1) %debug

    BER = EbNo_BER('../Simlink/PSK.slx', 4, -12, max_EBN, resulution, '-*') % Run simulation
    %BER = EbNo_BER('../Simlink/PSK.slx', 8, -12, max_EBN, resulution, '-o') % Run simulation
    BER = EbNo_BER('../Simlink/PSK.slx', 16, -12, max_EBN, resulution, '-x') % Run simulation
    BER = EbNo_BER('../Simlink/PSK.slx', 64, -12, max_EBN, resulution, '-+') % Run simulation

    BER = EbNo_BER('../Simlink/QAM.slx', 4, -12, max_EBN, resulution, '-*') % Run simulation
    %BER = EbNo_BER('../Simlink/QAM.slx', 8, -12, max_EBN, resulution, '-o') % Run simulation
    BER = EbNo_BER('../Simlink/QAM.slx', 16, -12, max_EBN, resulution, '-x') % Run simulation
    BER = EbNo_BER('../Simlink/QAM.slx', 64, -12, max_EBN, resulution, '-+') % Run simulation

end

%BPSK BER
EbN0dB = -12:1:40; % Eb/N0 range in dB
EbN0lin = 10 .^ (EbN0dB / 10) % Eb/N0 range in linear scale
colours = {'k-', 'k-', 'b-', 'b-', 'r-', 'r-'}; % Colours for the plot
index = 0 % Index for the colours

index = index + 1; % Index for the colours
M = [4 16 64]; % M-ary

for i = M,
    k = log2(i) % Bits per symbol
    y_s = k * EbN0lin % gamma_s

    syms x % Symbol for the Q function
    Q(x) = (1/2) * erfc(x / sqrt(2 * k)); % Q function

    if i == 4 % QPSK
        berErr = 2 * Q(sqrt(2 * EbN0lin)) - Q(sqrt(2 * EbN0lin)) .^ 2 % BER for QPSK
    else
        berErr = 2 * Q(sin(pi / i) * sqrt(2 * y_s)); % BER for M-PSK
    end

    berErr2 = 1 - (1 - (2 * (1 - 1 / sqrt(i))) * Q(sqrt((3 * y_s) / (i - 1)))) .^ 2 % BER for M-QAM

    plotHandle = plot(EbN0dB, (berErr), char(colours(index))); % Plot PSK BER
    index = index +1; % Index for the colours

    plotHandle2 = plot(EbN0dB, (berErr2), char(colours(index))); % Plot QAM BER
    index = index +1; % Index for the colours
end

set(gca, 'YScale', 'log') % Set Y axis to log scale
legend('QPSK', '16-PSK', '64-PSK', '4-QAM', '16-QAM', '64-QAM', Location = 'southwest') % Legend
xlabel('Eb/No [dB]') % X label
ylabel('BER [arb]') % Y label
xlim([-20 40]); % X axis limits
ylim([10 ^ -3 1]); % Y axis limits
hold off % Hold figure
grid on; % Grid on

cleanfigure; % Clean figure
matlab2tikz('../Figures/fig3.tex'); % Export figure to LaTeX

function BER = EbNo_BER(model, m, start, stop, resolution, line)
    
    global m_ary; % M-ary global to use in funciton
    global Eb_No_db; % Eb/No in dB global to use in funciton
    global idx; % Index global to use in funciton

    m_ary = m % M-ary global to use in funciton
    idx = idx + 1; % Index global to use in funciton

    col = {'k*', 'b*', 'r*', 'ko', 'bo', 'ro'}; % Colours for the plot

    Eb_N = linspace(start, stop, resolution); % Eb/No range

    for i = 1:length(Eb_N) % Loop through Eb/No
        Eb_No_db = Eb_N(i); % Eb/No in dB global to use in funciton
        res = sim(model) % Run simulation
        BER(i) = res.yout{1}.Values.Data(end, 1) % Get BER
    end

    plot(Eb_N(:), BER(:), char(col(idx))); % Plot BER

end
