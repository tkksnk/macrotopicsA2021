function  res = EulerEq_cheb(cons)
% c��^�����Ƃ��̃I�C���[�������̎c����Ԃ��֐�

global beta gamma alpha delta capital theta kgrid

wealth = capital.^alpha + (1.-delta).*capital;

kprime = wealth - cons;
% �g���b�N: k'�͐��̒l�������Ȃ�
kprime = max(kgrid(1),kprime);

% �����̐���֐�����`���
%cnext = interp1(m.kgrid,cfcn,kprime,'linear','extrap');
% �����̉��l�֐����X�v���C�����
%cnext = interp1(kgrid,cfcn0,kprime,'spline');
% �����̉��l�֐��𑽍������
nk = size(kgrid,1);
T = polybas(kgrid(1),kgrid(end),nk,kprime);
cnext = T*theta;

%% �I�C���[������
res = (1/cons) - beta*(1/cnext)*(alpha*kprime.^(alpha-1) + (1.-delta));
 
return