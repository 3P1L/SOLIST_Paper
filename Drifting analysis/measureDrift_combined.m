% this script in meant to be run in /group/erdmann/gaia_perone/Projects/ClassicalLO/TomoDrifting/

% close all; 
clear all; clc;

%% Halfmoon grid
frame_dir = '../231204/frames/231128/';

load('../231204/tomolist.mat');     % automatically named as tomolist

tomo_names_FREE = [];
tomo_names_PIN = [];

for i = 1:2:size(tomolist,2)
    tomo_names_FREE = [tomo_names_FREE ; tomolist(i).stack_name];
    tomo_names_PIN = [tomo_names_PIN ; tomolist(i+1).stack_name];
end

for i = 1:size(tomolist,2)  % loop through every tomogram

frame_names = tomolist(i).frame_names;

stack_names = tomolist(i).stack_name;

tilts = tomolist(i).collected_tilts;

tiltseries_drifts = zeros(size(frame_names,1),2);   % initialize to 0 a matrix that will contain: I column = tilts name ; II column = drift accumulated in that tilt

tiltseries_drifts(:,1) = tilts;

for j = 1:size(frame_names,1)   % loop through every frame (we want to measure the drift in each frame)

    current_frame = frame_names{j};

    current_frame_path = [frame_dir, strrep(current_frame, '.eer', '.xml')];   % points to the file already

    dm = readstruct(current_frame_path);

    m_x = [dm.GridMovementX.Node.ValueAttribute];

    m_y = [dm.GridMovementY.Node.ValueAttribute];

    v = [m_x;m_y];

    drift = sum(vecnorm(v))/10;

    tiltseries_drifts(j,2) = drift;

end

%scatter(tiltseries_drifts(:,1), tiltseries_drifts(:,2))

data(i).tomo = stack_names;
data(i).driftdata = tiltseries_drifts;

end
%% Plot the drift for each tilt divided between FREE or PIN

AllDrift_FREE = [];
AllDrift_PIN = [];

for i = 1 : size(tomolist,2)
    if contains(data(i).tomo,'FREE')
        Drift_FREE = [];
        Drift_FREE = data(i).driftdata;
        Drift_FREE = Drift_FREE(:,2);
        AllDrift_FREE = [AllDrift_FREE; Drift_FREE];

    else
        Drift_PIN = [];
        Drift_PIN = data(i).driftdata;
        Drift_PIN = Drift_PIN(:,2);
        AllDrift_PIN = [AllDrift_PIN; Drift_PIN];
    end
end

AllDrift_FREE_stats = [mean(AllDrift_FREE) std(AllDrift_FREE)];
AllDrift_PIN_stats = [mean(AllDrift_PIN) std(AllDrift_PIN)];

AllDrift_PIN(size(AllDrift_PIN+1):size(AllDrift_FREE)) = nan;
AllDrift_HalfMoon = [AllDrift_FREE AllDrift_PIN];
% figure()
% boxplot(AllDrift_HalfMoon)

%figure()
%boxchart(AllDrift)

% [h,p,~,stats] = ttest2(AllDrift_FREE, AllDrift_PIN)

%% SOLIST
% yeast dataset

frame_dir_SOLIST = 'Yeast/frames/';

load('Yeast/tomolist.mat');     % automatically named as tomolist
tomolist_rand = tomolist(randsample(length(tomolist), 9));

for i = 1:size(tomolist_rand,2)  % loop through every tomogram

frame_names_SOLIST = tomolist_rand(i).frame_names;

stack_names_SOLIST = tomolist_rand(i).stack_name;

tilts_SOLIST = tomolist_rand(i).collected_tilts;

tiltseries_drifts_SOLIST = zeros(size(frame_names_SOLIST,1),2);   % initialize to 0 a matrix that will contain: I column = tilts name ; II column = drift accumulated in that tilt

tiltseries_drifts_SOLIST(:,1) = tilts_SOLIST;

for j = 1:size(frame_names_SOLIST,1)   % loop through every frame (we want to measure the drift in each frame)

    current_frame_SOLIST = frame_names_SOLIST{j};

    current_frame_path_SOLIST = [frame_dir_SOLIST, strrep(current_frame_SOLIST, '.eer', '.xml')];   % points to the file already

    dm_SOLIST = readstruct(current_frame_path_SOLIST);

    m_x_SOLIST = [dm_SOLIST.GridMovementX.Node.ValueAttribute];

    m_y_SOLIST = [dm_SOLIST.GridMovementY.Node.ValueAttribute];

    v_SOLIST = [m_x_SOLIST;m_y_SOLIST];

    drift_SOLIST = sum(vecnorm(v_SOLIST))/10;   % normalize by eer fractionation

    tiltseries_drifts_SOLIST(j,2) = drift_SOLIST;

end

%scatter(tiltseries_drifts(:,1), tiltseries_drifts(:,2))

data_SOLIST(i).tomo = stack_names_SOLIST;
data_SOLIST(i).driftdata = tiltseries_drifts_SOLIST;

end
%% Plot the drift for all the 9 tomograms

AllDrift_SOLIST = [];

for i = 1 : size(tomolist_rand,2)
        Drift_SOLIST = data_SOLIST(i).driftdata(:,2);
        AllDrift_SOLIST = [AllDrift_SOLIST; Drift_SOLIST];
end

AllDrift_stats_SOLIST = [mean(AllDrift_SOLIST) std(AllDrift_SOLIST)];

% figure()
% boxplot(AllDrift_SOLIST)

%figure()
%boxchart(AllDrift_SOLIST)

%% combined tests and plots

AllDrift_SOLIST(size(AllDrift_SOLIST+1):size(AllDrift_FREE)) = nan;
AllDrift = [AllDrift_SOLIST AllDrift_HalfMoon];

figure()
boxplot(AllDrift)

[h,p,~,stats] = ttest2(AllDrift_FREE, AllDrift_PIN)
[h,p,~,stats] = ttest2(AllDrift_FREE, AllDrift_SOLIST)
[h,p,~,stats] = ttest2(AllDrift_PIN, AllDrift_SOLIST)