###############################################################################
# MHK:
# IMPORTS
###############################################################################

require 'nokogiri'
require 'open-uri'
require 'securerandom'
require 'set'


###############################################################################
# MHK:
# CONSTANTS
###############################################################################

# Temporary root location for a shortened URL
BASE_WEBSITE = 'http://localhost:3000'


###############################################################################
# MHK:
# CLASSES
###############################################################################

class Member < ApplicationRecord
  before_validation :make_short_url
  after_create :store_header_lines
  
  validates :full_name, :website, :shortened_url, presence: true
  validates :website, :shortened_url, uniqueness: true
  validates :website, :shortened_url, format: URI::regexp(%w[https http])
  
  has_many :friendships, class_name: 'Friendship', foreign_key: :member_id, dependent: :destroy
  has_many :header_one_lines, class_name: 'HeaderOneLine', foreign_key: :member_id, dependent: :destroy
  has_many :header_two_lines, class_name: 'HeaderTwoLine', foreign_key: :member_id, dependent: :destroy
  has_many :header_three_lines, class_name: 'HeaderThreeLine', foreign_key: :member_id, dependent: :destroy

  # MHK
  # Creates a shortened URL within Rails 6
  # NOTE: This method can be changed to use an external URL shortening service
  def make_short_url
    self.shortened_url = "#{BASE_WEBSITE}/#{SecureRandom.uuid[0...8]}"
  end

  # MHK
  # Uses Nokogiri gem to extract H1, H2 and H3 lines from a website and save
  # them in the database for the Member
  def store_header_lines
    html = URI.open(self.website)
    doc = Nokogiri::HTML(html)
    doc.css('H1, h1').each do |h1|
      self.header_one_lines.create(header_one: h1.text.strip)
    end
    doc.css('H2, h2').each do |h2|
      self.header_two_lines.create(header_two: h2.text.strip)
    end
    doc.css('H3, h3').each do |h3|
      self.header_three_lines.create(header_three: h3.text.strip)
    end
  end

  # MHK
  # Search for members based even on a partial name and exclude the current
  # Member object
  def self.search(search, id)
    if search
      self.where('full_name like ? and id != ?', "%#{search}%", id)
    end
  end

  # MHK
  # Use breadth first search to find the shortest path from one Member to
  # another if that path exists
  def self.shortest_path(start_member, end_member)
    visited_ids = Set[]
    final_id = end_member.id
    queue = [MemberDataNode.new(nil, start_member)]
    until queue.empty?
      current_node = queue.shift
      current_data = current_node.data
      current_id = current_data.id
      if current_id == final_id
        node_path_stack = []
        until current_node.nil?
          node_path_stack.unshift(current_node.data)
          current_node = current_node.parent
        end
        return node_path_stack
      end
      
      visited_ids.add(current_id)
      current_data.friendships.each do |f|
        friend_id = f.friend_member_id
        unless visited_ids.include?(friend_id)
          new_data = MemberDataNode.new(current_node, Member.find(friend_id))
          unless queue.include?(new_data)
            queue.push(new_data)
          end
        end
      end
    end
    
    return []
  end
  
end


# MHK
# Used in breadth first search to find the shortest path between 2 Member
# objects if it exists
# NOTE:
# Backtrack at the end of a successful search is needed so the child nodes in
# the tree-like structure are not stored
class MemberDataNode
  attr_reader :parent, :data

  def initialize(parent, data)
    @parent = parent
    @data = data
  end

  def ==(other)
    self.data.id == other.data.id
  end
end


# MHK
# A Member object can have one or more friendships
class Friendship < ActiveRecord::Base
  belongs_to :member, class_name: 'Member', foreign_key: :member_id
  
  validates :member_id, :friend_member_id, presence: true
  validate :check_arguments_different
  validate :check_members_exist
  validate :check_friendship_entry_unique

  # MHK
  # Friendship is bidirectional so A->B and B->A exist when A is a friend of B
  after_create do |p|
    if Friendship.find_by(
         member_id: p.friend_member_id,
         friend_member_id: p.member_id
       ).nil?
      Friendship.create(
        member_id: p.friend_member_id,
        friend_member_id: p.member_id
      )
    end
  end

  # MHK
  # Friendship is bidirectional so A->B and B->A friendships must be removed
  after_destroy do |p|
    reciprocal_friend = Friendship.find_by(
      member_id: p.friend_member_id,
      friend_member_id: p.member_id
    )
    reciprocal_friend.destroy unless reciprocal_friend.nil?
  end

  # MHK
  # Prevent friendship of A->A in the friendships table
  def check_arguments_different
    errors.add('Same arguments !') unless member_id != friend_member_id
  end

  # MHK
  # Permit friendship only between valid Member objects
  def check_members_exist
    if Member.find(member_id).nil? or Member.find(friend_member_id).nil?
      errors.add('Both members must exist !')
    end
  end

  # MHK
  # Each entry in the friendships table is unique
  def check_friendship_entry_unique
    unless Friendship.find_by(
             member_id: member_id,
             friend_member_id: friend_member_id
           ).nil?
      errors.add('Friendship entry not unique !')
    end
  end
end


# MHK
# A Member object can have one or more H1 lines from their website stored
class HeaderOneLine < ActiveRecord::Base
  belongs_to :member, class_name: 'Member', foreign_key: :member_id
  
  validates :member_id, :header_one, presence: true
end


# MHK
# A Member object can have one or more H2 lines from their website stored
class HeaderTwoLine < ActiveRecord::Base
  belongs_to :member, class_name: 'Member', foreign_key: :member_id
  
  validates :member_id, :header_two, presence: true
end


# MHK
# A Member object can have one or more H3 lines from their website stored
class HeaderThreeLine < ActiveRecord::Base
  belongs_to :member, class_name: 'Member', foreign_key: :member_id
  
  validates :member_id, :header_three, presence: true
end
