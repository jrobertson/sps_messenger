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

require 'sps-sub'
require "curses"
include Curses



class SPSMessenger < SPSSub

  def onmessage(msg)
    clear_screen()
    puts msg
  end

  def start()
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

    subscribe()
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

end

if __FILE__ == $0 then
  SPSMessenger.new(host: ARGV[0] || 'sps').start
end
