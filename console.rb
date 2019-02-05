require_relative("./models/bounty.rb")

Bounty.delete_all()

bounty1 = Bounty.new({
  "name" => "Spike Spiegel",
  "bounty_value" => 5000,
  "danger_level" => "high",
  "location" => "Mars"
  })

bounty2 = Bounty.new({
  "name" => "Faye Valentine",
  "bounty_value" => 2500,
  "danger_level" => "medium",
  "location" => "Earth"
  })

bounty1.save()
bounty2.save()
