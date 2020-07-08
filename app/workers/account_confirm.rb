class AccountConfirm
  include Sidekiq::Worker

  def perform(name, count)
    # do something
  end
end

{"rank":"Above average Booster",
  "level":23,
  "gender":"Male",
  "property":"Private Island",
  "signup":"2019-11-13 02:16:14",
  "awards":85,"friends":8,"enemies":2,
  "forum_posts":10,"karma":5,"age":238,
  "role":"Civilian","donator":0,"player_id":2422075,
  "name":"archetype2142","property_id":2835699,
  "life":{"current":1281,"maximum":1281,"increment":64,
    "interval":300,"ticktime":230,"fulltime":0},
    "status":{"description":"Okay","details":"",
      "state":"Okay","color":"green","until":0},
      "job":{"position":"Employee",
        "company_id":71200,"company_name":"[Hiring] Blow Me &#127788;&#65039;"},
        "faction":{"position":"Member","faction_id":12249,"days_in_faction":61,"faction_name":"PnB Proteges"},
        "married":{"spouse_id":2185858,"spouse_name":"JWIL","duration":42},
        "basicicons":{"icon6":"Male","icon8":"Married - To JWIL","icon27":"Company - Employee of [Hiring] Blow Me &#127788;&#65039; (Candle Shop)","icon9":"Faction - Member of PnB Proteges"},"states":{"hospital_timestamp":0,"jail_timestamp":0},"last_action":{"status":"Online","timestamp":1594230636,"relative":"0 minutes ago"}}
