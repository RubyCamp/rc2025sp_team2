class Ebichan
    atter_reader :lux_right, :lux_left
    def initialize
      @motor1_pwm1 = PWM.new(25)
      @motor1_pwm2 = PWM.new(26)

      @motor2_pwm1 = PWM.new(32)
      @motor2_pwm2 = PWM.new(33)

      @lux_right = ADC.new(35) 
      @lux_left  = ADC.new(2)

      @servo1 = PWM.new(27, timer: 2, channel: 5, frequency: 50) 
      @servo2 = PWM.new(14, timer: 2, channel: 6, frequency: 50) 

      @i2c = I2C.new()
      @vl53l0x = VL53L0X.new(@i2c)
      @vl53l0x.set_timeout(2000)

      @fieldout = false
      @catched = false

      @vl53l0x.init
      @vl53l0x.start_continuous(1000)

    end
    def stop
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
    def dash
        @motor1_pwm1.duty( 90 ) 
        @motor1_pwm2.duty( 50 ) 
          
        @motor2_pwm1.duty( 90 ) 
        @motor2_pwm2.duty( 50 ) 
    end

    def open
        @servo1.pulse_width_us(1900)
        @servo2.pulse_width_us(1100)
    end
    
    def close
        @servo1.pulse_width_us(1300)
        @servo2.pulse_width_us(1700)
    end
end

robotto = Ebichan.new

robotto.open

while true do
    if robotto.lux_left.read_raw < 200

        robotto.fieldout = true
        robotto.close

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
            robotto.turn_righght

        end
    else
        if robotto.lux_right.read_raw < 200

            robotto.fieldout = true
            robotto.close

            #　左が黒ではない右が黒
            robotto.stop
            sleep 2
            robotto.back
            sleep 3
            robotto.turn_left

        else
            #　左右とも白(前進)

            robotto.fieldout = false
            robotto.dash
            
        end
    end
    
    distance = robotto.vl53l0x.read_range_continuous_millimeters
    if distance < 150 && !robotto.fieldout
        robotto.catched = true
        robotto.close
    else 
        robotto.open
    end
    sleep 1
end

# かにロボ A3の対角線514mm 角度　54.5°



