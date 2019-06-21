% EPO-4 Group B4
% 15-06-2019
%[] = drawMap is used to iniate a plot functioning as a field map
function [] = drawMap(handles, startpoint, endpoint, orientation, waypoint)
    
    % Map size
    %figure('WindowState', 'maximized')   
    
    % Draw the start and end points (and optionally waypoint)
    plot(handles.LocationPlot,startpoint(1), startpoint(2), 'b*', 'MarkerSize', 10);
    plot(handles.LocationPlot,endpoint(1), endpoint(2), 'r*', 'MarkerSize', 10);
    % Draw orientation of the startposition of the car
    quiver(handles.LocationPlot,startpoint(1), startpoint(2), 150*cosd(orientation), 150*sind(orientation), 0, 'MaxHeadSize', 10, 'color',[0 0.6 0]);

    % Add a legend
    if (nargin > 4)
        plot(handles.LocationPlot,waypoint(1), waypoint(2), 'g*', 'MarkerSize', 10);
        %legend(handles.LocationPlot,'Startpoint', 'Endpoint', 'Starting orientation', 'Waypoint');
    else
        %legend(handles.LocationPlot,'Startpoint', 'Endpoint', 'Starting orientation','Location','best'); 
    end
     
    % function to draw a line between 2 points
    function [] = drawLine(p1, p2)
        theta = atan2( p2(2) - p1(2), p2(1) - p1(1));
        r = sqrt( (p2(1) - p1(1))^2 + (p2(2) - p1(2))^2);
        line = 0:0.01: r;
        x = p1(1) + line*cos(theta);
        y = p1(2) + line*sin(theta);
        plot(handles.LocationPlot,x, y, 'LineWidth',1)
    end

end%drawMap
