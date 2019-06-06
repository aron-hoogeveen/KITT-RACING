function [res] = recursiveFunc(argin)
if (argin ~= 3)
    res = recursiveFunc(argin + 1);
    disp("Hoi ik ben een functie met argin waarde " + string(argin));
else
    disp("OMG IK BEN EINDELIJK AANGEROEPEN. argin = " + string(argin));
    res = argin;
end

disp("Einde van functie met argin = " + string(argin));
end