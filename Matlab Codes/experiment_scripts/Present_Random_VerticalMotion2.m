function Present_Random_VerticalMotion2(Repeat,Duration1,Duration2,Duration4,Interval,RepeatB,Gap,DurationB,IntervalB)

%ON 2012/08/28, updated the saved file name to ...2.
%
%Written on 2012/08/23. Add Present_Random_VerticalMotion behind the
%Present_Random_VerticalMotion_untilFlight.
%
%
%Written on 2012/08/21, based on Present_Stripe_Horizontal_Vertical2.
%
%Written to show vertical motions for OCT experiment. Should be similar to
%Marie's visual stimulation. Except this will be in blue, and won't show
%8Hz or higher.
%
%Modifed on 2012/07/20.
%Present each pattern (without moving for 1 sec before moving).
%
%Modifed on 2012/07/16.
%
% 1. Present Stripe in the middle for "Stripe Duration" (at 1 Hz temporal frequency)
% 2. Present Horizontal motion for "Horizontal Duration" (at randomly chosen temporal freq. from -4,-1,1,or 4)
% 3. Present Stripe again as above.
% 4. Present Vertical motion for "Vertical Duration" (at rand. chosen temp
% freq. from -4,-1,1,or 4).
% 5. Go back to 1 if necessary.
%
%Modifeid on 2012/03/20.
%Now use Panel_Com instead of Panel_Com_USB. Should rename to Present_RandomSpeed instead of ...usb.
%Show 1 Hz and 4 Hz in both directions.
%
%Modifed on 2011/12/02
%Just show 1Hz in both directions.
%
%Modified on 2011/12/01.
%Just show 1Hz and 4 Hz to both ways. Use for checking turning related increases.
%
%
%Modified on 2011/11/17.
%Use different pattern file, now gain 16 is 1Hz, should be able to go up
%to higher temporal frequency. For now use 16 (1Hz preferred direction),
%32 (2Hz), 64 (4Hz), 128 (8Hz). No null direction for now.
%
%
%modified on 2011/11/04.
%Present in other direction too. It will have 4 gains, 1Hz and 2Hz for CW
%and CCW.
%
%
%modified on 2011/10/25, based on Present_RandomDuration_USB.
%
%Instead of randomizing the duration, show different speed in a random
%order.
%Duration should be 2 seconds to get a good responses and also not to waste
%too much time.
%
%Will first show 1Hz stimulus for 2 seconds.
%For now, it will just randomize between 1Hz and 2Hz, gain of -48 and -96.
%Need to make a pattern that can move faster.
%
%modified on 2011/09/08
%
%Just use pause for the duration of the presentation and the duration of
%the interval.
%
%Present 500ms, 1s, 2s, and 4s duration stimulus in a random order. Present
%2s prestimulation before at the very beginning to eliminate the large
%response seen at the very first presentation.
%
%now Repeat will specify how may sets we will show.
%for 1Hz stimulation set gain to -48.
%
%
%modified on 2011/09/01
%for use with vertical pattern
%
%written on 2011/08/03
%
%Load the pattern, set position, set mode, set gain,
%Then start the pattern. after "Delay", stop the pattern.
%
%TestPattern(Delay,Repeat,Interval)
%
%Delay --- time to present stimulus in seconds.
%Repeat --- number of repetition.
%Interval --- time between presentations in seconds.
%
%Saves the time just before sending the start command and the just before
%the interval to a TimeMatrix and save it to a file with a date as a name.
%


NofRows=RepeatB*4;
TimeMatrixB=zeros(NofRows,6);

Gain_V=[64 -64];
%StartPosition=[1 5 9 13];

SequenceIndex_VB=zeros(RepeatB+1,2);
SequenceIndex_VB(1,:)=[1 2];%First one has to go to the positive direction so it will trigger the airpuff counter

%Load vertical pattern and set it up.
Panel_com('set_pattern_id',2);
Panel_com('set_position',[16,1])
Panel_com('set_mode',[0 ,0])
Panel_com('stop')
%show static pattern
Panel_com('send_gain_bias',[0,0,0,0]);%Either 1 or 4 hz going right or left. 
Panel_com('start')               
pause(5)
Panel_com('stop')

for n=1:RepeatB
    SequenceIndex_VB(n+1,:)=randperm(2);%Corresponds to 1hz, 2hz, 4hz goin up and down
    for nn=1:2
        Panel_com('send_gain_bias',[Gain_V(SequenceIndex_VB(n,nn)),0,0,0]);%Either 1 or 4 hz going right or left. 

        Gain_V(SequenceIndex_VB(n,nn))
        
            
        %Move the pattern vertically.
        TimeMatrixB((n-1)*12+(nn-1)*2+1,:)=clock;
        Panel_com('start')
        pause(DurationB)
        Panel_com('stop')
        TimeMatrixB((n-1)*12+(nn-1)*2+2,:)=clock;
        %Load vertical pattern and set it up.
        
        
        pause(IntervalB)
         
       
    end
end



Gap

pause(Gap);


NofRows=Repeat*12;
TimeMatrix=zeros(NofRows,6);


Gain_V=[16 32 64 -16 -32 -64];
%StartPosition=[1 5 9 13];
SequenceIndex_V=zeros(Repeat,6);


for n=1:Repeat
    SequenceIndex_V(n,:)=randperm(6);%Corresponds to 1hz, 2hz, 4hz goin up and down.
    for nn=1:6
        
        pause(Interval)
         
        Panel_com('send_gain_bias',[Gain_V(SequenceIndex_V(n,nn)),0,0,0]);%Either 1 or 4 hz going right or left. 

        Gain_V(SequenceIndex_V(n,nn))
        
        if Gain_V(SequenceIndex_V(n,nn)) == 16
            VerticalDuration=Duration1;
        elseif Gain_V(SequenceIndex_V(n,nn)) == -16
            VerticalDuration=Duration1;
        elseif Gain_V(SequenceIndex_V(n,nn)) == 32
            VerticalDuration=Duration2;
        elseif Gain_V(SequenceIndex_V(n,nn)) == -32
            VerticalDuration=Duration2;
        else
            VerticalDuration=Duration4;
        end
            
        %Move the pattern vertically.
        TimeMatrix((n-1)*12+(nn-1)*2+1,:)=clock;
        Panel_com('start')
        pause(VerticalDuration)
        Panel_com('stop')
        TimeMatrix((n-1)*12+(nn-1)*2+2,:)=clock;
    end
end


OutPutFile=strcat('Present_Random_VerticalMotion2',datestr(TimeMatrix(1,:),'yyyymmddTHHMMSS'));

save (OutPutFile,'TimeMatrix*','SequenceIndex_*')
