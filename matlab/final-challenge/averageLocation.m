% EPO-4 Group B4
% 13-05-2019
% averageLocation returns the average x, and y for corresponding vectors
function [x, y] = averageLocation(x_vector, y_vector)
    
  if (length(x_vector) ~= length(y_vector))
      error('Vectors are not of same length');
  end
  
  xsum = 0;
  ysum = 0;
   for i = 1:length(x_vector)
       xsum = x_vector(i) + xsum;
       ysum = y_vector(i) + ysum;
   end
   x = xsum/length(x_vector);
   y = ysum/length(y_vector);
end

