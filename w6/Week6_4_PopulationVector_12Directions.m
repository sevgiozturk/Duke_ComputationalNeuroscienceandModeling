
close all
clear all
load('computationalcourse_230712_V1_data_SG.mat')

global radius
data = data.*2;

cosStr = 'p(1) + p(2) * cos ( theta - p(3) )'; %Cosine function in string form
cosFun = inline(cosStr,'p','theta'); %Converts string to a function

radian = [0 pi/6 pi/3 pi/2 2*pi/3 5*pi/6 pi 7*pi/6 4*pi/3 3*pi/2 5*pi/3 11*pi/6];
degree = 180*radian/pi;

tuningDirections = zeros(size(data,1),1);
fittedFiringRates = zeros(size(data,1),1);
for indNeuron=1:size(data,1)
    [beta,R,J,CovB,MSE,ErrorModelInfo] = ... % call nlinfit() here (Least squares curve fit to inline function "cosFun")
    %## TODO for students:
    %# Fill out function and remove
    ME = MException('cosFit:NotImplementedError','Student exercise: call nlinfit for cosine fit function and execute it with parameters');
    throw(ME);

    yFit = cosFun(beta,radian);
    fittedFiringRates(indNeuron) = max(yFit);
    tuningDirections(indNeuron) = radian(find(yFit==max(yFit))); % Preferred direction in Radyan
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DRAWINGS ABOUT DATA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

h = figure('name','Direction Estimation');
set(h,'OuterPosition',[50,50,900,700]);
radius = 2;
upLimit = 10;

initCircle([0 0]);
xlim([-upLimit upLimit]);
ylim([-upLimit upLimit]);
hold on;

popVectorX = 0;
popVectorY = 0;

observeXs = zeros(1,length(tuningDirections));
% Population Vector
for n=1:length(tuningDirections)
    preferredDir = tuningDirections(n);
    w = fittedFiringRates(n);    
      
    x = cos(preferredDir) * w;
    y = sin(preferredDir) * w;
    vectorOnCircle(x,y,preferredDir);
    
    observeXs(n) = x;
    popVectorX = popVectorX + x;
    popVectorY = popVectorY + y;
end

plot([0 popVectorX], [0 popVectorY], 'Color',[1,0,0], 'LineWidth',3);
popVector = sqrt(popVectorX*popVectorX + popVectorY*popVectorY);
theta = 180*atan(popVectorY/popVectorX)/pi;
if theta<0
    theta = theta + 180;
end
title(['Population Vector Magnitude = ' num2str(popVector,4) '  \theta = ' num2str(theta,3)],'FontWeight','Bold','FontSize',12,'Interpreter','tex');

function [x,y] = initCircle(center)  
    global radius
    xCenter = center(1);
    yCenter = center(2);
    theta = 0 : 0.01 : 2*pi;
    inputDegrees = 0 : pi/6 : 2*pi;
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

function vectorOnCircle(x, y, theta)
    global radius
    
    x1 = radius*cos(theta);
    x2 = x1 + x;
    
    y1 = radius*sin(theta);    
    y2 = y1 + y;
        
    jitter = rand(1)*.5;
     
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