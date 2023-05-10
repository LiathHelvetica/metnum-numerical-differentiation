%% Prosty przykład 

f = @(x) x^3;
df = @(x) 3 * x^2;

x = 2;
h = 0.01;

D_f1(f, x, h);
df(x);

%% zmiana h

f = @sin;
df = @cos;

x = pi / 4;
h = logspace(0, -10, 11);

out = arrayfun(@(h) D_f1(f, x, h), h);
err = abs(out - df(x));

figure;
loglog(abs(out(2:11) - out(1:10)));
title("Różnice kolejnych wartości (sin(x), różne h)")

figure;
loglog(err);
title("Różnice między wartością rzeczywistą (sin(x), różne h)")

x_plot = linspace(0, pi / 2, 100);
figure;
plot(x_plot, arrayfun(f, x_plot))
hold on;
plot(x, f(x), '.', 'MarkerSize',10);

df1 = @(x_in) out(1) * x_in + (f(x) - out(1) * x);
df2 = @(x_in) out(2) * x_in + (f(x) - out(2) * x);
df3 = @(x_in) out(9) * x_in + (f(x) - out(9) * x);

hold on;
p3 = plot(x_plot, arrayfun(df1, x_plot));
hold on;
p4 = plot(x_plot, arrayfun(df2, x_plot));
hold on;
p5 = plot(x_plot, arrayfun(df3, x_plot));
title("Naniesione pochodne na sin(x), różne h")
legend([p3, p4, p5], ["h = 10e-0", "h = 10e-1", "h = 10e-9"])

%% zmiana stopnia Richardsona

f = @sin;
df = @cos;

x = pi / 4;
h = 1e-1;
n = 1:1:10;

out = arrayfun(@(n) D_f_rich(f, n, x, h), n);
err = abs(out - df(x));

figure;
semilogy(abs(out(2:10) - out(1:9)));
title("Różnice kolejnych wartości (sin(x), różne stopnie Richardsona)")

figure;
semilogy(err);
title("Różnice między wartością rzeczywistą (sin(x), różne stopnie Richardsona)")

%% aproksymacja 

f = @(x) 3*x^4 + 4*x^3 + x;
df = @(x) 12*x^3 + 12*x^2 + 1;

x = (1:0.1:2) - rand(1, 11) / 5;
y = arrayfun(f, x);
y_with_err = arrayfun(f, x) - rand(1, 11);

p = polyfit(x, y_with_err, 4);

figure;
plot(x, polyval(p, x))
hold on;
plot(x, y)
title("Różnice między aproksymacją a oryginalnymi wartościami")

p_d = polyder(p);
figure;
plot(x, polyval(p_d, x))
hold on;
plot(x, arrayfun(df, x))
title("Różnice między pochodną aproksymacji a oryginalną pochodną")

%% mniejszy stopień aproksymacji

f = @(x) 3*x^2 + sin(x) + 2 * cos(x);
df = @(x) 6 * x + cos(x) - 2 * sin(x);

x = (1:0.1:2) - rand(1, 11) / 5;
y = arrayfun(f, x);
y_with_err = arrayfun(f, x) - rand(1, 11) / 10;

p = polyfit(x, y_with_err, 3);

figure;
plot(x, polyval(p, x))
hold on;
plot(x, y)
title("Różnice między aproksymacją (2) a oryginalnymi wartościami")

p_d = polyder(p);
figure;
plot(x, polyval(p_d, x))
hold on;
plot(x, arrayfun(df, x))
title("Różnice między pochodną aproksymacji (2) a oryginalną pochodną")

%%

function out = D_f1(f, x, h)
	out = (f(x + h) - f(x)) / h;
end

function out = D_f_rich(f, n, x, h)
	if n == 1
		out = D_f1(f, x, h);
	else
		out = (2^(n-1) * D_f_rich(f, n - 1, x, h) - D_f_rich(f, n - 1, x, 2 * h)) / (2^(n-1) - 1);
	end
end