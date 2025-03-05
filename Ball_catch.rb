i2c = I2C.new()
vl53l0x = VL53L0X.new(i2c)
vl53l0x.set_timeout(600)

vl53l0x.init
vl53l0x.start_continuous(100)
loop do
    distance = vl53l0x.read_range_continuous_millimeters
    puts distance.to_s
end
