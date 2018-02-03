#!/usr/bin/env ruby


# file: sps_messenger.rb

# description: Subscribes to SPS messages intended for a human. 
#
# Messages could include: 
#
#   * weather info
#   * reminders (e.g. upcoming events or appointsments, to-do list)
#   * unread important email
#   * local news headlines
#   * price of Bitcoin
#   * latest RSS headlines etc.

require "socket"
require 'sps-sub'
require 'sps-pub'
require "curses"
include Curses



class SPSMessenger < SPSSub


  def start(watchx: false, pub_host: 'sps', pub_port: '59000', 
            client_id: Socket.gethostname)
    
    Curses.init_screen
    #x = Curses.cols / 2  # We will center our text
    x = 0
    y = Curses.lines / 2
    Curses.setpos(y, x)  # Move the cursor to the center of the screen
    curs_set(0) # invisible cursor
    start_color
    init_pair(COLOR_GREEN, COLOR_GREEN,COLOR_BLACK) 
    init_pair(COLOR_YELLOW,COLOR_YELLOW,COLOR_BLACK)
    attron(color_pair(COLOR_GREEN)|A_NORMAL){ addstr('ready ') }
    refresh()
    
    Thread.new { watch_xset(pub_host, pub_port, client_id) } if watchx

    subscribe(topic: 'messenger | ' + client_id + '/messenger')
    
  end

  private


  def subscribe(topic: 'messenger')

    super(topic: topic) do |msg|

      clear()
      #x = cols / 2  # We will center our text
      x = 0
      y = lines / 2
      setpos(y, x)  # Move the cursor to the center of the screen


      begin
        #flash()
        #addstr(msg)  # Display the text
        #attron(color_pair(COLOR_YELLOW)|A_NORMAL){ addstr(msg) }
        addstr(msg)
        refresh  # Refresh the screen

      end

    end

  end
  
  # Monitors the state of the monitor (either On or Off). 
  # To use this feature you must be using X Windows  and have DPMS enabled.
  # To enable DPMS, go to the screensaver settings, click on the *advanced* 
  # tab and enable power management. Note: This only enables the power 
  # management of the monitor.
  #
  def watch_xset(host, port, client_id)
    
    pub = SPSPub.new host: host, port: port
    pub.notice 'sps_messenger: publisher ready'
    old_state = 'on'
    
    loop do
      
      state = `xset -q`[/(?<=Monitor is )\w+/].downcase

      if state != old_state then
        pub.notice "monitor/%s/%s: Display monitor for %s is now %s " % \
            [state, client_id.downcase,client_id.downcase, state] 
        old_state = state        
      end
      
      sleep 1
      
    end

  end

end

if __FILE__ == $0 then
  SPSMessenger.new(host: ARGV[0] || 'sps').start
end
