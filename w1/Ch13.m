x = 1:20; %Create a vector with 20 elements
y = x; %Make y the same as x
z = randn(1,20); %Create a vector of random numbers with same dimensions as x
y = y + z ; %Add z to y, introducing random variation
plot(x,y, '.' ) %Plot the data as a scatter plot
xlabel('Luminance')
ylabel('Firing rate')

p=polyfit(x,y,1) %fits data to a linear, 1st degree polynomial

hold on %Allow 2 plots of the same graph
yFit = x*p(1)+p(2); %Calculate fitted regression line
plot(x,yFit) %Plot regression

x = 0 : 0.1 : 30; %Create a vector from 0 to 10 in steps of 0.1
y = cos (x); %Take the cosine of x, put it into y
z = randn(1,301); %Create random numbers, put it into 301 columns
y = y + z; %Add the noise in z to y
figure %Create a new figure
plot (x,y) %Plot it

mystring = 'p(1) + p(2) * cos ( theta - p(3) )'; %Cosine function in string form
myfun = inline ( mystring, 'p', 'theta' ); %Converts string to a function
p = nlinfit(x, y, myfun, [1 1 0] ); %Least squares curve fit to inline function "myfun"

hold on %allows 2 plots of the same graph
yFit = myfun(p,x); %calculates fitted regression line
plot(x,yFit,'k') %plots regression