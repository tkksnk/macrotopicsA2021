global beta gamma alpha capital vfcn kgrid

%% *** カリブレーション ***
beta  = 0.96; % 割引因子
gamma = 1.0;  % 相対的危険回避度(異時点間の代替の弾力性の逆数)
alpha = 0.4;  % 資本分配率

% *** 離散化用のパラメータ ***
nk   = 11;    % グリッドの数
kmax =  1.0;  % 資本グリッドの最大値
kmin =  0.05; % 資本グリッドの最小値

%% グリッドポイントを計算
kgrid = linspace(kmin, kmax, nk)';

%% T-1期
for i = 1:nk

    % グローバル変数を設定
    % fminsearchで使う関数(BellmanEq)に最適化する変数"以外"の変数を渡す(グローバル変数を使わない方法もあるはず)
    capital = kgrid(i);

    % MATLABの最適化関数(fminsearch)を使ってグリッド上で価値関数と政策関数の値を探す
    % 初期値は0.01
    [pfcn1(i), vfcn1(i)] = fminsearch(@BellmanEqT, 0.01);

end

% 消費関数を計算(必ずしも計算する必要はない)
cfcn1 = kgrid.^alpha - pfcn1;

% fminsearchは最小値を探す関数なので符号を反転させる
vfcn1 = -1*vfcn1;

%% DATA POINTS
figure;
plot(kgrid, vfcn1, 'o', 'color', 'blue', 'MarkerSize', 12, 'linewidth', 3);
xlabel('資本保有量：k', 'Fontsize', 16);
ylabel('グリッド上の価値関数：V_{T-1}(k^{i})', 'Fontsize', 16);
xlim([0, 1.5]);
ylim([-3, 0]);
grid on;
set(gca,'Fontsize',16);