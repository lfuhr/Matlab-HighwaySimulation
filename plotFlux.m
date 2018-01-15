function [] = plotFlux( results, legends )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

figure
subplot(2,1,1)
hold on;
subplot(2,1,2)
hold on;
plots=[];
colors={'blue' 'magenta' 'cyan' 'red' 'black'};


for iResults = 1:length(results(:,1))
    rhosHighway=results{iResults,2};
    fluxs=results{iResults,3};
    for iPlot = 1:2
        for iFlux = 1:length(fluxs)
            subplot(2,1,iPlot)
            if iFlux == 1 && iPlot == 1
                plots(end + 1) = scatter(rhosHighway(iFlux),fluxs(iFlux,iPlot),colors{iResults},'filled');
            else
                scatter(rhosHighway(iFlux),fluxs(iFlux,iPlot),colors{iResults},'filled');
            end
            if iFlux > 1
                plot([rhosHighway(iFlux-1) rhosHighway(iFlux)], [fluxs(iFlux-1,iPlot) fluxs(iFlux,iPlot)],colors{iResults});
            end
        end
    end    
end

subplot(2,1,1)
legend(plots,legends);
ylabel('mean(v)');
subplot(2,1,2)
legend(plots,legends);
xlabel('Dichte/ rho');
ylabel('Fluss');
end

