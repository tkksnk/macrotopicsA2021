global beta gamma alpha capital vfcn kgrid

%% *** カリブレーション ***
beta  = 0.96; % 割引因子
gamma = 1.0;  % 相対的危険回避度(異時点間の代替の弾力性の逆数)
alpha = 0.40; % 資本分配率
delta = 1.00; % 固定資本減耗(0.08)

% *** 離散化用のパラメータ ***
nk   = 1001;  % グリッドの数
kmax = 0.5;   % 資本グリッドの最大値
%kmax = 10.0; % 資本グリッドの最大値(固定資本減耗=0.08の場合に使用)
kmin = 0.005;  % 資本グリッドの最小値 (0にすると生産が出来なくなる)

% *** 収束の基準 ***
it = 1;          % ループ・カウンター
maxit = 1000;    % 繰り返し計算の最大値
tol  = 1.0e-005; % 許容誤差(STEP 2)
dif1 = 1;        % 価値関数の繰り返し誤差
dif2 = 1.0;      % 政策関数の繰り返し誤差
count = 1;

%% STEP 1(a): グリッド生成
kgrid = linspace(kmin, kmax, nk)';

%% STEP 1(b): 価値関数・政策関数の初期値を設定
%vfcn = CRRA(kgrid.^alpha,gamma)/(1-beta);
vfcn  = zeros(nk, 1);
pfcn  = zeros(nk, 1);
Tvfcn = zeros(nk, 1);
Tpfcn = zeros(nk, 1);
vkp   = zeros(nk, nk);
val_tmp = zeros(nk, 4);

%% 解析的解
AA = (1.0-beta).^(-1) * (log(1.0-alpha*beta) + ((alpha*beta)/(1.0-alpha*beta))*log(alpha*beta));
BB = alpha/(1.0-alpha*beta);
v_true = AA + BB*log(kgrid);
p_true = beta*alpha*(kgrid.^alpha);

%% STEP 3: 効用関数の組み合わせ

% 効用関数の初期値 (消費が0以下になる組み合わせにはペナルティ)
util = -10000.0*ones(nk, nk);

% 消費が正値になる(k,k')の組み合わせについて効用を計算
for i = 1:nk
    %  あらゆる操作変数k'について:
    for j = 1:nk
        wealth = kgrid(i).^alpha + (1.0-delta).*kgrid(i);
        cons = wealth - kgrid(j);
        if cons > 0
           util(j,i) = CRRA(cons, gamma);
        end
    end
end

%% STEP 4: 価値関数を繰り返し計算
while it < maxit && dif1 > tol

    % ベルマン方程式: V(k;k')
    for i = 1:nk
        vkp(:,i) = util(:,i) + beta.*vfcn;
    end
    
    % 最適化: 各kについてV(k;k')を最大にするk'を探す
    [Tvfcn, ploc] = max(vkp);
    Tvfcn = Tvfcn';
    Tpfcn = kgrid(ploc);
    
    % 繰り返し計算誤差を確認
    dif1 = max(abs((Tvfcn-vfcn)./vfcn));

    % 価値関数・政策関数をアップデート
    vfcn = Tvfcn;
    pfcn = Tpfcn;
    fprintf('iteration index: %i, iteration diff of value: %d, iteration diff of policy: %d \n', it, dif1, dif2);
    
    it = it + 1;

end

%% 図を描く
figure;
plot(kgrid, vfcn, '-', 'color', 'blue', 'linewidth', 3); hold('on');
plot(kgrid, v_true, '--', 'color', 'red', 'linewidth', 3); hold('off');
%title('価値関数', 'fontsize', 16);
xlabel('資本保有量：k', 'Fontsize', 16);
ylabel('価値関数：V(k)', 'Fontsize', 16);
xlim([0,kmax]);
legend('近似解', '解析的解', 'Location', 'SouthEast');
grid on;
set(gca,'Fontsize', 16);
% saveas (gcf,'Fig3_dndp1.eps','epsc2');

figure;
plot(kgrid, pfcn, '-', 'color', 'blue', 'linewidth', 3); hold('on');
plot(kgrid, p_true, '--', 'color', 'red', 'linewidth', 3);
plot(kgrid, kgrid, ':', 'color', 'black', 'linewidth', 2); hold('off');
%title('政策関数', 'fontsize', 16);
xlabel('今期の資本保有量：k', 'Fontsize', 16);
ylabel("次期の資本保有量：k'", 'Fontsize', 16);
xlim([0,kmax]);
legend('近似解', '解析的解', '45度線', 'Location', 'NorthWest');
grid on;
set(gca,'Fontsize', 16);