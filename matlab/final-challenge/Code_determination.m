clear all;
close all;
N = 32;
number = 29;
checknumb = 13;
Begin_plot = 30;
Max_plots = 31;
n_colors = Max_plots-Begin_plot +3;
colors = distinguishable_colors(n_colors);
i = Begin_plot;
Hadmatrix = hadamard(N);

T = (-N+1:N-1);

figure;
Codmatrix = Hadmatrix;
Codmatrix(Codmatrix == -1) = 0;

while i <= Max_plots
    
AutoCode = conv(Codmatrix(:,i),fliplr(Codmatrix(:,i)));
plot(T,abs(AutoCode), 'Color', colors(i-28,:));
hold on
xlim([-31,31]);
ylim([0 18]);
title(strcat('Auto correlation plots of different Hadamard codes'));
xlabel('Lags');
ylabel('Amplitude');
i = i + 1;
end

k =1;
j = 1;
while j <= 2
    CheckCode = randi([0 1],1,32);
    i = Begin_plot;
    while i <= Max_plots

        CrossB = conv(Codmatrix(i,:),CheckCode);
        plot(T,abs(CrossB), 'Color',colors(k,:));
        xlim([-31,31]);
        hold on
        i = i +1;
        k = k +1;
    end
    hold on;
    
j = j +1;
end
title('Cross correlation plots of different Hadamard codes and two different random bitcodes');
xlabel('Lags');
ylabel('Amplitude');
legend('Code number 30, Randomcode 1', 'Code number 31, Randomcode 1', 'Code number 30, Randomcode 2', 'Code number 31, Randomcode 2');


hex = binaryVectorToHex(Codmatrix(31,:))


