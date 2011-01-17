MailQueue
=========


MailQueue is an asynchronous mail delivery method for the Mail gem. It delivers mail to a [Beanstalk](http://kr.github.com/beanstalkd/) queue. Worker processes can then pick up the mail from the queue and send it on over SMTP or the like.

Installation
------------

gem install mail_queue

Configuration
-------------

+ Mail gem:

    Mail.defaults { delivery_method MailQueue::Beanstalk, :tube => 'rculosis' }
    

+ Rails:

    ActionMailer::Base.delivery_method = MailQueue::Beanstalk
    

or, if you insist on changing the default options:

    ActionMailer::Base.add_delivery_method(:beanstalk, MailQueue::Beanstalk)
    ActionMailer::Base.beanstalk_settings = {
      :tube => "email"
    }
    ActionMailer::Base.delivery_method = :beanstalk


options are:

+ :pri    priority, from 0 to 2^32, 0 being the highest, 65536 the default 

+ :ttr    time to run, default 120 (seconds)

+ :delay  how many seconds before the job is put on the ready queue (default 0)

+ :tube   tube name used on beanstalk, defaults to 'email.send'


Worker
------

Have a worker pull the mails off the queue.
For example, using [Stalker](http://github.com/adamwiggins/stalker):

    smtp = Net::SMTP.new('smtp.example.com', 25)
    job 'email.send' do |args|
      smtp.start('example.com', 'me', 'mypassword', 'plain') do |smtp|
        smtp.sendmail(args['message'], args['from'], args['destinations'])
      end
    end 

See [Stalker](http://github.com/adamwiggins/stalker) documentation for how to run a job.


Meta
----

Created by Han Kessels

Released under the MIT License: http://www.opensource.org/licenses/mit-license.php

http://github.com/han/mailqueue

