function pts = intercept(planeObjs)
% The "intercept" method finds the lower dimensional plane that is the
% intercept of two other planes. It will return an array of plane intercept
% for every pair planes given.
%
% SYNTAX:
%   pts = planeObjs.intercept
%
% INPUTS:
%   planeObjs - (? x 1 simulate.plane)
%       Instances of the "simulate.plane" class. Dimension must be the same
%       for all planes and be less than or equal to 3. 
%       N = numel(planeObjs)
%
% OUTPUTS:
%   pts - (N x N x 2 numbers)
%       Points of intercept. X coordinates are in the front matrix
%       (pts(:,:,1)), Y coordinates are in the back matrix (pts(:,:,2)).
%       First and second dimensions correspond to "planeObjs" indices. A
%       NaN means the planes don't intercept.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%    distance
%
% AUTHOR:
%    Rowland O'Flaherty 02-NOV-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(1,1,nargin))

% Check arguments for errors
assert(isa(planeObjs,'simulate.plane') && all([planeObjs.dimension] <= 3) && all([planeObjs.dimension] == planeObjs(1).dimension),...
    'simulate:plane:intercept:planeObjs',...
    'Input argument "planeObjs" must be "simulate.plane" objects with all the same dimension <= 3.')
dimension = planeObjs(1).dimension;

%% Parameters
zeroSize = 1e6*eps;

%% Intercetps
switch dimension
    case 2
        N = numel(planeObjs);
        pts = nan(N,N,2);
        for i = 1:N-1
            for j = i:N
                    
                di = planeObjs(i).direction;
                li = planeObjs(i).location;
                dj = planeObjs(j).direction;
                lj = planeObjs(j).location;
                
                detij = det([di dj]);
                
                if abs(detij) <= zeroSize
                    continue
                end
                
                t = (lj - li)'*dj/detij;
                dic = [-di(2);di(1)];
                
                pts(i,j,:) = permute(dic*t+li,[3 2 1]);
                
            end
        end
        
    otherwise
        error('simulate:plane:intercept:dimension','Intercepts for dimensions higher than 2 have not been programmed yet.')
end

pts(abs(pts) <= zeroSize) = 0;

end
