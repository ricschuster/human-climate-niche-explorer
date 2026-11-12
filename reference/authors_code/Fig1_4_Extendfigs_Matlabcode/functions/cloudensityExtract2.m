function [ varargout ] = cloudensityExtract2( varargin)
%CLOUDPLOT Does a cloud plot of the data in X and Y.
%
% CLOUDPLOT(X,Y) draws a cloudplot of Y versus X. A cloudplot is in essence
% a 2 dimensional histogram showing the density distribution of the data
% described by X and Y. As the plot displays density information, the
% dimensionality of X and Y are ignored. The only requirement is that X and
% Y have the same number of elements. Cloudplot is written to visualize
% large quantities of data and is most appropriate for datasets of 10000
% elements or more.
%
% CLOUDPLOT is fully compatible with SUBPLOT, COLORBAR and COLORMAP, and
% hold states.
%
% CLOUTPLOT(X,Y,axisLimits) plots the values of X and Y that are within the
% limits specified by axisLimits. axisLimits is a 4-element vector with the
% same meaning as "axis( axisLimits )" would have on a regular plot.
% axisLimits can be [] in which case it will be ignored.
%
% CLOUTPLOT(X,Y,axisLimits,useLogScale) If useLogScale == true, plots the
% base10 logarithm of the density at each point. Useful for distributions
% where the density varies greatly. Setting it empty will be itnerprated as
% linear scale.
% 
% CLOUDPLOT(X,Y,axisLimits,useLogScale,bins) By setting bins to a 2-element
% vector, the number of bins used in the x and y direction can be adjusted.
% If you for example have a smaller data set, setting a lower number of
% bins may be clearer. The default value is to have one bin per pixel of
% the screen.
%
% CLOUDPLOT(...,'name',value) Any name-value pairs tacked on to the end of
% the argument list will be set as properties of the image object used
% internally. Type 'doc image_props' to find out about valid options.
%
% h = CLOUTPLOT(...) returns the handle to the cloud image in h.
%
% [h, canvas] = CLOUTPLOT(...) additionally returns a matrix indicating the
% number of elements in each bin.
%
% Example:
%   cloudPlot( randn(10000,1), randn(10000,1) );
%    Will plot a Gaussian scattered distribution.
%
%   cloudPlot( randn(1000), randn(1000), [0 3 -1 4]);
%    Will plot a Gaussian scattered distribution of X and Y values within
%    the limits.
%
%   See also IMAGE, SCATTER
%
% Contributions:
% Thanks to Eric Sampson for ideas about additional arguments.
% Thanks to Eric for the addition of the xscale/yscale output option.
% Thanks to Romesh who provided a bugfix, the bins input option, and the
% ability to resize the plot and a fix to remove the need to return scaling
% factors.
% Copyright 1984-2013 The MathWorks, Inc.

% example:

% cloudenPlot(x,y,z[0 90 0 50],true,[200,200]);

[args,pvpairs] = parseparams(varargin);

nArgs = numel(args);
bins = []; %Default value
useLogScale = false; %Default value
axisLimitsSet = false; %Default value

if ( nArgs >= 1 ); X = args{1}; end
if ( nArgs >= 2 ); Y = args{2}; end
if ( nArgs >= 3 ); Z = args{3}; end
if ( nArgs >= 4 ) 
    axisLimits = args{4}; 
    if ( ~isempty(axisLimits) )
        pointSelect = X<=axisLimits(2) & X>=axisLimits(1) & ...
        Y<=axisLimits(4) & Y>=axisLimits(3);
        X = X(pointSelect);
        Y = Y(pointSelect);
        Z = Z(pointSelect);
        axisLimitsSet = true;
    end
end
if ( nArgs >= 5 ); useLogScale = args{5}; end
if ( nArgs >= 6 ); bins = args{6}; end
if ( nArgs >= 7 ); usesmooth = args{7}; end
if ( nArgs >= 8 ); smoothsize = args{8}; end
if ( nArgs >= 9 ); densityvaluematrix = args{9}; end

assert ( nArgs < 10, 'No more than 9 arguments plus name-value pairs allowed' );
assert ( nArgs >= 2, 'At least 2 arguments required' );

% Check the data size
assert ( numel(X) == numel(Y), ...
    'The number of elements in X and Y must be the same.' );
assert ( numel(Y) == numel(Z), ...
    'The number of elements in Y and Z must be the same.' );
assert ( numel(X) == numel(Z), ...
    'The number of elements in X and Z must be the same.' );
  
%Remove any nans or Infs in the data as they have no meaning in this
%context.
pointSelect = ~(isinf(X) | isnan(X) | isinf(Y) | isnan(Y) | isinf(Z) | isnan(Z) );
X = X(pointSelect);
Y = Y(pointSelect);
Z = Z(pointSelect);

% Plot to get appropriate limits
h = [];
if ( axisLimitsSet )    
    g = gca;
    set ( g, 'Xlim', [axisLimits(1) axisLimits(2)] );
    set ( g, 'Ylim', [axisLimits(3) axisLimits(4)] );
    set ( g, 'units', 'pixels' );
else
    h = plot ( X(:), Y(:), '.' );        
    g = get( h, 'Parent' );        
end
xLim = get(g, 'Xlim' );
yLim = get(g, 'Ylim' );

%Get the bin size.
unitType = get(g,'Unit');
set(g,'Unit','Pixels')
axesPos = get(g,'Position');
nHorizontalBins = axesPos(3);
nVerticalBins = axesPos(4);
set(g,'Unit', unitType );

% Clear the data, as we actually don't want to see it.
if ( ~isempty(h) )
    set ( h, 'XData', [] );
    set ( h, 'YData', [] );
end

% Allocate an area to draw on
if ( isempty(bins) )
    bins = ceil([nHorizontalBins nVerticalBins ]);
else
    assert ( isnumeric(bins) && isreal(bins), ...
        'Bin counts must be real numbers' );
    assert ( numel(bins) == 2, ...
        'There must be exactly 2 bin values, one for x and one for y' );
    if( bins(1) > nHorizontalBins && bins(2) > nVerticalBins )
        warning ( 'CLOUDPLOT:TOO_MANY_BINS', ...
            'Having bins smaller than one pixel on the screen is not advised' );
    end        
        
end
binSize(2) = diff(yLim)./(bins(2));
binSize(1) = diff(xLim)./(bins(1));

numpoint = zeros(bins);
denpoint = zeros(bins);
% Draw in the canvas
xBinIndex = floor((X - xLim(1))/binSize(1))+1;  %% falling onto which pixel 
yBinIndex = floor((Y - yLim(1))/binSize(2))+1;

% Added security: Make sure indexes are never outside canvas. May not be
% possible.

% pointsSelect = xBinIndex > 0 & xBinIndex <= bins(1) & ...
%     yBinIndex > 0 & yBinIndex <= bins(2);
% xBinIndex = xBinIndex(pointsSelect);
% yBinIndex = yBinIndex(pointsSelect);

xBinIndex(xBinIndex > bins(1)) = bins(1);
yBinIndex(yBinIndex > bins(2)) = bins(2);

for i = 1:numel(xBinIndex)
    numpoint(xBinIndex(i),yBinIndex(i)) = ...
        numpoint(xBinIndex(i),yBinIndex(i)) + 1;
    denpoint(xBinIndex(i),yBinIndex(i)) = ...
        denpoint(xBinIndex(i),yBinIndex(i)) + Z(i);
end

denpoint = denpoint./numpoint;
denpoint( isinf(denpoint) ) = 0;  %%%%%%%%%%%%%%%%% or nan
denpoint( isnan(denpoint) ) = 0;

% Show the canvas and adjust the grids.
if ( useLogScale )
    if (usesmooth)
       Hfilter = fspecial('average',smoothsize);
       denpoint = imfilter(denpoint,Hfilter);        
    end
        h = imagesc(xLim, yLim,log10(denpoint)');
        set(h,'alphadata',~isnan(denpoint'));
else
    if (usesmooth)
       Hfilter = fspecial('average',smoothsize);
       denpoint = imfilter(denpoint,Hfilter);        
    end
    h = imagesc(xLim, yLim, denpoint');    
    set(h,'alphadata',~isnan(denpoint'));
end


axis ( 'xy' );
axis ( 'tight' );
set ( g, 'units', 'normalized' ); % Enable resizing 

% Now set any parameters that were passed to the imagesc object.
numExtraArgs = numel(pvpairs)/2;
assert ( numExtraArgs == round(numExtraArgs), ...
    'Additional arguments must be in name-value pair format' );
for i = 0:(numExtraArgs-1)
    name = pvpairs{2*i+1};
    value = pvpairs{2*i+2};    
    set ( h, name, value );
end

% Optionally return a handle.
if ( nargout >= 1)
    varargout{1} = h;
end
if ( nargout >= 2)
    varargout{2} = denpoint;
end

%% extract the density value to X Y points
pointvalue = X;
%% get rid of nan
denpoint2 = densityvaluematrix;
denpoint2( isnan(denpoint2) ) = 0;

%% normalize the density value to 0-100
maxvalue = max(denpoint2(:));
minvalue = min(denpoint2(:));
denpoint2 = 100.0* (denpoint2-minvalue)/(maxvalue-minvalue);
%% normalize to sum unity *100
% nichesum = sum(denpoint2(:));  
% nicheraw = denpoint2;
% denpoint2  = 100 * nicheraw./nichesum;

for i = 1:numel(xBinIndex)  
    pointvalue(i) = denpoint2(xBinIndex(i),yBinIndex(i));
end

if ( nargout >= 3)
    varargout{3} = pointvalue;
end




