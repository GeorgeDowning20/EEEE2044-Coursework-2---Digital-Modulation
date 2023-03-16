clear all;
close all;

x = linspace(0,2*pi,100);
y = sin(x);
plot(x,y)

cleanfigure; 
matlab2tikz('../Figures/fig1.tex'); 