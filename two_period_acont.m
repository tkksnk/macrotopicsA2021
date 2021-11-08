% グローバル変数：obj_two_period.m, obj_projection.mと変数を共有
global w grid_w beta gamma rent

%% *** カリブレーション ***
beta  = 0.985.^30;     % 割引因子
gamma = 2.0;           % 相対的危険回避度
rent  = 1.025.^30-1.0; % 純利子率

% *** パラメータ ***
nw    =  10;   % 所得グリッドの数
w_max = 1.0;   % 所得グリッドの最大値
w_min = 0.1;   % 所得グリッドの最小値
% na    =  400;   % 貯蓄グリッドの数
% a_max = 1.0;   % 貯蓄グリッドの最大値
% a_min = 0.025; % 貯蓄グリッドの最小値

%% グリッドポイントを計算
grid_w = linspace(w_min, w_max, nw)';
% grid_a = linspace(a_min, a_max, na)';

%% fminbnd(最適化関数の一つ)を使って効用最大化問題を解く
a_gs = zeros(nw,1);

% 各wについて目的関数(obj_two_period.mを最大にするaを探す)
for i = 1:nw
    w = grid_w(i);
    % w*0.01とw*2.0は探す区間の範囲：詳細は"help fminbnd"
    [a_gs(i), fval] = fminbnd(@obj_two_period, w*0.01, w*2.0);
end

%% fminsearch(最適化関数の一つ)を使って効用最大化問題を解く
a_ss = zeros(nw,1);

for i = 1:nw
    w = grid_w(i);
    % 0.0は初期値：詳細は"help fminsearch"
    [a_ss(i), fval] = fminsearch(@obj_two_period, 0.0);
end

%% 図を描く
figure;
plot(grid_w, a_gs, '-o', 'color', 'blue', 'MarkerEdgeColor', 'b', 'MarkerSize', 12, 'linewidth', 3); hold('on');
plot(grid_w, a_ss, '--d', 'color', 'red', 'MarkerEdgeColor', 'r', 'MarkerSize', 12, 'linewidth', 3); hold('off');
xlabel('若年期の所得：w', 'Fontsize', 16);
ylabel('若年期の貯蓄：a', 'Fontsize', 16);
xlim([0, w_max]);
ylim([0, 0.5]);
legend('fminbnd','fminsearch','Location','NorthWest');
set(gca, 'Fontsize', 16);
grid on;