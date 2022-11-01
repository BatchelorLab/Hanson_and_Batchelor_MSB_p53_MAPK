% ----------------------------------------------------------------------- %
% Function plot_areaerrorbar plots the mean and standard deviation of a   %
% set of data filling the space between the positive and negative mean    %
% error using a semi-transparent background, completely customizable.     %
%                                                                         %
%   Input parameters:                                                     %
%       - data:     Data matrix, with rows corresponding to observations  %
%                   and columns to samples.                               %
%       - options:  (Optional) Struct that contains the customized params.%
%           * options.handle:       Figure handle to plot the result.     %
%           * options.color_area:   RGB color of the filled area.         %
%           * options.color_line:   RGB color of the mean line.           %
%           * options.alpha:        Alpha value for transparency.         %
%           * options.line_width:   Mean line width.                      %
%           * options.x_axis:       X time vector.                        %
%           * options.error:        Type of error to plot (+/-).          %
%                   if 'std',       one standard deviation;               %
%                   if 'sem',       standard error mean;                  %
%                   if 'var',       one variance;                         %
%                   if 'c95',       95% confidence interval.              %
% ----------------------------------------------------------------------- %
%   Example of use:                                                       %
%       data = repmat(sin(1:0.01:2*pi),100,1);                            %
%       data = data + randn(size(data));                                  %
%       plot_areaerrorbar(data);                                          %
% ----------------------------------------------------------------------- %
%   Author:  Victor Martinez-Cagigal                                      %
%   Date:    30/04/2018                                                   %
%   E-mail:  vicmarcag (at) gmail (dot) com                               %
% ----------------------------------------------------------------------- %
function plot_areaerrorbar2(data, varargin)
    p=inputParser;
    addParameter(p,'Xaxis',1:size(data,2),@isnumeric);
    addParameter(p,'Error','std',@ischar);
    addParameter(p,'Alpha',0.5,@isnumeric);
    addParameter(p,'LineWidth',2,@isnumeric);
    addParameter(p,'LineColor','b',@ischar);
    addParameter(p,'AreaColor','b',@ischar);
    p.KeepUnmatched = true;
    parse(p,varargin{:});
    Xaxis = p.Results.Xaxis;
    Error = p.Results.Error;
    Alpha=p.Results.Alpha;
    LineSize=p.Results.LineWidth;
    Color=p.Results.LineColor;
    AreaColor=p.Results.AreaColor;
    
    
    % Default options
%     if(nargin<2)
%         options.handle     = figure(1);
%         options.color_area = [128 193 219]./255;    % Blue theme
%         options.color_line = [ 52 148 186]./255;
%         %options.color_area = [243 169 114]./255;    % Orange theme
%         %options.color_line = [236 112  22]./255;
%         options.alpha      = 0.5;
%         options.line_width = 2;
%         options.error      = 'std';
%     end
%     if(isfield(options,'x_axis')==0), options.x_axis = 1:size(data,2); end
%     options.x_axis = options.x_axis(:);
    
    % Computing the mean and standard deviation of the data matrix
    data_mean = nanmean(data,1);
    data_std  = nanstd(data,0,1);
    if strcmp(Error,'std')==1
    
    error = data_std;
    elseif strcmp(Error,'sem')==1
        error = (data_std./sqrt(size(data,1)));
    elseif strcmp(Error,'var')==1
        error = (data_std.^2);
    elseif strcmp(Error,'c95')==1
        error = (data_std./sqrt(size(data,1))).*1.96;
    end
    % Type of error plot
%     switch(options.error)
%         case 'std', error = data_std;
%         case 'sem', error = (data_std./sqrt(size(data,1)));
%         case 'var', error = (data_std.^2);
%         case 'c95', error = (data_std./sqrt(size(data,1))).*1.96;
%     end
    
    % Plotting the result
%     figure();
%%corrected to account for potential NaN
    x_vector = [Xaxis(~isnan(data_std)), fliplr(Xaxis(~isnan(data_std)))];
    patch = fill(x_vector, [data_mean(~isnan(data_std))+error(~isnan(error)),fliplr(data_mean(~isnan(data_mean))-error(~isnan(error)))], AreaColor);
    set(patch, 'edgecolor', 'none');
    set(patch, 'FaceAlpha', Alpha);
    hold on;
    plot(Xaxis, data_mean, 'color', Color, ...
        'LineWidth', LineSize);
%     hold off;
    
end