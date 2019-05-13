% Line part
line_samples = 0:16;
line_part = polyfit(line_samples, Xcomb(line_samples+1), 1);
X_line = polyval(line_part, line_samples);


poly_samples = 16:44;
ri = 10.244;
pu = 153.31275;
%aplusc= ri-pu;
%bmin2c = ri - 2*(ri-pu);
b = ri;
c = pu;
% (poly) Braking part
ft = fittype(@(a, x) a*(x-16)A.^2+b*(x-16)+c);
FO = fit(poly_samples',X_combpoly',ft);
%poly_part = polyfitB(samples, Xcomb(17:45), 2, 153.127450980392);
%X_poly = polyval(poly_part, samples);

%Xcombi = [X_line; X_poly];

plot(FO);