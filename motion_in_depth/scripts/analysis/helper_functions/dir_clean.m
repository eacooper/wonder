function listing = dir_clean(pathname)
%
% removes hidden files from Matlab dir file listing

listing     = dir(pathname);
crit        = '^[^.]+';
rxResult    = regexp( {listing.name}, crit ); % return cell array of results, [] if no match
nodot       = (cellfun('isempty', rxResult)==0); % loop over all cells, set true if regex matched
listing     = listing(nodot);
