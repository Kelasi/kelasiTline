require 'spec_helper'

describe IssuesController do

	before {session['user'] = User.first}

	context 'index' do

		it 'should call Octokit issues method' do
			o = ['1','2','3']
			Octokit::Client.any_instance.stub(:issues).with('Kelasi/kelasi').and_return(o)
			get 'index', org: 'Kelasi', repo: 'kelasi', format: :json
			expect(assigns(:issues)).to eq o
		end
	end

	let(:returned_issue) { ['1'] }

	def ostub(action, *args)
		obj = args.extract_options!
		Octokit::Client.any_instance.should_receive(action)
						.with('Kelasi/kelasi', *args, obj).and_return(returned_issue)
	end

	context 'create' do

		it 'should call Octokit create_issue method' do
			ostub :create_issue, 'title', 'body'
			post 'create', org: 'Kelasi', repo: 'kelasi', title: 'title', body: 'body', format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should be able to get a hash of valid (assignee, milestone and labels) optional arguments' do
			ostub :create_issue, 'title', 'body', 'milestone' => '19'
			post 'create', org: 'Kelasi', repo: 'kelasi', title: 'title',
						   body: 'body', options: {'milestone' => '19'}, format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should reject invalid optional parameters' do
			ostub :create_issue, 'title', 'body'
			post 'create', org: 'Kelasi', repo: 'kelasi', title: 'title',
						   body: 'body', options: {option: 'invalid'}, format: :json
			expect(assigns(:issue)).to eq returned_issue
		end
	end

	context 'update' do

		it 'should call Octokit update_issue method' do
			ostub :update_issue, '12', 'new title', 'new body'
			put 'update', org: 'Kelasi', repo: 'kelasi', id: '12', title: 'new title',
						  body: 'new body', format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should be able to get a hash of valid (assignee, milestone, labels and state) optional arguments' do
			ostub :update_issue, '12' , 'new title', 'new body', 'milestone' => '19'
			put 'update', org: 'Kelasi', repo: 'kelasi', id: '12', title: 'new title',
						  body: 'new body', options: {'milestone' => '19'}, format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should reject invalis optional arguments' do
			ostub :update_issue, '12' , 'new title', 'new body'
			put 'update', org: 'Kelasi', repo: 'kelasi', id: '12', title: 'new title',
						  body: 'new body', options: {'option' => 'invalid'}, format: :json
		end
	end

	context 'destroy' do

		it 'should call Octokit close method' do
			ostub :close_issue, '12'
			delete 'destroy', org: 'Kelasi', repo: 'kelasi', id: '12', format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should be able to get a hash of valid (assignee, milestone and labels) optional arguments' do
			ostub :close_issue, '12', 'milestone' => '19'
			delete 'destroy', org: 'Kelasi', repo: 'kelasi', id: '12',
							  options: {'milestone' => '19'}, format: :json
			expect(assigns(:issue)).to eq returned_issue
		end

		it 'should reject invalid optional arguments' do
			ostub :close_issue, '12'
			delete 'destroy', org: 'Kelasi', repo: 'kelasi', id: '12',
							  options: {'option' => 'invalid'}, format: :json
			expect(assigns(:issue)).to eq returned_issue
		end
	end
end
