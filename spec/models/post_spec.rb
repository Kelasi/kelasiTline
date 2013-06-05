require "spec_helper"

describe Post do
	
  before do
    @post = Post.create do |p|
      p.msg = "test message"
    end
  end

	it "Should have a parent" do
		p = Post.new parent_id: @post.id
		p.parent.should be_an_instance_of Post
	end

	it "Should have replies" do
		Post.create {|q| q.msg = 'reply'; q.parent_id = @post.id }
		@post.replies.count.should == 1
	end

	it "Should sort by 'created_at desc' by default" do
		p1 = Post.create {|q| q.msg = '1'}
		p2 = Post.create {|q| q.msg = '2'}
		Post.first(2).should == [p2, p1]
	end

	it "Should have recent posts" do
		ps = []
		30.times do |i|
			ps << Post.create {|q| q.msg = i.to_s}
		end
		Post.recent_posts(10).should == ps.last(10).reverse
	end

  it "Should have post.parent_id==nil as recent_posts" do
    p = Post.create {|q| q.parent_id = nil; q.msg = 'nil message'}
    Post.recent_posts.should include p
  end

	it "Should have a user" do
		p = Post.create user_id: 1
		p.user.should == User.find(1)
	end

  it "Should refuse to save a post with empty message" do
    p = Post.new
    p.save
    expect(p.errors.messages).to have_key :msg
    expect(p.errors.messages[:msg]).to include "can't be blank"
  end
end
