clear all

%data = load('data_worstcase.log');
data = load('data.log');

L = 1;
H = length(data);

T1 = 1;
T2 = data(H, end);
%T1 = 1e5;
%T2 = 1.5e5;

%t = 1:(H-L+1);
t = data(:,end);

banka_i = data(L:H,1)*2.5/(4096*0.005*50);
banka_v = data(L:H,2)*2.5/4096;
banka_p = banka_i.*banka_v;

bankb_i = data(L:H,3)*2.5/(4096*0.005*50);
bankb_v = data(L:H,4)*2.5/4096;
bankb_p = bankb_i.*bankb_v;

bankc_i = data(L:H,5)*2.5/(4096*0.005*50);
bankc_v = data(L:H,6)*2.5/4096;
bankc_p = bankc_i.*bankc_v;

% not currently measured
fpga_i = data(L:H,7)*2.5/(4096*0.010*50); % 10mohm shunt
fpga_v = data(L:H,8)*2.5/4096;
fpga_p = fpga_i.*fpga_v;

sdram_i = data(L:H,9)*2.5/(4096*0.005*50);
sdram_v = data(L:H,10)*2.5/4096;
sdram_p = sdram_i.*sdram_v;

v3_i = data(L:H,11)*2.5/(4096*0.010*50); % 10mohm shunt
v3_v = data(L:H,14)*2.5/4096*3/2; % R divider = 200/(200+100) = 2/3
v3_p = v3_i.*v3_v;

v12_i = data(L:H,12)*2.5/(4096*0.005*50);
v12_v = data(L:H,13)*2.5/4096*6; % R divider = 124/(124+620) = 1/6
v12_p = v12_i.*v12_v;
%-------------------------------

figure;
subplot(3,1,1);
%plot(t, banka_i, 'r');
%hold all;
ax=plotyy(t, banka_v, t, banka_p);

%set(ax(1),'Box','off')
set(ax(2), 'YLim', [0,20]);
set(ax(2), 'YTick',[0:5:20]);
set(ax(1), 'YLim', [0,1.6]);
set(ax(1), 'YTick',[0:0.4:2]);


subplot(3,1,2);
ax=plotyy(t, bankb_v, t, bankb_p);
%set(ax(1),'Box','off')
set(ax(2), 'YLim', [0,20]);
set(ax(2), 'YTick',[0:5:20]);
set(ax(1), 'YLim', [0,1.6]);
set(ax(1), 'YTick',[0:0.4:2]);

subplot(3,1,3);
ax=plotyy(t, bankc_v, t, bankc_p);
%set(ax(1),'Box','off')
set(ax(2), 'YLim', [0,20]);
set(ax(2), 'YTick',[0:5:20]);
set(ax(1), 'YLim', [0,1.6]);
set(ax(1), 'YTick',[0:0.4:2]);

%%
figure;
subplot(6,1,1);
[ax,p1,p2] = plotyy(t, banka_i, t, banka_v);
ylabel(ax(1), 'BankA I(A)');
ylabel(ax(2), 'BankA V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,10]);
set(ax(1), 'YTick',[0:2:10]);
set(ax(2), 'YLim', [0,2]);
set(ax(2), 'YTick',[0:0.5:2])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,2);
plot(t, banka_p);
ylabel('BankA P(W)');
ylim([0 15]);
xlim([T1 T2]);

%---------------------

subplot(6,1,3);
[ax,p1,p2] = plotyy(t, bankb_i, t, bankb_v);
ylabel(ax(1), 'BankB I(A)');
ylabel(ax(2), 'BankB V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,10]);
set(ax(1), 'YTick',[0:2:10]);
set(ax(2), 'YLim', [0,2]);
set(ax(2), 'YTick',[0:0.5:2])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,4);
plot(t, bankb_p);
ylabel('BankB P(W)');
ylim([0 15]);
xlim([T1 T2]);

%---------------------

subplot(6,1,5);
[ax,p1,p2] = plotyy(t, bankc_i, t, bankc_v);
ylabel(ax(1), 'BankC I(A)');
ylabel(ax(2), 'BankC V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,10]);
set(ax(1), 'YTick',[0:2:10]);
set(ax(2), 'YLim', [0,2]);
set(ax(2), 'YTick',[0:0.5:2])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,6);
plot(t, bankc_p);
ylabel('BankC P(W)');
ylim([0 15]);
xlim([T1 T2]);

xlabel('Time (ms)');
%---------------------
%---------------------

figure;
subplot(6,1,1);
[ax,p1,p2] = plotyy(t, sdram_i, t, sdram_v);
ylabel(ax(1), 'SDRAM I(A)');
ylabel(ax(2), 'SDRAM V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,5]);
set(ax(1), 'YTick',[0:1:5]);
set(ax(2), 'YLim', [0,3]);
set(ax(2), 'YTick',[0:3])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,2);
plot(t, sdram_p);
ylabel('SDRAM P(W)');
ylim([0 10]);
xlim([T1 T2]);

%---------------------

subplot(6,1,3);
[ax,p1,p2] = plotyy(t, v3_i, t, v3_v);
ylabel(ax(1), '3.3V I(A)');
ylabel(ax(2), '3.3V V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,5]);
set(ax(1), 'YTick',[0:5]);
set(ax(2), 'YLim', [0,5]);
set(ax(2), 'YTick',[0:5])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,4);
plot(t, v3_p);
ylabel('3.3V P(W)');
ylim([0 10]);
xlim([T1 T2]);

%---------------------

subplot(6,1,5);
[ax,p1,p2] = plotyy(t, v12_i, t, v12_v);
ylabel(ax(1), '12V I(A)');
ylabel(ax(2), '12V V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,10]);
set(ax(1), 'YTick',[0:2:10]);
set(ax(2), 'YLim', [0,16]);
set(ax(2), 'YTick',[0:4:16])
set(ax(1), 'XLim', [T1 T2]);
set(ax(2), 'XLim', [T1 T2]);

subplot(6,1,6);
plot(t, v12_p);
ylabel('12V P(W)');
ylim([0 100]);
xlim([T1 T2]);

xlabel('Time (ms)');

