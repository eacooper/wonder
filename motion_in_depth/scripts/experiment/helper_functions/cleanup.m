% Cleanup routine:
function cleanup

Eyelink('Shutdown');    % Shutdown Eyelink:
sca;                    % Close window:
ListenChar(0);          % Restore keyboard output to Matlab:
error('Exited experiment before completion');
commandwindow;