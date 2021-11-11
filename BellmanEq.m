function  value = BellmanEq(kprime)

global beta gamma alpha delta capital vfcn kgrid
%global beta gamma alpha capital val_fcn kgrid

%% �x���}��������

wealth = capital.^alpha;

cons = wealth - kprime;

% ������l�̏ꍇ�A�y�i���e�B��^���Ă��̒l���I�΂�Ȃ��悤�ɂ���
if cons > 0.0
    util = CRRA(cons, gamma);
else
    util = -10000.0;
end

% �����̉��l�֐�����`���
% vnext = interp1(kgrid, vfcn, kprime, 'linear', 'extrap');

% �����̉��l�֐����X�v���C�����
vnext = interp1(kgrid, vfcn, kprime, 'spline');

value = util + beta.*vnext;

%% �g���b�N(1): k'�͐��̒l�������Ȃ��̂ŁA�y�i���e�B��^���Ă��̒l���I�΂�Ȃ��悤�ɂ���
if kprime < 0
    value = -1000000.0;
end

%% �g���b�N(2): "�ŏ���"������̂ŕ����𔽓]
value = -1*value;