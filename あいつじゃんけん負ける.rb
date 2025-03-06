#勝ち　負け　負け
janken = rand(1..3)
if janken == 1
    puts "明日のじゃんけんで藤田は負ける"
elsif janken == 2
    puts "明日のじゃんけんで藤田は勝つだろう"
else 
    puts "明日のじゃんけんで高確率で藤田は負ける！"
end