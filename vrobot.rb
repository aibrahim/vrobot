#!/usr/bin/env ruby

#by       Abdullah Ibrahim
#license  GPLv2 
#mail     abdullahibra@gmail.com

#need xclip installed
def get_selection
  `xclip -o`
end

#run program with argument
def runprog(prog, arg)
	%x( #{prog} #{arg} )
end

class Actions
  def initialize(text, browser, fromlang, tolang, editor)
    @text     = text
    @fromlang = fromlang || 'en'
    @tolang   = tolang   || 'ar'
    @browser  = browser  || 'google-chrome'
    @editor   = editor   || 'gedit'
  end
  
  def to_s
    "#{@text}"
  end

  def to_google
    url = %{ https://www.google.com.eg/#q="#{@text}" }
    runprog(@browser, url)
  end
  
  def to_translate
    url = %{ http://translate.google.com/\##{@fromlang}/#{@tolang}/"#{@text}" }
    runprog(@browser, url)
  end
  
  def to_stackoverflow
    url = %{ http://stackoverflow.com/search?q="#{@text}" }
    runprog(@browser, url)
  end
  
  def to_editor
    nsec = Time.now.nsec
    fname = "/tmp/junk-#{nsec}"
    File.open(fname, 'w') do |f|
      f.write(@text)
    end
    %x( #{@editor} #{fname} )
  end
  ############################################################
  # You ca define More actions here as suitable for your use #
  # Also all requests to add new actions idea to this code   #
  #                       are welcomed                       #
  ############################################################
end

key = nil

loop { 
    case ARGV[0]
    when '-g' then  ARGV.shift; key = 'g'
    when '-t' then  ARGV.shift; key = 't'
    when '-s' then  ARGV.shift; key = 's'
    when '-e' then  ARGV.shift; key = 'e'
    else break
    end 
}

selection = get_selection()
newaction = Actions.new(selection, nil, nil, nil, nil)

case key
when 'g'
  newaction.to_google
when 't'
  newaction.to_translate
when 's'
  newaction.to_stackoverflow
when 'e'
  newaction.to_editor
end

