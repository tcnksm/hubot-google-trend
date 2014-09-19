# Description:
#  Show links of trend word on Google. Don't miss new trend.
# 
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_GOOGLE_TREND_TLD - Which google do you want to use. Default value is `com`. 
#
# Commands:
#   hubot trend
#   hubot trend <TLD> - Search trend in <TLD> e.g., uk
#

ParseString = require('xml2js').parseString
Util = require('util')
Request = require 'request'

module.exports = (robot) ->
  
  robot.respond /trend( )?(.*)?/i, (msg) ->
    trend(msg, msg.match[2], robot.adapterName)
    
  robot.on "google-trend", (tld) ->
    trend(robot, tld, robot.adapterName)

trend = (msg,tld,adapter) ->
  trendWord msg, tld, (words) ->
      switch adapter
        when "hipchat"
          sendAsHipChatLink(msg,words)
        when "slack"
          sendAsPlainText(msg,words) # TODO
        else
          sendAsPlainText(msg,words)

trendWord = (msg, tld, cb) ->
  google = "google.com"
  if not tld? and process.env.HUBOT_GOOGLE_TREND_TLD
    tld = process.env.HUBOT_GOOGLE_TREND_TLD

  if Domains[tld]
    google = Domains[tld]

  url = Util.format('http://www.%s/trends/hottrends/atom/hourly',google)
  msg.http(url).get() (err, res, body) ->
    ParseString body, (err, result) ->
      cb extractTrendWords(result)

extractTrendWords = (res) ->
  words = res['feed']['entry'][0]['title'][0]['_'].split(',')
  ( w.trim() for w in words[0...words.length-1] ) # Last element is '...'

sendAsPlainText = (msg, words) ->
  contents = ""
  for i in [0..words.length - 1]
    searchLink words[i], (link) ->
      contents += (i+1) + ": " + words[i] + ", " + link + '\n'
  msg.send contents
    
sendAsHipChatLink = (msg, words) ->
  contents = ""
  for i in [0..words.length - 1]
    searchLink words[i], (link) ->
      contents += Util.format("<a href='%s'>%d: %s</a><br>", link, i+1, words[i])
  postHipChat contents

# Send message to hipchat api v2 as html format
postHipChat = (contents) ->
  url = Util.format('https://api.hipchat.com/v2/room/%s/notification?auth_token=%s', process.env.HUBOT_HIPCHAT_ROOMS_NAME, process.env.HUBOT_HIPCHAT_AUTH_TOKEN)
  Request.post
    url: url
    json:
      message_format: 'html'
      message: contents
  , (err, response, body) ->
    throw err if err

searchLink = (word, cb) ->
  cb Util.format("https://www.google.co.jp/search?q=%s", encodeURI(word))

Domains =
  "com":"google.com"
  "ac":"google.ac"
  "ad":"google.ad"
  "ae":"google.ae"
  "af":"google.com.af"
  "ag":"google.com.ag"
  "ai":"google.com.ai"
  "al":"google.al"
  "am":"google.am"
  "ao":"google.co.ao"
  "ar":"google.com.ar"
  "as":"google.as"
  "at":"google.at"
  "au":"google.com.au"
  "az":"google.az"
  "ba":"google.ba"
  "bd":"google.com.bd"
  "be":"google.be"
  "bf":"google.bf"
  "bg":"google.bg"
  "bh":"google.com.bh"
  "bi":"google.bi"
  "bj":"google.bj"
  "bn":"google.com.bn"
  "bo":"google.com.bo"
  "br":"google.com.br"
  "bs":"google.bs"
  "bt":"google.bt"
  "bw":"google.co.bw"
  "by":"google.by"
  "bz":"google.com.bz"
  "ca":"google.ca"
  "kh":"google.com.kh"
  "cc":"google.cc"
  "cd":"google.cd"
  "cf":"google.cf"
  "cat":"google.cat"
  "cg":"google.cg"
  "ch":"google.ch"
  "ci":"google.ci"
  "ck":"google.co.ck"
  "cl":"google.cl"
  "cm":"google.cm"
  "cn":"google.cn"
  "co":"google.com.co"
  "cr":"google.co.cr"
  "cu":"google.com.cu"
  "cv":"google.cv"
  "cy":"google.com.cy"
  "cz":"google.cz"
  "de":"google.de"
  "dj":"google.dj"
  "dk":"google.dk"
  "dm":"google.dm"
  "do":"google.com.do"
  "dz":"google.dz"
  "ec":"google.com.ec"
  "ee":"google.ee"
  "eg":"google.com.eg"
  "es":"google.es"
  "et":"google.com.et"
  "fi":"google.fi"
  "fj":"google.com.fj"
  "fm":"google.fm"
  "fr":"google.fr"
  "ga":"google.ga"
  "ge":"google.ge"
  "gf":"google.gf"
  "de":"google.de"
  "gg":"google.gg"
  "gh":"google.com.gh"
  "gi":"google.com.gi"
  "gl":"google.gl"
  "gm":"google.gm"
  "gp":"google.gp"
  "gr":"google.gr"
  "gt":"google.com.gt"
  "gy":"google.gy"
  "hk":"google.com.hk"
  "hn":"google.hn"
  "hr":"google.hr"
  "ht":"google.ht"
  "hu":"google.hu"
  "id":"google.co.id"
  "ir":"google.ir"
  "iq":"google.iq"
  "ie":"google.ie"
  "il":"google.co.il"
  "im":"google.im"
  "in":"google.co.in"
  "io":"google.io"
  "is":"google.is"
  "it":"google.it"
  "je":"google.je"
  "jm":"google.com.jm"
  "jo":"google.jo"
  "jp":"google.co.jp"
  "ke":"google.co.ke"
  "ki":"google.ki"
  "kg":"google.kg"
  "kr":"google.co.kr"
  "kw":"google.com.kw"
  "kz":"google.kz"
  "la":"google.la"
  "lb":"google.com.lb"
  "lc":"google.com.lc"
  "li":"google.li"
  "lk":"google.lk"
  "ls":"google.co.ls"
  "lt":"google.lt"
  "lu":"google.lu"
  "lv":"google.lv"
  "ly":"google.com.ly"
  "ma":"google.co.ma"
  "md":"google.md"
  "me":"google.me"
  "mg":"google.mg"
  "mk":"google.mk"
  "ml":"google.ml"
  "mm":"google.com.mm"
  "mn":"google.mn"
  "ms":"google.ms"
  "mt":"google.com.mt"
  "mu":"google.mu"
  "mv":"google.mv"
  "mw":"google.mw"
  "mx":"google.com.mx"
  "my":"google.com.my"
  "mz":"google.co.mz"
  "na":"google.com.na"
  "ne":"google.ne"
  "nf":"google.com.nf"
  "ng":"google.com.ng"
  "ni":"google.com.ni"
  "nl":"google.nl"
  "no":"google.no"
  "np":"google.com.np"
  "nr":"google.nr"
  "nu":"google.nu"
  "nz":"google.co.nz"
  "om":"google.com.om"
  "pa":"google.com.pa"
  "pe":"google.com.pe"
  "ph":"google.com.ph"
  "pk":"google.com.pk"
  "pl":"google.pl"
  "pg":"google.com.pg"
  "pn":"google.pn"
  "pr":"google.com.pr"
  "ps":"google.ps"
  "pt":"google.pt"
  "py":"google.com.py"
  "qa":"google.com.qa"
  "ro":"google.ro"
  "rs":"google.rs"
  "ru":"google.ru"
  "rw":"google.rw"
  "sa":"google.com.sa"
  "sb":"google.com.sb"
  "sc":"google.sc"
  "se":"google.se"
  "sg":"google.com.sg"
  "sh":"google.sh"
  "si":"google.si"
  "sk":"google.sk"
  "sl":"google.com.sl"
  "sn":"google.sn"
  "sm":"google.sm"
  "so":"google.so"
  "st":"google.st"
  "sv":"google.com.sv"
  "td":"google.td"
  "tg":"google.tg"
  "th":"google.co.th"
  "tj":"google.com.tj"
  "tk":"google.tk"
  "tl":"google.tl"
  "tm":"google.tm"
  "to":"google.to"
  "tn":"google.tn"
  "tn":"google.com.tn"
  "tr":"google.com.tr"
  "tt":"google.tt"
  "tw":"google.com.tw"
  "tz":"google.co.tz"
  "ua":"google.com.ua"
  "ug":"google.co.ug"
  "uk":"google.co.uk"
  "us":"google.us"
  "uy":"google.com.uy"
  "uz":"google.co.uz"
  "vc":"google.com.vc"
  "ve":"google.co.ve"
  "vg":"google.vg"
  "vi":"google.co.vi"
  "vn":"google.com.vn"
  "vu":"google.vu"
  "ws":"google.ws"
  "za":"google.co.za"
  "zm":"google.co.zm"
  "zw":"google.co.zw"
