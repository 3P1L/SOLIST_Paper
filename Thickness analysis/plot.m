% import the table from thickness.xlsx

idx = thickness(:,1);

thick = thickness(:,2);
thick1 = table2array(thick);

%% barplot
x = [1:length(thick1)];

figure(1)
b1 = bar(thick1)
title('Lamella thickness','FontWeight','normal')
xlabel('Lamella')
set(gca, 'XTick',x, 'XTickLabel',x)
ylabel('Thickness [nm]')

saveas(gcf,'Thickness_barplot.pdf')
saveas(gcf,'Thickness_barplot.svg')

%% boxCHART
figure(2)
b2 = boxchart(thick1)
title('Lamella thickness','FontWeight','normal')
ylabel('Thickness [nm]')
% b.JitterOutliers = "on"; % to display differently outliers
% b.MarkerStyle = '.';
ylim([140,260]);

saveas(gcf,'Thickness_boxchart.svg')
saveas(gcf,'Thickness_boxchart.pdf')

%% boxPLOT
figure()
b = boxplot(thick1)
title('Lamella thickness','FontWeight','normal')
ylabel('Thickness [nm]')
ylim([140,260]);

saveas(gcf,'Thickness_boxplot.svg')
saveas(gcf,'Thickness_boxplot.pdf')