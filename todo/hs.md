# Hacker Scripts 黑客脚本

Based on a _[true story](https://www.jitbit.com/alexblog/249-now-thats-what-i-call-a-hacker/)_:

这是个 _[真事儿](https://www.jitbit.com/alexblog/249-now-thats-what-i-call-a-hacker/)_:

> xxx: OK, so, our build engineer has left for another company. The dude was literally living inside the terminal. You know, that type of a guy who loves Vim, creates diagrams in Dot and writes wiki-posts in Markdown... If something - anything - requires more than 90 seconds of his time, he writes a script to automate that.

> xxx: 我们的架构工程师跳槽了。这家伙简直就活在命令行里，你懂么，就是那种迷恋 Vim ，用 Dot 画图表，用 Markdown 写 wiki 的那种人。要是有任何事要花他 90 秒以上，他就要写个自动化脚本。

> xxx: So we're sitting here, looking through his, uhm, "legacy"

> xxx: 我们来看看他的，呃，“遗产”。

> xxx: You're gonna love this

> xxx: 你会喜欢的。

> xxx: [`smack-my-bitch-up.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/smack-my-bitch-up.sh) - sends a text message "late at work" to his wife (apparently). Automatically picks reasons from an array of strings, randomly. Runs inside a cron-job. The job fires if there are active SSH-sessions on the server after 9pm with his login.

> xxx: [`扇你个婆娘.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/smack-my-bitch-up.sh) - 写好 cron ，如果晚上 9 点服务器上还有 ssh 会话，就自动给他老婆（很明显）发个“加班”的短信，附加一个自动从字符串数组里随机挑选的理由。

> xxx: [`kumar-asshole.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/kumar-asshole.sh) - scans the inbox for emails from "Kumar" (a DBA at our clients). Looks for keywords like "help", "trouble", "sorry" etc. If keywords are found - the script SSHes into the clients server and rolls back the staging database to the latest backup. Then sends a reply "no worries mate, be careful next time".

> xxx: [`库马尔个傻逼.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/kumar-asshole.sh) - 扫描邮箱里来自“库马尔”（客户公司的 DBA ）的邮件，如果搜到“帮忙”，“问题”，“不好意思”等关键字，就自动 ssh 到客户的服务器上把数据库恢复到最近的备份，然后回复邮件“没事了，下次注意点”。

> xxx: [`hangover.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/hangover.sh) - another cron-job that is set to specific dates. Sends automated emails like "not feeling well/gonna work from home" etc. Adds a random "reason" from another predefined array of strings. Fires if there are no interactive sessions on the server at 8:45am.

> xxx: [`喝多了.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/hangover.sh) - 这又是个指定日期的任务计划。如果早上 8:45 服务器上还没有会话，就自动（给老板）发一封“有点不舒服/准备在家办公”之类的邮件，附加一个从另一个字符串数组里随机挑选的理由。

> xxx: (and the oscar goes to) [`fucking-coffee.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/fucking-coffee.sh) - this one waits exactly 17 seconds (!), then opens a telnet session to our coffee-machine (we had no frikin idea the coffee machine is on the network, runs linux and has a TCP socket up and running) and sends something like `sys brew`. Turns out this thing starts brewing a mid-sized half-caf latte and waits another 24 (!) seconds before pouring it into a cup. The timing is exactly how long it takes to walk to the machine from the dudes desk.

> xxx: (最牛逼的是这个) [`草蛋的咖啡.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/fucking-coffee.sh) - 先等 17 秒，然后 telnet 到我们的咖啡机上（我们他妈的都不知道这个咖啡机竟然是联网的，跑 linux ，还开了个 socket ）然后执行 `sys brew` 什么什么的命令。 后来我们才搞明白，原来是冲个中杯半咖拿铁，再等 24 秒，然后才灌到杯子里。这个时间，正好是这个家伙从他桌子走到咖啡机的时间。

> xxx: holy sh*t I'm keeping those

> xxx: 我草，收藏了 

Original: http://bash.im/quote/436725 (in Russian)  

出处： http://bash.im/quote/436725 (俄语)  

Pull requests with other implementations (Python, Perl, Shell, etc) are welcome.

欢迎其他语言实现（Python, Perl, Shell 等）的 pl 。

## Usage 用法

You need these environment variables:

你需要如下环境变量：

```sh
# used in `smack-my-bitch-up` and `hangover` scripts
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

# used in `kumar_asshole` script
GMAIL_USERNAME=admin@example.org
GMAIL_PASSWORD=password
```

For Ruby scripts you need to install gems: `gem install dotenv twilio-ruby gmail`

Ruby 脚本需要安装 gems: `gem install dotenv twilio-ruby gmail`

## Cron jobs 任务计划

```sh
# Runs `smack-my-bitch-up.sh` monday to friday at 9:20 pm.
# 周一到周五每天 21:20 运行 `smack-my-bitch-up.sh`
20 21 * * 1-5 /path/to/scripts/smack-my-bitch-up.sh >> /path/to/smack-my-bitch-up.log 2>&1

# Runs `hangover.sh` monday to friday at 8:45 am.
# 周一到周五每天 8:45 运行 `hangover.sh`
45 8 * * 1-5 /path/to/scripts/hangover.sh >> /path/to/hangover.log 2>&1

# Runs `kumar-asshole.sh` every 10 minutes.
# 每隔 10 分钟运行一次 `kumar-asshole.sh`
*/10 * * * * /path/to/scripts/kumar-asshole.sh

# Runs `fucking-coffee.sh` hourly from 9am to 6pm on weekdays.
# 工作日早 9 到晚 6 每小时运行一次 `fucking-coffee.sh`
0 9-18 * * 1-5 /path/to/scripts/fucking-coffee.sh
```

---
Code is released under WTFPL.

代码遵循 WTFPL 协议。
