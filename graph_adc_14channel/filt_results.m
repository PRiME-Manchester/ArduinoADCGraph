clear all;

data2=load('data2.log');
i=data2(:,1)*2.5/(4096*0.005*50);
v=data2(:,2)*2.5/4096;

%filter data (x32)
filt_size=32;
m=1;
for k=1:length(i)/filt_size
   i_filt(k) = sum(i(m:m+filt_size-1))/filt_size;
   v_filt(k) = sum(v(m:m+filt_size-1))/filt_size;
   m = m + filt_size;
end
p_filt = i_filt.*v_filt;
t=1:length(i_filt);

figure;
subplot(2,1,1);
[ax,p1,p2] = plotyy(t, i_filt, t, v_filt);
ylabel(ax(1), 'BankA I(A)');
ylabel(ax(2), 'BankA V(V)');

set(ax(1),'Box','off')
set(ax(1), 'YLim', [0,10]);
set(ax(1), 'YTick',[0:2:10]);
set(ax(2), 'YLim', [0,2]);
set(ax(2), 'YTick',[0:0.5:2])

subplot(2,1,2);
plot(p_filt);
ylabel('BankA P(W)');
ylim([0 10]);
