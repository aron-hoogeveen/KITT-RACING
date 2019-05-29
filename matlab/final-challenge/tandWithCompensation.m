% Compensation for tan to make it correct for every quadrant (+pi/-pi)
 function degrees = tandWithCompensation(y,x)
       if(y<0 && x<0)
           plus = -180;
       elseif(y>0 && x<0)
           plus = 180;
       else 
           plus = 0;
       end
       degrees = atand(y/x)+plus;
  end