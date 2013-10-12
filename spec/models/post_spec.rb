require "spec_helper"
require "our_date"

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

  context "HTML Pipeline" do

    describe :message= do

      subject { Post.new }

      it "should respond to message=" do
        expect(subject.respond_to? :message=).to be_true
      end

      it "should understand links" do
        subject.message = "http://example.com"
        expect(subject.msg).to eq '<p><a href="http://example.com">http://example.com</a></p>'
      end

      it "should understand markdown" do
        subject.message = "This _is_ **text**"
        expect(subject.msg).to eq '<p>This <em>is</em> <strong>text</strong></p>'
      end
    end
  end

  context "paginate" do

    before do
      14.times do |i|
        Post.create!{|p| p.msg="post no #{i}"; p.created_at= i.days.ago}
      end
    end

    it "when argument is 0, should include today posts as well" do
      p = Post.paginate(0).map{|p| p.created_at.to_date}
      expect(p).to include Date.today
    end

    it "when argument is 0, should not return posts before nearest Thursday" do
      p = Post.paginate(0)
      q = p.map do |p|
        p.created_at > Date.last_thursday
      end
      expect(q).not_to include false
    end

    it "when argument is 1, should only return posts for last week" do
      p = Post.paginate(1)
      from_date = Date.last_thursday - 7
      to_date = from_date + 7
      q = p.map do |p|
        (from_date..to_date).include? p.created_at.to_date
      end
      expect(q).not_to include false
    end
  end
end
