function point = CurvesIntersect(d, x_brake, v_brake, x_acc, v_acc, brakeEnding)

    % d = desired ending point

    % Accerlating
    shift_x = shift(d); % Shift the braking curve to match distance
    plot(x_brake - shift_x, v_brake);
    hold on;
    plot(x_acc, v_acc);

    % Intersection point (m)
    Braking_Point = intersectCurves(x_brake - shift_x, v_brake, x_acc, v_acc);
    
    point = Braking_Point;
    
    function brakeStart = intersectCurves(x_brak, v_brak, x_acc, v_acc)
        brakeStart = polyxpoly(x_brak, v_brak, x_acc, v_acc);
    end 

    function shift_x = shift(d) %Determine the start velocity to shift it to the right end distance
        shift_x = brakeEnding - d;
    end
end

