
class Ebichan
    attr_accessor :lux_right, :lux_left, :fieldout, :catched, :vl53l0x, :counter, :ball_find
    def initialize
      @motor1_pwm1 = PWM.new(25, timer:0, channel:1)
      @motor1_pwm2 = PWM.new(26, timer:0, channel:2)

      @motor2_pwm1 = PWM.new(32, timer:1, channel:3)
      @motor2_pwm2 = PWM.new(33, timer:1, channel:4)

      @lux_right = ADC.new(35) 
      @lux_left  = ADC.new(2)

      @servo1 = PWM.new(27, timer: 2, channel: 5, frequency: 50) 
      @servo2 = PWM.new(14, timer: 2, channel: 6, frequency: 50) 

      @i2c = I2C.new()
      @vl53l0x = VL53L0X.new(@i2c)
      @vl53l0x.set_timeout(2000)

      @fieldout = false
      @catched = false
      @ball_find = false
      @counter = 0

      @vl53l0x.init
      @vl53l0x.start_continuous(500)

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
    def hand_open
        @servo1.pulse_width_us( 1900 )
        @servo2.pulse_width_us( 1100 )
    end
    
    def hand_close
        @servo1.pulse_width_us( 1300 )
        @servo2.pulse_width_us( 1700 )
    end
    def read_distance
        @distance = @vl53l0x.read_range_continuous_millimeters
        if @distance <  800
            @ball_find = true
            return true
        else
            return false
        end
    end
end

robotto = Ebichan.new

robotto.hand_open

first_loop = true

while true do
    if robotto.lux_left.read_raw < 200 

        robotto.fieldout = true
        robotto.hand_open

        if robotto.lux_right.read_raw < 200 
            # 左右とも黒
            robotto.stop
            
            sleep 2
            robotto.back
            sleep 3
            #一旦停止
            robotto.turn_left

            
        else 
            # 左が黒で右が白
            robotto.stop
            sleep 2
            robotto.back
            sleep 3
            robotto.turn_right

        end
    else
        if robotto.lux_right.read_raw < 200 

            robotto.fieldout = true
            robotto.hand_open

            #　左が黒ではない右が黒
            robotto.stop
            sleep 2
            robotto.back
            sleep 3
            robotto.turn_left

        else
            #　左右とも白(前進)
            robotto.fieldout = false
            
            if !first_loop
                if robotto.counter < 2
                    robotto.dash_mode1 
                else robotto.counter 
                    robotto.dash_mode2 
                end
                if robotto.counter >  3 && !robotto.catched && robotto.ball_find
                    robotto.stop
                    robotto.ball_find = false
                end
            else
                first_loop = false
            end
        end
    end

    distance = robotto.vl53l0x.read_range_continuous_millimeters
    if distance < 200 && !robotto.fieldout
        robotto.ball_find = true
        robotto.catched = true
        robotto.hand_close
    elsif robotto.ball_find == false && robotto.counter % 2 == 0
        robotto.hand_open
        #首振り
        sleep 1
        robotto.turnslow_left
        5.times do
            sleep 1
            if robotto.read_distance
                break
            end
        end
        if robotto.ball_find
            robotto.stop
            next
        end
        if robotto.lux_left.read_raw < 200 || robotto.lux_left.read_raw === red_range_left
            robotto.turnslow_right
        end
        robotto.turnslow_right
        sleep 4
        6.times do
            sleep 1
            if robotto.read_distance
                break
            end
        end
        if robotto.ball_find
            robotto.stop
            next
        end
        if robotto.lux_right.read_raw < 200 
            robotto.trunslow_left
        end
        if robotto.read_distance
            next
        end
        robotto.turnslow_left
        sleep 3
    end
    sleep 1
    robotto.counter += 1
end