class Ebichan
    attr_accessor :motor1_pwm1, :motor1_pwm2, :motor2_pwm1, :motor2_pwm2
    def initialize
      @motor1_pwm1 = PWM.new(25, timer:0, channel:1)
      @motor1_pwm2 = PWM.new(26, timer:0, channel:2)

      @motor2_pwm1 = PWM.new(32, timer:1, channel:3)
      @motor2_pwm2 = PWM.new(33, timer:1, channel:4)
    end
    def stop
        @counter = 0
        
        @motor1_pwm1.duty( 50 )
        @motor1_pwm2.duty( 50 )
        @motor2_pwm1.duty( 50 )
        @motor2_pwm2.duty( 50 )

    end
    def back
        @motor1_pwm1.duty( 50 )
        @motor1_pwm2.duty( 100 )

        @motor2_pwm1.duty( 50 )
        @motor2_pwm2.duty( 100 )
    end
    def turn_left
        @motor1_pwm1.duty( 100 )
        @motor1_pwm2.duty( 50 )

        @motor2_pwm1.duty( 50 )
        @motor2_pwm2.duty( 50 )
    end
    def turn_right
        @motor1_pwm1.duty( 50 ) 
        @motor1_pwm2.duty( 50 ) 
      
        @motor2_pwm1.duty( 100 ) 
        @motor2_pwm2.duty( 50 )
    end
   
    def turnslow_left
        @motor1_pwm1.duty( 100 )
        @motor1_pwm2.duty( 80 )

        @motor2_pwm1.duty( 50 )
        @motor2_pwm2.duty( 50 )
    end
    def turnslow_right
        @motor1_pwm1.duty( 50 ) 
        @motor1_pwm2.duty( 50 ) 
      
        @motor2_pwm1.duty( 100 ) 
        @motor2_pwm2.duty( 80 )
    end
    
    def dash_mode1
        @motor1_pwm1.duty( 100 ) 
        @motor1_pwm2.duty( 70 ) 
          
        @motor2_pwm1.duty( 100 ) 
        @motor2_pwm2.duty( 67 ) 
    end
    def dash_mode2
        @motor1_pwm1.duty( 100 ) 
        @motor1_pwm2.duty( 70 ) 
          
        @motor2_pwm1.duty( 100 ) 
        @motor2_pwm2.duty( 73 ) 
    end
end

robotto = Ebichan.new

thread_for_hand = Thread.new do
    loop do
        robotto.motor1_pwm1.duty( 100 )
        robotto.motor1_pwm2.duty( 60 )
    end
end
thread_for_move = Thread.new do
    loop do
        robotto.motor2_pwm1.duty( 100 )
        robotto.motor2_pwm2.duty( 60 )
    end
end
thread_for_hand.join
thread_for_move.join