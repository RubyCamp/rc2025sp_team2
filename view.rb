#ビジュアライザー
#カニとボール表示ver.

#ボール初期位置指定用変数 
default_ball_pos = 'c'

#wifiの設定
wlan = WLAN.new('STA')
wlan.connect("RubyCamp", "shimanekko")

#カニロボの初期位置指定
$now_pos_kani_x = 690
$now_pos_kani_y = 100
$now_ang_kani = 180


#team_members_ip=[#チームメンバーのipアドレス格納用配列(書きかけ・多分使わん)

#ボールの初期位置指定用配列
$default_ball_pos_x =[130,265,400,530,660]
$default_ball_pos_y = [300,145,450,150,300]
    
  
#ボールの初期位置指定    
case default_ball_pos
when 'a' then
$now_pos_ball_x = $default_ball_pos_x[0]
$now_pos_ball_y = $default_ball_pos_y[0]
$now_ang_ball = 0
when 'b' then
$now_pos_ball_x = $default_ball_pos_x[1]
$now_pos_ball_y = $default_ball_pos_y[1]
$now_ang_ball = 0
when 'c' then
$now_pos_ball_x = $default_ball_pos_x[2]
$now_pos_ball_y = $default_ball_pos_y[2]
$now_ang_ball = 0
when 'd' then
$now_pos_ball_x = $default_ball_pos_x[3]
$now_pos_ball_y = $default_ball_pos_y[3]
$now_ang_ball = 0
when 'e' then
$now_pos_ball_x = $default_ball_pos_x[4]
$now_pos_ball_y = $default_ball_pos_y[4]
$now_ang_ball = 0
end

#データ送信用関数
def send_data (now_pos_kani_x,now_pos_kani_y,now_ang_kani,now_pos_ball_x,now_pos_ball_y,now_ang_ball)
  #if wlan.connected?
  
    #192.168.6.31落合 
    HTTP.get( "http://192.168.6.31:3000/angle?op=abs&value=#{now_ang_kani}&target=Kani1")
    HTTP.get( "http://192.168.6.31:3000/position?op=abs&x=#{now_pos_kani_x}&y=#{now_pos_kani_y}&target=Kani1")
    
    HTTP.get( "http://192.168.6.31:3000/angle?op=abs&value=#{now_ang_ball}&target=Ball")
    HTTP.get( "http://192.168.6.31:3000/position?op=abs&x=#{now_pos_ball_x}&y=#{now_pos_ball_y}&target=Ball")
    
    
    #192.168.6.22藤田
    #HTTP.get( "http://192.168.6.22:3000/angle?op=abs&value=#{now_ang_kani}&target=Kani1")
    #HTTP.get( "http://192.168.6.22:3000/position?op=abs&x=#{now_pos_kani_x}&y=#{now_pos_kani_y}&target=Kani1")
    
    #HTTP.get( "http://192.168.6.22:3000/angle?op=abs&value=#{now_ang_ball}&target=Ball")
    #HTTP.get( "http://192.168.6.22:3000/position?op=abs&x=#{now_pos_ball_x}&y=#{now_pos_ball_y}&target=Ball")
    
    sleep 0.1
  #end
end

#カニロボの座標更新用関数
def update_data_kani (ang_diff = 0,pos_diff_x= 0,pos_diff_y= 0)
  $now_ang_kani = ang_diff
  $now_pos_kani_x += pos_diff_x
  $now_pos_kani_y += pos_diff_y
end

#ボールの座標更新用関数
def update_data_ball (ang_diff= 0,pos_diff_x= 0,pos_diff_y= 0)
  $now_ang_ball = ang_diff
  $now_pos_ball_x += pos_diff_x
  $now_pos_ball_y += pos_diff_y
end


loop do
  
  #wifiに接続できていれば
  if wlan.connected?

#カニロボがフィールド内にいる間、45度に向けて10ずつ左下に移動(動作確認用)
if($now_pos_kani_x <= 750 && $now_pos_kani_y <= 550)
    update_data_kani(225,-10,10)
    update_data_ball(225,-10,10)
else　#場外に出た場合初期位置に戻す(動作確認用)
    $now_pos_kani_x = 600
    $now_pos_kani_y = 100
    $now_ang_kani = 180
end
    
#ボールが場外に出た場合ポップアップ(現在不具合あり・要修正)    
if ($now_pos_ball_x <= 800 || $now_pos_bwll_y <= 600)    
    HTTP.get( "http://192.168.6.31:3000/target=Goal&visible=true")
end
    
    #パソコンにデータ送信
    send_data($now_pos_kani_x,$now_pos_kani_y,$now_ang_kani,$now_pos_ball_x,$now_pos_ball_y,$now_ang_ball)


   end
  end
