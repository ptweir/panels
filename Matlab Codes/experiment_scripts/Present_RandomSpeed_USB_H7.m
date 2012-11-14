function Present_RandomSpeed_USB_H7(Repeat,Interval,Duration)

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

NofRows=Repeat*4*2+2;

TimeMatrix=zeros(NofRows,6);


Panel_com('set_pattern_id',1);
 
Panel_com('set_position',[1,1])
Panel_com('set_mode',[0 ,0])
Panel_com('stop')
Panel_com('send_gain_bias',[16,0,0,0]);%initially use 1hz going right. 

%Start the prepulse

TimeMatrix(1,:)=clock;
Panel_com('start')
pause(Duration)
Panel_com('stop')
TimeMatrix(2,:)=clock;
pause(Interval);

Gain=[16 64 -16 -64];

for n=1:Repeat
    SequenceIndex(n,:)=randperm(4)%Corresponds to 1 and 4 hz to the right and to the left.
    
    for nn=1:4
        TimeMatrix((n-1)*8+(nn-1)*2+1+2,:)=clock;
        Panel_com('stop')
        Panel_com('send_gain_bias',[Gain(SequenceIndex(n,nn)),0,0,0]);%Either 1hz or 4hz going right or left. 
        Panel_com('start')
        pause(Duration);
        Panel_com('stop')
        TimeMatrix((n-1)*8+(nn-1)*2+2+2,:)=clock;        
        pause(Interval)
    end
end


OutPutFile=strcat('Present_RandomSpeed_USB_H7',datestr(TimeMatrix(1,:),'yyyymmddTHHMMSS'));

save (OutPutFile,'TimeMatrix','SequenceIndex')
