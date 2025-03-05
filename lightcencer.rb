num = 0
	  
10.times do |i|
    puts i.to_s + "times"
end

motor1_pwm1 = PWM.new(25)
motor1_pwm2 = PWM.new(26)

motor2_pwm1 = PWM.new(32)
motor2_pwm2 = PWM.new(33)

lux_right = ADC.new(35) # 右ライトセンサー初期化（GPIO番号: 35）
lux_left  = ADC.new(2)  # 左ライトセンサー初期化（GPIO番号: 2）


while true do
    if lux_left.read_raw < 200
        if lux_right.read_raw < 200

            # 左右とも黒
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 50 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 50 )
            sleep 2
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 100 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 100 )
            sleep 3
            #一旦停止
            motor1_pwm1.duty( 100 )
            motor1_pwm2.duty( 50 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 50 )

        else 
            # 左が黒で右が白
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 50 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 50 )
            sleep 2
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 100 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 100 )
            sleep 3
            motor1_pwm1.duty( 50 ) 
            motor1_pwm2.duty( 50 ) 
          
            motor2_pwm1.duty( 100 ) 
            motor2_pwm2.duty( 50 )
        end
    else
        if lux_right.read_raw < 200
            #　左が黒ではない右が黒
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 50 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 50 )
            sleep 2
            motor1_pwm1.duty( 50 )
            motor1_pwm2.duty( 100 )

            motor2_pwm1.duty( 50 )
            motor2_pwm2.duty( 100 )
            sleep 3
            motor1_pwm1.duty( 100 ) 
            motor1_pwm2.duty( 50 ) 
          
            motor2_pwm1.duty( 50 ) 
            motor2_pwm2.duty( 50 )
        else
            #　左右とも白(前進)
            motor1_pwm1.duty( 90 ) 
            motor1_pwm2.duty( 50 ) 
          
            motor2_pwm1.duty( 90 ) 
            motor2_pwm2.duty( 50 ) 
        end
    end

    sleep 1
end

# かにロボ A3の対角線514mm 角度　54.5°



