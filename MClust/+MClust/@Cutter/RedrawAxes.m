function RedrawAxes(self, ~, ~)

MCS = MClust.GetSettings();

% Something has changed in the control window, redraw as necessary...

if ~self.get_redrawStatus()
    
    % ADR 2013-12-12 if uncheck redraw axes note that will need to reset window
    if ~isempty(self.CC_displayWindow) && ishandle(self.CC_displayWindow)
        % there's a window
        ax = get(self.CC_displayWindow, 'CurrentAxes');
        xLabel = get(get(ax, 'xlabel'), 'string');
        if xLabel(1) ~= '@'
            xlabel(ax, ['@@@-' xLabel]);
        end
    end
    
else % DRAW IT   
        
    % window for display
    if isempty(self.CC_displayWindow) || ~ishandle(self.CC_displayWindow)
        % create new drawing figure
        self.CC_displayWindow = ...
            figure('Name', 'Cluster Cutting Window',...
            'NumberTitle', 'off', ...
            'Tag', 'CHDrawingAxisWindow', ...
			'Position',MCS.CHDrawingAxisWindow_Pos);        
        MCS.PlaceWindow(self.CC_displayWindow); % ADR 2013-12-12
    else
        % figure already exists -- select it
        figure(self.CC_displayWindow);
    end
       
    % get axes
    xFeat = self.Features{self.get_xAxis};
    yFeat = self.Features{self.get_yAxis};
   
    % get FD data
    xFD = xFeat.GetData();
    yFD = yFeat.GetData();
    
    
    ax = gca;
    % set xLim
    if streq(get(get(ax, 'xlabel'), 'string'), xFeat.name) % ADR 2013-12-12 check if axes have changed
        xLim = get(ax, 'XLim');
    
    elseif MCS.maxZoom > 0 %ETG 2018-05-17 restrict energy and peak window axis scalings to maxZoom
        %adjust x axis range
        if contains(xFeat.name, "Energy") || contains(xFeat.name, "Peak")
            xLim = [min(xFD)-eps, MCS.maxZoom+eps]; 
            
             xMiss = int2str(sum(xFD>MCS.maxZoom));
             xTot = int2str(numel(xFD));
             if xMiss/xTot >= 0.1
                 xMissPercent = num2str(round(100*xMiss/xTot, 2))
                 warning(strcat(xMissPercent, "% of ", xFeat.name, ...
                     " points cut off due to maxZoom setting."));
             end
%             disp(strcat(xMiss, " of ", xTot, " ", xFeat.name, ...
%                 " points cut off due to maxZoom setting."));
        else xLim = [min(xFD)-eps max(xFD)+eps];
        end
    else xLim = [min(xFD)-eps max(xFD)+eps];
    end
    
    %set yLim
    if streq(get(get(ax, 'ylabel'), 'string'), yFeat.name) % ADR 2013-12-12 check if axes have changed
        yLim = get(ax, 'YLim');
        
    elseif MCS.maxZoom > 0
        %adjust y axis range
        if contains(yFeat.name, "Energy") || contains(yFeat.name, "Peak")
            yLim = [min(yFD)-eps, MCS.maxZoom+eps];
            
             yMiss = int2str(sum(yFD>MCS.maxZoom));
             yTot = int2str(numel(yFD));
             if yMiss/yTot >= 0.1
                 yMissPercent = num2str(round(100*yMiss/yTot, 2))
                 warning(strcat(yMissPercent, "% of ", yFeat.name, ...
                     " points cut off due to maxZoom setting."));
             end
%             disp(strcat(yMiss, " of ", yTot, " ", yFeat.name, ...
%                 " points cut off due to maxZoom setting."));
        else yLim = [min(yFD)-eps max(yFD)+eps];
        end        
        
    else yLim = [min(yFD)-eps max(yFD)+eps];
    end
    
    clf;
    ax = axes('Parent', self.CC_displayWindow, ...
        'XLim', xLim, 'YLim', yLim);
    hold on;
    
    % go!
    AllClusters = self.getClusters();
    for iC = 1:length(AllClusters)        
        if ~AllClusters{iC}.hide
            AllClusters{iC}.PlotSelf(xFD, yFD, ax, xFeat, yFeat); 
        end
    end 
    
    xlabel(xFeat.name,'interpreter','none');
    ylabel(yFeat.name,'interpreter','none');
    zoom on
    
end

end