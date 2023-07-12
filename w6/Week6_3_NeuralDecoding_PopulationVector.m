clear all
close all
clc
load('Chapter16_CenterOutTest.mat')
neuronIndexStart = 65;
neuronIndexEnd = 143;
size = neuronIndexEnd-neuronIndexStart;
% Wi = ki*cos(Qm-Qi) + bi;  where k is the pick point in the function if
% Qm=Qi which means Qm(happened) and Qi(predicted) values match
cosStr = 'p(1) + p(2) * cos ( theta - p(3) )'; %Cosine function in string form
cosFun = inline(cosStr,'p','theta'); %Converts string to a function

tuningDirections = zeros(size,1);
firingRates = zeros(8,size);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    ESTIMATION BASED ON DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

radian = [0;pi/4;pi/2;3*pi/4;pi;5*pi/4;3*pi/2;7*pi/4];
%degree = [0;45;90;135;180;225;270;315];

for j=neuronIndexStart+1:length(unit) % neuronNum
    neuronIndex = j-neuronIndexStart;    
        
    for i=1:8   % For every direction
        angleTrials = find(direction==i); % For every degree, find its trial indexes
        instTimes = instruction(angleTrials);    
        spikeCount = 0;
        for k=1:length(instTimes) % Actually this is TrialCount for this degree(i)

            % 1 ms after the Instruction Cue
            startPt = instTimes(k);
            endPt = instTimes(k)+1;
            indexes = find( startPt<unit(j).times & endPt>unit(j).times );
            if ~isempty(indexes)                
                spikeCount = spikeCount + length(indexes);
            end 
        end
        fr = spikeCount/length(instTimes); % Gives the Spike/Sec. Divide by length(instTimes)=TrialCount
        firingRates(i,neuronIndex) = fr;       
    end
    
    
    %   cosStr = 'p(1) + p(2) * cos ( theta - p(3) )';
    [beta,R,J,CovB,MSE,ErrorModelInfo] = nlinfit(radian, firingRates(:,neuronIndex), cosFun, [1 1 0] ); %Least squares curve fit to inline function "cosFun"
    yFit = cosFun(beta,radian);
    tuningDirections(neuronIndex) = radian(find(yFit==max(yFit))); % Preferred direction in Radyan
           
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DRAWINGS ABOUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure('name','Direction Estimation');
set(h,'OuterPosition',[50,50,900,700]);
radius = 5;
upLimit = 30;

initCircle([0 0], radius);
xlim([-upLimit upLimit]);
ylim([-upLimit upLimit]);
hold on;

popVectorX = 0;
popVectorY = 0;

% Population Vector
for n=1:neuronIndex
    preferredDir = tuningDirections(n);
    ind = find (radian == tuningDirections(n));
    w = firingRates(ind,n);    
      
    x = cos(preferredDir) * w;
    y = sin(preferredDir) * w;
    vectorOnCircle(radius, preferredDir,w);
    
    popVectorX = popVectorX + x;
    popVectorY = popVectorY + y;
end

plot([0 popVectorX], [0 popVectorY], 'Color',[1,0,0], 'LineWidth',6);
popVector = sqrt(popVectorX*popVectorX + popVectorY*popVectorY);
theta = 180*atan(popVectorY/popVectorX)/pi;
if theta<0
    theta = theta + 180;
end
title(['Population Vector Magnitude = ' num2str(popVector,4) '  \theta = ' num2str(theta,3)],'FontWeight','Bold','FontSize',12,'Interpreter','tex');

function [x,y] = initCircle(center, radius)    
    xCenter = center(1);
    yCenter = center(2);
    theta = 0 : 0.01 : 2*pi;
    inputDegrees = 0 : pi/4 : 2*pi;
    x = radius * cos(theta) + xCenter;
    y = radius * sin(theta) + yCenter;

    xInput = radius * cos(inputDegrees) + xCenter;
    yInput = radius * sin(inputDegrees) + yCenter;

    plot(x, y);
    hold on;
    plot(xInput, yInput,'o');
    axis square;    
    grid on;
end

function [x2,y2] = vectorOnCircle(radius, radian, magnitude)
    
    x1 = radius * cos(radian);
    y1 = radius * sin(radian);
        
    spread = rand(1)*2;
        
    x2 = (magnitude+radius) * cos(radian);
    y2 = (magnitude+radius) * sin(radian); 

    jitter = rand(1);
     
    if x2<0
        x2 = x2-jitter;
    else
        x2 = x2+jitter;
    end
    if y2<0
        y2 = y2-jitter;
    else
        y2 = y2+jitter;
    end        
    plot([x1 x2], [y1 y2], 'Color',[rand(1),rand(1),rand(1)], 'LineWidth',2);
        
    axis square;
    grid on;
end