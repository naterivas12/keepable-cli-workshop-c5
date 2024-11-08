require "httparty"
require "json"

module Services
  class Notes
    include HTTParty

    base_uri("https://keepable-api.herokuapp.com/notes")

    def self.index_notes(token)
      options = {
        headers: { Authorization: "Token token=#{token}" }
      }

      response = get("/", options)
      raise(HTTParty::ResponseError, response) unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.create_note(token, note_data)
      options = {
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: note_data.to_json
      }

      response = post("/", options)
      raise(HTTParty::ResponseError, response) unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.update_note(token, id, note_data)
      options = {
        headers: {
          Authorization: "Token token=#{token}",
          "Content-Type": "application/json"
        },
        body: note_data.to_json
      }

      response = patch("/#{id}", options)
      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true)
    end

    def self.delete_note(token, id)
      options = {
        headers: {
          Authorization: "Token token=#{token}"
        }
      }

      response = delete("/#{id}", options)
      raise HTTParty::ResponseError, response unless response.success?

      JSON.parse(response.body, symbolize_names: true) unless response.body.nil?
    end
  end
end
