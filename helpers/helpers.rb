module Helpers
  def get_with_options(options, required: true, default: nil)
    action = ""
    id = nil
    loop do
      puts options.join(" | ")
      print "> "
      action, id = gets.chomp.split # ["update", "48"]
      break if options.include?(action) || (action.nil? && !required)

      puts "Invalid option"
    end

    action.nil? && default ? [default] : [action, id]
  end

  def get_string(label, required: false)
    input = ""
    loop do
      print "#{label}: "
      input = gets.chomp
      break unless input.empty? && required

      puts "#{label} can't be blank"
    end
    input.empty? ? nil : input
  end

  def credentials_form
    username = get_string("username")
    password = get_string("password")

    { username: username, password: password }
  end

  def note_form
    title = get_string("title", required: true)
    body = get_string("body")

    puts "Select a color (default: white)"
    options = ["white", "red", "green", "yellow", "blue", "magenta", "cyan"]
    color, _rest = get_with_options(options, required: false, default: "white")

    { title: title, body: body, color: color }
  end

  def update_note_form
    title = get_string("title")
    body = get_string("body")

    puts "Select a color (default: white)"
    options = ["white", "red", "green", "yellow", "blue", "magenta", "cyan"]
    color, _rest = get_with_options(options, required: false)

    { title: title, body: body, color: color }.compact
  end

  def welcome
    [
      "#############################",
      "#    Welcome to Keepable    #",
      "#############################"
    ].join("\n")
  end

  def login_menu
    get_with_options(["login", "create_user", "exit"])
  end

  def notes_menu
    get_with_options(["create", "update", "delete", "toggle", "trash", "logout"])
  end

  def trash_menu
    get_with_options(["delete", "recover", "back"])
  end
end
