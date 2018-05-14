%%
%Hyun's script for visualizing cluster firing around laser pulse
%modified by Elsie for use plotting SG data clustered in MClust
%%


%%preamble
clear; load EVENTS;
%%UI
fnMask = 'VIP-Ai32-NNx-6_20180415_153353'
TT_num = 1;
cluster_start = 1;
cluster_end = 1;


%%
clf;
figure; hold on;
num_clusters = cluster_end - cluster_start + 1
subplot_x = floor(sqrt(num_clusters))
subplot_y = ceil(sqrt(num_clusters))
if subplot_x * subplot_y < num_clusters
    subplot_x = subplot_y
end

offset=.1;
step_size=offset/2;

cluster_list = [cluster_start:cluster_end]
for tt=cluster_list
subplot(subplot_x, subplot_y, find(cluster_list==tt))

%%
%load_string = strcat('TT',num2str(TT_num), '_', num2str(tt), '.mat')
load_string = strcat(fnMask,'.spikes_nt',num2str(TT_num), '_', num2str(tt), '.mat')
load(load_string);

%% Bpod TTLs; 
% CuedReward ---- LightStim = 2, SoundDelivery = 12, Outcome =14 
ON_tmp = find(Events_Nttls==14);   
num_pulses=100; 
%num_pulses = length(ON_tmp)

stim_idx = ON_tmp(1:num_pulses);

events=Events_TimeStamps(stim_idx);
T=TS;

for i=1:round(length(events))
    Allspikes=T(:)-events(i);
    on_spike=Allspikes(Allspikes>=-offset & Allspikes<=offset);
    mycellmat{1,i}=on_spike;
    spike(i).times=on_spike;
    for k = 1:length(on_spike)
        line([on_spike(k) on_spike(k)],[i-1 i],'linewidth',2);
    end
end
line([0 0], [0 length(events)],'color',[.7 .7 .7])

%title_string = strrep(strrep(strrep(load_string, '_','.'), '.mat',''), 'nt','');
title_string = ['Shank ', int2str(TT_num), ', Cluster ', int2str(tt)]
cleanFN = strrep(load_string, '_', '\_')
title({title_string, cleanFN});
axis([-offset offset 0 length(events)])
set(gca,'xtick',[-offset:step_size:offset])
end

