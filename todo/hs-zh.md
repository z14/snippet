# 黑客脚本

这是个 _[真事儿](https://www.jitbit.com/alexblog/249-now-thats-what-i-call-a-hacker/)_:

> xxx: 我们的架构工程师跳槽了。这家伙简直就活在命令行里，你懂么，就是那种迷恋 Vim ，用 Dot 画图表，用 Markdown 写 wiki 的那种人。要是有任何事要花他 90 秒以上，他就要写个自动化脚本。

> xxx: 我们来看看他的，呃，“遗产”。

> xxx: 你会喜欢的。

> xxx: [`扇你个婆娘.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/smack-my-bitch-up.sh) - 写好 cron ，如果晚上 9 点服务器上还有 ssh 会话，就自动给他老婆（很明显）发个“加班”的短信，附加一个自动从字符串数组里随机挑选的理由。

> xxx: [`库马尔个傻逼.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/kumar-asshole.sh) - 扫描邮箱里来自“库马尔”（客户公司的 DBA ）的邮件，如果搜到“帮忙”，“问题”，“不好意思”等关键字，就自动 ssh 到客户的服务器上把数据库恢复到最近的备份，然后回复邮件“没事了，下次注意点”。

> xxx: [`喝多了.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/hangover.sh) - 这又是个指定日期的任务计划。如果早上 8:45 服务器上还没有会话，就自动（给老板）发一封“有点不舒服/准备在家办公”之类的邮件，附加一个从另一个字符串数组里随机挑选的理由。

> xxx: (最牛逼的是这个) [`草蛋的咖啡.sh`](https://github.com/NARKOZ/hacker-scripts/blob/master/fucking-coffee.sh) - 先等 17 秒，然后 telnet 到我们的咖啡机上（我们他妈的都不知道这个咖啡机竟然是联网的，跑 linux ，还开了个 socket ）然后执行 `sys brew` 什么什么的命令。 后来我们才搞明白，原来是冲个中杯半咖拿铁，再等 24 秒，然后才灌到杯子里。这个时间，正好是这个家伙从他桌子走到咖啡机的时间。

> xxx: 我草，收藏了 

出处： http://bash.im/quote/436725 (俄语)  

欢迎其他语言实现（Python, Perl, Shell 等）的 pl 。

## 用法

你需要如下环境变量：

```sh
# used in `smack-my-bitch-up` and `hangover` scripts
TWILIO_ACCOUNT_SID=ACxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
TWILIO_AUTH_TOKEN=yyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy

# used in `kumar_asshole` script
GMAIL_USERNAME=admin@example.org
GMAIL_PASSWORD=password
```

Ruby 脚本需要安装 gems: `gem install dotenv twilio-ruby gmail`

## Cron jobs 任务计划

```sh
# 周一到周五每天 21:20 运行 `扇你个婆娘.sh`
20 21 * * 1-5 /path/to/scripts/smack-my-bitch-up.sh >> /path/to/smack-my-bitch-up.log 2>&1

# 周一到周五每天 8:45 运行 `喝多了.sh`
45 8 * * 1-5 /path/to/scripts/hangover.sh >> /path/to/hangover.log 2>&1

# 每隔 10 分钟运行一次 `库马尔个傻逼.sh`
*/10 * * * * /path/to/scripts/kumar-asshole.sh

# 工作日早 9 到晚 6 每小时运行一次 `草蛋的咖啡.sh`
0 9-18 * * 1-5 /path/to/scripts/fucking-coffee.sh
```
---
代码遵循 WTFPL 协议。
