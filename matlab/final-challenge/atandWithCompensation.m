% EPO-4 Group B4
% 28-05-2019
% Tan function but compensated to make tan^-1 correct for every quadrant (+pi/-pi)
 function degrees = atandWithCompensation(y,x)
       if(y<0 && x<0)
           plus = -180;
       elseif(y>0 && x<0)
           plus = 180;
       else 
           plus = 0;
       end
       degrees = atand(y/x)+plus;
  end