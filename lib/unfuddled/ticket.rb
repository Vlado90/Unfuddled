require 'memoizer'
module Unfuddled
  # Ticket Class
  # 
  # Class for a Ticket, part of a Project hosted on Unfuddle
  # Provides access to its milestone, reporter, time entries and comments
  class Ticket < Unfuddled::Base

    include Memoizer
    
    # Get the time entries for the ticket
    #
    # @return [Array[Unfuddled::TimeEntry]]
    def time_entries
      get_ticket_property_list("time_entries" , Unfuddled::TimeEntry)
    end

    # Get the project for the ticket
    #
    # @memoized
    # @return [Unfuddled::Project]
    def project
      @client.project(:id => project_id)
    end
    memoize(:project)

    # To String
    # @return [String]
    def to_s
      "Unfuddled::Ticket: ##{number} #{summary}"
    end

    # Get the custom fields
    #
    # @return [Array(Unfuddled::CustomField)]
    def custom_fields
      field_values = @client.account_details.custom_field_values

      fields = []

      3.times do |i|
        n = i+1

        if send(:"field#{n}_value_id").nil?
          fields << nil
        else

          field_value = field_values.select { |fv| fv["id"] == send(:"field#{n}_value_id") }
          fields << Unfuddled::CustomField.new(
                                               :number => n,
                                               :title  => project.send(:"ticket_field#{n}_title"),
                                               :type   => project.send(:"ticket_field#{n}_disposition"),
                                               :value  => field_value
                                               )
        end
      end

      fields
    end

    # Get the ticket reporter
    #
    # @memoized
    # @return [Unfuddled::Person]
    def reporter
      @client.person(reporter_id)
    end
    memoize(:reporter)

    # Get the milestone for this ticket
    #
    # @memoized
    # @return [Unfuddled::Milestone]
    def milestone
      @client.milestone(project_id , milestone_id)
    end
    memoize(:milestone)

    # Get / Update / Set ticket comments
    #
    # @return [Array(Unfuddled::Comment)]
    def comments
      get_ticket_property_list("comments" , Unfuddled::Comment)
    end

    # Add a new Comment
    #
    # @param  body [String] Body text for Comment
    # @return      [Integer] Newly created comment ID
    def add_comment(body)

      raise ArgumentError("Comment body must be a string") unless body.is_a?(String)

      url = "/api/v1/projects/#{project_id}/tickets/#{id}/comments.json"
      @client.post(url , {:body => body})
    end
    


    # Save a Ticket
    def save
      raise Unfuddled::Error.new("Cannot Create a new ticket like this. Use Unfuddled::Ticket.create(@client , DATA)") if id.nil?

      url = "/api/v1/projects/#{project_id}/tickets/#{id}.json"
      method = :put

      @client.send(method , url , send(:to_h))
    end

    private
    def get_ticket_property_list(p_name , klass)
      url = "/api/v1/projects/#{project_id}/tickets/#{id}/#{p_name}.json"
      @client.process_list_response( @client.send(:get , url)[:body] , klass)
    end

  end
end
