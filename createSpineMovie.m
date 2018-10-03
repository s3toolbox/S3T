for jj=0:59
    nSpikes = 3;
    freqSpikes = 0.2;
    Nspines = 20; % Active spines
    Nspines2 = 20; % Non-active spines
    pos=ceil(512*rand(Nspines,2)); % Spine positions
    bgF=400*ones(Nspines,1); % Background Fluorescence
    bgF2=400*ones(Nspines,1); % Background Fluorescence
    pos2=ceil(512*rand(Nspines2,2)); % Postion of non-active spines
    spiketimes = 1.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    spiketimes2 = 6.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    spiketimes3 = 11.2*ones(Nspines,1)+0.03*randn(Nspines,1); % SpikeTime + random delay
    
    
    
    spikeAmplitude = 500*ones(Nspines,1); % The same amplitude
    spikeAmplitude2 = 500*ones(Nspines,1); % The same amplitude
    spikeAmplitude3 = 500*ones(Nspines,1); % The same amplitude
    decaytime= 0.95*ones(Nspines,1)-.003*rand(Nspines,1); % Almost all the same decay time
    %dy=-0.05*y=> exp(-0.5*t/pi)
    backSeed=rand(516,516);
    
    [X,Y]=meshgrid(-20:20,-20:20);
    spineshape=(X.*X+Y.*Y)<10; % Binary shaped synapses
    spineshape=exp(-(X.*X+Y.*Y)/18); % Gaussian shaped synapse
    % spineshape=...
    %     [0 0 1 0 0;
    %      0 1 1 1 0;
    %      1 1 1 1 1;
    %      0 1 1 1 0;
    %      0 0 1 0 0];
    
    
    conn=(size(spineshape)-1);
    sX=(512+conn(1));
    sY=(512+conn(2));
    [X,Y]=meshgrid(1:sX,1:sY);
    sc=1;
    background=.000005*(((X.*X*0.01*sc-200).*(X*sc-200)+Y*sc.*X.*Y*sc));%+(X*sc-20).*Y));
    
    fs=30;
    tFrame=1/fs;
    totalTime=17;
    totFrames=floor(totalTime/tFrame);
    images=zeros(512,512);
    image2=zeros(sX,sY,totFrames);
    for i=1:length(pos)
        images(pos(i,1),pos(i,2)) = bgF(i);
    end
    for f=1:totFrames
        for i=1:length(pos2)
            images(pos2(i,1),pos2(i,2)) = bgF2(i);
        end
        for i=1:length(pos)
            %images(pos(i,1),pos(i,2))=images(pos(i,1),pos(i,2))+bgF(i);
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude(i)*(tFrame/2>abs(f*tFrame-spiketimes(i)));
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude2(i)*(tFrame/2>abs(f*tFrame-spiketimes2(i)));
            images(pos(i,1),pos(i,2)) = images(pos(i,1),pos(i,2))+spikeAmplitude3(i)*(tFrame/2>abs(f*tFrame-spiketimes3(i)));
            images(pos(i,1),pos(i,2)) = bgF(i)+(images(pos(i,1),pos(i,2))-bgF(i))*decaytime(i);
        end
        image2(:,:,f) = image2(:,:,f)+10*0.5*randn(size(image2(:,:,f)));
        image2(:,:,f) = conv2(spineshape,images);
        image2(:,:,f) = image2(:,:,f)+10*0.5*randn(size(image2(:,:,f)));
        image2(:,:,f) = image2(:,:,f)+background;
    end
    figure(1);colormap gray;
    tic
    %  for f=1:totFrames
    %     image(image2(:,:,f)*.10);
    %     pause(.0285);
    %  end
    toc
    %%
    figure(2)
    hold off
    plot((1:totFrames)*tFrame, squeeze(image2(pos(1,1)+conn(1)/2,pos(1,2)+conn(2)/2,:)));
    hold on;
    % Decay time:
    t=0:0.032:8;plot(t,5*exp(-0.5*(t-1)*pi))
    %% Export the movie:
    %image2=conv2(images,spineshape);
    ID = num2str(10000+jj);
    mkdir(['E:/simulated_e' ID(2:end)] );
    mkdir(['E:/simulated_e' ID(2:end) '/GT'] );
    for i=1:totFrames
        image(image2(:,:,i)/20);
        
        imwrite(image2(:,:,i)/1024, ['E:/simulated_e' ID(2:end) '/frame' num2str(i) '.png'],'BitDepth',16);
        pause(.01)
    end
    save(['E:/simulated_e' ID(2:end) '/GT/groundTruth' ID(2:end) '.mat'])
    
    
end
%% Convert png seqs to tif
!C:\Users\SA-PRD-Synapse\Documents\ij150-win-jre6\ImageJ\ImageJ-win64.exe --headless --console -macro ./png2tif.ijm 

%'folder=../folder1 parameters=a.properties output=../samples/Output'
