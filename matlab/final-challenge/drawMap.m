% EPO-4 Group B4
% 29-05-2019
%[] = drawMap is used to iniate a plot functioning as a field map
function [] = drawMap(startpoint, endpoint, orientation, waypoint)
    
    % Map size
    %figure('WindowState', 'maximized')
    
    %Draw the bounds of the field:
    rectangle('Position', [0,0,50,700], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
    hold on;
    rectangle('Position', [650,0,50,700], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
    rectangle('Position', [0,650,700,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
    rectangle('Position', [0,0,700,50], 'EdgeColor',[.9 .9 .9], 'FaceColor', [.9 .9 .9])
    
    % Draw the start and end points (and optionally waypoint)
    plot(startpoint(1), startpoint(2), 'b*', 'MarkerSize', 10);
    plot(endpoint(1), endpoint(2), 'r*', 'MarkerSize', 10);
    % Draw orientation of the startposition of the car
    quiver(startpoint(1), startpoint(2), 150*cosd(orientation), 150*sind(orientation), 0, 'MaxHeadSize', 10, 'color',[0 0.6 0]);

    % Add a legend
    if (nargin > 3)
        plot(waypoint(1), waypoint(2), 'g*', 'MarkerSize', 10);
        legend('Startpoint', 'Endpoint', 'Starting orientation', 'Waypoint');
    else
        legend('Startpoint', 'Endpoint', 'Starting orientation','Location','best'); 
    end
    
    %drawLine(startpoint, endpoint)
    % Set limits, ratio, units and grid
    xlim([0,700]);
    ylim([0, 700]);
    xlabel('X Distance [cm]');
    ylabel('Y Distance [cm]');
    grid on;
    pbaspect([1 1 1]); %fixed square map

    
    % function to draw a line between 2 points
    function [] = drawLine(p1, p2)
        theta = atan2( p2(2) - p1(2), p2(1) - p1(1));
        r = sqrt( (p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
        line = 0:0.01: r;
        x = p1(1) + line*cos(theta);
        y = p1(2) + line*sin(theta);
        plot(x, y, 'LineWidth',1)
    end

end%drawMap
