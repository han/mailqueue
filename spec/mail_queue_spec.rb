require 'spec_helper'
require 'mail'
require 'stalker'
require 'mail_queue'
#  require 'ruby-debug'
#  Debugger.start

def Stalker.log(msg)  
end


describe "beanstalk" do
  it "should be running" do
    Stalker.beanstalk.stats
  end
end 

describe MailQueue do
  
  it "should be valid" do
    MailQueue.should be_a(Module)
  end
    
  describe "sending a mail"

  before(:each) do
    @mail = Mail.new do
      from 'sjeng@example.com'
      to 'sjeng@example.com'
      subject 'test from MailQueue'
      body 'this is my body'
    end
    @mail.delivery_method MailQueue::Beanstalk
    @msg = @mail.to_s
  end
  
  it "should use Mail to serialize an e-mail" do
    @msg.should match /From: sjeng@example\.com/
    @msg.should match /this is my body/
    @msg.should_not match /and my soul/
  end
  
  
  it "should put the message on a queue" do
    @mail.deliver!
    
    Stalker.job 'email.send' do |args|
      msg = args['message']
      msg.should match /From: sjeng@example\.com/
      msg.should match /this is my body/
      msg.should_not match /and my soul/
      args['from'].should == "sjeng@example.com"
      args['destinations'].should == ["sjeng@example.com"]
    end
    Stalker.prep
    Stalker.work_one_job
      
  end
  
  it "should validate presence of from attribute" do
    expect {
      @mail.from = ""
      @mail.deliver!
    }.to raise_error(ArgumentError)
  end
  
  it "should validate presence of to attribute" do
    expect {
      @mail.to = []
      @mail.deliver!
    }.to raise_error(ArgumentError)
  end

  it "should put a message on the correct tube" do
    @mail.delivery_method.settings["tube"] = "boe"
    @mail.deliver!
    
    Stalker.job 'boe' do |args|
      msg = args['message']
      msg.should match /From: sjeng@example\.com/
      msg.should match /this is my body/
      msg.should_not match /and my soul/
      args['from'].should == "sjeng@example.com"
      args['destinations'].should == ["sjeng@example.com"]
    end
    Stalker.prep
    Stalker.work_one_job
 
  end
  
end