% グローバル変数：obj_two_period.m, obj_projection.mと変数を共有
% global w grid_w beta gamma rent

%% *** カリブレーション ***
beta  = 0.985.^30;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^30-1.0; % 純利子率

% *** パラメータ ***
nw    =  10;   % 所得グリッドの数
w_max = 1.0;   % 所得グリッドの最大値
w_min = 0.1;   % 所得グリッドの最小値
na    =  400;   % 貯蓄グリッドの数
a_max = 1.0;   % 貯蓄グリッドの最大値
a_min = 0.025; % 貯蓄グリッドの最小値

%% グリッドポイントを計算
grid_w = linspace(w_min, w_max, nw)';
grid_a = linspace(a_min, a_max, na)';

%% あらゆる(w,a)の組み合わせについて生涯効用を計算
obj = zeros(na, nw);

for i = 1:nw
    for j = 1:na
        cons = grid_w(i) - grid_a(j);
        if cons > 0.0
            obj(j, i) = CRRA(cons, gamma) + beta*CRRA((1.0+rent)*grid_a(j), gamma);
        else
            % 消費が負値の場合、ペナルティを与えてその値が選ばれないようにする
            obj(j, i) = -10000.0;
        end
    end
end

%% 効用を最大にする操作変数を探し出す：政策関数
pol = zeros(nw,1);

% 各wについて生涯効用を最大にするaを探す
for i = 1:nw
    [maxv, maxl] = max(obj(:,i));
    pol(i) = grid_a(maxl);
end

disp([pol(5) pol(8) pol(10)])

figure;
plot(grid_w,pol, '-o', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3);
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, 1]);
ylim([0, 0.5]);
set(gca, 'Fontsize', 16);
grid on;