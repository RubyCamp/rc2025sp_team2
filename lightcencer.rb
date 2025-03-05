num = 0
	  
10.times do |i|
    puts i.to_s + "times"
end



class Ebichan
    atter_reader :lux_right, :lux_left
    def initialize
      @motor1_pwm1 = PWM.new(25)
      @motor1_pwm2 = PWM.new(26)

      @motor2_pwm1 = PWM.new(32)
      @motor2_pwm2 = PWM.new(33)

      @lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
      @lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）

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
end

robotto = Ebichan.new

while true do
    if robotto.lux_left.read_raw < 200
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
            #　左が黒ではない右が黒
            robotto.stop
            sleep 2
            robotto.back
            sleep 3
            robotto.turn_left

        else
            #　左右とも白(前進)
            robotto.dash
            
        end
    end

    sleep 1
end

# かにロボ A3の対角線514mm 角度　54.5°



