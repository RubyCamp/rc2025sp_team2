# サーボモーターの初期化
servo1 = PWM.new(27, timer: 2, channel: 5, frequency: 50) 
servo2 = PWM.new(14, timer: 2, channel: 6, frequency: 50) 

# モーター１の初期化
motor1_pwm1 = PWM.new(25, timer: 0, channel: 1) 
motor1_pwm2 = PWM.new(26, timer: 0, channel: 2) 

# モーター２の初期化
motor2_pwm1 = PWM.new(32, timer: 1, channel: 3) 
motor2_pwm2 = PWM.new(33, timer: 1, channel: 4) 

# ライトセンサーの初期化
lux_right = ADC.new(35) 
lux_left  = ADC.new(2)

# 距離センサーの初期化
i2c = I2C.new()
vl53l0x = VL53L0X.new(i2c)
vl53l0x.set_timeout(2000)

# サーボモーターの初期位置(開脚)
servo1.pulse_width_us(1900)
servo2.pulse_width_us(1100)

# 距離センサーの計測開始
vl53l0x.init
vl53l0x.start_continuous(1000)

fieldout = false

# メインループ
while true do
if lux_left.read_raw < 200
        if lux_right.read_raw < 200
            fieldout = true
            servo1.pulse_width_us(1900)
            servo2.pulse_width_us(1100)
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
            fieldout = true
            servo1.pulse_width_us(1900)
            servo2.pulse_width_us(1100)
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
            fieldout = true
            servo1.pulse_width_us(1900)
            servo2.pulse_width_us(1100)
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
            fieldout = false
            #　左右とも白(前進)
            motor1_pwm1.duty( 90 ) 
            motor1_pwm2.duty( 50 ) 
          
            motor2_pwm1.duty( 90 ) 
            motor2_pwm2.duty( 50 ) 
        end
    end

    distance = vl53l0x.read_range_continuous_millimeters
    if distance < 150 && !fieldout
        catched = true
            servo1.pulse_width_us(1370)
            servo2.pulse_width_us(1630)
        
    else 
        # サーボモーターの動作(開脚)
        servo1.pulse_width_us(1900)
        servo2.pulse_width_us(1100)
    end

    sleep 1
end

# かにロボ A3の対角線514mm 角度　54.5°