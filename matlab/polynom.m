sa = [1:140];
samples = [1: length(x)];

p = polyfit(samples, x, 10);
q = polyfit(samples, v, 10);

P = polyval(p, sa);
Q = polyval(q, sa);

plot(x_acc185, v_acc185);
hold on;
plot(P, Q);
