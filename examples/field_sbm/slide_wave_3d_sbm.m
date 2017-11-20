clear all

fdir='/Volumes/Seagate Backup Plus Drive/LANDSLIDE_BENCH_7/sbm_nhw/';
fdep='../input/';

dep_init=load([fdep 'depth_sbm_1200x520.txt']);

[ny,nx]=size(dep_init);
dx=13.27;
dy=16.47;
is=1;
ie=nx-350;
js=100;
je=ny-1;

x1=(0:1:nx-1)*dx;
y1=(0:1:ny-1)*dy;

[x,y]=meshgrid(x1,y1);
icount=0;

%ns=input('ns=');
%ne=input('ne=');

ns=1;
ne=260;

% Set up file and options for creating the movie
vidObj = VideoWriter('movie.avi');  % Set filename to write video file
vidObj.FrameRate=10;  % Define the playback framerate [frames/sec]
open(vidObj);

wid=8;
len=6;
set(gcf,'units','inches','paperunits','inches','papersize', [wid len],'position',[1 1 wid len],'paperposition',[0 0 wid len]);


dep=dep_init;
dep(dep<0)=dep(dep<0)/1.;
bathy=dep;
topo=dep;
topo(dep>15)=NaN;
bathy(dep<0)=NaN;

hotel_x=7.1790700e+03;
hotel_y=3.9857400e+03;

for num=ns:2:ne

icount=icount+1;

fnum=sprintf('%.4d',num);

eta=load([fdir 'eta_' fnum]);

slide=load([fdir 'slide_' fnum]);


eta(eta+dep-slide<0.0)=NaN;
slide(slide-dep>0)=0.0;




clf

surface(x(js:je,is:ie),y(js:je,is:ie),-bathy(js:je,is:ie), 'FaceColor',[0.8 0.8 0.8],'EdgeColor','none','CDataMapping','direct','DiffuseStrength',0.5)


hold on
surface(x(js:je,is:ie),y(js:je,is:ie),-topo(js:je,is:ie), 'FaceColor',[0.0 0.4 0.0],'EdgeColor','none','CDataMapping','direct','DiffuseStrength',0.5)


sli=-dep+slide;
sli(slide==0)=NaN;
surface(x(js:je,is:ie),y(js:je,is:ie),sli(js:je,is:ie), 'FaceColor',[0.54 0.44 0.35],'EdgeColor','none','CDataMapping','direct','DiffuseStrength',0.5)

hsurf=surface(x(js:je,is:ie),y(js:je,is:ie),eta(js:je,is:ie)*1.5,'FaceColor',[0.1 0.6 1],'EdgeColor','none','CDataMapping','direct','DiffuseStrength',0.5);

alpha(hsurf,0.60);
 %lightangle(-35,50)
lightangle(35,30)
grid

%plot3([hotel_x,hotel_x],[hotel_y,hotel_y],[-10 50],'r','LineWidth',2)

%axis([500 12000 300 6000 -300 50])
%view([60 22])
view([14 48])
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
time1=(num)*1;
title(['time = ' num2str(time1,'%4.1f') ' sec'])
%M(:,icount)=getframe(gcf);
pause(0.1)

    currframe=getframe(gcf);
    writeVideo(vidObj,currframe);  % Get each recorded frame and write it to filename defined above

end
close(vidObj)

%movie2avi(M,'result1','FPS',15)
