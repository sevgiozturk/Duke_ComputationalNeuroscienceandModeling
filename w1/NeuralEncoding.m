
clear all
close all
clc
load('Chapter13_CenterOutTrain.mat')
neuronNum = 78;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR THE INSTRUCTION CUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h=figure('name','Instruction Time Raster Plots'); %Create a new figure
set(h,'OuterPosition',[50,50,900,700]);
hold on %Allow multiple plots on the same graph

plotArea = [6 3 2 1 4 7 8 9];
minGlobal = 0;
binSize = 0.1; % 100 ms
edges = [-1:binSize:1]; %Define the edges of the histogram
psth = zeros(2/binSize+1,8); %Initialize the PSTH with zeros
firingRates = zeros(8,1);

for i=1:8   % For every ANGLE
    angleTrials = find(direction==i); % For every degree, find its trial indexes
    instTimes = instruction(angleTrials);
    subplot(3,3,plotArea(i));
    for j=neuronNum:neuronNum %length(unit)
        for k=1:length(instTimes) % Actually this is TrialCount for this degree(i)
            
            % 0.5 ms before the Instruction Cue and 1 ms after the Instruction Cue
            startPt = instTimes(k)-1;
            endPt = instTimes(k)+1;
            indexes = find( startPt<unit(j).times & endPt>unit(j).times );
            if ~isempty(indexes)
                matchSpikes = unit(j).times(indexes);
                matchSpikes = matchSpikes - instTimes(k); % SHIFT Instruction Time to ZERO
                minLocal = min(matchSpikes);
                if minGlobal>minLocal
                    minGlobal = minLocal;
                end
                
                for m=1:length(matchSpikes)
                    lo = (k-1)*0.5; % upper limit of line height
                    hi = k*0.5; % upper limit of line height
                    % RASTER PLOT
                    line([matchSpikes(m) matchSpikes(m)], [lo hi]); %Create a tick mark at x = t(i) with a height of 1
                end                
                psth(:,i) = psth(:,i)+histc(matchSpikes,edges);                
            end 
        end
        fr = sum(psth(:,i))/(length(instTimes)*2); % Gives the Spike/Sec. Divide by length(instTimes)=TrialCount ==> mean other than zeros, divide 2 sec.
        firingRates(i) = fr;
    end
    xlim([-1 1]);
    xlabel('Time (sec)') %Label x-axis
    ylabel('# of Trials') %Label y-axis
end
h2 = subplot(3,3,5);
text(.2,.5,strcat('Chan ',num2str(unit(neuronNum).chanNum),'-',num2str(unit(neuronNum).unitNum)),'FontSize',16, 'Parent',h2);
xlabel('Time (sec)') %Label x-axis

h = figure('name','Instruction Time PSTH Plots');
set(h,'OuterPosition',[50,50,900,700]);
hold on

for i=1:8   % For every ANGLE
    subplot(3,3,plotArea(i));
    bar(edges,psth(:,i)); %Plot PSTH as a bar graph
    xlim([-1 1]); %Set limits of X-axis
    xlabel('Time (sec)') %Label x-axis
    ylabel('# of spikes') %Label y-axis
end
h2 = subplot(3,3,5);
text(.2,.5,strcat('Chan ',num2str(unit(neuronNum).chanNum),'-',num2str(unit(neuronNum).unitNum)),'FontSize',16, 'Parent',h2);
xlabel('Time (sec)') %Label x-axis

h = figure('name','Instruction Time Tuning Curve (Fitted)');
set(h,'OuterPosition',[50,50,900,700]);
x = [0;45;90;135;180;225;270;315];
plot(x,firingRates,'o');
xlim([0 360]);
xlabel('Degree') %Label x-axis
ylabel('Firing Rate') %Label x-axis

%#################################################################################
%## TODO for students:
%# Fill out function and remove
ME = MException('cosFit:NotImplementedError','Student exercise: implement cosine fit function and execute it with parameters');
throw(ME);
%#################################################################################
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FOR THE GO CUE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure('name','GO Time Raster Plots');
set(h,'OuterPosition',[50,50,900,700]);
psth = zeros(2/binSize+1,8); %Initialize the PSTH with zeros
hold on

firingRates = zeros(8,1);
for i=1:8   % For every ANGLE
    angleTrials = find(direction==i); % For every degree, find its trial indexes
    goTimes = go(angleTrials);
    subplot(3,3,plotArea(i));
    for j=neuronNum:neuronNum %length(unit)
        
        for k=1:length(goTimes) % Actually this is TrialCount for this degree(i)
            
            % 0.5 ms before the Instruction Cue and 1 ms after the Instruction Cue
            startPt = goTimes(k)-1;
            endPt = goTimes(k)+1;
            indexes = find( startPt<unit(j).times & endPt>unit(j).times );
            if ~isempty(indexes)
                matchSpikes = unit(j).times(indexes);
                matchSpikes = matchSpikes - goTimes(k); % SHIFT GO Time to ZERO
                minLocal = min(matchSpikes);
                if minGlobal>minLocal
                    minGlobal = minLocal;
                end
                
                for m=1:length(matchSpikes)
                    lo = (k-1)*0.5; % upper limit of line height
                    hi = k*0.5; % upper limit of line height
                    % RASTER PLOT
                    line([matchSpikes(m) matchSpikes(m)], [lo hi]); %Create a tick mark at x = t(i) with a height of 1
                end
                
                psth(:,i) = psth(:,i)+histc(matchSpikes,edges);
            end 
        end
        fr = sum(psth(:,i))/(length(goTimes)*2); % Gives the Spike/Sec. Divide by length(instTimes)=TrialCount ==> mean other than zeros, divide 2 sec.
        firingRates(i) = fr;
    end
    xlim([-1 1]);
    xlabel('Time (sec)') %Label x-axis
    ylabel('# of Trials') %Label y-axis
end
h2 = subplot(3,3,5);
text(.2,.5,strcat('Chan ',num2str(unit(neuronNum).chanNum),'-',num2str(unit(neuronNum).unitNum)),'FontSize',16, 'Parent',h2);
%ylim([0 5]) %Reformat y-axis for legibility
xlabel('Time (sec)') %Label x-axis

h = figure('name','GO Time PSTH Plots');
set(h,'OuterPosition',[50,50,900,700]);

for i=1:8   % For every ANGLE
    subplot(3,3,plotArea(i));
    bar(edges,psth(:,i)); %Plot PSTH as a bar graph
    xlim([-1 1]);
    xlabel('Time (sec)') %Label x-axis
    ylabel('# of spikes') %Label y-axis
end

h2 = subplot(3,3,5);
hold on
text(.2,.5,strcat('Chan ',num2str(unit(neuronNum).chanNum),'-',num2str(unit(neuronNum).unitNum)),'FontSize',16, 'Parent',h2);
xlabel('Time (sec)') %Label x-axis

h = figure('name','Go Time Tuning Curve (Fitted)');
set(h,'OuterPosition',[50,50,900,700]);
x = [0;45;90;135;180;225;270;315];
plot(x,firingRates,'o');
xlim([0 360]);
xlabel('Degree') %Label x-axis
ylabel('Firing Rate') %Label x-axis

%#################################################################################
%## TODO for students:
%# Fill out function and remove
ME = MException('cosFit:NotImplementedError','Student exercise: implement cosine fit function and execute it with parameters');
throw(ME);
%#################################################################################

