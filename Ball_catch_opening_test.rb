servo1 = PWM.new(27, timer: 2, channel: 5, frequency: 50)
servo2 = PWM.new(14, timer: 2, channel: 6, frequency: 50)

motor1_pwm1 = PWM.new(25, timer: 0, channel: 1)
motor1_pwm2 = PWM.new(26, timer: 0, channel: 2)

motor1_pwm1.duty( 80 )
motor1_pwm2.duty( 50 )

motor2_pwm1 = PWM.new(32, timer: 1, channel: 3)
motor2_pwm2 = PWM.new(33, timer: 1, channel: 4)

motor2_pwm1.duty( 80 )
motor2_pwm2.duty( 50 )

i2c = I2C.new()
vl53l0x = VL53L0X.new(i2c)
vl53l0x.set_timeout(500)

servo1.pulse_width_us(1900)
servo2.pulse_width_us(1100)

vl53l0x.init
vl53l0x.start_continuous(200)

counter = 0
loop do
    distance = vl53l0x.read_range_continuous_millimeters
    if distance < 110
        catched = true
        
        if counter_for_servo == 0
            # サーボモーターの動作(閉脚)
            servo1.pulse_width_us(1370)
            servo2.pulse_width_us(1630)
            
        elsif counter_for_servo == 2
            # サーボモーターの動作(やや開く)
            servo1.pulse_width_us(1400)
            servo2.pulse_width_us(1600)
            
        elsif counter_for_servo == 3
            counter_for_servo = -1
        end
        counter_for_servo += 1
        
    elsif distance > 160
        # サーボモーターの動作(開脚)
        counter_for_servo = 0
        servo1.pulse_width_us(1900)
        servo2.pulse_width_us(1100)
    end
end