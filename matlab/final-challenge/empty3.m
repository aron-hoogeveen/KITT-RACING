turnEndPos = [3, 3];
deviation = 2;
m = -1;
b = turnEndPos(2) - m * turnEndPos(1);


A = m^2 + 1;
B = (2*b*m - 2*turnEndPos(1)-2*turnEndPos(2)*m);
C = b^2 + -2*b*turnEndPos(2) + turnEndPos(1)^2 + turnEndPos(2)^2 - deviation^2;
D = B^2 - 4*A*C;

 x_deviation = (-B + sqrt(D))/(2*A)
 y_deviation = m*x_deviation+b