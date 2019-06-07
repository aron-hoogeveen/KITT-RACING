% EPO-4 Group B4
% 06-05-2019
% intersection of two curves with shifting included

% d: desired x where v = 0;
% x_brake, v_brake, x_acc, v_acc: velocity-position curves
% brakeEnding: property of braking curve where v = 0;
% If getPosition = 1, x location is given, otherwise v location
   

function point = CurvesIntersect(d, x_brake, v_brake, x_acc, v_acc, brakeEnding, getPosition)
 
    shift_x = shift(d); % Shift the braking curve to match distance
    %plot(x_brake - shift_x, v_brake);
    %hold on;
    %plot(x_acc, v_acc);

    % Intersection point (m)
    if (getPosition)
        point = intersectCurves(x_brake - shift_x, v_brake, x_acc, v_acc);
    else
        point = intersectCurves(v_brake, x_brake - shift_x, v_acc, x_acc);
    end
   
    function brakeStart = intersectCurves(x_brak, v_brak, x_acc, v_acc)
        brakeStart = polyxpoly(x_brak, v_brak, x_acc, v_acc);
    end 

    function shift_x = shift(d) %Determine the start velocity to shift it to the right end distance
        shift_x = brakeEnding - d;
    end
end

% End of code