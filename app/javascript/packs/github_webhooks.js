const Discord = require('discord.js');
const client = new Discord.Client();

// var client_id = 743958957571309730
var token = "NzQzOTU4OTU3NTcxMzA5NzMw.XzcPxQ.cLRA9A5DYfg6XAeeQhpRZnqEGcE"
// var permissions = 8

const prefix = '!';

client.once('ready', () => {
  console.log('Torntrader is online!')
});

client.on('message', message => {
  if(!message.content.startsWith(prefix) || message.author.bot) return;

  const args = message.content.slice(prefix.length).split(/ +/);
  const command = args.shift().toLowerCase();

  if(command === "ping") {
    message.channel.send("pong");
  }
})

client.channel()
client.login(token);