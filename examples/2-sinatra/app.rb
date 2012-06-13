require 'sinatra'
require 'wlang'

get '/' do
  wlang :index, :locals => {:who => "world"}
end

__END__

@@layout
  <html>
    >{yield}
  </html>

@@index
  Hello from a partial: >{partial}

@@partial
  yeah, a partial!

