%% general percentages
t1 = 'Rough milling';
t2 = 'Thin milling';
t3 = 'TEM';
x = categorical({t1,t2,t3});
x = reordercats(x,{t1,t2,t3});

y = [94,91,90];

figure
b = bar(x,y);

title('Survival rate','FontWeight','normal')
ylabel('%')

saveas(gcf,'Survival_percentage.pdf')
saveas(gcf,'Survival_percentage.svg')

xtips = b(1).XEndPoints;
ytips = b(1).YEndPoints;
labels = string(b(1).YData);
text(xtips,ytips,labels,'HorizontalAlignment','center','VerticalAlignment','bottom')


%% without Stellaris (percentage)
rough_mill = 91; % from attaching to TEM
TEM = 90; % suitable for TEM
y = [rough_mill,TEM];
x = [1,2];
% figure
% bar(x,y)

%% without Stellaris (numbers)
t1 = 'attached';
t2 = 'survived';
t3 = 'TEM';
x = categorical({t1,t2,t3});
x = reordercats(x,{t1,t2,t3});

y = [46,42,38];

% figure
% bar(x,y)
