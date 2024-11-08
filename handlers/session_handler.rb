module SessionHandler
  def login
    credentials = credentials_form
    @user = Services::Sessions.login(credentials)
    notes_page
  end
end
