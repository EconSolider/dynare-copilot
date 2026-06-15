rho=0.9;
variance=0.5^2;
x=[-0.75:0.01:0.75];
y_true=exp(rho*x+1/2*variance);
y_pert1=1+rho*x;
y_AESpert1=1+1/2*variance+rho*(1+1/2*variance)*x
figure
plot(x,y_true,'b-',x,y_pert1,'r--',x,y_AESpert1,'k-.','LineWidth',1.5)
xlabel('x_t')
xlabel('y_t')
ll=legend('True','Simultaneous Perturbation','Sequential Perturbation','Location','Northwest')
set(ll,'FontSize',14)
axis tight
print -depsc2 AES_example