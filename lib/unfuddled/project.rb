module Unfuddled
  # Project Class
  #
  # Class for a Project hosted on Unfuddle
  # Provides access to milestones , tickets and messages
  class Project < Unfuddled::Base

    # Get Project Tickets
    #
    # @return [Array(Unfuddled::Ticket)]
    def tickets
      @client.tickets_for_project( id )
    end
     
    # To String
    # @return [String]
    def to_s
      "Unfuddled::Project: #{title}"
    end

    # Get the milestones
    #
    # @memoized
    # @param status [Symbol] Milestone Status
    #                        Can be +:late+ , +:upcoming+ , +:completed+ or +:archived+
    # @return [Array(Unfuddled::Milestone)]
    def milestones(status = nil)
      if status.nil? then
        url = "/api/v1/projects/#{id}/milestones.json"
      else
        url = "/api/v1/projects/#{id}/milestones/#{status}.json"
      end

      @client.process_list_response( @client.send(:get , url)[:body] , Unfuddled::Milestone )
    end
    memoize(:milestones)

  end
end
