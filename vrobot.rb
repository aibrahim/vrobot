#!/usr/bin/env ruby

#by       Abdullah Ibrahim
#license  GPLv2 
#mail     abdullahibra@gmail.com

def get_selection
  return `xclip -o` if RUBY_PLATFORM =~ /linux/
  return `pbpaste`  if RUBY_PLATFORM =~ /darwin/
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
  
  def to_wikipedia
    url = %{ http://en.wikipedia.org/wiki/"#{@text}" }
    runprog(@browser, url)
  end
  
  def to_facebook
    url = %{ http://www.facebook.com/search.php?q="#{@text}" }
    runprog(@browser, url)
  end
  #############################################################
  # You can define More actions here as suitable for your use #
  # Also all requests to add new actions idea to this code    #
  #                       are welcomed                        #
  #############################################################
end

key = []

loop { 
  case ARGV[0]
  when '-g' then  ARGV.shift; key << 'g'
  when '-t' then  ARGV.shift; key << 't'
  when '-s' then  ARGV.shift; key << 's'
  when '-e' then  ARGV.shift; key << 'e'
  when '-w' then  ARGV.shift; key << 'w'
  when '-f' then  ARGV.shift; key << 'f'
  when nil
    break
  end 
}

selection = get_selection()
newaction = Actions.new(selection, nil, nil, nil, nil)

fork { newaction.to_google }         if key.include? 'g'
fork { newaction.to_translate }      if key.include? 't'
fork { newaction.to_stackoverflow }  if key.include? 's'
fork { newaction.to_editor }         if key.include? 'e'
fork { newaction.to_wikipedia }      if key.include? 'w'
fork { newaction.to_facebook }       if key.include? 'f'

