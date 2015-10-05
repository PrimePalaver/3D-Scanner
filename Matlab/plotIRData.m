function res = plotIRData(dist, phi, dir)
    close all;

    %Assign variables to workspace variables
    assignin('base', 'dist', dist);
    assignin('base', 'dir', dir);
    assignin('base', 'phi', phi);
    
    %Initialize variables
    xOffset = 21;
    yOffset = 15.25;
    distOffset = 0;
    thetaOffset = 0;
    prevDir = dir(1);
    prevBreak = 1;
    graphScale = 10;
    lenDist = length(dist);
    
    %Modify phi
    horizontal = 104;
    phi = phi - horizontal;
    phi = degtorad(phi);
    
    %Modify array lengths to match lenDist
    dir = dir(length(dir) + 1 - lenDist : end);
    phi = phi(length(phi) + 1 - lenDist : end);
    
    theta = zeros(1, lenDist);
    
    %Create theta according to direction of spins
    for i = 1:lenDist
        currDir = dir(i);
        
        if ~isequal(prevDir, currDir)
            if currDir
                theta(prevBreak: i - 1) = linspace(0+thetaOffset, 2*pi+thetaOffset, i - prevBreak);
            else
                theta(prevBreak: i - 1) = linspace(2*pi, 0, i - prevBreak);
            end
            
            prevBreak = i;
            
            prevDir = ~prevDir;
        end
    end
    
    %Create theta for last spin
    if currDir
        theta(prevBreak + 1: end) = linspace(2*pi, 0, length(dir) - prevBreak);
    else
        theta(prevBreak + 1: end) = linspace(0+thetaOffset, 2*pi+thetaOffset, length(dir) - prevBreak);
    end
    
    %r is radial distance from center of table
    dist = dist + distOffset;
    r = xOffset - dist.*cos(phi);
    
    %z is vertical distance from center of table
    z = yOffset - dist.*sin(phi);
    
    %Plot distance over time
    figure();
    plot(dist);
    
    %Plot the 3D points of the object
    figure();
    [x, y, z] = pol2cart(theta, r, z);
    plot3(x, y, z, '.');
    xlim([-graphScale graphScale])
    ylim([-graphScale graphScale])
    zlim([0 2*graphScale])

    %Convert degrees to radian
    function rad = degtorad(deg)
        rad = deg .* pi/180;
    end
end