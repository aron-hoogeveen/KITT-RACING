function [] = drawMap(startpoint, endpoint, waypoint)
    
    plot(startpoint(1), startpoint(2), 'b*', 'MarkerSize', 10);
    hold on;
    plot(endpoint(1), endpoint(2), 'r*', 'MarkerSize', 10);
    hold on;
    if (nargin > 2)
        plot(waypoint(1), waypoint(2), 'g*', 'MarkerSize', 10);
        legend('Startpoint', 'Endpoint', 'Waypoint');
    else
        legend('Startpoint', 'Endpoint','Location','best'); 
    end
    
    %drawLine(startpoint, endpoint)
    xlim([0,600]);
    ylim([0, 600]);
    xlabel('cm');
    ylabel('cm');
    grid on;
    pbaspect([1 1 1]); %fixed square map

   
    function [] = drawLine(p1, p2)
        theta = atan2( p2(2) - p1(2), p2(1) - p1(1));
        r = sqrt( (p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
        line = 0:0.01: r;
        x = p1(1) + line*cos(theta);
        y = p1(2) + line*sin(theta);
        plot(x, y, 'LineWidth',1)
    end

end%drawMap
