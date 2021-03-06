function this = plotAll(this, type, varargin)

if nargin < 3, mode = 'TRAJ'; 
else mode = varargin{1};
end

if length(varargin)>1
    split = varargin{2};
else
    split = 9;
end

import AMF.utils.defineCustomColormap

comps = this.(type);
if strcmpi(type, 'PARAMETERS')
    comps = comps(logical([this.parameters.fit]));
end


n = length(comps);
ns = sqrt(split);
% ns = sqrt(n);

numIter = this.options.numIter;

figure('Name', upper(type));

for i = 1:n
    figure(ceil(i/split));
    counter = ceil(i/split);
    subplot(ceil(ns),ceil(ns),i-(counter-1)*split); hold on;
%     subplot(ceil(ns),ceil(ns),i); hold on;

    comp = comps(i);
    
    switch upper(mode)
        case 'TRAJ'
            colorMap = defineCustomColormap({[0.8 0.6 0.6] [0.8 0 0] [0.2 0 0]}, numIter);
            plotTraj(this, comp, colorMap);
            
        case 'HIST'
            colorMap = defineCustomColormap({[1 1 1] [0.8 0 0] [0.2 0 0]}, numIter);
            plotHist(this, comp, colorMap);
            
        case 'HIST_LOG'
          % TODO: plot logarithmic histograms
        case 'MAD' % median absolute deviation
            plotMad(this, comp, 'g');

        otherwise
            error('Unknown plot mode %s', mode);
    end
    
    xlabel([this.predictor.unitType, ' [', this.predictor.unit, ']']);
    xlim([this.time(1) this.time(end)]);

    if comp.label
        title(comp.label);
    else
        title(comp.name);
    end

    if comp.unit
        ylabel(sprintf('%s [%s]', comp.unitType, comp.unit));
    else
        ylabel(comp.unitType);
    end
end