v = [11.26 11.26 11.26 11.26 11.26 0];
x = [0 10 20 30 40 50];
samples = [1 2 3 4 5 6];
p = polyfit(samples, v, 3);
P = polyval(p, samples);
plot(x, P);