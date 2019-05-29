function [] = drawMap(startpoint, endpoint, orientation, waypoint)
    
    % Map size
    %figure('WindowState', 'maximized')
    
    plot(startpoint(1), startpoint(2), 'b*', 'MarkerSize', 10);
    hold on;
    plot(endpoint(1), endpoint(2), 'r*', 'MarkerSize', 10);
    hold on;
    quiver(startpoint(1), startpoint(2), 150*cosd(orientation), 150*sind(orientation), 0, 'MaxHeadSize', 10, 'color',[0 0.6 0]);
    hold on;
    if (nargin > 3)
        plot(waypoint(1), waypoint(2), 'g*', 'MarkerSize', 10);
        legend('Startpoint', 'Endpoint', 'Starting orientation', 'Waypoint');
    else
        legend('Startpoint', 'Endpoint', 'Starting orientation','Location','best'); 
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
