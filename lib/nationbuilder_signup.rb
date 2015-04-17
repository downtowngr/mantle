require "nationbuilder"

class NationbuilderSignup
  def initialize(email)
    @email  = email
    @client = NationBuilder::Client.new(ENV["NATIONBUILDER_NAME"], ENV["NATIONBUILDER_TOKEN"])
  end

  def subscribe
    response = @client.call(:people, :push, {person: {email: @email, email_opt_in: true}})

    if response["code"] == "validation_failed"
      false
    else
      @client.call(:people, :tag_person, id: response["person"]["id"], tagging: {tag: ENV["NATIONBUILDER_TAG"]})
      true
    end
  end
end