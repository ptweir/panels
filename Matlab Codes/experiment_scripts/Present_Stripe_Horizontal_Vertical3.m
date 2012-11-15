function Present_Stripe_Horizontal_Vertical3(Repeat,StripeDuration,HorizontalDuration,VerticalDuration,PreStimulus)

%Modified on 2012/10/18.
%Now has PreDuration parameter to specify how many seconds to place the
%stationary stimulus. For now, just make it 1 Hz to either direction for
%simplicity.
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

NofRows=Repeat*48*2+2;
TimeMatrix=zeros(NofRows,6);

Gain_H=[16 -16];
Gain_V=[16 -16];

for n=1:Repeat
    SequenceIndex_H(n,:)=randperm(2);%Corresponds to 1 hz to the right and to the left.
    SequenceIndex_V(n,:)=randperm(2);
    for nn=1:2
        
        %Load the stripe pattern and set it up.
        Panel_com('set_pattern_id',3);
        Panel_com('set_position',[1,1])
        Panel_com('set_mode',[0 ,0])
        Panel_com('stop')
        Panel_com('send_gain_bias',[16,0,0,0]);%Just 1 Hz oscillation 

        %Move the stripe.
        TimeMatrix((n-1)*48+(nn-1)*12+1,:)=clock;
        Panel_com('start')
        pause(StripeDuration)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+2,:)=clock;

        %Load horizontal pattern and set it up.
        Panel_com('set_pattern_id',1);
        Panel_com('set_position',[1,1])
        Panel_com('set_mode',[0 ,0])
        Panel_com('stop')
        Panel_com('send_gain_bias',[0,0,0,0]);
        
        %Show static pattern for 1 sec. We can use this to calculate the
        %artifact for pattern on.
        TimeMatrix((n-1)*48+(nn-1)*12+3,:)=clock;
        Panel_com('start')
        pause(PreStimulus)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+4,:)=clock;

        
        %now move the pattern
        Panel_com('send_gain_bias',[Gain_H(SequenceIndex_H(n,nn)),0,0,0]);%Either 1 or 4 hz going right or left. 

        Gain_H(SequenceIndex_H(n,nn))
        
        %Move the pattern horizontally.
        TimeMatrix((n-1)*48+(nn-1)*12+5,:)=clock;
        Panel_com('start')
        pause(HorizontalDuration)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+6,:)=clock;

        %Load the stripe pattern and set it up.
        Panel_com('set_pattern_id',3);
        Panel_com('set_position',[1,1])
        Panel_com('set_mode',[0 ,0])
        Panel_com('stop')
        Panel_com('send_gain_bias',[16,0,0,0]);%Just 1 Hz oscillation 

        %Move the stripe.
        TimeMatrix((n-1)*48+(nn-1)*12+7,:)=clock;
        Panel_com('start')
        pause(StripeDuration)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+8,:)=clock;

        %Load vertical pattern and set it up.
        Panel_com('set_pattern_id',2);
        Panel_com('set_position',[1,1])
        Panel_com('set_mode',[0 ,0])
        Panel_com('stop')
        
        %show static pattern
        Panel_com('send_gain_bias',[0,0,0,0]);%Either 1 or 4 hz going right or left. 

        TimeMatrix((n-1)*48+(nn-1)*12+9,:)=clock;
        Panel_com('start')
        pause(PreStimulus)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+10,:)=clock;
        
        Panel_com('send_gain_bias',[Gain_V(SequenceIndex_V(n,nn)),0,0,0]);%Either 1 or 4 hz going right or left. 

        Gain_V(SequenceIndex_V(n,nn))
        
        %Move the pattern vertically.
        TimeMatrix((n-1)*48+(nn-1)*12+11,:)=clock;
        Panel_com('start')
        pause(VerticalDuration)
        Panel_com('stop')
        TimeMatrix((n-1)*48+(nn-1)*12+12,:)=clock;
    end
end

%End with a stripe at the front.
%Load the stripe pattern and set it up.
Panel_com('set_pattern_id',3);
Panel_com('set_position',[1,1])
Panel_com('set_mode',[0 ,0])
Panel_com('stop')
Panel_com('send_gain_bias',[16,0,0,0]);%Just 1 Hz oscillation 

%Move the stripe.
TimeMatrix((n-1)*48+(nn-1)*12+13,:)=clock;
Panel_com('start')
pause(StripeDuration)
Panel_com('stop')
TimeMatrix((n-1)*48+(nn-1)*12+14,:)=clock;


OutPutFile=strcat('Present_Stripe_Horizontal_Vertical3',datestr(TimeMatrix(1,:),'yyyymmddTHHMMSS'));

save (OutPutFile,'TimeMatrix','SequenceIndex_*','StripeDuration','HorizontalDuration','VerticalDuration','PreStimulus')
