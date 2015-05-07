function [net,P] = nn_train(Num_Inputs)

trains = 21; % number of training images
shapes = 2; % number of shapes
P=zeros(Num_Inputs,trains);% input matrix
T=zeros(shapes,trains);

%% training
for h=1:trains % 9 boucles pour 9 images
    switch h
       case 1
           Img = imread('Ricktangles/1_triangle.jpg');
           Target=[1;-1];
       case 2 
           Img = imread('Ricktangles/2_triangle.jpg');
           Target=[1;-1];
       case 3
           Img = imread('Ricktangles/3_triangle.jpg');
           Target=[1;-1];
       case 4
           Img = imread('Ricktangles/4_triangle.jpg');
           Target=[1;-1];
       case 5
           Img = imread('Ricktangles/5_triangle.jpg');
           Target=[1;-1];
       case 6
           Img = imread('Ricktangles/6_triangle.jpg');
           Target=[1;-1];
       case 7
           Img = imread('Ricktangles/7_triangle.jpg');
           Target=[1;-1];
       case 8
           Img = imread('Tringles/1_triangle.jpg');
           Target=[-1;1];
       case 9
           Img = imread('Tringles/2_triangle.jpg');
           Target=[-1;1];
       case 10
           Img = imread('Tringles/3_triangle.jpg');
           Target=[-1;1];
       case 11
           Img = imread('Tringles/3_triangle.jpg');
           Target=[-1;1];
       case 12
           Img = imread('Tringles/5_triangle.jpg');
           Target=[-1;1];
       case 13
           Img = imread('Tringles/6_triangle.jpg');
           Target=[-1;1];
       case 14
           Img = imread('Tringles/7_triangle.jpg');
           Target=[-1;1];
       case 15
           Img = imread('Tringles/8_triangle.jpg');
           Target=[-1;1];
       case 16
           Img = imread('Tringles/9_triangle.jpg');
           Target=[-1;1];
       case 17
           Img = imread('Tringles/10_triangle.jpg');
           Target=[-1;1];
       case 18
           Img = imread('Tringles/11_triangle.jpg');
           Target=[-1;1];
       case 19
           Img = imread('Tringles/12_triangle.jpg');
           Target=[-1;1];
       case 20
           Img = imread('Tringles/13_triangle.jpg');
           Target=[-1;1];
       case 21
           Img = imread('Tringles/14_triangle.jpg');
           Target=[-1;1];
    end 
    
    T(:,h)=Target;

[Num_Row,Num_column] = size(Img);
           for i=1:Num_Inputs
                     for j=round((((Num_Row/Num_Inputs)*(i-1))+1)) : round(((Num_Row/Num_Inputs)*(i)))
                          for k=1 : Num_column
                             if Img(j,k)==0
                             P(i,h)=P(i,h)+k ;
                             end
                           end
                     end
           end
end

AN = zeros(size(P));
maxi=max(max(P));
mini=min(min(P));
[a,b]=size(P);
for i=1:a
    for j=1:b
        AN(i,j)=2*(P(i,j)/(maxi-mini))-1;
    end
end

P=AN;

Num_Neuron_Hidden=100;
net = feedforwardnet(Num_Neuron_Hidden);
net=init(net);
net.trainparam.epochs=250;
net.trainparam.goal=0.001;
net=train(net,P,T);

end
