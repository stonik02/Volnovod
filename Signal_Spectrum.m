% 1. Алгоритм как все делал.
% 2. Написать что был такой исходный сигнал при таких параметрах, вот
% принятый сигнал, такая-то мода, такая глубина такая-то дальность
% распространения. Наша рограмма при моделировании учитывает что меняется
% форма сигнала.
% 3. Менять разные параметры и скринить графики что вот,, при 50 метрах вот
% так исказился сигнал, а при 200 вот так. Для 1 моды вот такой принятый
% сигнал, для 2 моды такой. Менять парметры по 1, чтобы было видно что это
% он влияет. Номер моды глубина частота сигнала, дальность распространения.
% Разницу частот есть chirp, среднюю частоту. Синусоиду с одной амплитудой,
% а потом с другой или меняющейся. Спектр сигнала рисовать. Можно рисовать
% график зависимости графика Wk от частоты. Те составляющие спектра у
% которых частота ниже Для каких-то частот фазовая скорость моды выше скорости
% звука в дне, то такие частоты на приемник не приходят и мы их зануляем. 
% 4. Теория: На гугл диске. Заключение: мы написали программу, что она
% делает, что мы протестировали, что при изменении такого параметра то
% меняется, при изменении того параметра сильнее искажение и тд. Можно
% попробовать блок схему программы нарисовать.
% Презентация в паверпоинте и словесную

% Презентация чтобы те кто слушал что бы они поняли что моя работа не
% просто реферат из инета, а что мы сами что то проделывали. Программу
% писали, моделировали. Наш конкретный вклад. Выступление 

% Сделать частоту 300 и сказать, что целиком поглотилось дном

% Параметры сигнала
Fs = 600;        % Частота дискретизации 
T = 1/Fs;        % Период дискретизации
t1 = 0:T:1;      % Ось длительности сигнала 
t2 = 0:T:8;      % Временная ось 
c = 1500;        % Скорость звука
H = 100;         % Глубина
L = 10000;       % Длинна трассы
l = 4;           % Мода
N = length(t1); % размер оси длительности сигнала
NN = length(t2); % размер временной оси 
f1 = 100;        % Частота сигнала 
c1 = 1700;       % Максимальная приемлимая скорость звука

% Сигналы

% Множество разных частот
%   s = zeros(size(t1));
%   for i = 1:length(f2)
%       s = s + sin(2*pi*f2(i)*t1);
%   end

%Создание чирп-сигнала (Повышение частоты со временем)
% s = chirp(t1, 100, 1, 200, 'linear');

% Амплитуда const
% s = sin(2*pi*f1*t1);
% Обычный
s = (1-2*t1/2).*sin(2*pi*f1*t1);

% s = (2+3*t1).*sin(5*pi*500*t1);

s = [s, zeros(1, NN-N)];

% Длина сигнала
N = length(s); 

delta_f = [0:N-1]*Fs/N;

Wk = 2*pi*delta_f; 


% Волновое число моды
ql = sqrt(Wk.^2/c^2 - pi^2/H^2*(l-1/2)^2);
ql = real(ql);
rr = Wk./ql; % Фазовая скорость моды

% Построение изначальной функции
%  figure;
%  plot(ql, Wk);
%  xlabel('ql (секунды)');
%  ylabel('wk');
%  title('ql/Wk');

% Ось частот (Гц)
f = (0:N-1)*(Fs/N);


% Фурье
S = fft(s);
% Потери принятого сигнала
SS = S(2:N/2+1).*exp(-1i*ql(2:N/2+1)*L); % Первая половина принятого сигнала
for i = 1:length(rr/2)
     if rr(i) > c1 
         SS(i) = 0;  
     end
 end
SS2 = conj(fliplr(SS));
% SS(1:361) = 0;
% SS2(2640:3000) = 0;
S = [0, SS, SS2];


% Обратное преобразование Фурье
s_reconstructed = ifft(S); 

% Построение изначальной функции
figure;
subplot(2,1,1);
plot(t2, s);
xlabel('Время (секунды)');
ylabel('Амплитуда');
title('Исходный сигнал');

% Построение графика полученного сигнала
subplot(2,1,2);
plot(t2, real(s_reconstructed));
xlabel('Время (секунды)');
ylabel('Амплитуда');
title('Принятый сигнал');


% Построение изначальной функции вблизи
figure;
subplot(2,1,1);
plot(t2, s);
xlabel('Время (секунды)');
ylabel('Амплитуда');
title('Исходный сигнал приближенный');
axis([0, 1, -1, 1]); % Задайте свои пределы для осей x и y

% Построение графика полученного сигнала
subplot(2,1,2);
plot(t2, real(s_reconstructed));
xlabel('Время (секунды)');
ylabel('Амплитуда');
title('Принятый сигнал приближенный');
if L == 10000
    axis([6.6, 7.7, -1, 1]); % Задайте свои пределы для осей x и y 10000м
end

if L == 5000
    axis([3.2, 4.4, -1, 1]); % Задайте свои пределы для осей x и y 5000м
end

if L == 1000
    axis([0.5, 1.7, -1, 1]); % Задайте свои пределы для осей x и y 5000м
end

