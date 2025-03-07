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
    def move(m1p1,m1p2,m2p1, m2p2)
        @motor1_pwm1.duty(m1p1)
        @motor1_pwm2.duty(m1p2)
        @motor2_pwm1.duty(m2p1)
        @motor2_pwm2.duty(m2p2)
    end

      def stop; move(50, 50, 50, 50); end
      def back; move(50, 100, 50, 100); end
      def turn_left; move(100, 50, 50, 50); end
      def turn_right; move(50, 50, 100, 50 ); end
      def turnslow_left; move(100, 77, 50, 50); end
      def turnslow_right; move(50, 50, 100, 77); end
      def dash; move(100, 70, 100, 67); end 
      def dash2; move(100, 60, 100, 57); end #出力duty比40%、43%
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
            # 左右とも黒、全動作一旦停止あり
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
                if robotto.counter > 6 && !robotto.catched && robotto.ball_find
                    robotto.stop
                    robotto.counter = -1
                    robotto.ball_find = false
                elsif robotto.counter % 8 == 0 && !robotto.ball_find && robotto.counter > 0
                    robotto.back
                    sleep 10
                    robotto.dash
                else
                    robotto.dash
                end
            else
                robotto.turnslow_right
                5.times do
                    sleep 1
                    if robotto.read_distance
                        break
                    end
                end
                if robotto.ball_find
                    robotto.stop
                    robotto.counter = -1
                else 
                    robotto.back
                end
                first_loop = false
            end
        end
    end

    distance = robotto.vl53l0x.read_range_continuous_millimeters
    if distance < 170 && !robotto.fieldout
        robotto.hand_close
        if !robotto.catched
            robotto.dash2
            sleep (1.5)
        end
        robotto.ball_find = true
        robotto.catched = true
    elsif robotto.ball_find == false && robotto.counter % 3 == 0
        robotto.hand_open
        #首振り
        sleep 1
        robotto.turnslow_left
        6.times do
            sleep 1
            if robotto.read_distance
                break
            end
        end
        if robotto.ball_find
            robotto.counter = -1
            next
        end
        if robotto.lux_left.read_raw < 200
            robotto.turnslow_right
            sleep 1
        end
        robotto.turnslow_right
        sleep 3
        5.times do
            sleep 1
            if robotto.read_distance
                break
            end
        end
        if robotto.ball_find
            robotto.counter = -1
            next
        end
        if robotto.lux_right.read_raw < 200 
            robotto.turnslow_left
            sleep 1
        end
        if robotto.read_distance
            next
        end
        robotto.turnslow_left
        sleep 2
    end
    sleep 1
    robotto.counter += 1
end