function [] = testLoop()
%TESTLOOP is used to test the functionality of a continuous while loop

while (1 == 1)
    % Get user input
    clear userInput;
    userInput = input('Command: ', 's');
    
    if (isempty(userInput))
        return;
    end
    
    switch userInput(1)
        case 'a'
            disp('a');
        case 'b'
            disp('b');
    end
end
end