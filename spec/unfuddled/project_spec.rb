require 'helper'

describe Unfuddled::Project do
  before do
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => "SUBDOMAIN",
                                          :username => "USER",
                                          :password => "PASS"
                                          )

    stub_request(:get , stub_path(@client , '/projects.json'))
      .to_return(:body => fixture("projects.json"),
                 :headers => {
                   :content_type => 'application/json'
                 })

    stub_request(:get , stub_path(@client , "/projects/1024/tickets.json"))
      .to_return(:body => fixture("tickets.json"),
                 :headers => {
                   :content_type => "application/json"
                 })
                

    @project = @client.projects.first
  end

  context 'has attribute accessors which' do
    it 'includes :backup_freqency' do
      expect(@project.backup_frequency).to be_an Integer
      expect(@project.backup_frequency).to be_zero
    end

    it 'includes :ticket_field1_disposition' do
      expect(@project.ticket_field1_disposition).to be_a String
      expect(@project.ticket_field1_disposition).to eq "text"
    end

    it 'includes :ticket_field1_title' do
      expect(@project.ticket_field1_title).to be_a String
      expect(@project.ticket_field1_title).to eq "Field 1"
    end

    it 'includes :ticket_field2_disposition' do
      expect(@project.ticket_field2_disposition).to be_a String
      expect(@project.ticket_field2_disposition).to eq "text"
    end

    it 'includes :ticket_field2_title' do
      expect(@project.ticket_field2_title).to be_a String
      expect(@project.ticket_field2_title).to eq "Field 2"
    end

    it 'includes :ticket_field3_disposition' do
      expect(@project.ticket_field3_disposition).to be_a String
      expect(@project.ticket_field3_disposition).to eq "text"
    end

    it 'includes :ticket_field3_title' do
      expect(@project.ticket_field3_title).to be_a String
      expect(@project.ticket_field3_title).to eq "Field 3"
    end

    it 'includes :tickets which is an array of Unfuddled::Ticket' do
      expect(@project.tickets).to be_an Array
      
      @project.tickets.each do |ticket|
        expect( ticket ).to be_an Unfuddled::Ticket
      end
    end

  end

  describe '#to_s' do
    it 'should be "Unfuddled::Project: :title"' do
      expect(@project.to_s).to be_a String
      expect(@project.to_s).to eq "Unfuddled::Project: Example Project"
    end
  end

end
