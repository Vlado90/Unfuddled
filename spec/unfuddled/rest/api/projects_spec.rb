require 'helper'

describe Unfuddled::REST::API::Projects do
  
  before do
    @subdomain = "SUBDOMAIN"
    @username = "USERNAME"
    @password = "PASSWORD"
    @client = Unfuddled::REST::Client.new(
                                          :subdomain => @subdomain,
                                          :username => @username,
                                          :password => @password
                                          )

  end

  describe '#projects' do
    before do
      stub_request( :get , stub_path(@client , "/projects.json"))
        .to_return(:body => fixture("projects.json") , :headers => {
                     :content_type => 'application/json' })

      stub_request( :get , stub_path(@client , "/projects/1.json"))
        .to_return(:body => fixture("project.json") ,
                   :headers => {
                     :content_type => "application/json"
                   })

      stub_request( :get , stub_path(@client , "/projects/by_short_name/valid_project.json"))
        .to_return(:body => fixture("project.json"),
                   :headers => {
                     :content_type => "application/json"
                   })

    end

    context 'without any arguments' do
      it 'requests the projects on GET' do
        @client.projects
        expect( a_request(:get , stub_path(@client , '/projects.json') ) ).to have_been_made
      end

      it 'gets the projects' do
        projects = @client.projects
        expect(projects).to be_a Array
        expect(projects.first).to be_a Unfuddled::Project
      end
    end


    context 'with a query' do
      pending 'returns an array of a single project with matchig :id' do
        projects = @client.projects(:id => 1)
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_an Unfuddled::Project
        expect(projects.first.id).to eq 1
      end

      pending 'returns an array of a single project with matching :name' do
        projects = @client.projects(:name => "valid_project")
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_an Unfuddled::Project
        expect(projects.first.id).to eq 1
      end

      pending 'returns an array of matching projects with a regex for :name' do
        projects = @client.projects(:name => /^project_/)
        expect(projects).to be_an Array
        expect(projects.first.short_name).to match /^project_/
      end

      pending 'returns an array of projects with an :id in a range' do
        projects = @client.projects(:id => [2..4])
        expect(projects).to be_an Array
        expect(projects.length).to eq 2
        expect(projcets.first).to be_an Unfuddled::Project
        
        projects.each do |project|
          expect( (2..4).include?(project.id) ).to be_true
        end
      end

      pending 'returns an array of projects with :time_tracking_enabled' do
        projects = @clinet.projects(:time_tracking_enabled => true)
        expect(projects).to be_an Array

        projects.each do |project|
          expect(project.time_tracking_enabled).to be_true
        end
      end
        
      
        
    end


    context 'when the account has one project' do
      before do
        stub_request( :get , stub_path(@client , "/projects.json"))
          .to_return(:body => fixture("project.json") , :headers => {
                       :content_type => "application/json"
                     })
      end

      it 'returns an array with one Unfuddled::Project in it' do
        projects = @client.projects
        expect(projects).to be_an Array
        expect(projects.length).to eq 1
        expect(projects.first).to be_an Unfuddled::Project
      end
    end
  end
  
  describe '#project' do

    context 'with arguments' do
      before do
        stub_request(:get , stub_path(@client , "/projects/by_short_name/valid_project.json"))
          .to_return(:body => fixture("project.json"),
                     :headers => {
                       :content_type => "application/json"
                     })
      end

      it 'gets an existing project by :name' do
        @client.project({:name => "valid_project"})
        expect( a_request(:get , stub_path(@client , "/projects/by_short_name/valid_project.json"))).to have_been_made
      end

      it 'returns a single Unfuddled::Project' do
        project = @client.project({:name => "valid_project"})
        expect(project).to be_an Unfuddled::Project
      end

    end
    
  end
end


    
                                          
                                          

