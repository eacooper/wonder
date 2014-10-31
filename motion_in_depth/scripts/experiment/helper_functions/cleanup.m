% Cleanup routine:
function cleanup(early,dat)

Eyelink('Shutdown');    % Shutdown Eyelink:
sca;                    % Close window:
ListenChar(0);          % Restore keyboard output to Matlab:
if(early)
    store_results(dat);
    error('Exited experiment before completion');
end
commandwindow;