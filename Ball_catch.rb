servo1 = PWM.new(27, timer: 2, channel: 3, frequency: 50)
servo2 = PWM.new(14, timer: 2, channel: 4, frequency: 50)

i2c = I2C.new()
vl53l0x = VL53L0X.new(i2c)
vl53l0x.set_timeout(500)

servo1.pulse_width_us(1900)
servo2.pulse_width_us(1100)

vl53l0x.start_continuous(200)
loop do
    distance = vl53l0x.read_range_continuous_millimeters
    puts distance.to_s
    if distance < 110
        servo1.pulse_width_us(1370)
        servo2.pulse_width_us(1630)
    end
end