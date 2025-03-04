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
loop do
    distance = vl53l0x.read_range_continuous_millimeters
    puts distance.to_s
    if distance < 110
        servo1.pulse_width_us(1370)
        servo2.pulse_width_us(1630)
    else
        servo1.pulse_width_us(1900)
        servo2.pulse_width_us(1100)
    end
end