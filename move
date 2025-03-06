  def move(m1p1,m1p2,m2p1, m2p2)
    @motor1_pwm1.duty(m1p1)
    @motor1_pwm2.duty(m1p2)
    @motor2_pwm1.duty(m2p1)
    @motor2_pwm2.duty(m2p2)
  end

  def stop; move(50, 50, 50, 50);@counter = -1; end
  def back; move(50, 100, 50, 100); end
  def turn_left; move(100, 50, 50, 50); end
  def turn_right; move(50, 50, 100, 50 ); end
  def turnslow_left; move(100, 80, 50, 50); end
  def turnslow_right; move(50, 100, 50, 100); end
  def dash_mode1; move(50, 50, 100, 80); end
  def dash_mode2; move(100, 70, 100, 73); end
