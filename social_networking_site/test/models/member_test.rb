require "test_helper"

class MemberTest < ActiveSupport::TestCase
  
  test "should not make empty member" do
    member = Member.new
    assert_not member.save
  end

  test "should not make member without name" do
    member = Member.new
    member.full_name = nil
    member.website = 'https://non_existent_website.com'
    assert_not member.save
  end
  
  test "should not make member without website" do
    member = Member.new
    member.full_name = 'Frederick Bloggs'
    member.website = nil
    assert_not member.save
  end
  
  test "should member exist" do
    assert_nothing_raised { Member.find(1) }
  end
  
  test "should member not exist" do
    assert_raise { Member.find(1000) }
  end

  test "should be expected member" do
    assert_nothing_raised { Member.find_by(full_name: 'John Doe') }
  end

  test "should have correct friendships" do
    member = Member.find_by(full_name: 'John Doe')
    friendships_count = member.friendships.length
    assert friendships_count == 2
  end

  test "should have reciprocal friendship" do
    member_5 = Member.find(5)
    member_6 = Member.find(6)
    friend_of_member_5 = nil
    member_5.friendships.each do |f|
      friend_of_member_5 = f.friend_member_id
    end
    friend_of_member_6 = nil
    member_6.friendships.each do |f|
      friend_of_member_6 = f.friend_member_id
    end
    assert member_5.id == friend_of_member_6 and member_6.id == friend_of_member_5
  end

  test "should be no shortest path" do
    member_1 = Member.find(1)
    member_6 = Member.find(6)
    result = Member.shortest_path(member_1, member_6)
    assert_empty result
  end

  test "should be a shortest path" do
    member_1 = Member.find(1)
    member_3 = Member.find(3)
    result = Member.shortest_path(member_1, member_3)
    assert_not_empty result
  end

end
