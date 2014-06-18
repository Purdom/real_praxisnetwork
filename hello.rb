require 'tk'
 
hello = TkRoot.new do
  title "Hello Purdom"
  minsize(400,400)
end
 
TkLabel.new(hello) do
  text 'Hello Purdom'
  foreground 'red'
  pack { padx 15; pady 15; side 'left' }
end
 
TkButton.new do
  text "EXIT"
  command { exit }
  pack{ side 'left'; padx 10; pady 10 }
end
 
Tk.mainloop
